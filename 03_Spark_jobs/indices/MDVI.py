import os
import argparse
import shutil
import logging
import rasterio
import numpy as np
import numpy.ma as ma
from rasterio.fill import  fillnodata
from scipy.ndimage.interpolation import zoom
from scipy.ndimage import gaussian_filter

from sentinel2biopar.S3_scripts import copy_to_s3, copy_from_s3_path
from sentinel2biopar.utilities.geoloader import AWSCOGSLoader, ParallelLoader


def _parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--tile",dest='tile',default=None,required=False)
    parser.add_argument("--paths", dest='paths', required = True)
    parser.add_argument('--local', dest='local',default=False, type=lambda x: (str(x).lower() in ['true', '1' , 'yes' ]))
    parser.add_argument('--version', dest='version', default=True)


    return parser.parse_args()

def read_data(Loader, qLoader, sclLoader, list, qlist, scllist, window,NODATA):
    print('reading in data ')


    aData = np.asarray(Loader.load_arrays(list, window))
    qData = np.asarray(qLoader.load_arrays(qlist, window))
    sclData = np.asarray(sclLoader.load_arrays(scllist, tuple(tuple(ti2/2 for ti2 in ti) for ti in window)))
    #zoom image
    step = 0.5
    sclData = zoom(sclData, (1, 1 / step, 1 / step), order=0)




    print('Applying QFLAG masks')

    # Applying mask
    # No Value en Saturated
    qData2 = np.zeros(np.shape(qData), dtype=np.uint16)

    qData2[(qData & 1) == 1] = 1
    # next line not necessary anymore but kept for future reference
    #qData2[(((qData & 1) == 1) & ((qData & 1024) == 1024)) | (((qData & 1) == 1) & ((qData & 2048) == 2048))] = 1
    qData2[(qData & 65535) == 65535] = 0
    qData = None

    aData[(qData2 == 0)] = NODATA
    qData2 = None



    print('Calculating num4')
    filterdvi4 = ((sclData != 4)) | (aData <= 0) | (aData >= 5000)
    dvi4 = aData.copy()
    dvi4[filterdvi4] = NODATA
    num4 = np.count_nonzero(dvi4 != NODATA , axis = (1,2))
    dvi4 = None
    filterdvi4 = None

    print('Calculating dvi45')
    filterdvi45 = ((sclData != 4) & (sclData != 5)) | (aData <= 0) | (aData >= 5000)
    sclData = None
    dvi45 = aData.copy()
    dvi45[filterdvi45] = NODATA

    return aData, dvi45, num4


def nanpercentile(arr, q, new_nodata_value=-32768):
    """ function to speed up nanpercentile from numpy
        arr = masked array
        q = one requested percentile or list of several requested percentiles

        designed for our LC100 data with is int16 masked array

        """
    # valid (non maksed) observations along the first axis
    valid_obs = arr.count(axis=0)
    # replace masked values with max value
    arr = arr.filled(32767).astype(np.int16)
    # sort - former masked arrays will move to the end
    arr = np.sort(arr, axis=0)

    # loop over requested quantiles
    if type(q) is list:
        qs = []
        qs.extend(q)
    else:
        qs = [q]

    result = []
    for i in range(len(qs)):
        quant = qs[i]
        # desired position in sorted value list as well as floor and ceiling of its index
        k_arr = (valid_obs - 1) * (quant / 100.0)
        # account for cases where no valid data exists
        k_arr[valid_obs == 0] = 0

        f_arr = np.floor(k_arr).astype(np.uint16)
        c_arr = np.ceil(k_arr).astype(np.uint16)

        # get positions where floored and ceiled index is the same
        fc_equal_k_mask = f_arr == c_arr

        # take the values at floored and ceiled quantile position
        # note: floored position is standard output
        quant_arr = _zvalue_from_index(arr=arr, ind=f_arr)
        ceil_val = _zvalue_from_index(arr=arr, ind=c_arr)

        # now calculte for arrays where floor and ceil was not the same index
        # here we take the average of the values and floor for int16
        quant_arr[~fc_equal_k_mask] = ((quant_arr[~fc_equal_k_mask].astype(np.int32) + ceil_val[
            ~fc_equal_k_mask].astype(np.int32)) / 2.0).astype(np.int16)

        # cleanup results wehere observations where 0 and fill with new_nodata_value
        quant_arr[valid_obs == 0] = new_nodata_value

        # append to result
        result.append(quant_arr)

    return result


def _zvalue_from_index(arr, ind):
    """private helper function to work around the limitation of np.choose() by employing np.take()
    arr has to be a 3D array
    ind has to be a 2D array containing values for z-indicies to take from arr
    See: http://stackoverflow.com/a/32091712/4169585
    This is faster and more memory efficient than using the ogrid based solution with fancy indexing.
    """
    # get number of columns and rows
    _, nC, nR = arr.shape

    # get linear indices and extract elements with np.take()
    idx = nC * nR * ind + np.arange(nC * nR).reshape((nC, nR))
    return np.take(arr, idx)

def calc_MDVI(aData, NODATA):
    DVImax = np.amax(aData, axis=0)  # return the maximum over the series
    # getting percentile (nodata masked)
    MeanDVImax = np.mean(DVImax[DVImax != NODATA])
    DVIMax = None
    mdata = np.ma.masked_where(aData == NODATA, aData)
    aData = None
    DVIperc = (nanpercentile(mdata, 95, NODATA))[0]
    mdata = None
    DVIperc_ma = np.ma.masked_where(DVIperc == NODATA, DVIperc)
    MeanDviperc = np.ma.mean(DVIperc_ma)
    correction =  (MeanDVImax - MeanDviperc) + 0.005 * 10000

    correction = np.ma.filled(correction, NODATA)


    return DVIperc, correction


def process_cube(Loader, qLoader,sclLoader, list, qlist, scllist, window, NODATA=-32768):

    print('Reading in data')
    aData, dvi45, num4 = read_data(Loader, qLoader, sclLoader, list, qlist, scllist, window, NODATA)

    print('Calculating DVI soil')
    DVI_soil = calc_DVIsoil(dvi45, num4, NODATA)
    dvi45 = None

    print('Calculating MDVI')
    dvi_95, correction = calc_MDVI(aData, NODATA)
    aData = None



    return  dvi_95, correction, DVI_soil  # return the series


def calc_DVIsoil(dvi45, num4, NODATA):
    num45 = np.count_nonzero(dvi45!=NODATA, axis=(1,2))

    p4of45 = np.divide(num4, num45)
    p = np.zeros(np.shape(p4of45))
    p[p4of45 <= 0.2] = 25
    p[p4of45 >= 0.8] = 5
    p[p==0] = (0.8 - p4of45[p==0]) * 20 / 0.6 + 5

    dvi45 = np.ma.masked_where(dvi45 ==NODATA, dvi45)
    tiledvi45 = np.zeros(np.shape(p))
    for idx,element in enumerate(p):
        if np.isnan(p4of45[idx]):
            tiledvi45[idx] = NODATA

        else:

            tiledvi45[idx] = np.percentile(dvi45[idx].compressed(), element)

    soildvi = np.ma.mean(np.ma.masked_where(tiledvi45 == NODATA, tiledvi45))

    soildvi = np.ma.filled(soildvi, NODATA)

    if soildvi != NODATA:
        soildvi = np.minimum(soildvi, 900)

    print('DVI soil is ' + str(soildvi))
    return soildvi



def run(list, qlist, scl_list, path_out , local):
    # read"
    if local:
        Loader = ParallelLoader(fill_value=-32768)


    else:
        Loader = AWSCOGSLoader(aws_access_key_id = REDACTED, aws_secret_access_key = REDACTED, endpoint_url='https://s3.waw3-1.cloudferro.com/',fill_value = -32768)

    qLoader = ParallelLoader(fill_value=65535)

    sclLoader = ParallelLoader(fill_value=0)

    NODATA = -32768


    with rasterio.open(list[0]) as src:
        # aData = src.read(1)
        src_profile = src.profile
    new_affine = src_profile.pop('transform')
    dim_x = src_profile['width']
    dim_y = src_profile['height']



    new_profile = src_profile.copy()
    new_profile.update(driver='GTiff',
                       compress='DEFLATE',
                       count=2,
                       transform=new_affine,
                       nodata=-32768)

    # Calculate N° of chunks for reading blocks of ~ 500 Mb
    nChunkLinesy = 1098
    # np.round((500 * 1024 * 1024) / (dim_x * count))  # to make sure it's a multiple of step (kernel size)
    nChunksy = int(dim_y / nChunkLinesy)

    nChunkLinesx = 1098
    # np.round((500 * 1024 * 1024) / (dim_x * count))  # to make sure it's a multiple of step (kernel size)
    nChunksx = int(dim_x / nChunkLinesx)

    LastnLinesy = np.round(dim_y - nChunksy * nChunkLinesy)  # to avoid that kernel exceeds last line)
    LastnLinesx = np.round(dim_x - nChunksx * nChunkLinesx)  # to avoid that kernel exceeds last line)
    if LastnLinesy > 0:
        nChunksy += 1
    else:
        LastnLinesy = nChunkLinesy
    if LastnLinesx > 0:
        nChunksx += 1
    else:
        LastnLinesx = nChunkLinesx

    # read series by chunk, calculate max and write out
    if not os.path.exists(path_out):
        os.mkdir(path_out)

    tile_out = os.path.join(path_out, os.path.basename(path_out) + '.tif')
    #create div_soil output aray
    advi_soil = np.full((nChunksy,nChunksx), NODATA, dtype =float)
    mdvi_correction = np.full((nChunksy,nChunksx), NODATA, dtype = float)

    with rasterio.open(tile_out, 'w+', **new_profile) as dest:
        for iChunky in range(nChunksy):
            FirstLiney = nChunkLinesy * iChunky
            for iChunkx in range(nChunksx):
                FirstLinex = nChunkLinesx * iChunkx
                print(
                    '***** Processing chunk: ' + str(iChunky * nChunksx + iChunkx + 1) + '/' + str(nChunksx * nChunksy))

                if iChunky == nChunksy - 1:
                    print(LastnLinesy)
                    nChunkLinesy = LastnLinesy
                if iChunkx == nChunksx - 1:
                    print(LastnLinesx)
                    nChunkLinesx = LastnLinesx

                aData, mdvi_correction[iChunky,iChunkx], advi_soil[iChunky,iChunkx] = process_cube(Loader, qLoader, sclLoader, list, qlist, scl_list,
                                               window=((FirstLiney, (FirstLiney + nChunkLinesy)),
                                                       (FirstLinex, (FirstLinex + nChunkLinesx))))


                # write out
                print('write out')
                dest.write(aData.astype(rasterio.int16), 1,
                           window=(
                           (int(FirstLiney), (int(FirstLiney + nChunkLinesy))), (FirstLinex, (FirstLinex + nChunkLinesx))))

                # free
                aData = None
                aMask = None

        #apply correction on DVI95
        DVI_95 = dest.read(1)
        ma_mdvi_correction = ma.masked_where(mdvi_correction == NODATA,mdvi_correction)
        mdvi_correction_filled = fillnodata(ma_mdvi_correction, mask = np.full(np.shape(ma_mdvi_correction),~ma_mdvi_correction.mask))
        MDVI = DVI_95 + zoom(mdvi_correction_filled.astype(np.float64),(nChunkLinesy,nChunkLinesx),order=3, mode='nearest')
        MDVI[DVI_95==NODATA] = NODATA

        dest.write(MDVI.astype(rasterio.int16),1)
        MDVI = None
        DVI_95 = None


        ma_advi_soil = ma.masked_where(advi_soil==NODATA, advi_soil)
        advi_soil_filled = fillnodata(ma_advi_soil, mask = np.full(np.shape(ma_advi_soil),~ma_advi_soil.mask))
        advi_soilzoom = zoom(advi_soil_filled.astype(np.float64),(nChunkLinesy,nChunkLinesx),order=3, mode='nearest')
        for x in range(nChunksx):
            for y in range(nChunksy):
                if advi_soil[y,x] == NODATA:
                    advi_soilzoom[nChunkLinesy*y:nChunkLinesy*(y+1),nChunkLinesx*x:nChunkLinesx*(x+1)] = NODATA
        dest.write(advi_soilzoom.astype(rasterio.int16),2)

    return tile_out


##########################
if __name__ == '__main__':
    args = _parse_args()

    log = logging.getLogger('py4j')




    #generate VRT
    '''
    vrt = generate_vrt(args.paths, args.tile)

    log.info("Start generating VRT of QFLAG2")
    qflagvrt = generate_vrt(args.paths, args.tile, qflag=True)
    '''

    #list with s3 files
    list = args.paths.split(' ')



    # start downloading data

    local_dir = '/mnt/tmp_b/tmpfolder'
    if os.path.exists(local_dir):
        shutil.rmtree(local_dir)
    os.mkdir(local_dir)
    list2 = [x.replace('/vsis3/', 's3://') for x in list]
    scl_list = [x.replace('DVI','QFLAG').replace('010m','020m') for x in list2]
    qf_list = [(x.replace('auxdata', 'products-vi')).replace('/AUXDATA','VI').replace('DVI', 'QFLAG2') for x in list2]
    local_list = [os.path.join(local_dir, s3_adress.split('/')[-1]) for s3_adress in list2]
    local_scl_list = [local_file.replace('DVI', 'QFLAG').replace('010m','020m')  for local_file in local_list]
    local_qf_list = [local_file.replace('DVI', 'QFLAG2') for local_file in local_list]
    log.info("Downloading QFLAGs")
    try:
        for idx, file in enumerate(list2):
            if idx % 10 == 0:
                print("downloading file " + str(idx) + " from " + str(len(list)) + " files")
            copy_from_s3_path(qf_list[idx], local_qf_list[idx],
                              source_s3_endpoint="https://s3.waw3-1.cloudferro.com", folder=False)
            copy_from_s3_path(scl_list[idx], local_scl_list[idx],
                              source_s3_endpoint="https://s3.waw3-1.cloudferro.com", folder=False)


        if args.local:
            log.info("Going Local")
            log.info("Downloading DVI")
            for idx,file in enumerate(list2):
                if idx%10 == 0:
                    print("downloading file " + str(idx) + " from " + str(len(list)) + " files" )
                copy_from_s3_path(file,local_list[idx],
                         source_s3_endpoint="https://s3.waw3-1.cloudferro.com", folder=False)
            list = local_list

        os.mkdir('/home/user/MDVI/')

        product_path = '/home/user/MDVI/' + args.tile

        log.info("Start calculating MDVI")
        # Calc MDVI

        tile_out = run(list, local_qf_list, local_scl_list, product_path, args.local)
        copy_to_s3(tile_out, os.path.join('MDVI',args.version, os.path.basename(tile_out)), s3_bucket_to='hr-vpp-auxdata')


        shutil.rmtree(local_dir)


    except Exception as e:
        shutil.rmtree(local_dir)
        print(e)
        raise



