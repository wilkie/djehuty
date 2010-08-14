/*
 * jpeg.d
 *
 * This module implements the JPEG image standard.
 *
 * Author: Dave Wilkinson
 *
 */

module decoders.image.jpeg;

import graphics.bitmap;

import core.string;
import core.stream;
import core.endian;
import core.definitions;

import decoders.image.decoder;
import decoders.decoder;
// Section: Codecs/Image

// Description: The JPEG Codec

class JPEGDecoder : ImageDecoder {

private :
	// Decoder States
	enum {
		JPEG_STATE_INIT_PROGRESS,

		JPEG_STATE_READ_HEADER,
		JPEG_STATE_READ_CHUNK_TYPE,
		JPEG_STATE_READ_CHUNK_SIZE,

		JPEG_STATE_INTERPRET_CHUNK,
		JPEG_STATE_SKIP_CHUNK,

		JPEG_STATE_START_OF_IMAGE,

		JPEG_STATE_CHUNK_SOF0,
		JPEG_STATE_CHUNK_SOF2,
		JPEG_STATE_CHUNK_APP0,
		JPEG_STATE_CHUNK_COM,
		JPEG_STATE_CHUNK_DNL,
		JPEG_STATE_CHUNK_DRI,

		JPEG_STATE_CHUNK_DQT,
		JPEG_STATE_CHUNK_DQT_READ_TABLE,

		JPEG_STATE_CHUNK_DHT,
		JPEG_STATE_CHUNK_DHT_READ_LENGTHS,
		JPEG_STATE_CHUNK_DHT_READ_TABLE,

		JPEG_STATE_CHUNK_SOF_READ_COMPONENTS,

		JPEG_STATE_CHUNK_APP0_UNKNOWN,
		JPEG_STATE_CHUNK_APP0_JFIF,

		JPEG_STATE_CHUNK_SOS,
		JPEG_STATE_CHUNK_SOS_READ_COMPONENTS,
		JPEG_STATE_CHUNK_SOS_READ_SELECTOR,


		JPEG_STATE_DECODE_INIT,
		JPEG_STATE_DECODE_HUFFMAN_INIT,
		JPEG_STATE_DECODE_HUFFMAN_DC,
		JPEG_STATE_DECODE_HUFFMAN_DC_READ,
		JPEG_STATE_DECODE_HUFFMAN_AC,
		JPEG_STATE_DECODE_HUFFMAN_AC_READ,
		JPEG_STATE_DECODE_IDCT,

		JPEG_STATE_RENDER_MCU,

		JPEG_STATE_READ_BYTE,
		JPEG_STATE_READ_BYTE_FF,

		JPEG_STATE_READ_BITS,
	}

	struct HUFFMAN_TABLE {
		ubyte[16] lengths;
		ubyte[][16] data;
		ubyte[16] data_pos;
		ushort[16] minor_code;
		ushort[16] major_code;
	}

	struct SCAN_COMPONENT_SELECTOR {
		ubyte Cs;
		ubyte DC_index;	//dc huffman table index
		ubyte AC_index;	//ac huffman table index
		ubyte C;		//component identifier
		ubyte H;		//horizontal sampling factor
		ubyte V;		//vertical sampling factor
		ubyte Tq;		//quantization table index
		ushort HxV;		//number of data sections
		short[] data;	//data section, allocate by (scs.H * scs.V) * 64;
		short lastDC;
	}

	struct JPEG_RENDER_INFO {
		HUFFMAN_TABLE[4] HT_DC;
		HUFFMAN_TABLE[4] HT_AC;

		ushort[64][4] quantization_table;

		ubyte Ns;

		ubyte sample_precision;
		ushort num_lines;
		ushort num_samples_per_line;

		ushort actual_image_width;
		ushort actual_image_height;

		ubyte num_image_components;

		ubyte Hmajor; ubyte Vmajor;

		SCAN_COMPONENT_SELECTOR * scan_components;

		ubyte * cb_upsample_lookup;
		ubyte * cr_upsample_lookup;

		uint component_counter;
		uint component_sample_counter;

	}

	align(1) struct JFIF_HEADER {
		ubyte version_major;
		ubyte version_minor;
		ubyte density_unit;
		ushort density_x;
		ushort density_y;
		ubyte thumb_w;
		ubyte thumb_h;
	}

	align(1) struct JPEG_SOF {
		ubyte sample_percision;			// sample percision
		ushort num_lines;				// number of lines
		ushort num_samples_per_line; 	// number of samples per line
		ubyte num_image_components; 	// number of image components per frame
	}

	align(1) struct JPEG_SOF_COMPONENTS {
		ubyte[255] component_identifier; 			// C(i)
		ubyte[255] sampling_factor;					// H(i), V(i) - hi 4 bits: horizontal, else: vertical
		ubyte[255] quantization_table_destination; 	// Tq(i)

		ubyte[255] H;
		ubyte[255] V;
		ubyte[255] HxV;
	}

	align(1) struct JPEG_SOS {
		ubyte num_image_components;
	}

	align(1) struct JPEG_SOS_COMPONENTS {
		ubyte[255] scan_components;			// C(j)
		ubyte[255] entropy_table_selector;	// Td(j), Ta(j) - hi 4 bits: DC entropy table, else: AC
	}

	align(1) struct JPEG_SOS_SELECTOR {
		ubyte start_spectral_selector;
		ubyte end_spectral_selector;
		ubyte successive_approximation;	// Ah, Al - hi 4 bits: high, else: low
	}

	align(1) struct JFIF_EXT {
		ubyte ext_code;
	}

    //static const ushort bit_mask[] = [1, 2, 4, 8, 16, 32, 64, 128]; //, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768};
    static const ushort bit_mask[] = [128, 64, 32, 16, 8, 4, 2, 1]; //, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768};

    static const ubyte zig_zag_reference[] = [0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63];

    static const float cb_b_uncode[] = [
        -226.816f, -225.044f, -223.272f, -221.5f, -219.728f, -217.956f, -216.184f, -214.412f, -212.64f, -210.868f, -209.096f,
        -207.324f, -205.552f, -203.78f, -202.008f, -200.236f, -198.464f, -196.692f, -194.92f, -193.148f, -191.376f,
        -189.604f, -187.832f, -186.06f, -184.288f, -182.516f, -180.744f, -178.972f, -177.2f, -175.428f, -173.656f,
        -171.884f, -170.112f, -168.34f, -166.568f, -164.796f, -163.024f, -161.252f, -159.48f, -157.708f, -155.936f,
        -154.164f, -152.392f, -150.62f, -148.848f, -147.076f, -145.304f, -143.532f, -141.76f, -139.988f, -138.216f,
        -136.444f, -134.672f, -132.9f, -131.128f, -129.356f, -127.584f, -125.812f, -124.04f, -122.268f, -120.496f,
        -118.724f, -116.952f, -115.18f, -113.408f, -111.636f, -109.864f, -108.092f, -106.32f, -104.548f, -102.776f,
        -101.004f, -99.232f, -97.46f, -95.688f, -93.916f, -92.144f, -90.372f, -88.6f, -86.828f, -85.056f,
        -83.284f, -81.512f, -79.74f, -77.968f, -76.196f, -74.424f, -72.652f, -70.88f, -69.108f, -67.336f,
        -65.564f, -63.792f, -62.02f, -60.248f, -58.476f, -56.704f, -54.932f, -53.16f, -51.388f, -49.616f,
        -47.844f, -46.072f, -44.3f, -42.528f, -40.756f, -38.984f, -37.212f, -35.44f, -33.668f, -31.896f,
        -30.124f, -28.352f, -26.58f, -24.808f, -23.036f, -21.264f, -19.492f, -17.72f, -15.948f, -14.176f,
        -12.404f, -10.632f, -8.86f, -7.088f, -5.316f, -3.544f, -1.772f, 0, 1.772f, 3.544f,
        5.316f, 7.088f, 8.86f, 10.632f, 12.404f, 14.176f, 15.948f, 17.72f, 19.492f, 21.264f,
        23.036f, 24.808f, 26.58f, 28.352f, 30.124f, 31.896f, 33.668f, 35.44f, 37.212f, 38.984f,
        40.756f, 42.528f, 44.3f, 46.072f, 47.844f, 49.616f, 51.388f, 53.16f, 54.932f, 56.704f,
        58.476f, 60.248f, 62.02f, 63.792f, 65.564f, 67.336f, 69.108f, 70.88f, 72.652f, 74.424f,
        76.196f, 77.968f, 79.74f, 81.512f, 83.284f, 85.056f, 86.828f, 88.6f, 90.372f, 92.144f,
        93.916f, 95.688f, 97.46f, 99.232f, 101.004f, 102.776f, 104.548f, 106.32f, 108.092f, 109.864f,
        111.636f, 113.408f, 115.18f, 116.952f, 118.724f, 120.496f, 122.268f, 124.04f, 125.812f, 127.584f,
        129.356f, 131.128f, 132.9f, 134.672f, 136.444f, 138.216f, 139.988f, 141.76f, 143.532f, 145.304f,
        147.076f, 148.848f, 150.62f, 152.392f, 154.164f, 155.936f, 157.708f, 159.48f, 161.252f, 163.024f,
        164.796f, 166.568f, 168.34f, 170.112f, 171.884f, 173.656f, 175.428f, 177.2f, 178.972f, 180.744f,
        182.516f, 184.288f, 186.06f, 187.832f, 189.604f, 191.376f, 193.148f, 194.92f, 196.692f, 198.464f,
        200.236f, 202.008f, 203.78f, 205.552f, 207.324f, 209.096f, 210.868f, 212.64f, 214.412f, 216.184f,
        217.956f, 219.728f, 221.5f, 223.272f, 225.044f
    ];

    static const float cb_g_uncode[] = [
        44.04992f, 43.70578f, 43.36164f, 43.0175f, 42.67336f, 42.32922f, 41.98508f, 41.64094f, 41.2968f, 40.95266f, 40.60852f,
        40.26438f, 39.92024f, 39.5761f, 39.23196f, 38.88782f, 38.54368f, 38.19954f, 37.8554f, 37.51126f, 37.16712f,
        36.82298f, 36.47884f, 36.1347f, 35.79056f, 35.44642f, 35.10228f, 34.75814f, 34.414f, 34.06986f, 33.72572f,
        33.38158f, 33.03744f, 32.6933f, 32.34916f, 32.00502f, 31.66088f, 31.31674f, 30.9726f, 30.62846f, 30.28432f,
        29.94018f, 29.59604f, 29.2519f, 28.90776f, 28.56362f, 28.21948f, 27.87534f, 27.5312f, 27.18706f, 26.84292f,
        26.49878f, 26.15464f, 25.8105f, 25.46636f, 25.12222f, 24.77808f, 24.43394f, 24.0898f, 23.74566f, 23.40152f,
        23.05738f, 22.71324f, 22.3691f, 22.02496f, 21.68082f, 21.33668f, 20.99254f, 20.6484f, 20.30426f, 19.96012f,
        19.61598f, 19.27184f, 18.9277f, 18.58356f, 18.23942f, 17.89528f, 17.55114f, 17.207f, 16.86286f, 16.51872f,
        16.17458f, 15.83044f, 15.4863f, 15.14216f, 14.79802f, 14.45388f, 14.10974f, 13.7656f, 13.42146f, 13.07732f,
        12.73318f, 12.38904f, 12.0449f, 11.70076f, 11.35662f, 11.01248f, 10.66834f, 10.3242f, 9.98006f, 9.63592f,
        9.29178f, 8.94764f, 8.6035f, 8.25936f, 7.91522f, 7.57108f, 7.22694f, 6.8828f, 6.53866f, 6.19452f,
        5.85038f, 5.50624f, 5.1621f, 4.81796f, 4.47382f, 4.12968f, 3.78554f, 3.4414f, 3.09726f, 2.75312f,
        2.40898f, 2.06484f, 1.7207f, 1.37656f, 1.03242f, 0.68828f, 0.34414f, 0, -0.34414f, -0.68828f,
        -1.03242f, -1.37656f, -1.7207f, -2.06484f, -2.40898f, -2.75312f, -3.09726f, -3.4414f, -3.78554f, -4.12968f,
        -4.47382f, -4.81796f, -5.1621f, -5.50624f, -5.85038f, -6.19452f, -6.53866f, -6.8828f, -7.22694f, -7.57108f,
        -7.91522f, -8.25936f, -8.6035f, -8.94764f, -9.29178f, -9.63592f, -9.98006f, -10.3242f, -10.66834f, -11.01248f,
        -11.35662f, -11.70076f, -12.0449f, -12.38904f, -12.73318f, -13.07732f, -13.42146f, -13.7656f, -14.10974f, -14.45388f,
        -14.79802f, -15.14216f, -15.4863f, -15.83044f, -16.17458f, -16.51872f, -16.86286f, -17.207f, -17.55114f, -17.89528f,
        -18.23942f, -18.58356f, -18.9277f, -19.27184f, -19.61598f, -19.96012f, -20.30426f, -20.6484f, -20.99254f, -21.33668f,
        -21.68082f, -22.02496f, -22.3691f, -22.71324f, -23.05738f, -23.40152f, -23.74566f, -24.0898f, -24.43394f, -24.77808f,
        -25.12222f, -25.46636f, -25.8105f, -26.15464f, -26.49878f, -26.84292f, -27.18706f, -27.5312f, -27.87534f, -28.21948f,
        -28.56362f, -28.90776f, -29.2519f, -29.59604f, -29.94018f, -30.28432f, -30.62846f, -30.9726f, -31.31674f, -31.66088f,
        -32.00502f, -32.34916f, -32.6933f, -33.03744f, -33.38158f, -33.72572f, -34.06986f, -34.414f, -34.75814f, -35.10228f,
        -35.44642f, -35.79056f, -36.1347f, -36.47884f, -36.82298f, -37.16712f, -37.51126f, -37.8554f, -38.19954f, -38.54368f,
        -38.88782f, -39.23196f, -39.5761f, -39.92024f, -40.26438f, -40.60852f, -40.95266f, -41.2968f, -41.64094f, -41.98508f,
        -42.32922f, -42.67336f, -43.0175f, -43.36164f, -43.70578f
    ];

    static const float cr_g_uncode[] = [
        -91.40992f, -90.69578f, -89.98164f, -89.2675f, -88.55336f, -87.83922f, -87.12508f, -86.41094f, -85.6968f, -84.98266f, -84.26852f,
        -83.55438f, -82.84024f, -82.1261f, -81.41196f, -80.69782f, -79.98368f, -79.26954f, -78.5554f, -77.84126f, -77.12712f,
        -76.41298f, -75.69884f, -74.9847f, -74.27056f, -73.55642f, -72.84228f, -72.12814f, -71.414f, -70.69986f, -69.98572f,
        -69.27158f, -68.55744f, -67.8433f, -67.12916f, -66.41502f, -65.70088f, -64.98674f, -64.2726f, -63.55846f, -62.84432f,
        -62.13018f, -61.41604f, -60.7019f, -59.98776f, -59.27362f, -58.55948f, -57.84534f, -57.1312f, -56.41706f, -55.70292f,
        -54.98878f, -54.27464f, -53.5605f, -52.84636f, -52.13222f, -51.41808f, -50.70394f, -49.9898f, -49.27566f, -48.56152f,
        -47.84738f, -47.13324f, -46.4191f, -45.70496f, -44.99082f, -44.27668f, -43.56254f, -42.8484f, -42.13426f, -41.42012f,
        -40.70598f, -39.99184f, -39.2777f, -38.56356f, -37.84942f, -37.13528f, -36.42114f, -35.707f, -34.99286f, -34.27872f,
        -33.56458f, -32.85044f, -32.1363f, -31.42216f, -30.70802f, -29.99388f, -29.27974f, -28.5656f, -27.85146f, -27.13732f,
        -26.42318f, -25.70904f, -24.9949f, -24.28076f, -23.56662f, -22.85248f, -22.13834f, -21.4242f, -20.71006f, -19.99592f,
        -19.28178f, -18.56764f, -17.8535f, -17.13936f, -16.42522f, -15.71108f, -14.99694f, -14.2828f, -13.56866f, -12.85452f,
        -12.14038f, -11.42624f, -10.7121f, -9.99796f, -9.28382f, -8.56968f, -7.85554f, -7.1414f, -6.42726f, -5.71312f,
        -4.99898f, -4.28484f, -3.5707f, -2.85656f, -2.14242f, -1.42828f, -0.71414f, 0, 0.71414f, 1.42828f,
        2.14242f, 2.85656f, 3.5707f, 4.28484f, 4.99898f, 5.71312f, 6.42726f, 7.1414f, 7.85554f, 8.56968f,
        9.28382f, 9.99796f, 10.7121f, 11.42624f, 12.14038f, 12.85452f, 13.56866f, 14.2828f, 14.99694f, 15.71108f,
        16.42522f, 17.13936f, 17.8535f, 18.56764f, 19.28178f, 19.99592f, 20.71006f, 21.4242f, 22.13834f, 22.85248f,
        23.56662f, 24.28076f, 24.9949f, 25.70904f, 26.42318f, 27.13732f, 27.85146f, 28.5656f, 29.27974f, 29.99388f,
        30.70802f, 31.42216f, 32.1363f, 32.85044f, 33.56458f, 34.27872f, 34.99286f, 35.707f, 36.42114f, 37.13528f,
        37.84942f, 38.56356f, 39.2777f, 39.99184f, 40.70598f, 41.42012f, 42.13426f, 42.8484f, 43.56254f, 44.27668f,
        44.99082f, 45.70496f, 46.4191f, 47.13324f, 47.84738f, 48.56152f, 49.27566f, 49.9898f, 50.70394f, 51.41808f,
        52.13222f, 52.84636f, 53.5605f, 54.27464f, 54.98878f, 55.70292f, 56.41706f, 57.1312f, 57.84534f, 58.55948f,
        59.27362f, 59.98776f, 60.7019f, 61.41604f, 62.13018f, 62.84432f, 63.55846f, 64.2726f, 64.98674f, 65.70088f,
        66.41502f, 67.12916f, 67.8433f, 68.55744f, 69.27158f, 69.98572f, 70.69986f, 71.414f, 72.12814f, 72.84228f,
        73.55642f, 74.27056f, 74.9847f, 75.69884f, 76.41298f, 77.12712f, 77.84126f, 78.5554f, 79.26954f, 79.98368f,
        80.69782f, 81.41196f, 82.1261f, 82.84024f, 83.55438f, 84.26852f, 84.98266f, 85.6968f, 86.41094f, 87.12508f,
        87.83922f, 88.55336f, 89.2675f, 89.98164f, 90.69578f
    ];

    static const float cr_r_uncode[] = [
        -179.456f, -178.054f, -176.652f, -175.25f, -173.848f, -172.446f, -171.044f, -169.642f, -168.24f, -166.838f, -165.436f,
        -164.034f, -162.632f, -161.23f, -159.828f, -158.426f, -157.024f, -155.622f, -154.22f, -152.818f, -151.416f,
        -150.014f, -148.612f, -147.21f, -145.808f, -144.406f, -143.004f, -141.602f, -140.2f, -138.798f, -137.396f,
        -135.994f, -134.592f, -133.19f, -131.788f, -130.386f, -128.984f, -127.582f, -126.18f, -124.778f, -123.376f,
        -121.974f, -120.572f, -119.17f, -117.768f, -116.366f, -114.964f, -113.562f, -112.16f, -110.758f, -109.356f,
        -107.954f, -106.552f, -105.15f, -103.748f, -102.346f, -100.944f, -99.542f, -98.14f, -96.738f, -95.336f,
        -93.934f, -92.532f, -91.13f, -89.728f, -88.326f, -86.924f, -85.522f, -84.12f, -82.718f, -81.316f,
        -79.914f, -78.512f, -77.11f, -75.708f, -74.306f, -72.904f, -71.502f, -70.1f, -68.698f, -67.296f,
        -65.894f, -64.492f, -63.09f, -61.688f, -60.286f, -58.884f, -57.482f, -56.08f, -54.678f, -53.276f,
        -51.874f, -50.472f, -49.07f, -47.668f, -46.266f, -44.864f, -43.462f, -42.06f, -40.658f, -39.256f,
        -37.854f, -36.452f, -35.05f, -33.648f, -32.246f, -30.844f, -29.442f, -28.04f, -26.638f, -25.236f,
        -23.834f, -22.432f, -21.03f, -19.628f, -18.226f, -16.824f, -15.422f, -14.02f, -12.618f, -11.216f,
        -9.814f, -8.412f, -7.01f, -5.608f, -4.206f, -2.804f, -1.402f, 0, 1.402f, 2.804f,
        4.206f, 5.608f, 7.01f, 8.412f, 9.814f, 11.216f, 12.618f, 14.02f, 15.422f, 16.824f,
        18.226f, 19.628f, 21.03f, 22.432f, 23.834f, 25.236f, 26.638f, 28.04f, 29.442f, 30.844f,
        32.246f, 33.648f, 35.05f, 36.452f, 37.854f, 39.256f, 40.658f, 42.06f, 43.462f, 44.864f,
        46.266f, 47.668f, 49.07f, 50.472f, 51.874f, 53.276f, 54.678f, 56.08f, 57.482f, 58.884f,
        60.286f, 61.688f, 63.09f, 64.492f, 65.894f, 67.296f, 68.698f, 70.1f, 71.502f, 72.904f,
        74.306f, 75.708f, 77.11f, 78.512f, 79.914f, 81.316f, 82.718f, 84.12f, 85.522f, 86.924f,
        88.326f, 89.728f, 91.13f, 92.532f, 93.934f, 95.336f, 96.738f, 98.14f, 99.542f, 100.944f,
        102.346f, 103.748f, 105.15f, 106.552f, 107.954f, 109.356f, 110.758f, 112.16f, 113.562f, 114.964f,
        116.366f, 117.768f, 119.17f, 120.572f, 121.974f, 123.376f, 124.778f, 126.18f, 127.582f, 128.984f,
        130.386f, 131.788f, 133.19f, 134.592f, 135.994f, 137.396f, 138.798f, 140.2f, 141.602f, 143.004f,
        144.406f, 145.808f, 147.21f, 148.612f, 150.014f, 151.416f, 152.818f, 154.22f, 155.622f, 157.024f,
        158.426f, 159.828f, 161.23f, 162.632f, 164.034f, 165.436f, 166.838f, 168.24f, 169.642f, 171.044f,
        172.446f, 173.848f, 175.25f, 176.652f, 178.054f
    ];

protected:

	JPEG_RENDER_INFO jpeg_vars;

	ushort chunkType;
	ushort chunkLength;

	ushort bytesToRead;

	JFIF_HEADER jfif;

	JPEG_SOF sof;
	SCAN_COMPONENT_SELECTOR[] sof_comp;

	JPEG_SOS sos;
	JPEG_SOS_COMPONENTS sos_comp;
	JPEG_SOS_SELECTOR sos_sel;

	HUFFMAN_TABLE HT_DC[4];
	HUFFMAN_TABLE HT_AC[4];

	HUFFMAN_TABLE* cur_ht;

	int quantization_destination;
	int quantization_precision;
	ushort[64][4] quantization_table;

	uint actual_image_width;
	uint actual_image_height;

	uint block_width;
	uint block_height;

	ubyte Hmajor;
	ubyte Vmajor;

	ubyte[] cb_upsample_lookup;
	ubyte[] cr_upsample_lookup;

	uint component_counter;
	uint component_sample_counter;

	int data_start_pos;


	ubyte cur_bit_pos;
	ubyte cur_byte;
	ushort huffman_code;
	uint huffman_bits;

	uint bits_to_read;
	ushort bits_read;
	uint first_bit;

	uint cur_ac;

	ubyte* intermediate_imgPos_Start;
	ubyte* intermediate_imgPos_Start_MCU;
	ubyte* intermediate_imgPos;

	uint image_ptr_offset;
	ulong image_length;

	uint imgylinemovement;
	uint imgylinemovement_block;

	uint imgylinemovement_block_start;
	uint imgxlinemovement_block_start;

	uint cur_block_x;
	uint cur_block_y;

public:
	override string name() {
		return "Joint Picture Experts Group";
	}

	StreamData decode(Stream stream, ref Bitmap view) {
		ImageFrameDescription imageDesc;
		bool hasMultipleFrames;

		hasMultipleFrames = false;

		ushort header;
		ubyte byteCheck;

		for (;;) {
			switch(decoderState) {
				case JPEG_STATE_READ_BYTE:

					//writefln("jpeg - decode - read byte");

					if (!stream.read(cur_byte)) {
						return StreamData.Required;
					}

					//cur_byte = file[file_idx];
					//file_idx++;

					cur_bit_pos = 0;

					// check for a FF block
					// if this is a 0xFF and the next block is a 0x00,
					// then we use this block, but skip the next byte
					if (cur_byte != 0xFF) {
						decoderState = decoderNextState;
						continue;
					}

					/* follow through */

				case JPEG_STATE_READ_BYTE_FF:

					ubyte test_byte;

					if (!stream.read(test_byte)) {
						return StreamData.Required;
					}

					//test_byte = file[file_idx];
					//file_idx++;

					// if this is not a 0x00, then check for the block type
					// else, this just effectively skips the 0x00

					if (test_byte == 0xD9) {
						// EOI (End Of Image)
						return StreamData.Complete;
					}

					decoderState = decoderNextState;

					continue;


				// state to read a certain amount of bits (bits_to_read)
				// and places them in bits_read
				case JPEG_STATE_READ_BITS:

					// cur_bit_pos tells us how many bits remain in cur_byte
					// read what we can until aligned, and then read a byte

					for (; cur_bit_pos < 8 && bits_to_read > 0; cur_bit_pos++, bits_to_read--) {
						if (first_bit == 0) {
							if (cur_byte & bit_mask[cur_bit_pos]) {
								bits_read = 0;
								first_bit = 0x11;
							}
							else {
								bits_read = 0xFFFF;
								first_bit = 0x10;
							}
						}

						bits_read <<= 1;

						if (cur_byte & bit_mask[cur_bit_pos]) {
							bits_read |= 1;
						}
					}

					if (cur_bit_pos == 8) {
						decoderState = JPEG_STATE_READ_BYTE;
						decoderNextState = JPEG_STATE_READ_BITS;
						continue;
					}

					if (bits_to_read == 0) {
						decoderState = decoderNextSubState;

						// is it a negative?
						if (first_bit == 0x10) {
							bits_read += 1; //-bits_read;
						}
					}

					continue;

				case JPEG_STATE_INIT_PROGRESS:

					decoderState = JPEG_STATE_READ_HEADER;

					/* fall through */

				case JPEG_STATE_READ_HEADER:

					if (!stream.read(header)) {
						return StreamData.Required;
					}

					if (header == FromBigEndian16(0xFFD8)) {
						// SOI (Start of Image)

						decoderState = JPEG_STATE_READ_CHUNK_TYPE;
					}
					else {
						//header not found
						return StreamData.Invalid;
					}

					/* follow through */

				case JPEG_STATE_READ_CHUNK_TYPE:
					//writeln("jpeg - reading chunk type");

					// get the the block type
					if (!stream.read(chunkType)) {
						return StreamData.Required;
					}

					chunkType = FromBigEndian16(chunkType);

					//grabbing info from block headers \ initing huffman tables

					//determine the block size
					decoderState = JPEG_STATE_READ_CHUNK_SIZE;

					/* follow through */

				case JPEG_STATE_READ_CHUNK_SIZE:

					// get chunk size

					if (!stream.read(chunkLength)) {
						return StreamData.Required;
					}

					chunkLength = FromBigEndian16(chunkLength);
					chunkLength -= 2; // supplement for the length identifier (short)

					// interpret chunk type
					decoderState = JPEG_STATE_INTERPRET_CHUNK;

					/* follow through */

				case JPEG_STATE_INTERPRET_CHUNK:
					switch(chunkType) {
						case 0xFFC0: // SOF0	(start of frame 0 - Baseline DCT)
							decoderState = JPEG_STATE_CHUNK_SOF0;
							break;
						case 0xFFC2: // SOF2	(start of frame 2 - Progressive DCT)
							decoderState = JPEG_STATE_CHUNK_SOF2;
							break;
						case 0xFFC4: // DHT (define huffman tables)
							decoderState = JPEG_STATE_CHUNK_DHT;
							break;
						case 0xFFCC: // DAC (define arithmetic coding conditionings)
							break;
						case 0xFFE0: // APP0	(signifies the JFIF spec is being utilized
							decoderState = JPEG_STATE_CHUNK_APP0;
							break;
						case 0xFFFE: // COM	(comment)
							decoderState = JPEG_STATE_CHUNK_COM;
							break;
						case 0xFFD8: // SOI (start of image)
							break;
						case 0xFFD9: // EOI (end of image)
							break;
						case 0xFFDA: // SOS (start of scan)
							decoderState = JPEG_STATE_CHUNK_SOS;
							break;
						case 0xFFDB: // DQT	(define quantization table)
							decoderState = JPEG_STATE_CHUNK_DQT;
							break;
						case 0xFFDC: // DNL (define number of lines)
							decoderState = JPEG_STATE_CHUNK_DNL;
							break;
						case 0xFFDD: // DRI	(define restart interval)
							decoderState = JPEG_STATE_CHUNK_DRI;
							break;
						case 0xFFDE: // DHP (define hierarchical progression)
							break;
						case 0xFFDF: // EXP (expand reference components)
							break;
						default:
							// just ignore unknown blocks
							// and pass over the section length
							if (!stream.skip(chunkLength))
							{
								return StreamData.Required;
							}
							decoderState = JPEG_STATE_READ_CHUNK_TYPE;
							break;
					}

					continue;

				case JPEG_STATE_CHUNK_COM:
				case JPEG_STATE_SKIP_CHUNK:

					if (!stream.skip(chunkLength)) {
						return StreamData.Required;
					}
					decoderState = JPEG_STATE_READ_CHUNK_TYPE;

					continue;

				// SOF0 - start of frame 0
				case JPEG_STATE_CHUNK_SOF0:

					// get information about the frame (dimensions)
					if (!stream.read(&sof, sof.sizeof)) {
						return StreamData.Required;
					}

					// enforce endian
					sof.num_lines = FromBigEndian16(sof.num_lines);
					sof.num_samples_per_line = FromBigEndian16(sof.num_samples_per_line);

					decoderState = JPEG_STATE_CHUNK_SOF_READ_COMPONENTS;

					/* follow through */

				case JPEG_STATE_CHUNK_SOF_READ_COMPONENTS:

					// read the image components
					if (stream.remaining < (sof.num_image_components * 3)) {
						return StreamData.Required;
					}

					sof_comp = new SCAN_COMPONENT_SELECTOR[3]; //sof.num_image_components];

					ubyte[] bytesRead = new ubyte[sof.num_image_components*3];

					stream.read(bytesRead.ptr, bytesRead.length);

					for (int n=0, a=0; a<sof.num_image_components; a++) {
						sof_comp[a].C = bytesRead[n];
						n++;

						sof_comp[a].H = cast(ubyte)((bytesRead[n] & 0xF0) >> 4);
						sof_comp[a].V = cast(ubyte)(bytesRead[n] & 0xF);
						n++;

						sof_comp[a].HxV = cast(ushort)(sof_comp[a].H * sof_comp[a].V);

						if (Hmajor < sof_comp[a].H) { Hmajor = sof_comp[a].H; }
						if (Vmajor < sof_comp[a].V) { Vmajor = sof_comp[a].V; }

						//allocate memory for the MCU data
						sof_comp[a].data = new short[sof_comp[a].HxV * 64];

						sof_comp[a].Tq = bytesRead[n];
						n++;

						sof_comp[a].lastDC = 0;
					}

					if (sof.num_image_components == 1) {
						// monochrome
						sof_comp[1].C = 2;
						sof_comp[1].data = new short[64];

						sof_comp[2].C = 3;
						sof_comp[2].data = new short[64];
					}

					//allocate memory for the image

					if (sof.num_samples_per_line % (Hmajor * 8) == 0) {
						actual_image_width = sof.num_samples_per_line;
					}
					else {
						actual_image_width = sof.num_samples_per_line + ((Hmajor * 8)-(sof.num_samples_per_line % (Hmajor * 8)));
					}

					if (sof.num_lines % (Vmajor * 8) == 0) {
						actual_image_height = sof.num_lines;
					}
					else {
						actual_image_height = sof.num_lines + ((Vmajor * 8)-(sof.num_lines % (Vmajor * 8)));
					}

					block_width = actual_image_width / (Hmajor * 8);
					block_height = actual_image_height / (Vmajor * 8);

					imgylinemovement = sof.num_samples_per_line * 4;
					imgylinemovement_block = imgylinemovement * 8;

					imgxlinemovement_block_start = 32 * Hmajor;
					imgylinemovement_block_start = imgylinemovement_block * Vmajor;

					view.create(sof.num_samples_per_line, sof.num_lines);
					//view.CreateDIB(actual_image_width, actual_image_height);

					decoderState = JPEG_STATE_READ_CHUNK_TYPE;
					continue;

				// SOF2 - start of frame 2
				case JPEG_STATE_CHUNK_SOF2:
					if (!stream.skip(chunkLength)) {
						return StreamData.Required;
					}
					decoderState = JPEG_STATE_READ_CHUNK_TYPE;
					continue;

				// APP0 - JFIF Specifications
				case JPEG_STATE_CHUNK_APP0:
					// Check for the signature of the APP0 segment
					char[5] signature;

					if (!stream.read(signature.ptr, signature.length)) {
						return StreamData.Required;
					}

					switch (signature) {
						case "JFIF\0":
							decoderState = JPEG_STATE_CHUNK_APP0_JFIF;
							break;

						case "JFXX\0":
							break;

						default:
							decoderState = JPEG_STATE_CHUNK_APP0_UNKNOWN;
							break;
					}

					continue;

				case JPEG_STATE_CHUNK_APP0_JFIF:

					// skip the unknown app extension
					if (!stream.read(&jfif, jfif.sizeof)) {
						return StreamData.Required;
					}

					jfif.density_x = FromBigEndian16(jfif.density_x);
					jfif.density_y = FromBigEndian16(jfif.density_y);

					decoderState = JPEG_STATE_READ_CHUNK_TYPE;
					continue;

				case JPEG_STATE_CHUNK_APP0_UNKNOWN:
					// skip the unknown app extension
					if (!stream.skip(chunkLength - 5)) {
						return StreamData.Required;
					}

					decoderState = JPEG_STATE_READ_CHUNK_TYPE;
					continue;






				// DHT - define huffman tables
				case JPEG_STATE_CHUNK_DHT:
					ubyte table_id;
					if (!stream.read(table_id)) {
						return StreamData.Required;
					}

					//find what table it should go into
					if (((table_id & 0x10) >> 4) == 0) {
						//DC TABLE
						cur_ht = &HT_DC[table_id & 0x03];
					}
					else {
						//AC TABLE
						cur_ht = &HT_AC[table_id & 0x03];
					}

					decoderState = JPEG_STATE_CHUNK_DHT_READ_LENGTHS;

					/* follow through */

				case JPEG_STATE_CHUNK_DHT_READ_LENGTHS:

					chunkLength -= 17;

					if (!stream.read(cur_ht.lengths.ptr, 16)) {
						return StreamData.Required;
					}

					//load the lengths into the specified table
					for (int a=0; a<16; a++) {
						int size = cur_ht.lengths[a];
						cur_ht.data[a] = new ubyte[size];
						cur_ht.data_pos[a] = 0;
					}

					decoderState = JPEG_STATE_CHUNK_DHT_READ_TABLE;

					//create the table
					int o=0;
					int n=0;

					bytesToRead = 0;

					for (int a=0; a<chunkLength; a++) {
						while (n == cur_ht.lengths[o]) {
							o++;
							n=0;

							if (o == 16) { break; }
						}
						if (o==16) { break;	}

						bytesToRead++;
						n++;
					}

					/* follow through */

				case JPEG_STATE_CHUNK_DHT_READ_TABLE:

					ubyte[] bytesRead = new ubyte[bytesToRead];

					if (!stream.read(bytesRead.ptr, bytesToRead)) {
						return StreamData.Required;
					}

					//create the table
					int o=0;
					int n=0;
					int q=0;

					for (int a=0; a<chunkLength; a++) {
						while (n == cur_ht.lengths[o]) {
							o++;
							n=0;

							if (o == 16) { break; }
						}
						if (o==16) { break;	}

						cur_ht.data[o][n] = bytesRead[q];
						q++;
						n++;
					}

					//aquire minor and major codes
					o=0;
					for (int a=0; a<16; a++) {
						cur_ht.minor_code[a] = cast(ushort)(o);
						o += cur_ht.lengths[a];
						cur_ht.major_code[a] = cast(ushort)(o-1);
						o = o << 1;
						if (cur_ht.lengths[a] == 0) {
							cur_ht.minor_code[a] = 0xFFFF;
							cur_ht.major_code[a] = 0x0000;
						}
					}

					decoderState = JPEG_STATE_READ_CHUNK_TYPE;
					continue;

				// DQT - define quantization tables
				case JPEG_STATE_CHUNK_DQT:

					chunkLength -= 65;	//supplement for the length identifier and the 1 byte for table id

					ubyte quantization_type;

					if (!stream.read(quantization_type)) {
						return StreamData.Required;
					}

					//get Pq - which is the precision... 0 for 8 bit values and 1 for 16 bit values
					quantization_precision = ((quantization_type & 0x10) >> 4);

					if (quantization_precision==1) { chunkLength -= 64; }
					//chunkLength should be 0 now

					//get Tq - the destination index of the table
					quantization_destination = (quantization_type & 0x03);

					decoderState = JPEG_STATE_CHUNK_DQT_READ_TABLE;

					/* follow through */

				case JPEG_STATE_CHUNK_DQT_READ_TABLE:

					if (quantization_precision==0) {
						ubyte[64] bytesRead;

						if (!stream.read(bytesRead.ptr, 64)) {
							return StreamData.Required;
						}

						for (int n = 0; n < 64; n++) {
							quantization_table[quantization_destination][n] = bytesRead[n];
						}
					}
					else {
						ushort[64] bytesRead;

						if (!stream.read(bytesRead.ptr, 128)) {
							return StreamData.Required;
						}

						for (int n = 0; n < 64; n++) {
							quantization_table[quantization_destination][n] = FromBigEndian16(bytesRead[n]);
						}
					}

					decoderState = JPEG_STATE_READ_CHUNK_TYPE;
					continue;

				// SOS - start of scan
				case JPEG_STATE_CHUNK_SOS:

					// read the number of image components in the scan
					// (a subset of the frame image components)
					if (!stream.read(&sos, sos.sizeof)) {
						return StreamData.Required;
					}

					decoderState = JPEG_STATE_CHUNK_SOS_READ_COMPONENTS;

					/* follow through */

				case JPEG_STATE_CHUNK_SOS_READ_COMPONENTS:

					if (stream.remaining < (sos.num_image_components * 2)) {
						return StreamData.Required;
					}

					ubyte[] bytesRead = new ubyte[sof.num_image_components*2];

					stream.read(bytesRead.ptr, bytesRead.length);

					//get the number of source components
										//jpeg_vars->Ns = in_bytes[file_counter];
					/*
					if (jpeg_vars->Ns < 1 || jpeg_vars->Ns > 4) {
						break;
					}

					if (jpeg_vars->scan_components != NULL) {
						if (jpeg_vars->num_image_components != jpeg_vars->Ns)
						{ delete jpeg_vars->scan_components; jpeg_vars->scan_components = new SCAN_COMPONENT_SELECTOR[jpeg_vars->Ns];}
					}
					else {
						jpeg_vars->scan_components = new SCAN_COMPONENT_SELECTOR[jpeg_vars->Ns];
					}*/

					//get scan component selectors
					int n = 0;
					for (int a = 0; a < sos.num_image_components; a++) {
						sof_comp[a].Cs = bytesRead[n];
						n++;

						sof_comp[a].DC_index = cast(ubyte)((bytesRead[n] & 0xF0) >> 4);
						sof_comp[a].AC_index = cast(ubyte)((bytesRead[n] & 0x0F));
						n++;

						sof_comp[a].lastDC = 0;
					}

					decoderState = JPEG_STATE_CHUNK_SOS_READ_SELECTOR;

					/* follow through */

				case JPEG_STATE_CHUNK_SOS_READ_SELECTOR:
					if (!stream.read(&sos_sel, sos_sel.sizeof)) {
						return StreamData.Required;
					}

					decoderState = JPEG_STATE_DECODE_INIT;

					/* follow through */

				case JPEG_STATE_DECODE_INIT:

					// decode init

					cb_upsample_lookup = new ubyte[64 * Hmajor * Vmajor];
					cr_upsample_lookup = new ubyte[64 * Hmajor * Vmajor];

					for (int a=0; a<3;a++) {
						sof_comp[a].lastDC = 0;

						int d0,d1,d2,d3;

						//create sampling lookup tables
						if (sof_comp[a].C == 1) {
							//Y component
						}
						else if (sof_comp[a].C == 2) {
							//ch

							d0 = 0;
							d2 = (8*Hmajor);
							for (int n=0; n<Hmajor; n++) {
								for (int q=0; q<Vmajor; q++) {
									//starting coords for the block
									d1 = (q*8) + (n*64*Hmajor);

									//for every 8x8 block in the MCU
									for (int o=0; o<8;o++) {
										d3 = d1;
										for (int p=0; p<8; p++) {
											cb_upsample_lookup[d0] = cast(ubyte)(cast(int)(d3 / (d2 * Vmajor) * 8) + cast(int)((d3 % d2)/Vmajor));
											//printf("cb %d, %d\n", cb_upsample_lookup[d0], d0);
											d3++;
											d0++;
										}

										d1+=d2;
									}
								}
							}
						}
						else if (sof_comp[a].C == 3) {
							//cr
							d0 = 0;
							d2 = (8*Hmajor);
							for (int n=0; n<Hmajor; n++) {
								for (int q=0; q<Vmajor; q++) {
									//starting coords for the block
									d1 = (q*8) + (n*64*Hmajor);

									//for every 8x8 block in the MCU
									for (int o=0; o<8;o++) {
										d3 = d1;
										for (int p=0; p<8; p++) {
											cr_upsample_lookup[d0] = cast(ubyte)(cast(int)(d3 / (d2 * Vmajor) * 8) + cast(int)((d3 % d2)/Vmajor));
											//printf("cr %d, %d\n", cr_upsample_lookup[d0], d0);
											d3++;
											d0++;
										}

										d1+=d2;
									}
								}
							}
						}
					}

					cur_bit_pos=7;

					component_counter = 0;
					component_sample_counter = 0;

					decoderState = JPEG_STATE_READ_BYTE;
					decoderNextState = JPEG_STATE_DECODE_HUFFMAN_INIT;

					continue;

				case JPEG_STATE_DECODE_HUFFMAN_INIT:

					data_start_pos = 64 * component_sample_counter;

					cur_ht = &HT_DC[sof_comp[component_counter].DC_index];

					huffman_code = 0;
					huffman_bits = 0;

					decoderState = JPEG_STATE_DECODE_HUFFMAN_DC;

					/* follow through */

				case JPEG_STATE_DECODE_HUFFMAN_DC:

					// Get DC Component

					if (huffman_bits == 16) {
						decoderState = JPEG_STATE_DECODE_HUFFMAN_DC_READ;

						huffman_code = 0;
						huffman_bits = 0;
					}
					else {
						if (cur_bit_pos == 8) {
							decoderNextState = JPEG_STATE_DECODE_HUFFMAN_DC;
							decoderState = JPEG_STATE_READ_BYTE;
							continue;
						}

						huffman_code <<= 1;
						if (cur_byte & bit_mask[cur_bit_pos]) {
							huffman_code |= 1;
						}

						cur_bit_pos++;

						if (huffman_code >= cur_ht.minor_code[huffman_bits]  && huffman_code <= cur_ht.major_code[huffman_bits]) {

							//valid code

							huffman_code -= cur_ht.minor_code[huffman_bits]; //get its position within that range of length!
							huffman_code = cur_ht.data[huffman_bits][huffman_code];

							//huffman_code == the # of bits following the code to read in
							if (huffman_code == 0) {
								sof_comp[component_counter].data[data_start_pos] = sof_comp[component_counter].lastDC;
								sof_comp[component_counter].data[data_start_pos] *= quantization_table[sof_comp[component_counter].Tq][0];

								decoderState = JPEG_STATE_DECODE_HUFFMAN_AC;

								// init AC huffman table
								cur_ht = &HT_AC[sof_comp[component_counter].AC_index];

								cur_ac = 1;
							}
							else {
								bits_read = 0;
								bits_to_read = huffman_code;
								first_bit = 0;

								decoderNextSubState = JPEG_STATE_DECODE_HUFFMAN_DC_READ;
								decoderState = JPEG_STATE_READ_BITS;
							}

							huffman_code = 0;
							huffman_bits = 0;
						}
						else {
							huffman_bits++;
						}

						continue;
					}

				case JPEG_STATE_DECODE_HUFFMAN_DC_READ:

					// read_bits state has stored the read code into bits_read

					int d0 = cast(short)bits_read;

					//huffman_code is actually component_counter value of the dc coefficent
					d0 += sof_comp[component_counter].lastDC;
					sof_comp[component_counter].data[data_start_pos] = cast(short)d0;
					sof_comp[component_counter].lastDC = sof_comp[component_counter].data[data_start_pos];
					d0 *= quantization_table[sof_comp[component_counter].Tq][0];
					sof_comp[component_counter].data[data_start_pos] = cast(short)d0;

					// init AC huffman table
					cur_ht = &HT_AC[sof_comp[component_counter].AC_index];

					cur_ac = 1;

					huffman_code = 0;
					huffman_bits = 0;

					decoderState = JPEG_STATE_DECODE_HUFFMAN_AC;

					/* follow through */

				case JPEG_STATE_DECODE_HUFFMAN_AC:

					// Get AC Components
					if (cur_ac >= 64) {
						// HUFFMAN CODING END
						decoderState = JPEG_STATE_DECODE_IDCT;
						huffman_code = 0;
						huffman_bits = 0;
						continue;
					}

					//from the next bits in the stream...find the first valid huffman code

					if (huffman_bits == 16) {
						decoderState = JPEG_STATE_DECODE_HUFFMAN_AC_READ;

						huffman_code = 0;
						huffman_bits = 0;
					}
					else {
						if (cur_bit_pos == 8) {
							decoderNextState = JPEG_STATE_DECODE_HUFFMAN_AC;
							decoderState = JPEG_STATE_READ_BYTE;
							continue;
						}

						huffman_code <<= 1;
						if (cur_byte & bit_mask[cur_bit_pos]) {
							huffman_code |= 1;
						}

						cur_bit_pos++;

						if (huffman_code >= cur_ht.minor_code[huffman_bits]  && huffman_code <= cur_ht.major_code[huffman_bits]) {

							//valid code

							huffman_code -= cur_ht.minor_code[huffman_bits]; //get its position within that range of length!
							huffman_code = cur_ht.data[huffman_bits][huffman_code];

							//code: (o, q);
							int q=huffman_code & 0xF;	//bit_count
							int o=huffman_code >> 4;	//zero_count

							if (q == 0) {
								if (o == 0) {
									//code: (0, 0)
									//end of data
									//the rest are zeroes
									o = 64;

									while (cur_ac!=o) {
										sof_comp[component_counter].data[data_start_pos+zig_zag_reference[cur_ac]] = 0;
										cur_ac++;
									}
								}
								else if (o==0xF) {
									// code: (15, 0)
									//next 16 spaces of data are zeroes!
									if (cur_ac+16 > 64) {
										o = 64;
									}
									else {
										o = cur_ac+16;
									}

									while (cur_ac!=o) {
										sof_comp[component_counter].data[data_start_pos+zig_zag_reference[cur_ac]] = 0;
										cur_ac++;
									}
								}
							}
							else {
								//set zeroes in all the spaces marked in zero_count
								if (cur_ac+o > 64) {
									o = 64;
								}
								else {
									o = cur_ac+o;
								}

								//set the items from p to o
								while (cur_ac!=o) {
									sof_comp[component_counter].data[data_start_pos+zig_zag_reference[cur_ac]] = 0;
									cur_ac++;
								}

								// grab the next 'q' bits from the stream
								bits_read = 0;
								bits_to_read = q;
								first_bit = 0;

								decoderNextSubState = JPEG_STATE_DECODE_HUFFMAN_AC_READ;
								decoderState = JPEG_STATE_READ_BITS;
							}

							huffman_code = 0;
							huffman_bits = 0;
						}
						else {
							huffman_bits++;
						}
					}

					continue;

				case JPEG_STATE_DECODE_HUFFMAN_AC_READ:

					//bits_read is actually the value of the data

					if (cur_ac < 64) {
						sof_comp[component_counter].data[data_start_pos+zig_zag_reference[cur_ac]] = cast(short)(cast(short)bits_read * quantization_table[sof_comp[component_counter].Tq][cur_ac]);
						cur_ac++;
					}

					decoderState = JPEG_STATE_DECODE_HUFFMAN_AC;
					huffman_code = 0;
					huffman_bits = 0;

					continue;

				case JPEG_STATE_DECODE_IDCT:
					// integer, fixed point implementation of IDCT

					//at this point we should have component_counter 8 x 8 block

					//IDCT

					short* dataRef = &sof_comp[component_counter].data[data_start_pos];

					int d0,d1,d2,d3,d4,d5,d6,d7,tmp;

					for (int o=0; o<8; o++) {
						d4 = dataRef[7]; d5 = dataRef[5]; d6 = dataRef[3]; d7 = dataRef[1];

						d2 = d4 + d6; d3 = d5 + d7;

						d1 = (d2 + d3) * 77062; d2 *= -128553; d3 *= -25571; d2 += d1; d3 += d1;

						d1 = (d4 + d7) * -58981; d4 *= 19571; d7 *= 98391; d4 += d1; d7 += d1;

						d1 = (d5 + d6) * -167963; d5 *= 134553; d6 *= 201373; d5 += d1; d6 += d1;

						d4 += d2; d5 += d3; d6 += d2; d7 += d3;

						//even

						d3 = dataRef[2]; d2 = dataRef[6];

						d1 = (d3 + d2) * 35468; d3 *= 50159; d2 *= -121095; d3 += d1; d2 += d1;

						d0 = dataRef[0] + dataRef[4]; d1 = dataRef[0] - dataRef[4];

						d0 = (d0 << 16) + 4096; d1 = (d1 << 16) + 4096;

						tmp = d0 + d3; d3 = d0 - d3; d0 = tmp;

						tmp = d1 + d2; d2 = d1 - d2; d1 = tmp;

						tmp = d0 + d7; d7 = d0 - d7; d0 = tmp;

						dataRef[0] = cast(short)(d0 >> 13); dataRef[7] = cast(short)(d7 >> 13);

						d0 = d1 + d6; d6 = d1 - d6; d1 = d0;

						dataRef[1] = cast(short)(d1 >> 13); dataRef[6] = cast(short)(d6 >> 13);

						d0 = d2 + d5; d5 = d2 - d5; d2 = d0;

						dataRef[2] = cast(short)(d2 >> 13); dataRef[5] = cast(short)(d5 >> 13);

						d0 = d3 + d4; d4 = d3 - d4; d3 = d0;

						dataRef[3] = cast(short)(d3 >> 13); dataRef[4] = cast(short)(d4 >> 13);

						dataRef += 8;
					}

					dataRef = &sof_comp[component_counter].data[data_start_pos];

					for (int o=0; o<8; o++) {
						// odd

						d4 = dataRef[56]; d5 = dataRef[40]; d6 = dataRef[24]; d7 = dataRef[8];

						d2 = d4 + d6; d3 = d5 + d7;

						d1 = (d2 + d3) * 77062; d2 *= -128553; d3 *= -25571; d2 += d1; d3 += d1;

						d1 = (d4 + d7) * -58981; d4 *= 19571; d7 *= 98391; d4 += d1; d7 += d1;

						d1 = (d5 + d6) * -167963; d5 *= 134553; d6 *= 201373; d5 += d1; d6 += d1;

						d4 += d2; d5 += d3; d6 += d2; d7 += d3;

						// even

						d3 = dataRef[2*8]; d2 = dataRef[6*8];

						d1 = (d3 + d2) * 35468; d3 *= 50159; d2 *= -121095; d3 += d1; d2 += d1;

						d0 = dataRef[0] + dataRef[32]; d1 = dataRef[0] - dataRef[32];

						d0 = (d0 << 16) + 2097152; d1 = (d1 << 16) + 2097152;

						tmp = d0 + d3; d3 = d0 - d3; d0 = tmp;

						tmp = d1 + d2; d2 = d1 - d2; d1 = tmp;

						tmp = d0 + d7; d7 = d0 - d7; d0 = tmp;

						//the 128 is part of the rescaling process of JPEG
						//and is not part of the IDCT algorithm

						//526870912 is 128 << 22

						d0 += (128 << 22); dataRef[0] = cast(short)(d0 >> 22) ;
						if (dataRef[0] > 255) { dataRef[0] = 255; } else if (dataRef[0] < 0) { dataRef[0] = 0;}

						d7 += (128 << 22); dataRef[56] = cast(short)(d7 >> 22) ;
						if (dataRef[56] > 255) { dataRef[56] = 255; } else if (dataRef[56] < 0) { dataRef[56] = 0;}

						d0 = d1 + d6; d6 = d1 - d6; d1 = d0;

						d1 += (128 << 22); dataRef[8] = cast(short)(d1 >> 22) ;
						if (dataRef[8] > 255) { dataRef[8] = 255; } else if (dataRef[8] < 0) { dataRef[8] = 0;}

						d6 += (128 << 22); dataRef[48] = cast(short)(d6 >> 22) ;
						if (dataRef[48] > 255) { dataRef[48] = 255; } else if (dataRef[48] < 0) { dataRef[48] = 0;}

						d0 = d2 + d5; d5 = d2 - d5; d2 = d0;

						d2 += (128 << 22);
						dataRef[16] = cast(short)(d2 >> 22) ;
						if (dataRef[16] > 255) { dataRef[16] = 255; } else if (dataRef[16] < 0) { dataRef[16] = 0;}

						d5 += (128 << 22); dataRef[40] = cast(short)(d5 >> 22) ;
						if (dataRef[40] > 255) { dataRef[40] = 255; } else if (dataRef[40] < 0) { dataRef[40] = 0;}

						d0 = d3 + d4; d4 = d3 - d4; d3 = d0;

						d3 += (128 << 22); dataRef[24] = cast(short)(d3 >> 22) ;
						if (dataRef[24] > 255) { dataRef[24] = 255; } else if (dataRef[24] < 0) { dataRef[24] = 0;}

						d4 += (128 << 22); dataRef[32] = cast(short)(d4 >> 22) ;
						if (dataRef[32] > 255) { dataRef[32] = 255; } else if (dataRef[32] < 0) { dataRef[32] = 0;}

						dataRef++;
					}

					//the IDCT has been done...we now have uncompressed data for this 8x8, 8 bit component

					//goto the next sample or next component to complete the scan
					component_sample_counter++;
					if (component_sample_counter == sof_comp[component_counter].HxV) {
						component_counter++;
						component_sample_counter=0;
					}

					if (component_counter != sof.num_image_components) {
						// continue decoding components
						decoderState = JPEG_STATE_DECODE_HUFFMAN_INIT;
						continue;
					}

					decoderState = JPEG_STATE_RENDER_MCU;

					/* follow through */

				case JPEG_STATE_RENDER_MCU:

					//writefln("jpeg - render - mcu");

					//we have decoded the MCU at this point
					//paint the MCU to the image

					//now, for every 8x8 pixel block, we will take the 8x8 information we have to
					//place the RGB transformed pixels on the image

					// LOCK the buffer, if it hasn't been locked yet
					if (intermediate_imgPos_Start is null) {
						view.lockBuffer(cast(void**)&intermediate_imgPos_Start, image_length);
					}

					intermediate_imgPos_Start_MCU = intermediate_imgPos_Start + image_ptr_offset;

					int d0=0;	//Y data index
					ushort* d0_pos;
					ushort* d1_pos;
					ushort* d2_pos;

					int d3=255;	//Y scan component index
					int d4=255;	//Cb scan component index
					int d5=255;	//Cr scan component index

					int a;

					for (a=0; a<3; a++) {
						if (sof_comp[a].C == 1) {
							//Y component
							d0_pos = cast(ushort*)sof_comp[a].data.ptr;
							d3=a;
						}
						else if (sof_comp[a].C == 2) {
							//cb
							d1_pos = cast(ushort*)sof_comp[a].data.ptr;
							d4=a;
						}
						else if (sof_comp[a].C == 3) {
							//cr
							d2_pos = cast(ushort*)sof_comp[a].data.ptr;
							d5=a;
						}
					}

					a=0;

					while (a<Vmajor) {
						for (int q=0;q<Hmajor;q++) {
							//code will be run through for every 8x8 block represented by this MCU
							//in this order:
							// /-------\
							// | 1 | 2 |
							// |-------|	a 2x2 MCU (could also be 1x1, 1x2, or 2x1 in common situations)
							// | 3 | 4 |
							// \-------/

							intermediate_imgPos = intermediate_imgPos_Start_MCU;


							float ab;

							if (sof.num_image_components == 1) {
								for (int n=0; n<8; n++) {
									for (int p=0; p<8; p++) {
										ubyte r,g,b;

										//write at the RGBA of intermediate_imgPos;
										r = g = b = (cast(ubyte)d0_pos[d0]);

										*(cast(uint*)intermediate_imgPos) = view.rgbaTouint(r,g,b,0xFF);

										d0++;

										intermediate_imgPos+=4;
									}
									intermediate_imgPos+=imgylinemovement-32;
								}
							}
							else {
								for (int n=0; n<8; n++) {
									for (int p=0; p<8; p++) {
										ubyte r,g,b;

										//write at the RGBA of intermediate_imgPos;
										ab = (cb_b_uncode[d1_pos[cb_upsample_lookup[d0]]] + cast(float)d0_pos[d0]);
										if (ab > 255) { ab = 255; }	else if (ab < 0) { ab = 0; }
										b = cast(ubyte)(ab);	//BB

										ab = (cb_g_uncode[d1_pos[cb_upsample_lookup[d0]]] - cr_g_uncode[d2_pos[cr_upsample_lookup[d0]]] + cast(float)d0_pos[d0]);
										if (ab > 255) { ab = 255; }	else if (ab < 0) { ab = 0; }
										g = cast(ubyte)(ab);		//GG

										ab = (cr_r_uncode[d2_pos[cr_upsample_lookup[d0]]] + cast(float)d0_pos[d0]);
										if (ab > 255) { ab = 255; }	else if (ab < 0) { ab = 0; }
										r = cast(ubyte)(ab);		//RR

										*(cast(uint*)intermediate_imgPos) = view.rgbaTouint(r,g,b,0xFF);

										d0++;

										intermediate_imgPos+=4;
									}
									intermediate_imgPos+=imgylinemovement-32;
								}
							}
							//translate pixels, place on image buffer

							//move over image pointer in the X direction
							intermediate_imgPos_Start_MCU+=32;
						} //end for (q)

						//reset X direction
						//move down image pointer in the Y direction
						a++;

						intermediate_imgPos_Start_MCU = intermediate_imgPos_Start + (image_ptr_offset + (a * imgylinemovement_block));
					} //end for (a)

					//move image buffer pointer to point at coords of next MCU block

					cur_block_x++;
					if (cur_block_x == block_width) {
						cur_block_x = 0;
						cur_block_y++;

						image_ptr_offset = (cur_block_y * imgylinemovement_block_start);

						if(cur_block_y == block_height) {
							//we should be done
							//we have decoded the frame

							if (intermediate_imgPos_Start !is null) {
								intermediate_imgPos_Start = null;
								view.unlockBuffer();
							}
							return StreamData.Complete;
						}
					}
					else {
						image_ptr_offset += imgxlinemovement_block_start;
					}

					component_counter=0;

					decoderState = JPEG_STATE_DECODE_HUFFMAN_INIT;
					continue;

				default:
					break;
			}
			break;
		}
		return StreamData.Invalid;
	}
}
