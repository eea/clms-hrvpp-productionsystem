import numpy as np
from numpy import cos, radians
import rasterio
from osgeo import gdal
import os
from pathlib import Path
from sentinel2biopar.S3_scripts import copy_to_s3, copy_from_s3, get_bucket, copy_from_s3_path, download_MDVI
from datetime import datetime
from sentinel2biopar.utilities.log import setup_logging
from sentinel2biopar.utilities.product import get_product_tile, get_product_start_date_time_as_datetime
from sentinel2biopar.utilities.Shell import Shell

class DigitizationParameters:
	   dvi = {
      'phy_min': -1,
      'phy_max': 1,
      'dn_min': -10000,
      'dn_max': 10000,
      'scaling': 1.0/10000.0,
      'offset': 0,
      'nodata': -32768,
      'satur_min': None,
      'satur_max':  None,
      'datatype': 'int16',
      'name': 'DVI',
      'description': 'Difference Vegetation Index calculated using the Sentinel2 ' + \
                         'Multi Spectral Imager data'
    }
        ppi = {
      'phy_min': 0.,
      'phy_max': 3.0,
      'dn_min': 0,
      'dn_max': 30000,
      'scaling': 1.0/10000.0,
      'offset': 0.0,
      'nodata': -32768,
      'satur_min': 0,
      'satur_max':  3,
      'datatype': 'int16',
      'name': 'PPI',
      'description': 'Plant Phenology Index calculated using the Sentinel2 ' + \
                         'Multi Spectral Imager data'
    }


class PPI:
    """
    This class implements the same public interface as biopar nnw, so we can substitute it
    """

    def __init__(self):
        pass

    def _dc(self,sza):
        predc = 0.0336 + (0.0477 / sza)
        dc = np.minimum(predc,1)
        return dc

    def _G(self,sza):
        #G = (np.sqrt(np.cos(sza) ** 2 + np.sin(sza) ** 2)) / (1 + 1.774 * (1 + 1.182) ** -0.733)
        # G = 1 / (1 + 1.774 * (1 + 1.182) ** -0.733)
        G = 0.5
        return G

    def _Qe(self,sza):
        Qe = self._dc(sza) + (1 - self._dc(sza)) * (self._G(sza) / sza)
        return Qe

    '''
    def _K(Qe,dvi_max,scaling):
        K = (1/(4*Qe))*((1+dvi_max*scaling)/(1-dvi_max*scaling))
        return K
    '''

    def _K(self,sza, dvi_max, scaling):
        K = (1 / (4 * self._Qe(sza))) * ((1 + dvi_max * scaling) / (1 - dvi_max * scaling))
        return K

    def _ppi(self,K, dvi_max, dvi_soil, dvi):
        ppi = -K * np.log((dvi_max - dvi) / (dvi_max - dvi_soil))
        return ppi

    def run(self, input_bands, output_scale=10000., output_dtype=rasterio.int16, nodata_val=-32768, minmax_flagging=False, scaled_max = None, offset=0.0, Singlerun = False):
        """

        :param input_bands: Sentinel 2 10m bands, in the order [B03,B04,B08]
        :param output_scale:
        :param output_dtype:
        :param minmax_flagging:
        :param scaled_max:
        :return:
        """
        scaling = 10000.
        if Singlerun:
            dvi_calc = input_bands[0]
            dvi_max = input_bands[2]
            dvi_soil = input_bands[3]
            # is actually cos of sza
            sza = input_bands[1]
        else:
            dvi_max = input_bands[6]
            dvi_soil = input_bands[7]
            #is actually cos of sza
            sza = input_bands[4]

            dvi_calc = DVI().run(input_bands, output_scale=scaling)

        mask_dvi_nodata = (dvi_calc == -32768)
        mask_dvi_max_nodata = (dvi_max == -32768)


        scalar_dvi_soil = np.max(dvi_soil)
        dvi_max[dvi_max < (scalar_dvi_soil * 2)] = scalar_dvi_soil *2
        #dvi_max[dvi_max / scaling == 1] = (1 - 0.0005) * scaling
        dvi_max[dvi_max > 0.8*scaling] = 0.8*scaling

        K = self._K(sza, dvi_max, 1/scaling)

        ppi = self._ppi(K, dvi_max, dvi_soil, dvi_calc)

        ppi[dvi_calc < dvi_soil] = 0
        ppi[dvi_max<=dvi_calc]= 3

        mask_inf = np.isin(ppi, [-np.inf, np.inf])
        mask_nan = np.isnan(ppi)

        ppi[ppi < 0] = 0
        ppi[ppi > 3] = 3  # set an upper limit for PPI

        ppi = ppi *output_scale

        ppi[mask_inf] = nodata_val
        ppi[mask_nan] = nodata_val

        ppi[mask_dvi_nodata] = nodata_val
        ppi[mask_dvi_max_nodata] = nodata_val

        return ppi



class singlePPI:

    def __init__(self,product,SZA_file, DVI_file, qflag2_file, test = False):
        self.product = product
        self.SZA_file = SZA_file
        self.DVI_file = DVI_file
        self.qflag2_file = qflag2_file
        self.version = '101'
        self.test = test
            #get_version_product(SZA_file)




    def runPPI(self,log):

        log.info(self.product)


        tile = get_product_tile(self.product)

        log.info('Downloading MDVI')
        #tmp_file = '/home/user/' + tile + 'MDVI.tif'
        tmp_file = download_MDVI(tile)
        log.info('Downloading MDVI done')

        log.info('Downloading SZA')
        tmp_file_sza = '/home/user/' + tile + 'SZADVI.tif'
        copy_from_s3_path(self.SZA_file, tmp_file_sza,
                     source_s3_endpoint="https://s3.waw3-1.cloudferro.com", folder=False)
        log.info('Downloading SZA done')

        log.info('Downloading DVI')
        tmp_file_dvi = '/home/user/' + tile + 'DVI.tif'
        copy_from_s3_path(self.DVI_file, tmp_file_dvi,
                     source_s3_endpoint="https://s3.waw3-1.cloudferro.com", folder=False)
        log.info('Downloading DVI done')

        log.info('Downloading QFLAG')
        tmp_file_qflag = '/home/user/' + tile + 'QFLAG2.tif'
        copy_from_s3_path(self.qflag2_file, tmp_file_qflag,
                     source_s3_endpoint="https://s3.waw3-1.cloudferro.com", folder=False)
        log.info('Downloading QFLAG done')


        log.info(self.DVI_file)

        with rasterio.Env(CPL_DEBUG=0, GDAL_CACHEMAX=3048, GTIFF_IMPLICIT_JPEG_OVR=False):
            with rasterio.open(tmp_file_dvi) as src:
                self.sensingtime = src.tags()['TIFFTAG_DATETIME']


                profile = src.profile

            profile['count'] = 1
            profile['dtype'] = rasterio.uint8
            profile['driver'] = 'GTIFF'
            profile['compress'] = 'DEFLATE'
            profile['nodata'] = 255
            profile['TILED'] = True

            profile['BLOCKXSIZE'] = 512
            profile['BLOCKYSIZE'] = 512

            scales = {'ppi': 1 / DigitizationParameters.ppi['scaling']}
            offset = {'ppi': DigitizationParameters.ppi['offset']}
            nodata = {'ppi': DigitizationParameters.ppi['nodata']}
            scaled_max = {'ppi': DigitizationParameters.ppi['dn_max']}
            datatype = {'ppi': DigitizationParameters.ppi['datatype']}

            config = {}
            config['nnw'] = PPI()
            parameter = 'ppi'


            profile['dtype'] = datatype.get(parameter)
            profile['nodata'] = nodata.get(parameter)
            config['output_file'] = '/home/user/PPI_temp.tif'
            self.output = config['output_file']

            config['output_dataset'] = rasterio.open(config['output_file'], 'w', **profile)
            config['output_dataset'].scales = [1. / scales.get('ppi')]
            config['output_dataset'].offsets = [offset.get(parameter, 0.0)]
            config['output_dataset'].nodatas = [nodata.get(parameter)]
            config['output_dataset'].types = [datatype.get(parameter)]





            config['output_dataset'].set_band_description(1, DigitizationParameters.ppi.get('description'))

            config['output_dataset'].set_band_unit(1, '-')
            config['output_dataset'].update_tags(1, PhysRange=str('0 to 3'))
            some_output_dataset = config['output_dataset']
            blocks = some_output_dataset.block_windows(1)
            windows = [((0, (0 + profile['height']/2)), (0, profile['width']/2)) , ((profile['height']/2, profile['height']), (0, profile['width']/2)),
                       ((0, (0 + profile['height'] / 2)), (profile['width']/2, profile['width'])),((profile['height'] / 2, profile['height']), (profile['width']/2, profile['width']))]

            for window in windows:
                with rasterio.open(tmp_file_dvi) as src:
                    dvi = src.read(1, window=window)

                with rasterio.open(tmp_file_qflag) as qflag:
                    mask = qflag.read(1, window=window) != 65535

                if mask is None or mask.any():

                    with rasterio.open(tmp_file_sza) as src:
                        sza = src.scales[0] * src.read(1, window=window).astype(rasterio.float32)
                    g2 = cos(radians(sza)).reshape(sza.shape)

                    input =  np.append([dvi],[g2],axis=0)
                    g2 = None





                    with rasterio.open(tmp_file) as src:
                        dvi_max = src.read(1, window=window)
                        dvi_soil = src.read(2, window=window)

                    input1 = np.append(input, [dvi_max], axis=0)
                    dvi_max = None
                    input2 = np.append(input1, [dvi_soil], axis=0)
                    dvi_soil = None
                    input1 = None


                    if mask is not None:
                        input2 = input2[:, mask]


                    output_scale = config['output_dataset'].scales[0]  # scales.get(parameter, 250.)
                    output_offset = config['output_dataset'].offsets[0]  # offset.get(parameter,0.0)
                    output_nodata = config['output_dataset'].nodatas[0]

                    output_dtype = self._get_rasterio_dtype(config['output_dataset'].types[0])
                    if not rasterio.dtypes.check_dtype(output_dtype):
                        raise ('error in check_dtype')

                    image = config['nnw'].run(input2.reshape((len(input2), -1)),
                                              output_scale=1 / output_scale, output_dtype=output_dtype,
                                              nodata_val=output_nodata,
                                              scaled_max=scaled_max.get(parameter, None),
                                              offset=-output_offset,
                                              Singlerun = True)


                    if mask is not None:
                        as_image = np.full(dvi.shape, output_nodata, dtype=output_dtype)
                        as_image[mask != 0] = image.flatten()
                    else:
                        as_image = image.flatten().astype(output_dtype).reshape(dvi.shape)
                    config['output_dataset'].write(as_image, 1, window=window)
            return



    def _get_rasterio_dtype(self,dtype):
        if dtype == 'byte':
            return rasterio.uint8
        elif dtype == 'uint16':
            return rasterio.uint16
        elif dtype == 'int16':
            return rasterio.int16
        elif dtype == 'float32':
            return rasterio.float32
        else:
            print('WARNING use standard rasterio dtype uint16')
            return rasterio.uint16

    def package(self):
        param= 'PPI'
        res = '010m'
        output_dir = Path('/home/user/final_output_dir/')
        if not output_dir.exists():
            output_dir.mkdir(parents=True)

        input_file = self.output

        final_output = output_dir / (os.path.basename(self.DVI_file)).replace('DVI','PPI')



        self._generate_cog(input_file, final_output)



        # only copy data when everything is ready
        if self.test :
            productBucket = 'test'
        else:
            productBucket = get_bucket(self.product, 'hr-vpp-products-vi', version = self.version)
        copy_to_s3(str(final_output), self.get_output_key_s3(str(final_output)), productBucket)





    def _generate_cog(self,input_file, final_output,method='average'):
        # run gdaladdo
        config = {}
        config['icor_path'] = None
        config['gdal_path'] = 'system-gdal'
        shell = Shell(config)
        shell.run("gdaladdo -ro --config GDAL_TIFF_OVR_BLOCKSIZE 512 --config COMPRESS_OVERVIEW DEFLATE -r {0} {1} 4 8 16 32".format(method, input_file))

        metadataOptions = {'Overviews method': method}
        with rasterio.open(str(input_file), 'r+') as src:
            src.update_tags(1, **metadataOptions)

        self._generate_cog_no_overviews(input_file, final_output, shell)

    def _generate_cog_no_overviews(self,input_file, final_output, shell):
        from sentinel2biopar._version import __version__
        # translate into COG
        dict_general = {'file_creation': '%s' % datetime.now().strftime('%Y:%m:%d %H:%M:%S'),
                        'L1C_product': '%s' % self.product,
                        'TIFFTAG_SOFTWARE' : 'HRVPP Biopar Workflow:%s' % __version__,
                        'TIFFTAG_COPYRIGHT' : 'Copernicus service information ' + str(datetime.now().year),
                        'TIFFTAG_DATETIME' : '%s' % self.sensingtime}
        with rasterio.open(input_file, 'r+') as src:
            src.update_tags(**dict_general)

        shell.run(
            "gdal_translate {0} {1} --config GDAL_TIFF_OVR_BLOCKSIZE 512 -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -co \x22COMPRESS=DEFLATE\x22 -co \x22TILED=YES\x22 -co \x22COPY_SRC_OVERVIEWS=YES\x22".format(
                str(input_file), str(final_output)))

    def get_output_key_s3(self, filename, theme = 'VI' ):
        # Create subdir with configured date/time format.
        basename = os.path.basename(filename)
        date_time = get_product_start_date_time_as_datetime(self.product)
        version = (basename.split('_')[-2])
        basename = basename.replace(version, 'V'+self.version)
        major_version = "v0" + (basename.split('_')[-2])[1]

        s3_key_to = os.path.join("CLMS/Pan-European/Biophysical/",theme,major_version, str(date_time.year), \
                                 str(date_time.month).zfill(2), str(date_time.day).zfill(2), basename)



        return s3_key_to

def get_version_product(vi_product):

    version = (os.path.basename(vi_product).split('_'))[-2]

    return version[1:]


def main(product, qflag_file, test = 0):

    log = setup_logging()
    version = get_version_product(qflag_file)
    if test:
        productBucket = 'test'
        auxBucket = 'test'
    else :
        productBucket = get_bucket(product, 'hr-vpp-products-vi', version)
        auxBucket = get_bucket(product, 'hr-vpp-auxdata', version)

    sza_file = ((qflag_file.replace(productBucket,auxBucket+'/SZA')).replace('QFLAG2','SZA'))
    dvi_file = sza_file.replace('SZA','DVI')

    log.info('create PPI class')
    PPI = singlePPI(product, sza_file, dvi_file, qflag_file)
    log.info('run PPI calc')
    PPI.runPPI(log)
    log.info('run Packager')
    PPI.package()


if __name__ == '__main__':
    import sys
    print(sys.argv)
    product = sys.argv[1]
    qflag_file = sys.argv[2]
    test = int(sys.argv[3])
    main(product, qflag_file, test)
