import numpy as np
import rasterio

class DVI:
    """
    This class implements the same public interface as biopar nnw, so we can substitute it
    """

    def __init__(self):
        pass

    def run(self, input_bands, output_scale=10000., output_dtype=rasterio.int16, nodata_val=-32768, minmax_flagging=False, scaled_max = None, offset=0.0):
        """

        :param input_bands: Sentinel 2 10m bands, in the order [B03,B04,B08]
        :param output_scale:
        :param output_dtype:
        :param minmax_flagging:
        :param scaled_max:
        :return:
        """

        if np.issubdtype(output_dtype,np.floating):
            nodata_val = np.nan

        red = input_bands[1]
        nir = input_bands[2]
        invalid_bands = np.any((input_bands[1:3, :] < 0) | (input_bands[1:3, :] > 1.), axis=0)

        dvi = (nir-red)

        digital_dvi = ((dvi - offset) * output_scale).astype(output_dtype)

        # push invalid reflectance input bands to no_value, avoid unreliable DVI's.
        digital_dvi[invalid_bands] = nodata_val

        return digital_dvi
