/*
 * glext.d;
 *
 * This module binds to the OpenGL Extensions found in glext.h.
 */

module binding.opengl.glext;

import binding.opengl.gl;

version = GL_GLEXT_PROTOTYPES;

// Original Copyright Follows

/*
** Copyright (c) 2007-2010 The Khronos Group Inc.
** 
** Permission is hereby granted, free of charge, to any person obtaining a;
** copy of this software and/or associated documentation files (the;
** "Materials"), to deal in the Materials without restriction, including
** without limitation the rights to use, copy, modify, merge, publish,
** distribute, sublicense, and/or sell copies of the Materials, and to
** permit persons to whom the Materials are furnished to do so, subject to
** the following conditions:
**
** The above copyright notice and this permission notice shall be included;
** in all copies or substantial portions of the Materials.
** 
** THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES Of;
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THe;
** MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.
*/

/* Header file version number, required by OpenGL ABI for Linux */
/* glext.h last updated $Date: 2010-04-09 02:45:33 -0700 (Fri, 09 Apr 2010) $ */
/* Current version at http://www.opengl.org/registry/ */
static const auto GL_GLEXT_VERSION = 61;

extern(System):

/*************************************************************/

version(GL_VERSION_1_2) {
}
else {
	static const auto GL_UNSIGNED_BYTE_3_3_2            = 0x8032;
	static const auto GL_UNSIGNED_SHORT_4_4_4_4         = 0x8033;
	static const auto GL_UNSIGNED_SHORT_5_5_5_1         = 0x8034;
	static const auto GL_UNSIGNED_INT_8_8_8_8           = 0x8035;
	static const auto GL_UNSIGNED_INT_10_10_10_2        = 0x8036;
	static const auto GL_TEXTURE_BINDING_3D             = 0x806A;
	static const auto GL_PACK_SKIP_IMAGES               = 0x806B;
	static const auto GL_PACK_IMAGE_HEIGHT              = 0x806C;
	static const auto GL_UNPACK_SKIP_IMAGES             = 0x806D;
	static const auto GL_UNPACK_IMAGE_HEIGHT            = 0x806E;
	static const auto GL_TEXTURE_3D                     = 0x806F;
	static const auto GL_PROXY_TEXTURE_3D               = 0x8070;
	static const auto GL_TEXTURE_DEPTH                  = 0x8071;
	static const auto GL_TEXTURE_WRAP_R                 = 0x8072;
	static const auto GL_MAX_3D_TEXTURE_SIZE            = 0x8073;
	static const auto GL_UNSIGNED_BYTE_2_3_3_REV        = 0x8362;
	static const auto GL_UNSIGNED_SHORT_5_6_5           = 0x8363;
	static const auto GL_UNSIGNED_SHORT_5_6_5_REV       = 0x8364;
	static const auto GL_UNSIGNED_SHORT_4_4_4_4_REV     = 0x8365;
	static const auto GL_UNSIGNED_SHORT_1_5_5_5_REV     = 0x8366;
	static const auto GL_UNSIGNED_INT_8_8_8_8_REV       = 0x8367;
	static const auto GL_UNSIGNED_INT_2_10_10_10_REV    = 0x8368;
	static const auto GL_BGR                            = 0x80E0;
	static const auto GL_BGRA                           = 0x80E1;
	static const auto GL_MAX_ELEMENTS_VERTICES          = 0x80E8;
	static const auto GL_MAX_ELEMENTS_INDICES           = 0x80E9;
	static const auto GL_CLAMP_TO_EDGE                  = 0x812F;
	static const auto GL_TEXTURE_MIN_LOD                = 0x813A;
	static const auto GL_TEXTURE_MAX_LOD                = 0x813B;
	static const auto GL_TEXTURE_BASE_LEVEL             = 0x813C;
	static const auto GL_TEXTURE_MAX_LEVEL              = 0x813D;
	static const auto GL_SMOOTH_POINT_SIZE_RANGE        = 0x0B12;
	static const auto GL_SMOOTH_POINT_SIZE_GRANULARITY  = 0x0B13;
	static const auto GL_SMOOTH_LINE_WIDTH_RANGE        = 0x0B22;
	static const auto GL_SMOOTH_LINE_WIDTH_GRANULARITY  = 0x0B23;
	static const auto GL_ALIASED_LINE_WIDTH_RANGE       = 0x846e;
}

version(GL_VERSION_1_2_DEPRECATED) {
}
else {
	static const auto GL_RESCALE_NORMAL                 = 0x803a;
	static const auto GL_LIGHT_MODEL_COLOR_CONTROL      = 0x81F8;
	static const auto GL_SINGLE_COLOR                   = 0x81F9;
	static const auto GL_SEPARATE_SPECULAR_COLOR        = 0x81Fa;
	static const auto GL_ALIASED_POINT_SIZE_RANGE       = 0x846d;
}

version(GL_ARB_imaging) {
}
else {
	static const auto GL_CONSTANT_COLOR                 = 0x8001;
	static const auto GL_ONE_MINUS_CONSTANT_COLOR       = 0x8002;
	static const auto GL_CONSTANT_ALPHA                 = 0x8003;
	static const auto GL_ONE_MINUS_CONSTANT_ALPHA       = 0x8004;
	static const auto GL_BLEND_COLOR                    = 0x8005;
	static const auto GL_FUNC_ADD                       = 0x8006;
	static const auto GL_MIN                            = 0x8007;
	static const auto GL_MAX                            = 0x8008;
	static const auto GL_BLEND_EQUATION                 = 0x8009;
	static const auto GL_FUNC_SUBTRACT                  = 0x800a;
	static const auto GL_FUNC_REVERSE_SUBTRACT          = 0x800b;
}

version(GL_ARB_imaging_DEPRECATED) {
}
else {
	static const auto GL_CONVOLUTION_1D                 = 0x8010;
	static const auto GL_CONVOLUTION_2D                 = 0x8011;
	static const auto GL_SEPARABLE_2D                   = 0x8012;
	static const auto GL_CONVOLUTION_BORDER_MODE        = 0x8013;
	static const auto GL_CONVOLUTION_FILTER_SCALE       = 0x8014;
	static const auto GL_CONVOLUTION_FILTER_BIAS        = 0x8015;
	static const auto GL_REDUCE                         = 0x8016;
	static const auto GL_CONVOLUTION_FORMAT             = 0x8017;
	static const auto GL_CONVOLUTION_WIDTH              = 0x8018;
	static const auto GL_CONVOLUTION_HEIGHT             = 0x8019;
	static const auto GL_MAX_CONVOLUTION_WIDTH          = 0x801a;
	static const auto GL_MAX_CONVOLUTION_HEIGHT         = 0x801b;
	static const auto GL_POST_CONVOLUTION_RED_SCALE     = 0x801c;
	static const auto GL_POST_CONVOLUTION_GREEN_SCALE   = 0x801d;
	static const auto GL_POST_CONVOLUTION_BLUE_SCALE    = 0x801e;
	static const auto GL_POST_CONVOLUTION_ALPHA_SCALE   = 0x801f;
	static const auto GL_POST_CONVOLUTION_RED_BIAS      = 0x8020;
	static const auto GL_POST_CONVOLUTION_GREEN_BIAS    = 0x8021;
	static const auto GL_POST_CONVOLUTION_BLUE_BIAS     = 0x8022;
	static const auto GL_POST_CONVOLUTION_ALPHA_BIAS    = 0x8023;
	static const auto GL_HISTOGRAM                      = 0x8024;
	static const auto GL_PROXY_HISTOGRAM                = 0x8025;
	static const auto GL_HISTOGRAM_WIDTH                = 0x8026;
	static const auto GL_HISTOGRAM_FORMAT               = 0x8027;
	static const auto GL_HISTOGRAM_RED_SIZE             = 0x8028;
	static const auto GL_HISTOGRAM_GREEN_SIZE           = 0x8029;
	static const auto GL_HISTOGRAM_BLUE_SIZE            = 0x802a;
	static const auto GL_HISTOGRAM_ALPHA_SIZE           = 0x802b;
	static const auto GL_HISTOGRAM_LUMINANCE_SIZE       = 0x802c;
	static const auto GL_HISTOGRAM_SINK                 = 0x802d;
	static const auto GL_MINMAX                         = 0x802e;
	static const auto GL_MINMAX_FORMAT                  = 0x802f;
	static const auto GL_MINMAX_SINK                    = 0x8030;
	static const auto GL_TABLE_TOO_LARGE                = 0x8031;
	static const auto GL_COLOR_MATRIX                   = 0x80B1;
	static const auto GL_COLOR_MATRIX_STACK_DEPTH       = 0x80B2;
	static const auto GL_MAX_COLOR_MATRIX_STACK_DEPTH   = 0x80B3;
	static const auto GL_POST_COLOR_MATRIX_RED_SCALE    = 0x80B4;
	static const auto GL_POST_COLOR_MATRIX_GREEN_SCALE  = 0x80B5;
	static const auto GL_POST_COLOR_MATRIX_BLUE_SCALE   = 0x80B6;
	static const auto GL_POST_COLOR_MATRIX_ALPHA_SCALE  = 0x80B7;
	static const auto GL_POST_COLOR_MATRIX_RED_BIAS     = 0x80B8;
	static const auto GL_POST_COLOR_MATRIX_GREEN_BIAS   = 0x80B9;
	static const auto GL_POST_COLOR_MATRIX_BLUE_BIAS    = 0x80Ba;
	static const auto GL_POST_COLOR_MATRIX_ALPHA_BIAS   = 0x80Bb;
	static const auto GL_COLOR_TABLE                    = 0x80D0;
	static const auto GL_POST_CONVOLUTION_COLOR_TABLE   = 0x80D1;
	static const auto GL_POST_COLOR_MATRIX_COLOR_TABLE  = 0x80D2;
	static const auto GL_PROXY_COLOR_TABLE              = 0x80D3;
	static const auto GL_PROXY_POST_CONVOLUTION_COLOR_TABLE = 0x80D4;
	static const auto GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE = 0x80D5;
	static const auto GL_COLOR_TABLE_SCALE              = 0x80D6;
	static const auto GL_COLOR_TABLE_BIAS               = 0x80D7;
	static const auto GL_COLOR_TABLE_FORMAT             = 0x80D8;
	static const auto GL_COLOR_TABLE_WIDTH              = 0x80D9;
	static const auto GL_COLOR_TABLE_RED_SIZE           = 0x80Da;
	static const auto GL_COLOR_TABLE_GREEN_SIZE         = 0x80Db;
	static const auto GL_COLOR_TABLE_BLUE_SIZE          = 0x80Dc;
	static const auto GL_COLOR_TABLE_ALPHA_SIZE         = 0x80Dd;
	static const auto GL_COLOR_TABLE_LUMINANCE_SIZE     = 0x80De;
	static const auto GL_COLOR_TABLE_INTENSITY_SIZE     = 0x80Df;
	static const auto GL_CONSTANT_BORDER                = 0x8151;
	static const auto GL_REPLICATE_BORDER               = 0x8153;
	static const auto GL_CONVOLUTION_BORDER_COLOR       = 0x8154;
}

version(GL_VERSION_1_3) {
}
else {
	static const auto GL_TEXTURE0                       = 0x84C0;
	static const auto GL_TEXTURE1                       = 0x84C1;
	static const auto GL_TEXTURE2                       = 0x84C2;
	static const auto GL_TEXTURE3                       = 0x84C3;
	static const auto GL_TEXTURE4                       = 0x84C4;
	static const auto GL_TEXTURE5                       = 0x84C5;
	static const auto GL_TEXTURE6                       = 0x84C6;
	static const auto GL_TEXTURE7                       = 0x84C7;
	static const auto GL_TEXTURE8                       = 0x84C8;
	static const auto GL_TEXTURE9                       = 0x84C9;
	static const auto GL_TEXTURE10                      = 0x84Ca;
	static const auto GL_TEXTURE11                      = 0x84Cb;
	static const auto GL_TEXTURE12                      = 0x84Cc;
	static const auto GL_TEXTURE13                      = 0x84Cd;
	static const auto GL_TEXTURE14                      = 0x84Ce;
	static const auto GL_TEXTURE15                      = 0x84Cf;
	static const auto GL_TEXTURE16                      = 0x84D0;
	static const auto GL_TEXTURE17                      = 0x84D1;
	static const auto GL_TEXTURE18                      = 0x84D2;
	static const auto GL_TEXTURE19                      = 0x84D3;
	static const auto GL_TEXTURE20                      = 0x84D4;
	static const auto GL_TEXTURE21                      = 0x84D5;
	static const auto GL_TEXTURE22                      = 0x84D6;
	static const auto GL_TEXTURE23                      = 0x84D7;
	static const auto GL_TEXTURE24                      = 0x84D8;
	static const auto GL_TEXTURE25                      = 0x84D9;
	static const auto GL_TEXTURE26                      = 0x84Da;
	static const auto GL_TEXTURE27                      = 0x84Db;
	static const auto GL_TEXTURE28                      = 0x84Dc;
	static const auto GL_TEXTURE29                      = 0x84Dd;
	static const auto GL_TEXTURE30                      = 0x84De;
	static const auto GL_TEXTURE31                      = 0x84Df;
	static const auto GL_ACTIVE_TEXTURE                 = 0x84E0;
	static const auto GL_MULTISAMPLE                    = 0x809d;
	static const auto GL_SAMPLE_ALPHA_TO_COVERAGE       = 0x809e;
	static const auto GL_SAMPLE_ALPHA_TO_ONE            = 0x809f;
	static const auto GL_SAMPLE_COVERAGE                = 0x80A0;
	static const auto GL_SAMPLE_BUFFERS                 = 0x80A8;
	static const auto GL_SAMPLES                        = 0x80A9;
	static const auto GL_SAMPLE_COVERAGE_VALUE          = 0x80Aa;
	static const auto GL_SAMPLE_COVERAGE_INVERT         = 0x80Ab;
	static const auto GL_TEXTURE_CUBE_MAP               = 0x8513;
	static const auto GL_TEXTURE_BINDING_CUBE_MAP       = 0x8514;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_X    = 0x8515;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_X    = 0x8516;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_Y    = 0x8517;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_Y    = 0x8518;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_Z    = 0x8519;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_Z    = 0x851a;
	static const auto GL_PROXY_TEXTURE_CUBE_MAP         = 0x851b;
	static const auto GL_MAX_CUBE_MAP_TEXTURE_SIZE      = 0x851c;
	static const auto GL_COMPRESSED_RGB                 = 0x84Ed;
	static const auto GL_COMPRESSED_RGBA                = 0x84Ee;
	static const auto GL_TEXTURE_COMPRESSION_HINT       = 0x84Ef;
	static const auto GL_TEXTURE_COMPRESSED_IMAGE_SIZE  = 0x86A0;
	static const auto GL_TEXTURE_COMPRESSED             = 0x86A1;
	static const auto GL_NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
	static const auto GL_COMPRESSED_TEXTURE_FORMATS     = 0x86A3;
	static const auto GL_CLAMP_TO_BORDER                = 0x812d;
}

version(GL_VERSION_1_3_DEPRECATED) {
}
else {
	static const auto GL_CLIENT_ACTIVE_TEXTURE          = 0x84E1;
	static const auto GL_MAX_TEXTURE_UNITS              = 0x84E2;
	static const auto GL_TRANSPOSE_MODELVIEW_MATRIX     = 0x84E3;
	static const auto GL_TRANSPOSE_PROJECTION_MATRIX    = 0x84E4;
	static const auto GL_TRANSPOSE_TEXTURE_MATRIX       = 0x84E5;
	static const auto GL_TRANSPOSE_COLOR_MATRIX         = 0x84E6;
	static const auto GL_MULTISAMPLE_BIT                = 0x20000000;
	static const auto GL_NORMAL_MAP                     = 0x8511;
	static const auto GL_REFLECTION_MAP                 = 0x8512;
	static const auto GL_COMPRESSED_ALPHA               = 0x84E9;
	static const auto GL_COMPRESSED_LUMINANCE           = 0x84Ea;
	static const auto GL_COMPRESSED_LUMINANCE_ALPHA     = 0x84Eb;
	static const auto GL_COMPRESSED_INTENSITY           = 0x84Ec;
	static const auto GL_COMBINE                        = 0x8570;
	static const auto GL_COMBINE_RGB                    = 0x8571;
	static const auto GL_COMBINE_ALPHA                  = 0x8572;
	static const auto GL_SOURCE0_RGB                    = 0x8580;
	static const auto GL_SOURCE1_RGB                    = 0x8581;
	static const auto GL_SOURCE2_RGB                    = 0x8582;
	static const auto GL_SOURCE0_ALPHA                  = 0x8588;
	static const auto GL_SOURCE1_ALPHA                  = 0x8589;
	static const auto GL_SOURCE2_ALPHA                  = 0x858a;
	static const auto GL_OPERAND0_RGB                   = 0x8590;
	static const auto GL_OPERAND1_RGB                   = 0x8591;
	static const auto GL_OPERAND2_RGB                   = 0x8592;
	static const auto GL_OPERAND0_ALPHA                 = 0x8598;
	static const auto GL_OPERAND1_ALPHA                 = 0x8599;
	static const auto GL_OPERAND2_ALPHA                 = 0x859a;
	static const auto GL_RGB_SCALE                      = 0x8573;
	static const auto GL_ADD_SIGNED                     = 0x8574;
	static const auto GL_INTERPOLATE                    = 0x8575;
	static const auto GL_SUBTRACT                       = 0x84E7;
	static const auto GL_CONSTANT                       = 0x8576;
	static const auto GL_PRIMARY_COLOR                  = 0x8577;
	static const auto GL_PREVIOUS                       = 0x8578;
	static const auto GL_DOT3_RGB                       = 0x86Ae;
	static const auto GL_DOT3_RGBA                      = 0x86Af;
}

version(GL_VERSION_1_4) {
}
else {
	static const auto GL_BLEND_DST_RGB                  = 0x80C8;
	static const auto GL_BLEND_SRC_RGB                  = 0x80C9;
	static const auto GL_BLEND_DST_ALPHA                = 0x80Ca;
	static const auto GL_BLEND_SRC_ALPHA                = 0x80Cb;
	static const auto GL_POINT_FADE_THRESHOLD_SIZE      = 0x8128;
	static const auto GL_DEPTH_COMPONENT16              = 0x81A5;
	static const auto GL_DEPTH_COMPONENT24              = 0x81A6;
	static const auto GL_DEPTH_COMPONENT32              = 0x81A7;
	static const auto GL_MIRRORED_REPEAT                = 0x8370;
	static const auto GL_MAX_TEXTURE_LOD_BIAS           = 0x84Fd;
	static const auto GL_TEXTURE_LOD_BIAS               = 0x8501;
	static const auto GL_INCR_WRAP                      = 0x8507;
	static const auto GL_DECR_WRAP                      = 0x8508;
	static const auto GL_TEXTURE_DEPTH_SIZE             = 0x884a;
	static const auto GL_TEXTURE_COMPARE_MODE           = 0x884c;
	static const auto GL_TEXTURE_COMPARE_FUNC           = 0x884d;
}

version(GL_VERSION_1_4_DEPRECATED) {
}
else {
	static const auto GL_POINT_SIZE_MIN                 = 0x8126;
	static const auto GL_POINT_SIZE_MAX                 = 0x8127;
	static const auto GL_POINT_DISTANCE_ATTENUATION     = 0x8129;
	static const auto GL_GENERATE_MIPMAP                = 0x8191;
	static const auto GL_GENERATE_MIPMAP_HINT           = 0x8192;
	static const auto GL_FOG_COORDINATE_SOURCE          = 0x8450;
	static const auto GL_FOG_COORDINATE                 = 0x8451;
	static const auto GL_FRAGMENT_DEPTH                 = 0x8452;
	static const auto GL_CURRENT_FOG_COORDINATE         = 0x8453;
	static const auto GL_FOG_COORDINATE_ARRAY_TYPE      = 0x8454;
	static const auto GL_FOG_COORDINATE_ARRAY_STRIDE    = 0x8455;
	static const auto GL_FOG_COORDINATE_ARRAY_POINTER   = 0x8456;
	static const auto GL_FOG_COORDINATE_ARRAY           = 0x8457;
	static const auto GL_COLOR_SUM                      = 0x8458;
	static const auto GL_CURRENT_SECONDARY_COLOR        = 0x8459;
	static const auto GL_SECONDARY_COLOR_ARRAY_SIZE     = 0x845a;
	static const auto GL_SECONDARY_COLOR_ARRAY_TYPE     = 0x845b;
	static const auto GL_SECONDARY_COLOR_ARRAY_STRIDE   = 0x845c;
	static const auto GL_SECONDARY_COLOR_ARRAY_POINTER  = 0x845d;
	static const auto GL_SECONDARY_COLOR_ARRAY          = 0x845e;
	static const auto GL_TEXTURE_FILTER_CONTROL         = 0x8500;
	static const auto GL_DEPTH_TEXTURE_MODE             = 0x884b;
	static const auto GL_COMPARE_R_TO_TEXTURE           = 0x884e;
}

version(GL_VERSION_1_5) {
}
else {
	static const auto GL_BUFFER_SIZE                    = 0x8764;
	static const auto GL_BUFFER_USAGE                   = 0x8765;
	static const auto GL_QUERY_COUNTER_BITS             = 0x8864;
	static const auto GL_CURRENT_QUERY                  = 0x8865;
	static const auto GL_QUERY_RESULT                   = 0x8866;
	static const auto GL_QUERY_RESULT_AVAILABLE         = 0x8867;
	static const auto GL_ARRAY_BUFFER                   = 0x8892;
	static const auto GL_ELEMENT_ARRAY_BUFFER           = 0x8893;
	static const auto GL_ARRAY_BUFFER_BINDING           = 0x8894;
	static const auto GL_ELEMENT_ARRAY_BUFFER_BINDING   = 0x8895;
	static const auto GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889f;
	static const auto GL_READ_ONLY                      = 0x88B8;
	static const auto GL_WRITE_ONLY                     = 0x88B9;
	static const auto GL_READ_WRITE                     = 0x88Ba;
	static const auto GL_BUFFER_ACCESS                  = 0x88Bb;
	static const auto GL_BUFFER_MAPPED                  = 0x88Bc;
	static const auto GL_BUFFER_MAP_POINTER             = 0x88Bd;
	static const auto GL_STREAM_DRAW                    = 0x88E0;
	static const auto GL_STREAM_READ                    = 0x88E1;
	static const auto GL_STREAM_COPY                    = 0x88E2;
	static const auto GL_STATIC_DRAW                    = 0x88E4;
	static const auto GL_STATIC_READ                    = 0x88E5;
	static const auto GL_STATIC_COPY                    = 0x88E6;
	static const auto GL_DYNAMIC_DRAW                   = 0x88E8;
	static const auto GL_DYNAMIC_READ                   = 0x88E9;
	static const auto GL_DYNAMIC_COPY                   = 0x88Ea;
	static const auto GL_SAMPLES_PASSED                 = 0x8914;
}

version(GL_VERSION_1_5_DEPRECATED) {
}
else {
	static const auto GL_VERTEX_ARRAY_BUFFER_BINDING    = 0x8896;
	static const auto GL_NORMAL_ARRAY_BUFFER_BINDING    = 0x8897;
	static const auto GL_COLOR_ARRAY_BUFFER_BINDING     = 0x8898;
	static const auto GL_INDEX_ARRAY_BUFFER_BINDING     = 0x8899;
	static const auto GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING = 0x889a;
	static const auto GL_EDGE_FLAG_ARRAY_BUFFER_BINDING = 0x889b;
	static const auto GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING = 0x889c;
	static const auto GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING = 0x889d;
	static const auto GL_WEIGHT_ARRAY_BUFFER_BINDING    = 0x889e;
	static const auto GL_FOG_COORD_SRC                  = 0x8450;
	static const auto GL_FOG_COORD                      = 0x8451;
	static const auto GL_CURRENT_FOG_COORD              = 0x8453;
	static const auto GL_FOG_COORD_ARRAY_TYPE           = 0x8454;
	static const auto GL_FOG_COORD_ARRAY_STRIDE         = 0x8455;
	static const auto GL_FOG_COORD_ARRAY_POINTER        = 0x8456;
	static const auto GL_FOG_COORD_ARRAY                = 0x8457;
	static const auto GL_FOG_COORD_ARRAY_BUFFER_BINDING = 0x889d;
	static const auto GL_SRC0_RGB                       = 0x8580;
	static const auto GL_SRC1_RGB                       = 0x8581;
	static const auto GL_SRC2_RGB                       = 0x8582;
	static const auto GL_SRC0_ALPHA                     = 0x8588;
	static const auto GL_SRC1_ALPHA                     = 0x8589;
	static const auto GL_SRC2_ALPHA                     = 0x858a;
}

version(GL_VERSION_2_0) {
}
else {
	static const auto GL_BLEND_EQUATION_RGB             = 0x8009;
	static const auto GL_VERTEX_ATTRIB_ARRAY_ENABLED    = 0x8622;
	static const auto GL_VERTEX_ATTRIB_ARRAY_SIZE       = 0x8623;
	static const auto GL_VERTEX_ATTRIB_ARRAY_STRIDE     = 0x8624;
	static const auto GL_VERTEX_ATTRIB_ARRAY_TYPE       = 0x8625;
	static const auto GL_CURRENT_VERTEX_ATTRIB          = 0x8626;
	static const auto GL_VERTEX_PROGRAM_POINT_SIZE      = 0x8642;
	static const auto GL_VERTEX_ATTRIB_ARRAY_POINTER    = 0x8645;
	static const auto GL_STENCIL_BACK_FUNC              = 0x8800;
	static const auto GL_STENCIL_BACK_FAIL              = 0x8801;
	static const auto GL_STENCIL_BACK_PASS_DEPTH_FAIL   = 0x8802;
	static const auto GL_STENCIL_BACK_PASS_DEPTH_PASS   = 0x8803;
	static const auto GL_MAX_DRAW_BUFFERS               = 0x8824;
	static const auto GL_DRAW_BUFFER0                   = 0x8825;
	static const auto GL_DRAW_BUFFER1                   = 0x8826;
	static const auto GL_DRAW_BUFFER2                   = 0x8827;
	static const auto GL_DRAW_BUFFER3                   = 0x8828;
	static const auto GL_DRAW_BUFFER4                   = 0x8829;
	static const auto GL_DRAW_BUFFER5                   = 0x882a;
	static const auto GL_DRAW_BUFFER6                   = 0x882b;
	static const auto GL_DRAW_BUFFER7                   = 0x882c;
	static const auto GL_DRAW_BUFFER8                   = 0x882d;
	static const auto GL_DRAW_BUFFER9                   = 0x882e;
	static const auto GL_DRAW_BUFFER10                  = 0x882f;
	static const auto GL_DRAW_BUFFER11                  = 0x8830;
	static const auto GL_DRAW_BUFFER12                  = 0x8831;
	static const auto GL_DRAW_BUFFER13                  = 0x8832;
	static const auto GL_DRAW_BUFFER14                  = 0x8833;
	static const auto GL_DRAW_BUFFER15                  = 0x8834;
	static const auto GL_BLEND_EQUATION_ALPHA           = 0x883d;
	static const auto GL_MAX_VERTEX_ATTRIBS             = 0x8869;
	static const auto GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886a;
	static const auto GL_MAX_TEXTURE_IMAGE_UNITS        = 0x8872;
	static const auto GL_FRAGMENT_SHADER                = 0x8B30;
	static const auto GL_VERTEX_SHADER                  = 0x8B31;
	static const auto GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;
	static const auto GL_MAX_VERTEX_UNIFORM_COMPONENTS  = 0x8B4a;
	static const auto GL_MAX_VARYING_FLOATS             = 0x8B4b;
	static const auto GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4c;
	static const auto GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4d;
	static const auto GL_SHADER_TYPE                    = 0x8B4f;
	static const auto GL_FLOAT_VEC2                     = 0x8B50;
	static const auto GL_FLOAT_VEC3                     = 0x8B51;
	static const auto GL_FLOAT_VEC4                     = 0x8B52;
	static const auto GL_INT_VEC2                       = 0x8B53;
	static const auto GL_INT_VEC3                       = 0x8B54;
	static const auto GL_INT_VEC4                       = 0x8B55;
	static const auto GL_BOOL                           = 0x8B56;
	static const auto GL_BOOL_VEC2                      = 0x8B57;
	static const auto GL_BOOL_VEC3                      = 0x8B58;
	static const auto GL_BOOL_VEC4                      = 0x8B59;
	static const auto GL_FLOAT_MAT2                     = 0x8B5a;
	static const auto GL_FLOAT_MAT3                     = 0x8B5b;
	static const auto GL_FLOAT_MAT4                     = 0x8B5c;
	static const auto GL_SAMPLER_1D                     = 0x8B5d;
	static const auto GL_SAMPLER_2D                     = 0x8B5e;
	static const auto GL_SAMPLER_3D                     = 0x8B5f;
	static const auto GL_SAMPLER_CUBE                   = 0x8B60;
	static const auto GL_SAMPLER_1D_SHADOW              = 0x8B61;
	static const auto GL_SAMPLER_2D_SHADOW              = 0x8B62;
	static const auto GL_DELETE_STATUS                  = 0x8B80;
	static const auto GL_COMPILE_STATUS                 = 0x8B81;
	static const auto GL_LINK_STATUS                    = 0x8B82;
	static const auto GL_VALIDATE_STATUS                = 0x8B83;
	static const auto GL_INFO_LOG_LENGTH                = 0x8B84;
	static const auto GL_ATTACHED_SHADERS               = 0x8B85;
	static const auto GL_ACTIVE_UNIFORMS                = 0x8B86;
	static const auto GL_ACTIVE_UNIFORM_MAX_LENGTH      = 0x8B87;
	static const auto GL_SHADER_SOURCE_LENGTH           = 0x8B88;
	static const auto GL_ACTIVE_ATTRIBUTES              = 0x8B89;
	static const auto GL_ACTIVE_ATTRIBUTE_MAX_LENGTH    = 0x8B8a;
	static const auto GL_FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8b;
	static const auto GL_SHADING_LANGUAGE_VERSION       = 0x8B8c;
	static const auto GL_CURRENT_PROGRAM                = 0x8B8d;
	static const auto GL_POINT_SPRITE_COORD_ORIGIN      = 0x8CA0;
	static const auto GL_LOWER_LEFT                     = 0x8CA1;
	static const auto GL_UPPER_LEFT                     = 0x8CA2;
	static const auto GL_STENCIL_BACK_REF               = 0x8CA3;
	static const auto GL_STENCIL_BACK_VALUE_MASK        = 0x8CA4;
	static const auto GL_STENCIL_BACK_WRITEMASK         = 0x8CA5;
}

version(GL_VERSION_2_0_DEPRECATED) {
}
else {
	static const auto GL_VERTEX_PROGRAM_TWO_SIDE        = 0x8643;
	static const auto GL_POINT_SPRITE                   = 0x8861;
	static const auto GL_COORD_REPLACE                  = 0x8862;
	static const auto GL_MAX_TEXTURE_COORDS             = 0x8871;
}

version (GL_VERSION_2_1) {
}
else {
	static const auto GL_PIXEL_PACK_BUFFER              = 0x88Eb;
	static const auto GL_PIXEL_UNPACK_BUFFER            = 0x88Ec;
	static const auto GL_PIXEL_PACK_BUFFER_BINDING      = 0x88Ed;
	static const auto GL_PIXEL_UNPACK_BUFFER_BINDING    = 0x88Ef;
	static const auto GL_FLOAT_MAT2x3                   = 0x8B65;
	static const auto GL_FLOAT_MAT2x4                   = 0x8B66;
	static const auto GL_FLOAT_MAT3x2                   = 0x8B67;
	static const auto GL_FLOAT_MAT3x4                   = 0x8B68;
	static const auto GL_FLOAT_MAT4x2                   = 0x8B69;
	static const auto GL_FLOAT_MAT4x3                   = 0x8B6a;
	static const auto GL_SRGB                           = 0x8C40;
	static const auto GL_SRGB8                          = 0x8C41;
	static const auto GL_SRGB_ALPHA                     = 0x8C42;
	static const auto GL_SRGB8_ALPHA8                   = 0x8C43;
	static const auto GL_COMPRESSED_SRGB                = 0x8C48;
	static const auto GL_COMPRESSED_SRGB_ALPHA          = 0x8C49;
}

version(GL_VERSION_2_1_DEPRECATED) {
}
else {
	static const auto GL_CURRENT_RASTER_SECONDARY_COLOR = 0x845f;
	static const auto GL_SLUMINANCE_ALPHA               = 0x8C44;
	static const auto GL_SLUMINANCE8_ALPHA8             = 0x8C45;
	static const auto GL_SLUMINANCE                     = 0x8C46;
	static const auto GL_SLUMINANCE8                    = 0x8C47;
	static const auto GL_COMPRESSED_SLUMINANCE          = 0x8C4a;
	static const auto GL_COMPRESSED_SLUMINANCE_ALPHA    = 0x8C4b;
}

version(GL_VERSION_3_0) {
}
else {
	static const auto GL_COMPARE_REF_TO_TEXTURE         = 0x884e;
	static const auto GL_CLIP_DISTANCE0                 = 0x3000;
	static const auto GL_CLIP_DISTANCE1                 = 0x3001;
	static const auto GL_CLIP_DISTANCE2                 = 0x3002;
	static const auto GL_CLIP_DISTANCE3                 = 0x3003;
	static const auto GL_CLIP_DISTANCE4                 = 0x3004;
	static const auto GL_CLIP_DISTANCE5                 = 0x3005;
	static const auto GL_CLIP_DISTANCE6                 = 0x3006;
	static const auto GL_CLIP_DISTANCE7                 = 0x3007;
	static const auto GL_MAX_CLIP_DISTANCES             = 0x0D32;
	static const auto GL_MAJOR_VERSION                  = 0x821b;
	static const auto GL_MINOR_VERSION                  = 0x821c;
	static const auto GL_NUM_EXTENSIONS                 = 0x821d;
	static const auto GL_CONTEXT_FLAGS                  = 0x821e;
	static const auto GL_DEPTH_BUFFER                   = 0x8223;
	static const auto GL_STENCIL_BUFFER                 = 0x8224;
	static const auto GL_COMPRESSED_RED                 = 0x8225;
	static const auto GL_COMPRESSED_RG                  = 0x8226;
	static const auto GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = 0x0001;
	static const auto GL_RGBA32F                        = 0x8814;
	static const auto GL_RGB32F                         = 0x8815;
	static const auto GL_RGBA16F                        = 0x881a;
	static const auto GL_RGB16F                         = 0x881b;
	static const auto GL_VERTEX_ATTRIB_ARRAY_INTEGER    = 0x88Fd;
	static const auto GL_MAX_ARRAY_TEXTURE_LAYERS       = 0x88Ff;
	static const auto GL_MIN_PROGRAM_TEXEL_OFFSET       = 0x8904;
	static const auto GL_MAX_PROGRAM_TEXEL_OFFSET       = 0x8905;
	static const auto GL_CLAMP_READ_COLOR               = 0x891c;
	static const auto GL_FIXED_ONLY                     = 0x891d;
	static const auto GL_MAX_VARYING_COMPONENTS         = 0x8B4b;
	static const auto GL_TEXTURE_1D_ARRAY               = 0x8C18;
	static const auto GL_PROXY_TEXTURE_1D_ARRAY         = 0x8C19;
	static const auto GL_TEXTURE_2D_ARRAY               = 0x8C1a;
	static const auto GL_PROXY_TEXTURE_2D_ARRAY         = 0x8C1b;
	static const auto GL_TEXTURE_BINDING_1D_ARRAY       = 0x8C1c;
	static const auto GL_TEXTURE_BINDING_2D_ARRAY       = 0x8C1d;
	static const auto GL_R11F_G11F_B10F                 = 0x8C3a;
	static const auto GL_UNSIGNED_INT_10F_11F_11F_REV   = 0x8C3b;
	static const auto GL_RGB9_E5                        = 0x8C3d;
	static const auto GL_UNSIGNED_INT_5_9_9_9_REV       = 0x8C3e;
	static const auto GL_TEXTURE_SHARED_SIZE            = 0x8C3f;
	static const auto GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = 0x8C76;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7f;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80;
	static const auto GL_TRANSFORM_FEEDBACK_VARYINGS    = 0x8C83;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85;
	static const auto GL_PRIMITIVES_GENERATED           = 0x8C87;
	static const auto GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88;
	static const auto GL_RASTERIZER_DISCARD             = 0x8C89;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8a;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8b;
	static const auto GL_INTERLEAVED_ATTRIBS            = 0x8C8c;
	static const auto GL_SEPARATE_ATTRIBS               = 0x8C8d;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER      = 0x8C8e;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8f;
	static const auto GL_RGBA32UI                       = 0x8D70;
	static const auto GL_RGB32UI                        = 0x8D71;
	static const auto GL_RGBA16UI                       = 0x8D76;
	static const auto GL_RGB16UI                        = 0x8D77;
	static const auto GL_RGBA8UI                        = 0x8D7c;
	static const auto GL_RGB8UI                         = 0x8D7d;
	static const auto GL_RGBA32I                        = 0x8D82;
	static const auto GL_RGB32I                         = 0x8D83;
	static const auto GL_RGBA16I                        = 0x8D88;
	static const auto GL_RGB16I                         = 0x8D89;
	static const auto GL_RGBA8I                         = 0x8D8e;
	static const auto GL_RGB8I                          = 0x8D8f;
	static const auto GL_RED_INTEGER                    = 0x8D94;
	static const auto GL_GREEN_INTEGER                  = 0x8D95;
	static const auto GL_BLUE_INTEGER                   = 0x8D96;
	static const auto GL_RGB_INTEGER                    = 0x8D98;
	static const auto GL_RGBA_INTEGER                   = 0x8D99;
	static const auto GL_BGR_INTEGER                    = 0x8D9a;
	static const auto GL_BGRA_INTEGER                   = 0x8D9b;
	static const auto GL_SAMPLER_1D_ARRAY               = 0x8DC0;
	static const auto GL_SAMPLER_2D_ARRAY               = 0x8DC1;
	static const auto GL_SAMPLER_1D_ARRAY_SHADOW        = 0x8DC3;
	static const auto GL_SAMPLER_2D_ARRAY_SHADOW        = 0x8DC4;
	static const auto GL_SAMPLER_CUBE_SHADOW            = 0x8DC5;
	static const auto GL_UNSIGNED_INT_VEC2              = 0x8DC6;
	static const auto GL_UNSIGNED_INT_VEC3              = 0x8DC7;
	static const auto GL_UNSIGNED_INT_VEC4              = 0x8DC8;
	static const auto GL_INT_SAMPLER_1D                 = 0x8DC9;
	static const auto GL_INT_SAMPLER_2D                 = 0x8DCa;
	static const auto GL_INT_SAMPLER_3D                 = 0x8DCb;
	static const auto GL_INT_SAMPLER_CUBE               = 0x8DCc;
	static const auto GL_INT_SAMPLER_1D_ARRAY           = 0x8DCe;
	static const auto GL_INT_SAMPLER_2D_ARRAY           = 0x8DCf;
	static const auto GL_UNSIGNED_INT_SAMPLER_1D        = 0x8DD1;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D        = 0x8DD2;
	static const auto GL_UNSIGNED_INT_SAMPLER_3D        = 0x8DD3;
	static const auto GL_UNSIGNED_INT_SAMPLER_CUBE      = 0x8DD4;
	static const auto GL_UNSIGNED_INT_SAMPLER_1D_ARRAY  = 0x8DD6;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D_ARRAY  = 0x8DD7;
	static const auto GL_QUERY_WAIT                     = 0x8E13;
	static const auto GL_QUERY_NO_WAIT                  = 0x8E14;
	static const auto GL_QUERY_BY_REGION_WAIT           = 0x8E15;
	static const auto GL_QUERY_BY_REGION_NO_WAIT        = 0x8E16;
	static const auto GL_BUFFER_ACCESS_FLAGS            = 0x911f;
	static const auto GL_BUFFER_MAP_LENGTH              = 0x9120;
	static const auto GL_BUFFER_MAP_OFFSET              = 0x9121;
	/* Reuse tokens from ARB_depth_buffer_float */
	/* reuse GL_DEPTH_COMPONENT32F */
	/* reuse GL_DEPTH32F_STENCIL8 */
	/* reuse GL_FLOAT_32_UNSIGNED_INT_24_8_REV */
	/* Reuse tokens from ARB_framebuffer_object */
	/* reuse GL_INVALID_FRAMEBUFFER_OPERATION */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE */
	/* reuse GL_FRAMEBUFFER_DEFAULT */
	/* reuse GL_FRAMEBUFFER_UNDEFINED */
	/* reuse GL_DEPTH_STENCIL_ATTACHMENT */
	/* reuse GL_INDEX */
	/* reuse GL_MAX_RENDERBUFFER_SIZE */
	/* reuse GL_DEPTH_STENCIL */
	/* reuse GL_UNSIGNED_INT_24_8 */
	/* reuse GL_DEPTH24_STENCIL8 */
	/* reuse GL_TEXTURE_STENCIL_SIZE */
	/* reuse GL_TEXTURE_RED_TYPE */
	/* reuse GL_TEXTURE_GREEN_TYPE */
	/* reuse GL_TEXTURE_BLUE_TYPE */
	/* reuse GL_TEXTURE_ALPHA_TYPE */
	/* reuse GL_TEXTURE_DEPTH_TYPE */
	/* reuse GL_UNSIGNED_NORMALIZED */
	/* reuse GL_FRAMEBUFFER_BINDING */
	/* reuse GL_DRAW_FRAMEBUFFER_BINDING */
	/* reuse GL_RENDERBUFFER_BINDING */
	/* reuse GL_READ_FRAMEBUFFER */
	/* reuse GL_DRAW_FRAMEBUFFER */
	/* reuse GL_READ_FRAMEBUFFER_BINDING */
	/* reuse GL_RENDERBUFFER_SAMPLES */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */
	/* reuse GL_FRAMEBUFFER_COMPLETE */
	/* reuse GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT */
	/* reuse GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT */
	/* reuse GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER */
	/* reuse GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER */
	/* reuse GL_FRAMEBUFFER_UNSUPPORTED */
	/* reuse GL_MAX_COLOR_ATTACHMENTS */
	/* reuse GL_COLOR_ATTACHMENT0 */
	/* reuse GL_COLOR_ATTACHMENT1 */
	/* reuse GL_COLOR_ATTACHMENT2 */
	/* reuse GL_COLOR_ATTACHMENT3 */
	/* reuse GL_COLOR_ATTACHMENT4 */
	/* reuse GL_COLOR_ATTACHMENT5 */
	/* reuse GL_COLOR_ATTACHMENT6 */
	/* reuse GL_COLOR_ATTACHMENT7 */
	/* reuse GL_COLOR_ATTACHMENT8 */
	/* reuse GL_COLOR_ATTACHMENT9 */
	/* reuse GL_COLOR_ATTACHMENT10 */
	/* reuse GL_COLOR_ATTACHMENT11 */
	/* reuse GL_COLOR_ATTACHMENT12 */
	/* reuse GL_COLOR_ATTACHMENT13 */
	/* reuse GL_COLOR_ATTACHMENT14 */
	/* reuse GL_COLOR_ATTACHMENT15 */
	/* reuse GL_DEPTH_ATTACHMENT */
	/* reuse GL_STENCIL_ATTACHMENT */
	/* reuse GL_FRAMEBUFFER */
	/* reuse GL_RENDERBUFFER */
	/* reuse GL_RENDERBUFFER_WIDTH */
	/* reuse GL_RENDERBUFFER_HEIGHT */
	/* reuse GL_RENDERBUFFER_INTERNAL_FORMAT */
	/* reuse GL_STENCIL_INDEX1 */
	/* reuse GL_STENCIL_INDEX4 */
	/* reuse GL_STENCIL_INDEX8 */
	/* reuse GL_STENCIL_INDEX16 */
	/* reuse GL_RENDERBUFFER_RED_SIZE */
	/* reuse GL_RENDERBUFFER_GREEN_SIZE */
	/* reuse GL_RENDERBUFFER_BLUE_SIZE */
	/* reuse GL_RENDERBUFFER_ALPHA_SIZE */
	/* reuse GL_RENDERBUFFER_DEPTH_SIZE */
	/* reuse GL_RENDERBUFFER_STENCIL_SIZE */
	/* reuse GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE */
	/* reuse GL_MAX_SAMPLES */
	/* Reuse tokens from ARB_framebuffer_sRGB */
	/* reuse GL_FRAMEBUFFER_SRGB */
	/* Reuse tokens from ARB_half_float_vertex */
	/* reuse GL_HALF_FLOAT */
	/* Reuse tokens from ARB_map_buffer_range */
	/* reuse GL_MAP_READ_BIT */
	/* reuse GL_MAP_WRITE_BIT */
	/* reuse GL_MAP_INVALIDATE_RANGE_BIT */
	/* reuse GL_MAP_INVALIDATE_BUFFER_BIT */
	/* reuse GL_MAP_FLUSH_EXPLICIT_BIT */
	/* reuse GL_MAP_UNSYNCHRONIZED_BIT */
	/* Reuse tokens from ARB_texture_compression_rgtc */
	/* reuse GL_COMPRESSED_RED_RGTC1 */
	/* reuse GL_COMPRESSED_SIGNED_RED_RGTC1 */
	/* reuse GL_COMPRESSED_RG_RGTC2 */
	/* reuse GL_COMPRESSED_SIGNED_RG_RGTC2 */
	/* Reuse tokens from ARB_texture_rg */
	/* reuse GL_RG */
	/* reuse GL_RG_INTEGER */
	/* reuse GL_R8 */
	/* reuse GL_R16 */
	/* reuse GL_RG8 */
	/* reuse GL_RG16 */
	/* reuse GL_R16F */
	/* reuse GL_R32F */
	/* reuse GL_RG16F */
	/* reuse GL_RG32F */
	/* reuse GL_R8I */
	/* reuse GL_R8UI */
	/* reuse GL_R16I */
	/* reuse GL_R16UI */
	/* reuse GL_R32I */
	/* reuse GL_R32UI */
	/* reuse GL_RG8I */
	/* reuse GL_RG8UI */
	/* reuse GL_RG16I */
	/* reuse GL_RG16UI */
	/* reuse GL_RG32I */
	/* reuse GL_RG32UI */
	/* Reuse tokens from ARB_vertex_array_object */
	/* reuse GL_VERTEX_ARRAY_BINDING */
}

version (GL_VERSION_3_0_DEPRECATED) {
}
else {
	static const auto GL_CLAMP_VERTEX_COLOR             = 0x891a;
	static const auto GL_CLAMP_FRAGMENT_COLOR           = 0x891b;
	static const auto GL_ALPHA_INTEGER                  = 0x8D97;
	/* Reuse tokens from ARB_framebuffer_object */
	/* reuse GL_TEXTURE_LUMINANCE_TYPE */
	/* reuse GL_TEXTURE_INTENSITY_TYPE */
}

version(GL_VERSION_3_1) {
}
else {
	static const auto GL_SAMPLER_2D_RECT                = 0x8B63;
	static const auto GL_SAMPLER_2D_RECT_SHADOW         = 0x8B64;
	static const auto GL_SAMPLER_BUFFER                 = 0x8DC2;
	static const auto GL_INT_SAMPLER_2D_RECT            = 0x8DCd;
	static const auto GL_INT_SAMPLER_BUFFER             = 0x8DD0;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D_RECT   = 0x8DD5;
	static const auto GL_UNSIGNED_INT_SAMPLER_BUFFER    = 0x8DD8;
	static const auto GL_TEXTURE_BUFFER                 = 0x8C2a;
	static const auto GL_MAX_TEXTURE_BUFFER_SIZE        = 0x8C2b;
	static const auto GL_TEXTURE_BINDING_BUFFER         = 0x8C2c;
	static const auto GL_TEXTURE_BUFFER_DATA_STORE_BINDING = 0x8C2d;
	static const auto GL_TEXTURE_BUFFER_FORMAT          = 0x8C2e;
	static const auto GL_TEXTURE_RECTANGLE              = 0x84F5;
	static const auto GL_TEXTURE_BINDING_RECTANGLE      = 0x84F6;
	static const auto GL_PROXY_TEXTURE_RECTANGLE        = 0x84F7;
	static const auto GL_MAX_RECTANGLE_TEXTURE_SIZE     = 0x84F8;
	static const auto GL_RED_SNORM                      = 0x8F90;
	static const auto GL_RG_SNORM                       = 0x8F91;
	static const auto GL_RGB_SNORM                      = 0x8F92;
	static const auto GL_RGBA_SNORM                     = 0x8F93;
	static const auto GL_R8_SNORM                       = 0x8F94;
	static const auto GL_RG8_SNORM                      = 0x8F95;
	static const auto GL_RGB8_SNORM                     = 0x8F96;
	static const auto GL_RGBA8_SNORM                    = 0x8F97;
	static const auto GL_R16_SNORM                      = 0x8F98;
	static const auto GL_RG16_SNORM                     = 0x8F99;
	static const auto GL_RGB16_SNORM                    = 0x8F9a;
	static const auto GL_RGBA16_SNORM                   = 0x8F9b;
	static const auto GL_SIGNED_NORMALIZED              = 0x8F9c;
	static const auto GL_PRIMITIVE_RESTART              = 0x8F9d;
	static const auto GL_PRIMITIVE_RESTART_INDEX        = 0x8F9e;
	/* Reuse tokens from ARB_copy_buffer */
	/* reuse GL_COPY_READ_BUFFER */
	/* reuse GL_COPY_WRITE_BUFFER */
	/* Would reuse tokens from ARB_draw_instanced, but it has none */
	/* Reuse tokens from ARB_uniform_buffer_object */
	/* reuse GL_UNIFORM_BUFFER */
	/* reuse GL_UNIFORM_BUFFER_BINDING */
	/* reuse GL_UNIFORM_BUFFER_START */
	/* reuse GL_UNIFORM_BUFFER_SIZE */
	/* reuse GL_MAX_VERTEX_UNIFORM_BLOCKS */
	/* reuse GL_MAX_FRAGMENT_UNIFORM_BLOCKS */
	/* reuse GL_MAX_COMBINED_UNIFORM_BLOCKS */
	/* reuse GL_MAX_UNIFORM_BUFFER_BINDINGS */
	/* reuse GL_MAX_UNIFORM_BLOCK_SIZE */
	/* reuse GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS */
	/* reuse GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS */
	/* reuse GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT */
	/* reuse GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH */
	/* reuse GL_ACTIVE_UNIFORM_BLOCKS */
	/* reuse GL_UNIFORM_TYPE */
	/* reuse GL_UNIFORM_SIZE */
	/* reuse GL_UNIFORM_NAME_LENGTH */
	/* reuse GL_UNIFORM_BLOCK_INDEX */
	/* reuse GL_UNIFORM_OFFSET */
	/* reuse GL_UNIFORM_ARRAY_STRIDE */
	/* reuse GL_UNIFORM_MATRIX_STRIDE */
	/* reuse GL_UNIFORM_IS_ROW_MAJOR */
	/* reuse GL_UNIFORM_BLOCK_BINDING */
	/* reuse GL_UNIFORM_BLOCK_DATA_SIZE */
	/* reuse GL_UNIFORM_BLOCK_NAME_LENGTH */
	/* reuse GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS */
	/* reuse GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES */
	/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER */
	/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER */
	/* reuse GL_INVALID_INDEX */
}

version (GL_VERSION_3_2) {
}
else {
	static const auto GL_CONTEXT_CORE_PROFILE_BIT       = 0x00000001;
	static const auto GL_CONTEXT_COMPATIBILITY_PROFILE_BIT = 0x00000002;
	static const auto GL_LINES_ADJACENCY                = 0x000a;
	static const auto GL_LINE_STRIP_ADJACENCY           = 0x000b;
	static const auto GL_TRIANGLES_ADJACENCY            = 0x000c;
	static const auto GL_TRIANGLE_STRIP_ADJACENCY       = 0x000d;
	static const auto GL_PROGRAM_POINT_SIZE             = 0x8642;
	static const auto GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = 0x8C29;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_LAYERED = 0x8DA7;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = 0x8DA8;
	static const auto GL_GEOMETRY_SHADER                = 0x8DD9;
	static const auto GL_GEOMETRY_VERTICES_OUT          = 0x8916;
	static const auto GL_GEOMETRY_INPUT_TYPE            = 0x8917;
	static const auto GL_GEOMETRY_OUTPUT_TYPE           = 0x8918;
	static const auto GL_MAX_GEOMETRY_UNIFORM_COMPONENTS = 0x8DDf;
	static const auto GL_MAX_GEOMETRY_OUTPUT_VERTICES   = 0x8DE0;
	static const auto GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = 0x8DE1;
	static const auto GL_MAX_VERTEX_OUTPUT_COMPONENTS   = 0x9122;
	static const auto GL_MAX_GEOMETRY_INPUT_COMPONENTS  = 0x9123;
	static const auto GL_MAX_GEOMETRY_OUTPUT_COMPONENTS = 0x9124;
	static const auto GL_MAX_FRAGMENT_INPUT_COMPONENTS  = 0x9125;
	static const auto GL_CONTEXT_PROFILE_MASK           = 0x9126;
	/* reuse GL_MAX_VARYING_COMPONENTS */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */
	/* Reuse tokens from ARB_depth_clamp */
	/* reuse GL_DEPTH_CLAMP */
	/* Would reuse tokens from ARB_draw_elements_base_vertex, but it has none */
	/* Would reuse tokens from ARB_fragment_coord_conventions, but it has none */
	/* Reuse tokens from ARB_provoking_vertex */
	/* reuse GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION */
	/* reuse GL_FIRST_VERTEX_CONVENTION */
	/* reuse GL_LAST_VERTEX_CONVENTION */
	/* reuse GL_PROVOKING_VERTEX */
	/* Reuse tokens from ARB_seamless_cube_map */
	/* reuse GL_TEXTURE_CUBE_MAP_SEAMLESS */
	/* Reuse tokens from ARB_sync */
	/* reuse GL_MAX_SERVER_WAIT_TIMEOUT */
	/* reuse GL_OBJECT_TYPE */
	/* reuse GL_SYNC_CONDITION */
	/* reuse GL_SYNC_STATUS */
	/* reuse GL_SYNC_FLAGS */
	/* reuse GL_SYNC_FENCE */
	/* reuse GL_SYNC_GPU_COMMANDS_COMPLETE */
	/* reuse GL_UNSIGNALED */
	/* reuse GL_SIGNALED */
	/* reuse GL_ALREADY_SIGNALED */
	/* reuse GL_TIMEOUT_EXPIRED */
	/* reuse GL_CONDITION_SATISFIED */
	/* reuse GL_WAIT_FAILED */
	/* reuse GL_TIMEOUT_IGNORED */
	/* reuse GL_SYNC_FLUSH_COMMANDS_BIT */
	/* reuse GL_TIMEOUT_IGNORED */
	/* Reuse tokens from ARB_texture_multisample */
	/* reuse GL_SAMPLE_POSITION */
	/* reuse GL_SAMPLE_MASK */
	/* reuse GL_SAMPLE_MASK_VALUE */
	/* reuse GL_MAX_SAMPLE_MASK_WORDS */
	/* reuse GL_TEXTURE_2D_MULTISAMPLE */
	/* reuse GL_PROXY_TEXTURE_2D_MULTISAMPLE */
	/* reuse GL_TEXTURE_2D_MULTISAMPLE_ARRAY */
	/* reuse GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY */
	/* reuse GL_TEXTURE_BINDING_2D_MULTISAMPLE */
	/* reuse GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY */
	/* reuse GL_TEXTURE_SAMPLES */
	/* reuse GL_TEXTURE_FIXED_SAMPLE_LOCATIONS */
	/* reuse GL_SAMPLER_2D_MULTISAMPLE */
	/* reuse GL_INT_SAMPLER_2D_MULTISAMPLE */
	/* reuse GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE */
	/* reuse GL_SAMPLER_2D_MULTISAMPLE_ARRAY */
	/* reuse GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY */
	/* reuse GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY */
	/* reuse GL_MAX_COLOR_TEXTURE_SAMPLES */
	/* reuse GL_MAX_DEPTH_TEXTURE_SAMPLES */
	/* reuse GL_MAX_INTEGER_SAMPLES */
	/* Don't need to reuse tokens from ARB_vertex_array_bgra since they're already in 1.2 core */
}

version(GL_VERSION_3_3) {
}
else {
	/* Reuse tokens from ARB_blend_func_extended */
	/* reuse GL_SRC1_COLOR */
	/* reuse GL_ONE_MINUS_SRC1_COLOR */
	/* reuse GL_ONE_MINUS_SRC1_ALPHA */
	/* reuse GL_MAX_DUAL_SOURCE_DRAW_BUFFERS */
	/* Would reuse tokens from ARB_explicit_attrib_location, but it has none */
	/* Reuse tokens from ARB_occlusion_query2 */
	/* reuse GL_ANY_SAMPLES_PASSED */
	/* Reuse tokens from ARB_sampler_objects */
	/* reuse GL_SAMPLER_BINDING */
	/* Would reuse tokens from ARB_shader_bit_encoding, but it has none */
	/* Reuse tokens from ARB_texture_rgb10_a2ui */
	/* reuse GL_RGB10_A2UI */
	/* Reuse tokens from ARB_texture_swizzle */
	/* reuse GL_TEXTURE_SWIZZLE_R */
	/* reuse GL_TEXTURE_SWIZZLE_G */
	/* reuse GL_TEXTURE_SWIZZLE_B */
	/* reuse GL_TEXTURE_SWIZZLE_A */
	/* reuse GL_TEXTURE_SWIZZLE_RGBA */
	/* Reuse tokens from ARB_timer_query */
	/* reuse GL_TIME_ELAPSED */
	/* reuse GL_TIMESTAMP */
	/* Reuse tokens from ARB_vertex_type_2_10_10_10_rev */
	/* reuse GL_INT_2_10_10_10_REV */
}

version(GL_VERSION_4_0) {
}
else {
	/* Reuse tokens from ARB_draw_indirect */
	/* reuse GL_DRAW_INDIRECT_BUFFER */
	/* reuse GL_DRAW_INDIRECT_BUFFER_BINDING */
	/* Reuse tokens from ARB_gpu_shader5 */
	/* reuse GL_GEOMETRY_SHADER_INVOCATIONS */
	/* reuse GL_MAX_GEOMETRY_SHADER_INVOCATIONS */
	/* reuse GL_MIN_FRAGMENT_INTERPOLATION_OFFSET */
	/* reuse GL_MAX_FRAGMENT_INTERPOLATION_OFFSET */
	/* reuse GL_FRAGMENT_INTERPOLATION_OFFSET_BITS */
	/* reuse GL_MAX_VERTEX_STREAMS */
	/* Reuse tokens from ARB_gpu_shader_fp64 */
	/* reuse GL_DOUBLE_VEC2 */
	/* reuse GL_DOUBLE_VEC3 */
	/* reuse GL_DOUBLE_VEC4 */
	/* reuse GL_DOUBLE_MAT2 */
	/* reuse GL_DOUBLE_MAT3 */
	/* reuse GL_DOUBLE_MAT4 */
	/* reuse GL_DOUBLE_MAT2x3 */
	/* reuse GL_DOUBLE_MAT2x4 */
	/* reuse GL_DOUBLE_MAT3x2 */
	/* reuse GL_DOUBLE_MAT3x4 */
	/* reuse GL_DOUBLE_MAT4x2 */
	/* reuse GL_DOUBLE_MAT4x3 */
	/* Reuse tokens from ARB_shader_subroutine */
	/* reuse GL_ACTIVE_SUBROUTINES */
	/* reuse GL_ACTIVE_SUBROUTINE_UNIFORMS */
	/* reuse GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS */
	/* reuse GL_ACTIVE_SUBROUTINE_MAX_LENGTH */
	/* reuse GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH */
	/* reuse GL_MAX_SUBROUTINES */
	/* reuse GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS */
	/* reuse GL_NUM_COMPATIBLE_SUBROUTINES */
	/* reuse GL_COMPATIBLE_SUBROUTINES */
	/* Reuse tokens from ARB_tessellation_shader */
	/* reuse GL_PATCHES */
	/* reuse GL_PATCH_VERTICES */
	/* reuse GL_PATCH_DEFAULT_INNER_LEVEL */
	/* reuse GL_PATCH_DEFAULT_OUTER_LEVEL */
	/* reuse GL_TESS_CONTROL_OUTPUT_VERTICES */
	/* reuse GL_TESS_GEN_MODE */
	/* reuse GL_TESS_GEN_SPACING */
	/* reuse GL_TESS_GEN_VERTEX_ORDER */
	/* reuse GL_TESS_GEN_POINT_MODE */
	/* reuse GL_ISOLINES */
	/* reuse GL_FRACTIONAL_ODD */
	/* reuse GL_FRACTIONAL_EVEN */
	/* reuse GL_MAX_PATCH_VERTICES */
	/* reuse GL_MAX_TESS_GEN_LEVEL */
	/* reuse GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS */
	/* reuse GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS */
	/* reuse GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS */
	/* reuse GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS */
	/* reuse GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS */
	/* reuse GL_MAX_TESS_PATCH_COMPONENTS */
	/* reuse GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS */
	/* reuse GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS */
	/* reuse GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS */
	/* reuse GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS */
	/* reuse GL_MAX_TESS_CONTROL_INPUT_COMPONENTS */
	/* reuse GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS */
	/* reuse GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS */
	/* reuse GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS */
	/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER */
	/* reuse GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER */
	/* reuse GL_TESS_EVALUATION_SHADER */
	/* reuse GL_TESS_CONTROL_SHADER */
	/* Would reuse tokens from ARB_texture_buffer_object_rgb32, but it has none */
	/* Reuse tokens from ARB_transform_feedback2 */
	/* reuse GL_TRANSFORM_FEEDBACK */
	/* reuse GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED */
	/* reuse GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE */
	/* reuse GL_TRANSFORM_FEEDBACK_BINDING */
	/* Reuse tokens from ARB_transform_feedback3 */
	/* reuse GL_MAX_TRANSFORM_FEEDBACK_BUFFERS */
	/* reuse GL_MAX_VERTEX_STREAMS */
}

version(GL_ARB_multitexture) {
}
else {
	static const auto GL_TEXTURE0_ARB                   = 0x84C0;
	static const auto GL_TEXTURE1_ARB                   = 0x84C1;
	static const auto GL_TEXTURE2_ARB                   = 0x84C2;
	static const auto GL_TEXTURE3_ARB                   = 0x84C3;
	static const auto GL_TEXTURE4_ARB                   = 0x84C4;
	static const auto GL_TEXTURE5_ARB                   = 0x84C5;
	static const auto GL_TEXTURE6_ARB                   = 0x84C6;
	static const auto GL_TEXTURE7_ARB                   = 0x84C7;
	static const auto GL_TEXTURE8_ARB                   = 0x84C8;
	static const auto GL_TEXTURE9_ARB                   = 0x84C9;
	static const auto GL_TEXTURE10_ARB                  = 0x84Ca;
	static const auto GL_TEXTURE11_ARB                  = 0x84Cb;
	static const auto GL_TEXTURE12_ARB                  = 0x84Cc;
	static const auto GL_TEXTURE13_ARB                  = 0x84Cd;
	static const auto GL_TEXTURE14_ARB                  = 0x84Ce;
	static const auto GL_TEXTURE15_ARB                  = 0x84Cf;
	static const auto GL_TEXTURE16_ARB                  = 0x84D0;
	static const auto GL_TEXTURE17_ARB                  = 0x84D1;
	static const auto GL_TEXTURE18_ARB                  = 0x84D2;
	static const auto GL_TEXTURE19_ARB                  = 0x84D3;
	static const auto GL_TEXTURE20_ARB                  = 0x84D4;
	static const auto GL_TEXTURE21_ARB                  = 0x84D5;
	static const auto GL_TEXTURE22_ARB                  = 0x84D6;
	static const auto GL_TEXTURE23_ARB                  = 0x84D7;
	static const auto GL_TEXTURE24_ARB                  = 0x84D8;
	static const auto GL_TEXTURE25_ARB                  = 0x84D9;
	static const auto GL_TEXTURE26_ARB                  = 0x84Da;
	static const auto GL_TEXTURE27_ARB                  = 0x84Db;
	static const auto GL_TEXTURE28_ARB                  = 0x84Dc;
	static const auto GL_TEXTURE29_ARB                  = 0x84Dd;
	static const auto GL_TEXTURE30_ARB                  = 0x84De;
	static const auto GL_TEXTURE31_ARB                  = 0x84Df;
	static const auto GL_ACTIVE_TEXTURE_ARB             = 0x84E0;
	static const auto GL_CLIENT_ACTIVE_TEXTURE_ARB      = 0x84E1;
	static const auto GL_MAX_TEXTURE_UNITS_ARB          = 0x84E2;
}

version(GL_ARB_transpose_matrix) {
}
else {
	static const auto GL_TRANSPOSE_MODELVIEW_MATRIX_ARB = 0x84E3;
	static const auto GL_TRANSPOSE_PROJECTION_MATRIX_ARB = 0x84E4;
	static const auto GL_TRANSPOSE_TEXTURE_MATRIX_ARB   = 0x84E5;
	static const auto GL_TRANSPOSE_COLOR_MATRIX_ARB     = 0x84E6;
}

version(GL_ARB_multisample) {
}
else {
	static const auto GL_MULTISAMPLE_ARB                = 0x809d;
	static const auto GL_SAMPLE_ALPHA_TO_COVERAGE_ARB   = 0x809e;
	static const auto GL_SAMPLE_ALPHA_TO_ONE_ARB        = 0x809f;
	static const auto GL_SAMPLE_COVERAGE_ARB            = 0x80A0;
	static const auto GL_SAMPLE_BUFFERS_ARB             = 0x80A8;
	static const auto GL_SAMPLES_ARB                    = 0x80A9;
	static const auto GL_SAMPLE_COVERAGE_VALUE_ARB      = 0x80Aa;
	static const auto GL_SAMPLE_COVERAGE_INVERT_ARB     = 0x80Ab;
	static const auto GL_MULTISAMPLE_BIT_ARB            = 0x20000000;
}

version(GL_ARB_texture_env_add) {
}
else {
}

version(GL_ARB_texture_cube_map) {
}
else {
	static const auto GL_NORMAL_MAP_ARB                 = 0x8511;
	static const auto GL_REFLECTION_MAP_ARB             = 0x8512;
	static const auto GL_TEXTURE_CUBE_MAP_ARB           = 0x8513;
	static const auto GL_TEXTURE_BINDING_CUBE_MAP_ARB   = 0x8514;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_X_ARB = 0x8515;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_X_ARB = 0x8516;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_Y_ARB = 0x8517;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_ARB = 0x8518;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_Z_ARB = 0x8519;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_ARB = 0x851a;
	static const auto GL_PROXY_TEXTURE_CUBE_MAP_ARB     = 0x851b;
	static const auto GL_MAX_CUBE_MAP_TEXTURE_SIZE_ARB  = 0x851c;
}

version(GL_ARB_texture_compression) {
}
else {
	static const auto GL_COMPRESSED_ALPHA_ARB           = 0x84E9;
	static const auto GL_COMPRESSED_LUMINANCE_ARB       = 0x84Ea;
	static const auto GL_COMPRESSED_LUMINANCE_ALPHA_ARB = 0x84Eb;
	static const auto GL_COMPRESSED_INTENSITY_ARB       = 0x84Ec;
	static const auto GL_COMPRESSED_RGB_ARB             = 0x84Ed;
	static const auto GL_COMPRESSED_RGBA_ARB            = 0x84Ee;
	static const auto GL_TEXTURE_COMPRESSION_HINT_ARB   = 0x84Ef;
	static const auto GL_TEXTURE_COMPRESSED_IMAGE_SIZE_ARB = 0x86A0;
	static const auto GL_TEXTURE_COMPRESSED_ARB         = 0x86A1;
	static const auto GL_NUM_COMPRESSED_TEXTURE_FORMATS_ARB = 0x86A2;
	static const auto GL_COMPRESSED_TEXTURE_FORMATS_ARB = 0x86A3;
}

version(GL_ARB_texture_border_clamp) {
}
else {
	static const auto GL_CLAMP_TO_BORDER_ARB            = 0x812d;
}

version(GL_ARB_point_parameters) {
}
else {
	static const auto GL_POINT_SIZE_MIN_ARB             = 0x8126;
	static const auto GL_POINT_SIZE_MAX_ARB             = 0x8127;
	static const auto GL_POINT_FADE_THRESHOLD_SIZE_ARB  = 0x8128;
	static const auto GL_POINT_DISTANCE_ATTENUATION_ARB = 0x8129;
}

version(GL_ARB_vertex_blend) {
}
else {
	static const auto GL_MAX_VERTEX_UNITS_ARB           = 0x86A4;
	static const auto GL_ACTIVE_VERTEX_UNITS_ARB        = 0x86A5;
	static const auto GL_WEIGHT_SUM_UNITY_ARB           = 0x86A6;
	static const auto GL_VERTEX_BLEND_ARB               = 0x86A7;
	static const auto GL_CURRENT_WEIGHT_ARB             = 0x86A8;
	static const auto GL_WEIGHT_ARRAY_TYPE_ARB          = 0x86A9;
	static const auto GL_WEIGHT_ARRAY_STRIDE_ARB        = 0x86Aa;
	static const auto GL_WEIGHT_ARRAY_SIZE_ARB          = 0x86Ab;
	static const auto GL_WEIGHT_ARRAY_POINTER_ARB       = 0x86Ac;
	static const auto GL_WEIGHT_ARRAY_ARB               = 0x86Ad;
	static const auto GL_MODELVIEW0_ARB                 = 0x1700;
	static const auto GL_MODELVIEW1_ARB                 = 0x850a;
	static const auto GL_MODELVIEW2_ARB                 = 0x8722;
	static const auto GL_MODELVIEW3_ARB                 = 0x8723;
	static const auto GL_MODELVIEW4_ARB                 = 0x8724;
	static const auto GL_MODELVIEW5_ARB                 = 0x8725;
	static const auto GL_MODELVIEW6_ARB                 = 0x8726;
	static const auto GL_MODELVIEW7_ARB                 = 0x8727;
	static const auto GL_MODELVIEW8_ARB                 = 0x8728;
	static const auto GL_MODELVIEW9_ARB                 = 0x8729;
	static const auto GL_MODELVIEW10_ARB                = 0x872a;
	static const auto GL_MODELVIEW11_ARB                = 0x872b;
	static const auto GL_MODELVIEW12_ARB                = 0x872c;
	static const auto GL_MODELVIEW13_ARB                = 0x872d;
	static const auto GL_MODELVIEW14_ARB                = 0x872e;
	static const auto GL_MODELVIEW15_ARB                = 0x872f;
	static const auto GL_MODELVIEW16_ARB                = 0x8730;
	static const auto GL_MODELVIEW17_ARB                = 0x8731;
	static const auto GL_MODELVIEW18_ARB                = 0x8732;
	static const auto GL_MODELVIEW19_ARB                = 0x8733;
	static const auto GL_MODELVIEW20_ARB                = 0x8734;
	static const auto GL_MODELVIEW21_ARB                = 0x8735;
	static const auto GL_MODELVIEW22_ARB                = 0x8736;
	static const auto GL_MODELVIEW23_ARB                = 0x8737;
	static const auto GL_MODELVIEW24_ARB                = 0x8738;
	static const auto GL_MODELVIEW25_ARB                = 0x8739;
	static const auto GL_MODELVIEW26_ARB                = 0x873a;
	static const auto GL_MODELVIEW27_ARB                = 0x873b;
	static const auto GL_MODELVIEW28_ARB                = 0x873c;
	static const auto GL_MODELVIEW29_ARB                = 0x873d;
	static const auto GL_MODELVIEW30_ARB                = 0x873e;
	static const auto GL_MODELVIEW31_ARB                = 0x873f;
}

version(GL_ARB_matrix_palette) {
}
else {
	static const auto GL_MATRIX_PALETTE_ARB             = 0x8840;
	static const auto GL_MAX_MATRIX_PALETTE_STACK_DEPTH_ARB = 0x8841;
	static const auto GL_MAX_PALETTE_MATRICES_ARB       = 0x8842;
	static const auto GL_CURRENT_PALETTE_MATRIX_ARB     = 0x8843;
	static const auto GL_MATRIX_INDEX_ARRAY_ARB         = 0x8844;
	static const auto GL_CURRENT_MATRIX_INDEX_ARB       = 0x8845;
	static const auto GL_MATRIX_INDEX_ARRAY_SIZE_ARB    = 0x8846;
	static const auto GL_MATRIX_INDEX_ARRAY_TYPE_ARB    = 0x8847;
	static const auto GL_MATRIX_INDEX_ARRAY_STRIDE_ARB  = 0x8848;
	static const auto GL_MATRIX_INDEX_ARRAY_POINTER_ARB = 0x8849;
}

version(GL_ARB_texture_env_combine) {
}
else {
	static const auto GL_COMBINE_ARB                    = 0x8570;
	static const auto GL_COMBINE_RGB_ARB                = 0x8571;
	static const auto GL_COMBINE_ALPHA_ARB              = 0x8572;
	static const auto GL_SOURCE0_RGB_ARB                = 0x8580;
	static const auto GL_SOURCE1_RGB_ARB                = 0x8581;
	static const auto GL_SOURCE2_RGB_ARB                = 0x8582;
	static const auto GL_SOURCE0_ALPHA_ARB              = 0x8588;
	static const auto GL_SOURCE1_ALPHA_ARB              = 0x8589;
	static const auto GL_SOURCE2_ALPHA_ARB              = 0x858a;
	static const auto GL_OPERAND0_RGB_ARB               = 0x8590;
	static const auto GL_OPERAND1_RGB_ARB               = 0x8591;
	static const auto GL_OPERAND2_RGB_ARB               = 0x8592;
	static const auto GL_OPERAND0_ALPHA_ARB             = 0x8598;
	static const auto GL_OPERAND1_ALPHA_ARB             = 0x8599;
	static const auto GL_OPERAND2_ALPHA_ARB             = 0x859a;
	static const auto GL_RGB_SCALE_ARB                  = 0x8573;
	static const auto GL_ADD_SIGNED_ARB                 = 0x8574;
	static const auto GL_INTERPOLATE_ARB                = 0x8575;
	static const auto GL_SUBTRACT_ARB                   = 0x84E7;
	static const auto GL_CONSTANT_ARB                   = 0x8576;
	static const auto GL_PRIMARY_COLOR_ARB              = 0x8577;
	static const auto GL_PREVIOUS_ARB                   = 0x8578;
}

version(GL_ARB_texture_env_crossbar) {
}
else {
}

version(GL_ARB_texture_env_dot3) {
}
else {
	static const auto GL_DOT3_RGB_ARB                   = 0x86Ae;
	static const auto GL_DOT3_RGBA_ARB                  = 0x86Af;
}

version(GL_ARB_texture_mirrored_repeat) {
}
else {
	static const auto GL_MIRRORED_REPEAT_ARB            = 0x8370;
}

version(GL_ARB_depth_texture) {
}
else {
	static const auto GL_DEPTH_COMPONENT16_ARB          = 0x81A5;
	static const auto GL_DEPTH_COMPONENT24_ARB          = 0x81A6;
	static const auto GL_DEPTH_COMPONENT32_ARB          = 0x81A7;
	static const auto GL_TEXTURE_DEPTH_SIZE_ARB         = 0x884a;
	static const auto GL_DEPTH_TEXTURE_MODE_ARB         = 0x884b;
}

version(GL_ARB_shadow) {
}
else {
	static const auto GL_TEXTURE_COMPARE_MODE_ARB       = 0x884c;
	static const auto GL_TEXTURE_COMPARE_FUNC_ARB       = 0x884d;
	static const auto GL_COMPARE_R_TO_TEXTURE_ARB       = 0x884e;
}

version(GL_ARB_shadow_ambient) {
}
else {
	static const auto GL_TEXTURE_COMPARE_FAIL_VALUE_ARB = 0x80Bf;
}

version(GL_ARB_window_pos) {
}
else {
}

version(GL_ARB_vertex_program) {
}
else {
	static const auto GL_COLOR_SUM_ARB                  = 0x8458;
	static const auto GL_VERTEX_PROGRAM_ARB             = 0x8620;
	static const auto GL_VERTEX_ATTRIB_ARRAY_ENABLED_ARB = 0x8622;
	static const auto GL_VERTEX_ATTRIB_ARRAY_SIZE_ARB   = 0x8623;
	static const auto GL_VERTEX_ATTRIB_ARRAY_STRIDE_ARB = 0x8624;
	static const auto GL_VERTEX_ATTRIB_ARRAY_TYPE_ARB   = 0x8625;
	static const auto GL_CURRENT_VERTEX_ATTRIB_ARB      = 0x8626;
	static const auto GL_PROGRAM_LENGTH_ARB             = 0x8627;
	static const auto GL_PROGRAM_STRING_ARB             = 0x8628;
	static const auto GL_MAX_PROGRAM_MATRIX_STACK_DEPTH_ARB = 0x862e;
	static const auto GL_MAX_PROGRAM_MATRICES_ARB       = 0x862f;
	static const auto GL_CURRENT_MATRIX_STACK_DEPTH_ARB = 0x8640;
	static const auto GL_CURRENT_MATRIX_ARB             = 0x8641;
	static const auto GL_VERTEX_PROGRAM_POINT_SIZE_ARB  = 0x8642;
	static const auto GL_VERTEX_PROGRAM_TWO_SIDE_ARB    = 0x8643;
	static const auto GL_VERTEX_ATTRIB_ARRAY_POINTER_ARB = 0x8645;
	static const auto GL_PROGRAM_ERROR_POSITION_ARB     = 0x864b;
	static const auto GL_PROGRAM_BINDING_ARB            = 0x8677;
	static const auto GL_MAX_VERTEX_ATTRIBS_ARB         = 0x8869;
	static const auto GL_VERTEX_ATTRIB_ARRAY_NORMALIZED_ARB = 0x886a;
	static const auto GL_PROGRAM_ERROR_STRING_ARB       = 0x8874;
	static const auto GL_PROGRAM_FORMAT_ASCII_ARB       = 0x8875;
	static const auto GL_PROGRAM_FORMAT_ARB             = 0x8876;
	static const auto GL_PROGRAM_INSTRUCTIONS_ARB       = 0x88A0;
	static const auto GL_MAX_PROGRAM_INSTRUCTIONS_ARB   = 0x88A1;
	static const auto GL_PROGRAM_NATIVE_INSTRUCTIONS_ARB = 0x88A2;
	static const auto GL_MAX_PROGRAM_NATIVE_INSTRUCTIONS_ARB = 0x88A3;
	static const auto GL_PROGRAM_TEMPORARIES_ARB        = 0x88A4;
	static const auto GL_MAX_PROGRAM_TEMPORARIES_ARB    = 0x88A5;
	static const auto GL_PROGRAM_NATIVE_TEMPORARIES_ARB = 0x88A6;
	static const auto GL_MAX_PROGRAM_NATIVE_TEMPORARIES_ARB = 0x88A7;
	static const auto GL_PROGRAM_PARAMETERS_ARB         = 0x88A8;
	static const auto GL_MAX_PROGRAM_PARAMETERS_ARB     = 0x88A9;
	static const auto GL_PROGRAM_NATIVE_PARAMETERS_ARB  = 0x88Aa;
	static const auto GL_MAX_PROGRAM_NATIVE_PARAMETERS_ARB = 0x88Ab;
	static const auto GL_PROGRAM_ATTRIBS_ARB            = 0x88Ac;
	static const auto GL_MAX_PROGRAM_ATTRIBS_ARB        = 0x88Ad;
	static const auto GL_PROGRAM_NATIVE_ATTRIBS_ARB     = 0x88Ae;
	static const auto GL_MAX_PROGRAM_NATIVE_ATTRIBS_ARB = 0x88Af;
	static const auto GL_PROGRAM_ADDRESS_REGISTERS_ARB  = 0x88B0;
	static const auto GL_MAX_PROGRAM_ADDRESS_REGISTERS_ARB = 0x88B1;
	static const auto GL_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB = 0x88B2;
	static const auto GL_MAX_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB = 0x88B3;
	static const auto GL_MAX_PROGRAM_LOCAL_PARAMETERS_ARB = 0x88B4;
	static const auto GL_MAX_PROGRAM_ENV_PARAMETERS_ARB = 0x88B5;
	static const auto GL_PROGRAM_UNDER_NATIVE_LIMITS_ARB = 0x88B6;
	static const auto GL_TRANSPOSE_CURRENT_MATRIX_ARB   = 0x88B7;
	static const auto GL_MATRIX0_ARB                    = 0x88C0;
	static const auto GL_MATRIX1_ARB                    = 0x88C1;
	static const auto GL_MATRIX2_ARB                    = 0x88C2;
	static const auto GL_MATRIX3_ARB                    = 0x88C3;
	static const auto GL_MATRIX4_ARB                    = 0x88C4;
	static const auto GL_MATRIX5_ARB                    = 0x88C5;
	static const auto GL_MATRIX6_ARB                    = 0x88C6;
	static const auto GL_MATRIX7_ARB                    = 0x88C7;
	static const auto GL_MATRIX8_ARB                    = 0x88C8;
	static const auto GL_MATRIX9_ARB                    = 0x88C9;
	static const auto GL_MATRIX10_ARB                   = 0x88Ca;
	static const auto GL_MATRIX11_ARB                   = 0x88Cb;
	static const auto GL_MATRIX12_ARB                   = 0x88Cc;
	static const auto GL_MATRIX13_ARB                   = 0x88Cd;
	static const auto GL_MATRIX14_ARB                   = 0x88Ce;
	static const auto GL_MATRIX15_ARB                   = 0x88Cf;
	static const auto GL_MATRIX16_ARB                   = 0x88D0;
	static const auto GL_MATRIX17_ARB                   = 0x88D1;
	static const auto GL_MATRIX18_ARB                   = 0x88D2;
	static const auto GL_MATRIX19_ARB                   = 0x88D3;
	static const auto GL_MATRIX20_ARB                   = 0x88D4;
	static const auto GL_MATRIX21_ARB                   = 0x88D5;
	static const auto GL_MATRIX22_ARB                   = 0x88D6;
	static const auto GL_MATRIX23_ARB                   = 0x88D7;
	static const auto GL_MATRIX24_ARB                   = 0x88D8;
	static const auto GL_MATRIX25_ARB                   = 0x88D9;
	static const auto GL_MATRIX26_ARB                   = 0x88Da;
	static const auto GL_MATRIX27_ARB                   = 0x88Db;
	static const auto GL_MATRIX28_ARB                   = 0x88Dc;
	static const auto GL_MATRIX29_ARB                   = 0x88Dd;
	static const auto GL_MATRIX30_ARB                   = 0x88De;
	static const auto GL_MATRIX31_ARB                   = 0x88Df;
}

version(GL_ARB_fragment_program) {
}
else {
	static const auto GL_FRAGMENT_PROGRAM_ARB           = 0x8804;
	static const auto GL_PROGRAM_ALU_INSTRUCTIONS_ARB   = 0x8805;
	static const auto GL_PROGRAM_TEX_INSTRUCTIONS_ARB   = 0x8806;
	static const auto GL_PROGRAM_TEX_INDIRECTIONS_ARB   = 0x8807;
	static const auto GL_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB = 0x8808;
	static const auto GL_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB = 0x8809;
	static const auto GL_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB = 0x880a;
	static const auto GL_MAX_PROGRAM_ALU_INSTRUCTIONS_ARB = 0x880b;
	static const auto GL_MAX_PROGRAM_TEX_INSTRUCTIONS_ARB = 0x880c;
	static const auto GL_MAX_PROGRAM_TEX_INDIRECTIONS_ARB = 0x880d;
	static const auto GL_MAX_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB = 0x880e;
	static const auto GL_MAX_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB = 0x880f;
	static const auto GL_MAX_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB = 0x8810;
	static const auto GL_MAX_TEXTURE_COORDS_ARB         = 0x8871;
	static const auto GL_MAX_TEXTURE_IMAGE_UNITS_ARB    = 0x8872;
}

version(GL_ARB_vertex_buffer_object) {
}
else {
	static const auto GL_BUFFER_SIZE_ARB                = 0x8764;
	static const auto GL_BUFFER_USAGE_ARB               = 0x8765;
	static const auto GL_ARRAY_BUFFER_ARB               = 0x8892;
	static const auto GL_ELEMENT_ARRAY_BUFFER_ARB       = 0x8893;
	static const auto GL_ARRAY_BUFFER_BINDING_ARB       = 0x8894;
	static const auto GL_ELEMENT_ARRAY_BUFFER_BINDING_ARB = 0x8895;
	static const auto GL_VERTEX_ARRAY_BUFFER_BINDING_ARB = 0x8896;
	static const auto GL_NORMAL_ARRAY_BUFFER_BINDING_ARB = 0x8897;
	static const auto GL_COLOR_ARRAY_BUFFER_BINDING_ARB = 0x8898;
	static const auto GL_INDEX_ARRAY_BUFFER_BINDING_ARB = 0x8899;
	static const auto GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING_ARB = 0x889a;
	static const auto GL_EDGE_FLAG_ARRAY_BUFFER_BINDING_ARB = 0x889b;
	static const auto GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING_ARB = 0x889c;
	static const auto GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING_ARB = 0x889d;
	static const auto GL_WEIGHT_ARRAY_BUFFER_BINDING_ARB = 0x889e;
	static const auto GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING_ARB = 0x889f;
	static const auto GL_READ_ONLY_ARB                  = 0x88B8;
	static const auto GL_WRITE_ONLY_ARB                 = 0x88B9;
	static const auto GL_READ_WRITE_ARB                 = 0x88Ba;
	static const auto GL_BUFFER_ACCESS_ARB              = 0x88Bb;
	static const auto GL_BUFFER_MAPPED_ARB              = 0x88Bc;
	static const auto GL_BUFFER_MAP_POINTER_ARB         = 0x88Bd;
	static const auto GL_STREAM_DRAW_ARB                = 0x88E0;
	static const auto GL_STREAM_READ_ARB                = 0x88E1;
	static const auto GL_STREAM_COPY_ARB                = 0x88E2;
	static const auto GL_STATIC_DRAW_ARB                = 0x88E4;
	static const auto GL_STATIC_READ_ARB                = 0x88E5;
	static const auto GL_STATIC_COPY_ARB                = 0x88E6;
	static const auto GL_DYNAMIC_DRAW_ARB               = 0x88E8;
	static const auto GL_DYNAMIC_READ_ARB               = 0x88E9;
	static const auto GL_DYNAMIC_COPY_ARB               = 0x88Ea;
}

version(GL_ARB_occlusion_query) {
}
else {
	static const auto GL_QUERY_COUNTER_BITS_ARB         = 0x8864;
	static const auto GL_CURRENT_QUERY_ARB              = 0x8865;
	static const auto GL_QUERY_RESULT_ARB               = 0x8866;
	static const auto GL_QUERY_RESULT_AVAILABLE_ARB     = 0x8867;
	static const auto GL_SAMPLES_PASSED_ARB             = 0x8914;
}

version(GL_ARB_shader_objects) {
}
else {
	static const auto GL_PROGRAM_OBJECT_ARB             = 0x8B40;
	static const auto GL_SHADER_OBJECT_ARB              = 0x8B48;
	static const auto GL_OBJECT_TYPE_ARB                = 0x8B4e;
	static const auto GL_OBJECT_SUBTYPE_ARB             = 0x8B4f;
	static const auto GL_FLOAT_VEC2_ARB                 = 0x8B50;
	static const auto GL_FLOAT_VEC3_ARB                 = 0x8B51;
	static const auto GL_FLOAT_VEC4_ARB                 = 0x8B52;
	static const auto GL_INT_VEC2_ARB                   = 0x8B53;
	static const auto GL_INT_VEC3_ARB                   = 0x8B54;
	static const auto GL_INT_VEC4_ARB                   = 0x8B55;
	static const auto GL_BOOL_ARB                       = 0x8B56;
	static const auto GL_BOOL_VEC2_ARB                  = 0x8B57;
	static const auto GL_BOOL_VEC3_ARB                  = 0x8B58;
	static const auto GL_BOOL_VEC4_ARB                  = 0x8B59;
	static const auto GL_FLOAT_MAT2_ARB                 = 0x8B5a;
	static const auto GL_FLOAT_MAT3_ARB                 = 0x8B5b;
	static const auto GL_FLOAT_MAT4_ARB                 = 0x8B5c;
	static const auto GL_SAMPLER_1D_ARB                 = 0x8B5d;
	static const auto GL_SAMPLER_2D_ARB                 = 0x8B5e;
	static const auto GL_SAMPLER_3D_ARB                 = 0x8B5f;
	static const auto GL_SAMPLER_CUBE_ARB               = 0x8B60;
	static const auto GL_SAMPLER_1D_SHADOW_ARB          = 0x8B61;
	static const auto GL_SAMPLER_2D_SHADOW_ARB          = 0x8B62;
	static const auto GL_SAMPLER_2D_RECT_ARB            = 0x8B63;
	static const auto GL_SAMPLER_2D_RECT_SHADOW_ARB     = 0x8B64;
	static const auto GL_OBJECT_DELETE_STATUS_ARB       = 0x8B80;
	static const auto GL_OBJECT_COMPILE_STATUS_ARB      = 0x8B81;
	static const auto GL_OBJECT_LINK_STATUS_ARB         = 0x8B82;
	static const auto GL_OBJECT_VALIDATE_STATUS_ARB     = 0x8B83;
	static const auto GL_OBJECT_INFO_LOG_LENGTH_ARB     = 0x8B84;
	static const auto GL_OBJECT_ATTACHED_OBJECTS_ARB    = 0x8B85;
	static const auto GL_OBJECT_ACTIVE_UNIFORMS_ARB     = 0x8B86;
	static const auto GL_OBJECT_ACTIVE_UNIFORM_MAX_LENGTH_ARB = 0x8B87;
	static const auto GL_OBJECT_SHADER_SOURCE_LENGTH_ARB = 0x8B88;
}

version(GL_ARB_vertex_shader) {
}
else {
	static const auto GL_VERTEX_SHADER_ARB              = 0x8B31;
	static const auto GL_MAX_VERTEX_UNIFORM_COMPONENTS_ARB = 0x8B4a;
	static const auto GL_MAX_VARYING_FLOATS_ARB         = 0x8B4b;
	static const auto GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS_ARB = 0x8B4c;
	static const auto GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS_ARB = 0x8B4d;
	static const auto GL_OBJECT_ACTIVE_ATTRIBUTES_ARB   = 0x8B89;
	static const auto GL_OBJECT_ACTIVE_ATTRIBUTE_MAX_LENGTH_ARB = 0x8B8a;
}

version(GL_ARB_fragment_shader) {
}
else {
	static const auto GL_FRAGMENT_SHADER_ARB            = 0x8B30;
	static const auto GL_MAX_FRAGMENT_UNIFORM_COMPONENTS_ARB = 0x8B49;
	static const auto GL_FRAGMENT_SHADER_DERIVATIVE_HINT_ARB = 0x8B8b;
}

version(GL_ARB_shading_language_100) {
}
else {
	static const auto GL_SHADING_LANGUAGE_VERSION_ARB   = 0x8B8c;
}

version(GL_ARB_texture_non_power_of_two) {
}
else {
}

version(GL_ARB_point_sprite) {
}
else {
	static const auto GL_POINT_SPRITE_ARB               = 0x8861;
	static const auto GL_COORD_REPLACE_ARB              = 0x8862;
}

version(GL_ARB_fragment_program_shadow) {
}
else {
}

version(GL_ARB_draw_buffers) {
}
else {
	static const auto GL_MAX_DRAW_BUFFERS_ARB           = 0x8824;
	static const auto GL_DRAW_BUFFER0_ARB               = 0x8825;
	static const auto GL_DRAW_BUFFER1_ARB               = 0x8826;
	static const auto GL_DRAW_BUFFER2_ARB               = 0x8827;
	static const auto GL_DRAW_BUFFER3_ARB               = 0x8828;
	static const auto GL_DRAW_BUFFER4_ARB               = 0x8829;
	static const auto GL_DRAW_BUFFER5_ARB               = 0x882a;
	static const auto GL_DRAW_BUFFER6_ARB               = 0x882b;
	static const auto GL_DRAW_BUFFER7_ARB               = 0x882c;
	static const auto GL_DRAW_BUFFER8_ARB               = 0x882d;
	static const auto GL_DRAW_BUFFER9_ARB               = 0x882e;
	static const auto GL_DRAW_BUFFER10_ARB              = 0x882f;
	static const auto GL_DRAW_BUFFER11_ARB              = 0x8830;
	static const auto GL_DRAW_BUFFER12_ARB              = 0x8831;
	static const auto GL_DRAW_BUFFER13_ARB              = 0x8832;
	static const auto GL_DRAW_BUFFER14_ARB              = 0x8833;
	static const auto GL_DRAW_BUFFER15_ARB              = 0x8834;
}

version(GL_ARB_texture_rectangle) {
}
else {
	static const auto GL_TEXTURE_RECTANGLE_ARB          = 0x84F5;
	static const auto GL_TEXTURE_BINDING_RECTANGLE_ARB  = 0x84F6;
	static const auto GL_PROXY_TEXTURE_RECTANGLE_ARB    = 0x84F7;
	static const auto GL_MAX_RECTANGLE_TEXTURE_SIZE_ARB = 0x84F8;
}

version(GL_ARB_color_buffer_float) {
}
else {
	static const auto GL_RGBA_FLOAT_MODE_ARB            = 0x8820;
	static const auto GL_CLAMP_VERTEX_COLOR_ARB         = 0x891a;
	static const auto GL_CLAMP_FRAGMENT_COLOR_ARB       = 0x891b;
	static const auto GL_CLAMP_READ_COLOR_ARB           = 0x891c;
	static const auto GL_FIXED_ONLY_ARB                 = 0x891d;
}

version(GL_ARB_half_float_pixel) {
}
else {
	static const auto GL_HALF_FLOAT_ARB                 = 0x140b;
}

version(GL_ARB_texture_float) {
}
else {
	static const auto GL_TEXTURE_RED_TYPE_ARB           = 0x8C10;
	static const auto GL_TEXTURE_GREEN_TYPE_ARB         = 0x8C11;
	static const auto GL_TEXTURE_BLUE_TYPE_ARB          = 0x8C12;
	static const auto GL_TEXTURE_ALPHA_TYPE_ARB         = 0x8C13;
	static const auto GL_TEXTURE_LUMINANCE_TYPE_ARB     = 0x8C14;
	static const auto GL_TEXTURE_INTENSITY_TYPE_ARB     = 0x8C15;
	static const auto GL_TEXTURE_DEPTH_TYPE_ARB         = 0x8C16;
	static const auto GL_UNSIGNED_NORMALIZED_ARB        = 0x8C17;
	static const auto GL_RGBA32F_ARB                    = 0x8814;
	static const auto GL_RGB32F_ARB                     = 0x8815;
	static const auto GL_ALPHA32F_ARB                   = 0x8816;
	static const auto GL_INTENSITY32F_ARB               = 0x8817;
	static const auto GL_LUMINANCE32F_ARB               = 0x8818;
	static const auto GL_LUMINANCE_ALPHA32F_ARB         = 0x8819;
	static const auto GL_RGBA16F_ARB                    = 0x881a;
	static const auto GL_RGB16F_ARB                     = 0x881b;
	static const auto GL_ALPHA16F_ARB                   = 0x881c;
	static const auto GL_INTENSITY16F_ARB               = 0x881d;
	static const auto GL_LUMINANCE16F_ARB               = 0x881e;
	static const auto GL_LUMINANCE_ALPHA16F_ARB         = 0x881f;
}

version(GL_ARB_pixel_buffer_object) {
}
else {
	static const auto GL_PIXEL_PACK_BUFFER_ARB          = 0x88Eb;
	static const auto GL_PIXEL_UNPACK_BUFFER_ARB        = 0x88Ec;
	static const auto GL_PIXEL_PACK_BUFFER_BINDING_ARB  = 0x88Ed;
	static const auto GL_PIXEL_UNPACK_BUFFER_BINDING_ARB = 0x88Ef;
}

version(GL_ARB_depth_buffer_float) {
}
else {
	static const auto GL_DEPTH_COMPONENT32F             = 0x8CAc;
	static const auto GL_DEPTH32F_STENCIL8              = 0x8CAd;
	static const auto GL_FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAd;
}

version(GL_ARB_draw_instanced) {
}
else {
}

version(GL_ARB_framebuffer_object) {
}
else {
	static const auto GL_INVALID_FRAMEBUFFER_OPERATION  = 0x0506;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217;
	static const auto GL_FRAMEBUFFER_DEFAULT            = 0x8218;
	static const auto GL_FRAMEBUFFER_UNDEFINED          = 0x8219;
	static const auto GL_DEPTH_STENCIL_ATTACHMENT       = 0x821a;
	static const auto GL_MAX_RENDERBUFFER_SIZE          = 0x84E8;
	static const auto GL_DEPTH_STENCIL                  = 0x84F9;
	static const auto GL_UNSIGNED_INT_24_8              = 0x84Fa;
	static const auto GL_DEPTH24_STENCIL8               = 0x88F0;
	static const auto GL_TEXTURE_STENCIL_SIZE           = 0x88F1;
	static const auto GL_TEXTURE_RED_TYPE               = 0x8C10;
	static const auto GL_TEXTURE_GREEN_TYPE             = 0x8C11;
	static const auto GL_TEXTURE_BLUE_TYPE              = 0x8C12;
	static const auto GL_TEXTURE_ALPHA_TYPE             = 0x8C13;
	static const auto GL_TEXTURE_DEPTH_TYPE             = 0x8C16;
	static const auto GL_UNSIGNED_NORMALIZED            = 0x8C17;
	static const auto GL_FRAMEBUFFER_BINDING            = 0x8CA6;
	static const auto GL_DRAW_FRAMEBUFFER_BINDING       = GL_FRAMEBUFFER_BINDING;
	static const auto GL_RENDERBUFFER_BINDING           = 0x8CA7;
	static const auto GL_READ_FRAMEBUFFER               = 0x8CA8;
	static const auto GL_DRAW_FRAMEBUFFER               = 0x8CA9;
	static const auto GL_READ_FRAMEBUFFER_BINDING       = 0x8CAa;
	static const auto GL_RENDERBUFFER_SAMPLES           = 0x8CAb;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;
	static const auto GL_FRAMEBUFFER_COMPLETE           = 0x8CD5;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = 0x8CDb;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER = 0x8CDc;
	static const auto GL_FRAMEBUFFER_UNSUPPORTED        = 0x8CDd;
	static const auto GL_MAX_COLOR_ATTACHMENTS          = 0x8CDf;
	static const auto GL_COLOR_ATTACHMENT0              = 0x8CE0;
	static const auto GL_COLOR_ATTACHMENT1              = 0x8CE1;
	static const auto GL_COLOR_ATTACHMENT2              = 0x8CE2;
	static const auto GL_COLOR_ATTACHMENT3              = 0x8CE3;
	static const auto GL_COLOR_ATTACHMENT4              = 0x8CE4;
	static const auto GL_COLOR_ATTACHMENT5              = 0x8CE5;
	static const auto GL_COLOR_ATTACHMENT6              = 0x8CE6;
	static const auto GL_COLOR_ATTACHMENT7              = 0x8CE7;
	static const auto GL_COLOR_ATTACHMENT8              = 0x8CE8;
	static const auto GL_COLOR_ATTACHMENT9              = 0x8CE9;
	static const auto GL_COLOR_ATTACHMENT10             = 0x8CEa;
	static const auto GL_COLOR_ATTACHMENT11             = 0x8CEb;
	static const auto GL_COLOR_ATTACHMENT12             = 0x8CEc;
	static const auto GL_COLOR_ATTACHMENT13             = 0x8CEd;
	static const auto GL_COLOR_ATTACHMENT14             = 0x8CEe;
	static const auto GL_COLOR_ATTACHMENT15             = 0x8CEf;
	static const auto GL_DEPTH_ATTACHMENT               = 0x8D00;
	static const auto GL_STENCIL_ATTACHMENT             = 0x8D20;
	static const auto GL_FRAMEBUFFER                    = 0x8D40;
	static const auto GL_RENDERBUFFER                   = 0x8D41;
	static const auto GL_RENDERBUFFER_WIDTH             = 0x8D42;
	static const auto GL_RENDERBUFFER_HEIGHT            = 0x8D43;
	static const auto GL_RENDERBUFFER_INTERNAL_FORMAT   = 0x8D44;
	static const auto GL_STENCIL_INDEX1                 = 0x8D46;
	static const auto GL_STENCIL_INDEX4                 = 0x8D47;
	static const auto GL_STENCIL_INDEX8                 = 0x8D48;
	static const auto GL_STENCIL_INDEX16                = 0x8D49;
	static const auto GL_RENDERBUFFER_RED_SIZE          = 0x8D50;
	static const auto GL_RENDERBUFFER_GREEN_SIZE        = 0x8D51;
	static const auto GL_RENDERBUFFER_BLUE_SIZE         = 0x8D52;
	static const auto GL_RENDERBUFFER_ALPHA_SIZE        = 0x8D53;
	static const auto GL_RENDERBUFFER_DEPTH_SIZE        = 0x8D54;
	static const auto GL_RENDERBUFFER_STENCIL_SIZE      = 0x8D55;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56;
	static const auto GL_MAX_SAMPLES                    = 0x8D57;
}

version(GL_ARB_framebuffer_object_DEPRECATED) {
}
else {
	static const auto GL_INDEX                          = 0x8222;
	static const auto GL_TEXTURE_LUMINANCE_TYPE         = 0x8C14;
	static const auto GL_TEXTURE_INTENSITY_TYPE         = 0x8C15;
}

version(GL_ARB_framebuffer_sRGB) {
}
else {
	static const auto GL_FRAMEBUFFER_SRGB               = 0x8DB9;
}

version(GL_ARB_geometry_shader4) {
}
else {
	static const auto GL_LINES_ADJACENCY_ARB            = 0x000a;
	static const auto GL_LINE_STRIP_ADJACENCY_ARB       = 0x000b;
	static const auto GL_TRIANGLES_ADJACENCY_ARB        = 0x000c;
	static const auto GL_TRIANGLE_STRIP_ADJACENCY_ARB   = 0x000d;
	static const auto GL_PROGRAM_POINT_SIZE_ARB         = 0x8642;
	static const auto GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_ARB = 0x8C29;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_LAYERED_ARB = 0x8DA7;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_ARB = 0x8DA8;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_ARB = 0x8DA9;
	static const auto GL_GEOMETRY_SHADER_ARB            = 0x8DD9;
	static const auto GL_GEOMETRY_VERTICES_OUT_ARB      = 0x8DDa;
	static const auto GL_GEOMETRY_INPUT_TYPE_ARB        = 0x8DDb;
	static const auto GL_GEOMETRY_OUTPUT_TYPE_ARB       = 0x8DDc;
	static const auto GL_MAX_GEOMETRY_VARYING_COMPONENTS_ARB = 0x8DDd;
	static const auto GL_MAX_VERTEX_VARYING_COMPONENTS_ARB = 0x8DDe;
	static const auto GL_MAX_GEOMETRY_UNIFORM_COMPONENTS_ARB = 0x8DDf;
	static const auto GL_MAX_GEOMETRY_OUTPUT_VERTICES_ARB = 0x8DE0;
	static const auto GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS_ARB = 0x8DE1;
	/* reuse GL_MAX_VARYING_COMPONENTS */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER */
}

version(GL_ARB_half_float_vertex) {
}
else {
	static const auto GL_HALF_FLOAT                     = 0x140b;
}

version(GL_ARB_instanced_arrays) {
}
else {
	static const auto GL_VERTEX_ATTRIB_ARRAY_DIVISOR_ARB = 0x88Fe;
}

version(GL_ARB_map_buffer_range) {
}
else {
	static const auto GL_MAP_READ_BIT                   = 0x0001;
	static const auto GL_MAP_WRITE_BIT                  = 0x0002;
	static const auto GL_MAP_INVALIDATE_RANGE_BIT       = 0x0004;
	static const auto GL_MAP_INVALIDATE_BUFFER_BIT      = 0x0008;
	static const auto GL_MAP_FLUSH_EXPLICIT_BIT         = 0x0010;
	static const auto GL_MAP_UNSYNCHRONIZED_BIT         = 0x0020;
}

version(GL_ARB_texture_buffer_object) {
}
else {
	static const auto GL_TEXTURE_BUFFER_ARB             = 0x8C2a;
	static const auto GL_MAX_TEXTURE_BUFFER_SIZE_ARB    = 0x8C2b;
	static const auto GL_TEXTURE_BINDING_BUFFER_ARB     = 0x8C2c;
	static const auto GL_TEXTURE_BUFFER_DATA_STORE_BINDING_ARB = 0x8C2d;
	static const auto GL_TEXTURE_BUFFER_FORMAT_ARB      = 0x8C2e;
}

version(GL_ARB_texture_compression_rgtc) {
}
else {
	static const auto GL_COMPRESSED_RED_RGTC1           = 0x8DBb;
	static const auto GL_COMPRESSED_SIGNED_RED_RGTC1    = 0x8DBc;
	static const auto GL_COMPRESSED_RG_RGTC2            = 0x8DBd;
	static const auto GL_COMPRESSED_SIGNED_RG_RGTC2     = 0x8DBe;
}

version(GL_ARB_texture_rg) {
}
else {
	static const auto GL_RG                             = 0x8227;
	static const auto GL_RG_INTEGER                     = 0x8228;
	static const auto GL_R8                             = 0x8229;
	static const auto GL_R16                            = 0x822a;
	static const auto GL_RG8                            = 0x822b;
	static const auto GL_RG16                           = 0x822c;
	static const auto GL_R16F                           = 0x822d;
	static const auto GL_R32F                           = 0x822e;
	static const auto GL_RG16F                          = 0x822f;
	static const auto GL_RG32F                          = 0x8230;
	static const auto GL_R8I                            = 0x8231;
	static const auto GL_R8UI                           = 0x8232;
	static const auto GL_R16I                           = 0x8233;
	static const auto GL_R16UI                          = 0x8234;
	static const auto GL_R32I                           = 0x8235;
	static const auto GL_R32UI                          = 0x8236;
	static const auto GL_RG8I                           = 0x8237;
	static const auto GL_RG8UI                          = 0x8238;
	static const auto GL_RG16I                          = 0x8239;
	static const auto GL_RG16UI                         = 0x823a;
	static const auto GL_RG32I                          = 0x823b;
	static const auto GL_RG32UI                         = 0x823c;
}

version(GL_ARB_vertex_array_object) {
}
else {
	static const auto GL_VERTEX_ARRAY_BINDING           = 0x85B5;
}

version(GL_ARB_uniform_buffer_object) {
}
else {
	static const auto GL_UNIFORM_BUFFER                 = 0x8A11;
	static const auto GL_UNIFORM_BUFFER_BINDING         = 0x8A28;
	static const auto GL_UNIFORM_BUFFER_START           = 0x8A29;
	static const auto GL_UNIFORM_BUFFER_SIZE            = 0x8A2a;
	static const auto GL_MAX_VERTEX_UNIFORM_BLOCKS      = 0x8A2b;
	static const auto GL_MAX_GEOMETRY_UNIFORM_BLOCKS    = 0x8A2c;
	static const auto GL_MAX_FRAGMENT_UNIFORM_BLOCKS    = 0x8A2d;
	static const auto GL_MAX_COMBINED_UNIFORM_BLOCKS    = 0x8A2e;
	static const auto GL_MAX_UNIFORM_BUFFER_BINDINGS    = 0x8A2f;
	static const auto GL_MAX_UNIFORM_BLOCK_SIZE         = 0x8A30;
	static const auto GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31;
	static const auto GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = 0x8A32;
	static const auto GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33;
	static const auto GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34;
	static const auto GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = 0x8A35;
	static const auto GL_ACTIVE_UNIFORM_BLOCKS          = 0x8A36;
	static const auto GL_UNIFORM_TYPE                   = 0x8A37;
	static const auto GL_UNIFORM_SIZE                   = 0x8A38;
	static const auto GL_UNIFORM_NAME_LENGTH            = 0x8A39;
	static const auto GL_UNIFORM_BLOCK_INDEX            = 0x8A3a;
	static const auto GL_UNIFORM_OFFSET                 = 0x8A3b;
	static const auto GL_UNIFORM_ARRAY_STRIDE           = 0x8A3c;
	static const auto GL_UNIFORM_MATRIX_STRIDE          = 0x8A3d;
	static const auto GL_UNIFORM_IS_ROW_MAJOR           = 0x8A3e;
	static const auto GL_UNIFORM_BLOCK_BINDING          = 0x8A3f;
	static const auto GL_UNIFORM_BLOCK_DATA_SIZE        = 0x8A40;
	static const auto GL_UNIFORM_BLOCK_NAME_LENGTH      = 0x8A41;
	static const auto GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS  = 0x8A42;
	static const auto GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43;
	static const auto GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44;
	static const auto GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = 0x8A45;
	static const auto GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;
	static const auto GL_INVALID_INDEX                  = 0xFFFFFFFFu;
}

version(GL_ARB_compatibility) {
}
else {
/* ARB_compatibility just defines tokens from core 3.0 */
}

version(GL_ARB_copy_buffer) {
}
else {
	static const auto GL_COPY_READ_BUFFER               = 0x8F36;
	static const auto GL_COPY_WRITE_BUFFER              = 0x8F37;
}

version(GL_ARB_shader_texture_lod) {
}
else {
}

version(GL_ARB_depth_clamp) {
}
else {
	static const auto GL_DEPTH_CLAMP                    = 0x864f;
}

version(GL_ARB_draw_elements_base_vertex) {
}
else {
}

version(GL_ARB_fragment_coord_conventions) {
}
else {
}

version(GL_ARB_provoking_vertex) {
}
else {
	static const auto GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = 0x8E4c;
	static const auto GL_FIRST_VERTEX_CONVENTION        = 0x8E4d;
	static const auto GL_LAST_VERTEX_CONVENTION         = 0x8E4e;
	static const auto GL_PROVOKING_VERTEX               = 0x8E4f;
}

version(GL_ARB_seamless_cube_map) {
}
else {
	static const auto GL_TEXTURE_CUBE_MAP_SEAMLESS      = 0x884f;
}

version(GL_ARB_sync) {
}
else {
	static const auto GL_MAX_SERVER_WAIT_TIMEOUT        = 0x9111;
	static const auto GL_OBJECT_TYPE                    = 0x9112;
	static const auto GL_SYNC_CONDITION                 = 0x9113;
	static const auto GL_SYNC_STATUS                    = 0x9114;
	static const auto GL_SYNC_FLAGS                     = 0x9115;
	static const auto GL_SYNC_FENCE                     = 0x9116;
	static const auto GL_SYNC_GPU_COMMANDS_COMPLETE     = 0x9117;
	static const auto GL_UNSIGNALED                     = 0x9118;
	static const auto GL_SIGNALED                       = 0x9119;
	static const auto GL_ALREADY_SIGNALED               = 0x911a;
	static const auto GL_TIMEOUT_EXPIRED                = 0x911b;
	static const auto GL_CONDITION_SATISFIED            = 0x911c;
	static const auto GL_WAIT_FAILED                    = 0x911d;
	static const auto GL_SYNC_FLUSH_COMMANDS_BIT        = 0x00000001;
	static const auto GL_TIMEOUT_IGNORED                = 0xFFFFFFFFFFFFFFFF;
}

version(GL_ARB_texture_multisample) {
}
else {
	static const auto GL_SAMPLE_POSITION                = 0x8E50;
	static const auto GL_SAMPLE_MASK                    = 0x8E51;
	static const auto GL_SAMPLE_MASK_VALUE              = 0x8E52;
	static const auto GL_MAX_SAMPLE_MASK_WORDS          = 0x8E59;
	static const auto GL_TEXTURE_2D_MULTISAMPLE         = 0x9100;
	static const auto GL_PROXY_TEXTURE_2D_MULTISAMPLE   = 0x9101;
	static const auto GL_TEXTURE_2D_MULTISAMPLE_ARRAY   = 0x9102;
	static const auto GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = 0x9103;
	static const auto GL_TEXTURE_BINDING_2D_MULTISAMPLE = 0x9104;
	static const auto GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = 0x9105;
	static const auto GL_TEXTURE_SAMPLES                = 0x9106;
	static const auto GL_TEXTURE_FIXED_SAMPLE_LOCATIONS = 0x9107;
	static const auto GL_SAMPLER_2D_MULTISAMPLE         = 0x9108;
	static const auto GL_INT_SAMPLER_2D_MULTISAMPLE     = 0x9109;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = 0x910a;
	static const auto GL_SAMPLER_2D_MULTISAMPLE_ARRAY   = 0x910b;
	static const auto GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910c;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910d;
	static const auto GL_MAX_COLOR_TEXTURE_SAMPLES      = 0x910e;
	static const auto GL_MAX_DEPTH_TEXTURE_SAMPLES      = 0x910f;
	static const auto GL_MAX_INTEGER_SAMPLES            = 0x9110;
}

version(GL_ARB_vertex_array_bgra) {
}
else {
	/* reuse GL_BGRA */
}

version(GL_ARB_draw_buffers_blend) {
}
else {
}

version(GL_ARB_sample_shading) {
}
else {
	static const auto GL_SAMPLE_SHADING                 = 0x8C36;
	static const auto GL_MIN_SAMPLE_SHADING_VALUE       = 0x8C37;
}

version(GL_ARB_texture_cube_map_array) {
}
else {
	static const auto GL_TEXTURE_CUBE_MAP_ARRAY         = 0x9009;
	static const auto GL_TEXTURE_BINDING_CUBE_MAP_ARRAY = 0x900a;
	static const auto GL_PROXY_TEXTURE_CUBE_MAP_ARRAY   = 0x900b;
	static const auto GL_SAMPLER_CUBE_MAP_ARRAY         = 0x900c;
	static const auto GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW  = 0x900d;
	static const auto GL_INT_SAMPLER_CUBE_MAP_ARRAY     = 0x900e;
	static const auto GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY = 0x900f;
}

version(GL_ARB_texture_gather) {
}
else {
	static const auto GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET_ARB = 0x8E5e;
	static const auto GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET_ARB = 0x8E5f;
}

version(GL_ARB_texture_query_lod) {
}
else {
}

version(GL_ARB_shading_language_include) {
}
else {
	static const auto GL_SHADER_INCLUDE_ARB             = 0x8DAe;
	static const auto GL_NAMED_STRING_LENGTH_ARB        = 0x8DE9;
	static const auto GL_NAMED_STRING_TYPE_ARB          = 0x8DEa;
}

version(GL_ARB_texture_compression_bptc) {
}
else {
	static const auto GL_COMPRESSED_RGBA_BPTC_UNORM_ARB = 0x8E8c;
	static const auto GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM_ARB = 0x8E8d;
	static const auto GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT_ARB = 0x8E8e;
	static const auto GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_ARB = 0x8E8f;
}

version(GL_ARB_blend_func_extended) {
}
else {
	static const auto GL_SRC1_COLOR                     = 0x88F9;
	/* reuse GL_SRC1_ALPHA */
	static const auto GL_ONE_MINUS_SRC1_COLOR           = 0x88Fa;
	static const auto GL_ONE_MINUS_SRC1_ALPHA           = 0x88Fb;
	static const auto GL_MAX_DUAL_SOURCE_DRAW_BUFFERS   = 0x88Fc;
}

version(GL_ARB_explicit_attrib_location) {
}
else {
}

version(GL_ARB_occlusion_query2) {
}
else {
	static const auto GL_ANY_SAMPLES_PASSED             = 0x8C2f;
}

version(GL_ARB_sampler_objects) {
}
else {
	static const auto GL_SAMPLER_BINDING                = 0x8919;
}

version(GL_ARB_shader_bit_encoding) {
}
else {
}

version(GL_ARB_texture_rgb10_a2ui) {
}
else {
	static const auto GL_RGB10_A2UI                     = 0x906f;
}

version(GL_ARB_texture_swizzle) {
}
else {
	static const auto GL_TEXTURE_SWIZZLE_R              = 0x8E42;
	static const auto GL_TEXTURE_SWIZZLE_G              = 0x8E43;
	static const auto GL_TEXTURE_SWIZZLE_B              = 0x8E44;
	static const auto GL_TEXTURE_SWIZZLE_A              = 0x8E45;
	static const auto GL_TEXTURE_SWIZZLE_RGBA           = 0x8E46;
}

version(GL_ARB_timer_query) {
}
else {
	static const auto GL_TIME_ELAPSED                   = 0x88Bf;
	static const auto GL_TIMESTAMP                      = 0x8E28;
}

version(GL_ARB_vertex_type_2_10_10_10_rev) {
}
else {
	/* reuse GL_UNSIGNED_INT_2_10_10_10_REV */
	static const auto GL_INT_2_10_10_10_REV             = 0x8D9f;
}

version(GL_ARB_draw_indirect) {
}
else {
	static const auto GL_DRAW_INDIRECT_BUFFER           = 0x8F3f;
	static const auto GL_DRAW_INDIRECT_BUFFER_BINDING   = 0x8F43;
}

version(GL_ARB_gpu_shader5) {
}
else {
	static const auto GL_GEOMETRY_SHADER_INVOCATIONS    = 0x887f;
	static const auto GL_MAX_GEOMETRY_SHADER_INVOCATIONS = 0x8E5a;
	static const auto GL_MIN_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5b;
	static const auto GL_MAX_FRAGMENT_INTERPOLATION_OFFSET = 0x8E5c;
	static const auto GL_FRAGMENT_INTERPOLATION_OFFSET_BITS = 0x8E5d;
	static const auto GL_MAX_VERTEX_STREAMS             = 0x8E71;
}

version(GL_ARB_gpu_shader_fp64) {
}
else {
	/* reuse GL_DOUBLE */
	static const auto GL_DOUBLE_VEC2                    = 0x8FFc;
	static const auto GL_DOUBLE_VEC3                    = 0x8FFd;
	static const auto GL_DOUBLE_VEC4                    = 0x8FFe;
	static const auto GL_DOUBLE_MAT2                    = 0x8F46;
	static const auto GL_DOUBLE_MAT3                    = 0x8F47;
	static const auto GL_DOUBLE_MAT4                    = 0x8F48;
	static const auto GL_DOUBLE_MAT2x3                  = 0x8F49;
	static const auto GL_DOUBLE_MAT2x4                  = 0x8F4a;
	static const auto GL_DOUBLE_MAT3x2                  = 0x8F4b;
	static const auto GL_DOUBLE_MAT3x4                  = 0x8F4c;
	static const auto GL_DOUBLE_MAT4x2                  = 0x8F4d;
	static const auto GL_DOUBLE_MAT4x3                  = 0x8F4e;
}

version(GL_ARB_shader_subroutine) {
}
else {
	static const auto GL_ACTIVE_SUBROUTINES             = 0x8DE5;
	static const auto GL_ACTIVE_SUBROUTINE_UNIFORMS     = 0x8DE6;
	static const auto GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS = 0x8E47;
	static const auto GL_ACTIVE_SUBROUTINE_MAX_LENGTH   = 0x8E48;
	static const auto GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH = 0x8E49;
	static const auto GL_MAX_SUBROUTINES                = 0x8DE7;
	static const auto GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS = 0x8DE8;
	static const auto GL_NUM_COMPATIBLE_SUBROUTINES     = 0x8E4a;
	static const auto GL_COMPATIBLE_SUBROUTINES         = 0x8E4b;
	/* reuse GL_UNIFORM_SIZE */
	/* reuse GL_UNIFORM_NAME_LENGTH */
}

version(GL_ARB_tessellation_shader) {
}
else {
	static const auto GL_PATCHES                        = 0x000e;
	static const auto GL_PATCH_VERTICES                 = 0x8E72;
	static const auto GL_PATCH_DEFAULT_INNER_LEVEL      = 0x8E73;
	static const auto GL_PATCH_DEFAULT_OUTER_LEVEL      = 0x8E74;
	static const auto GL_TESS_CONTROL_OUTPUT_VERTICES   = 0x8E75;
	static const auto GL_TESS_GEN_MODE                  = 0x8E76;
	static const auto GL_TESS_GEN_SPACING               = 0x8E77;
	static const auto GL_TESS_GEN_VERTEX_ORDER          = 0x8E78;
	static const auto GL_TESS_GEN_POINT_MODE            = 0x8E79;
	/* reuse GL_TRIANGLES */
	/* reuse GL_QUADS */
	static const auto GL_ISOLINES                       = 0x8E7a;
	/* reuse GL_EQUAL */
	static const auto GL_FRACTIONAL_ODD                 = 0x8E7b;
	static const auto GL_FRACTIONAL_EVEN                = 0x8E7c;
	/* reuse GL_CCW */
	/* reuse GL_CW */
	static const auto GL_MAX_PATCH_VERTICES             = 0x8E7d;
	static const auto GL_MAX_TESS_GEN_LEVEL             = 0x8E7e;
	static const auto GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E7f;
	static const auto GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E80;
	static const auto GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS = 0x8E81;
	static const auto GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS = 0x8E82;
	static const auto GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS = 0x8E83;
	static const auto GL_MAX_TESS_PATCH_COMPONENTS      = 0x8E84;
	static const auto GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS = 0x8E85;
	static const auto GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS = 0x8E86;
	static const auto GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS = 0x8E89;
	static const auto GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS = 0x8E8a;
	static const auto GL_MAX_TESS_CONTROL_INPUT_COMPONENTS = 0x886c;
	static const auto GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS = 0x886d;
	static const auto GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS = 0x8E1e;
	static const auto GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS = 0x8E1f;
	static const auto GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER = 0x84F0;
	static const auto GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x84F1;
	static const auto GL_TESS_EVALUATION_SHADER         = 0x8E87;
	static const auto GL_TESS_CONTROL_SHADER            = 0x8E88;
}

version(GL_ARB_texture_buffer_object_rgb32) {
}
else {
	/* reuse GL_RGB32F */
	/* reuse GL_RGB32UI */
	/* reuse GL_RGB32I */
}

version(GL_ARB_transform_feedback2) {
}
else {
	static const auto GL_TRANSFORM_FEEDBACK             = 0x8E22;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED = 0x8E23;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE = 0x8E24;
	static const auto GL_TRANSFORM_FEEDBACK_BINDING     = 0x8E25;
}

version(GL_ARB_transform_feedback3) {
}
else {
	static const auto GL_MAX_TRANSFORM_FEEDBACK_BUFFERS = 0x8E70;
}

version(GL_EXT_abgr) {
}
else {
	static const auto GL_ABGR_EXT                       = 0x8000;
}

version(GL_EXT_blend_color) {
}
else {
	static const auto GL_CONSTANT_COLOR_EXT             = 0x8001;
	static const auto GL_ONE_MINUS_CONSTANT_COLOR_EXT   = 0x8002;
	static const auto GL_CONSTANT_ALPHA_EXT             = 0x8003;
	static const auto GL_ONE_MINUS_CONSTANT_ALPHA_EXT   = 0x8004;
	static const auto GL_BLEND_COLOR_EXT                = 0x8005;
}

version(GL_EXT_polygon_offset) {
}
else {
	static const auto GL_POLYGON_OFFSET_EXT             = 0x8037;
	static const auto GL_POLYGON_OFFSET_FACTOR_EXT      = 0x8038;
	static const auto GL_POLYGON_OFFSET_BIAS_EXT        = 0x8039;
}

version(GL_EXT_texture) {
}
else {
	static const auto GL_ALPHA4_EXT                     = 0x803b;
	static const auto GL_ALPHA8_EXT                     = 0x803c;
	static const auto GL_ALPHA12_EXT                    = 0x803d;
	static const auto GL_ALPHA16_EXT                    = 0x803e;
	static const auto GL_LUMINANCE4_EXT                 = 0x803f;
	static const auto GL_LUMINANCE8_EXT                 = 0x8040;
	static const auto GL_LUMINANCE12_EXT                = 0x8041;
	static const auto GL_LUMINANCE16_EXT                = 0x8042;
	static const auto GL_LUMINANCE4_ALPHA4_EXT          = 0x8043;
	static const auto GL_LUMINANCE6_ALPHA2_EXT          = 0x8044;
	static const auto GL_LUMINANCE8_ALPHA8_EXT          = 0x8045;
	static const auto GL_LUMINANCE12_ALPHA4_EXT         = 0x8046;
	static const auto GL_LUMINANCE12_ALPHA12_EXT        = 0x8047;
	static const auto GL_LUMINANCE16_ALPHA16_EXT        = 0x8048;
	static const auto GL_INTENSITY_EXT                  = 0x8049;
	static const auto GL_INTENSITY4_EXT                 = 0x804a;
	static const auto GL_INTENSITY8_EXT                 = 0x804b;
	static const auto GL_INTENSITY12_EXT                = 0x804c;
	static const auto GL_INTENSITY16_EXT                = 0x804d;
	static const auto GL_RGB2_EXT                       = 0x804e;
	static const auto GL_RGB4_EXT                       = 0x804f;
	static const auto GL_RGB5_EXT                       = 0x8050;
	static const auto GL_RGB8_EXT                       = 0x8051;
	static const auto GL_RGB10_EXT                      = 0x8052;
	static const auto GL_RGB12_EXT                      = 0x8053;
	static const auto GL_RGB16_EXT                      = 0x8054;
	static const auto GL_RGBA2_EXT                      = 0x8055;
	static const auto GL_RGBA4_EXT                      = 0x8056;
	static const auto GL_RGB5_A1_EXT                    = 0x8057;
	static const auto GL_RGBA8_EXT                      = 0x8058;
	static const auto GL_RGB10_A2_EXT                   = 0x8059;
	static const auto GL_RGBA12_EXT                     = 0x805a;
	static const auto GL_RGBA16_EXT                     = 0x805b;
	static const auto GL_TEXTURE_RED_SIZE_EXT           = 0x805c;
	static const auto GL_TEXTURE_GREEN_SIZE_EXT         = 0x805d;
	static const auto GL_TEXTURE_BLUE_SIZE_EXT          = 0x805e;
	static const auto GL_TEXTURE_ALPHA_SIZE_EXT         = 0x805f;
	static const auto GL_TEXTURE_LUMINANCE_SIZE_EXT     = 0x8060;
	static const auto GL_TEXTURE_INTENSITY_SIZE_EXT     = 0x8061;
	static const auto GL_REPLACE_EXT                    = 0x8062;
	static const auto GL_PROXY_TEXTURE_1D_EXT           = 0x8063;
	static const auto GL_PROXY_TEXTURE_2D_EXT           = 0x8064;
	static const auto GL_TEXTURE_TOO_LARGE_EXT          = 0x8065;
}

version(GL_EXT_texture3D) {
}
else {
	static const auto GL_PACK_SKIP_IMAGES_EXT           = 0x806b;
	static const auto GL_PACK_IMAGE_HEIGHT_EXT          = 0x806c;
	static const auto GL_UNPACK_SKIP_IMAGES_EXT         = 0x806d;
	static const auto GL_UNPACK_IMAGE_HEIGHT_EXT        = 0x806e;
	static const auto GL_TEXTURE_3D_EXT                 = 0x806f;
	static const auto GL_PROXY_TEXTURE_3D_EXT           = 0x8070;
	static const auto GL_TEXTURE_DEPTH_EXT              = 0x8071;
	static const auto GL_TEXTURE_WRAP_R_EXT             = 0x8072;
	static const auto GL_MAX_3D_TEXTURE_SIZE_EXT        = 0x8073;
}

version(GL_SGIS_texture_filter4) {
}
else {
	static const auto GL_FILTER4_SGIS                   = 0x8146;
	static const auto GL_TEXTURE_FILTER4_SIZE_SGIS      = 0x8147;
}

version(GL_EXT_subtexture) {
}
else {
}

version(GL_EXT_copy_texture) {
}
else {
}

version(GL_EXT_histogram) {
}
else {
	static const auto GL_HISTOGRAM_EXT                  = 0x8024;
	static const auto GL_PROXY_HISTOGRAM_EXT            = 0x8025;
	static const auto GL_HISTOGRAM_WIDTH_EXT            = 0x8026;
	static const auto GL_HISTOGRAM_FORMAT_EXT           = 0x8027;
	static const auto GL_HISTOGRAM_RED_SIZE_EXT         = 0x8028;
	static const auto GL_HISTOGRAM_GREEN_SIZE_EXT       = 0x8029;
	static const auto GL_HISTOGRAM_BLUE_SIZE_EXT        = 0x802a;
	static const auto GL_HISTOGRAM_ALPHA_SIZE_EXT       = 0x802b;
	static const auto GL_HISTOGRAM_LUMINANCE_SIZE_EXT   = 0x802c;
	static const auto GL_HISTOGRAM_SINK_EXT             = 0x802d;
	static const auto GL_MINMAX_EXT                     = 0x802e;
	static const auto GL_MINMAX_FORMAT_EXT              = 0x802f;
	static const auto GL_MINMAX_SINK_EXT                = 0x8030;
	static const auto GL_TABLE_TOO_LARGE_EXT            = 0x8031;
}

version(GL_EXT_convolution) {
}
else {
	static const auto GL_CONVOLUTION_1D_EXT             = 0x8010;
	static const auto GL_CONVOLUTION_2D_EXT             = 0x8011;
	static const auto GL_SEPARABLE_2D_EXT               = 0x8012;
	static const auto GL_CONVOLUTION_BORDER_MODE_EXT    = 0x8013;
	static const auto GL_CONVOLUTION_FILTER_SCALE_EXT   = 0x8014;
	static const auto GL_CONVOLUTION_FILTER_BIAS_EXT    = 0x8015;
	static const auto GL_REDUCE_EXT                     = 0x8016;
	static const auto GL_CONVOLUTION_FORMAT_EXT         = 0x8017;
	static const auto GL_CONVOLUTION_WIDTH_EXT          = 0x8018;
	static const auto GL_CONVOLUTION_HEIGHT_EXT         = 0x8019;
	static const auto GL_MAX_CONVOLUTION_WIDTH_EXT      = 0x801a;
	static const auto GL_MAX_CONVOLUTION_HEIGHT_EXT     = 0x801b;
	static const auto GL_POST_CONVOLUTION_RED_SCALE_EXT = 0x801c;
	static const auto GL_POST_CONVOLUTION_GREEN_SCALE_EXT = 0x801d;
	static const auto GL_POST_CONVOLUTION_BLUE_SCALE_EXT = 0x801e;
	static const auto GL_POST_CONVOLUTION_ALPHA_SCALE_EXT = 0x801f;
	static const auto GL_POST_CONVOLUTION_RED_BIAS_EXT  = 0x8020;
	static const auto GL_POST_CONVOLUTION_GREEN_BIAS_EXT = 0x8021;
	static const auto GL_POST_CONVOLUTION_BLUE_BIAS_EXT = 0x8022;
	static const auto GL_POST_CONVOLUTION_ALPHA_BIAS_EXT = 0x8023;
}

version(GL_SGI_color_matrix) {
}
else {
	static const auto GL_COLOR_MATRIX_SGI               = 0x80B1;
	static const auto GL_COLOR_MATRIX_STACK_DEPTH_SGI   = 0x80B2;
	static const auto GL_MAX_COLOR_MATRIX_STACK_DEPTH_SGI = 0x80B3;
	static const auto GL_POST_COLOR_MATRIX_RED_SCALE_SGI = 0x80B4;
	static const auto GL_POST_COLOR_MATRIX_GREEN_SCALE_SGI = 0x80B5;
	static const auto GL_POST_COLOR_MATRIX_BLUE_SCALE_SGI = 0x80B6;
	static const auto GL_POST_COLOR_MATRIX_ALPHA_SCALE_SGI = 0x80B7;
	static const auto GL_POST_COLOR_MATRIX_RED_BIAS_SGI = 0x80B8;
	static const auto GL_POST_COLOR_MATRIX_GREEN_BIAS_SGI = 0x80B9;
	static const auto GL_POST_COLOR_MATRIX_BLUE_BIAS_SGI = 0x80Ba;
	static const auto GL_POST_COLOR_MATRIX_ALPHA_BIAS_SGI = 0x80Bb;
}

version(GL_SGI_color_table) {
}
else {
	static const auto GL_COLOR_TABLE_SGI                = 0x80D0;
	static const auto GL_POST_CONVOLUTION_COLOR_TABLE_SGI = 0x80D1;
	static const auto GL_POST_COLOR_MATRIX_COLOR_TABLE_SGI = 0x80D2;
	static const auto GL_PROXY_COLOR_TABLE_SGI          = 0x80D3;
	static const auto GL_PROXY_POST_CONVOLUTION_COLOR_TABLE_SGI = 0x80D4;
	static const auto GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE_SGI = 0x80D5;
	static const auto GL_COLOR_TABLE_SCALE_SGI          = 0x80D6;
	static const auto GL_COLOR_TABLE_BIAS_SGI           = 0x80D7;
	static const auto GL_COLOR_TABLE_FORMAT_SGI         = 0x80D8;
	static const auto GL_COLOR_TABLE_WIDTH_SGI          = 0x80D9;
	static const auto GL_COLOR_TABLE_RED_SIZE_SGI       = 0x80Da;
	static const auto GL_COLOR_TABLE_GREEN_SIZE_SGI     = 0x80Db;
	static const auto GL_COLOR_TABLE_BLUE_SIZE_SGI      = 0x80Dc;
	static const auto GL_COLOR_TABLE_ALPHA_SIZE_SGI     = 0x80Dd;
	static const auto GL_COLOR_TABLE_LUMINANCE_SIZE_SGI = 0x80De;
	static const auto GL_COLOR_TABLE_INTENSITY_SIZE_SGI = 0x80Df;
}

version(GL_SGIS_pixel_texture) {
}
else {
	static const auto GL_PIXEL_TEXTURE_SGIS             = 0x8353;
	static const auto GL_PIXEL_FRAGMENT_RGB_SOURCE_SGIS = 0x8354;
	static const auto GL_PIXEL_FRAGMENT_ALPHA_SOURCE_SGIS = 0x8355;
	static const auto GL_PIXEL_GROUP_COLOR_SGIS         = 0x8356;
}

version(GL_SGIX_pixel_texture) {
}
else {
	static const auto GL_PIXEL_TEX_GEN_SGIX             = 0x8139;
	static const auto GL_PIXEL_TEX_GEN_MODE_SGIX        = 0x832b;
}

version(GL_SGIS_texture4D) {
}
else {
	static const auto GL_PACK_SKIP_VOLUMES_SGIS         = 0x8130;
	static const auto GL_PACK_IMAGE_DEPTH_SGIS          = 0x8131;
	static const auto GL_UNPACK_SKIP_VOLUMES_SGIS       = 0x8132;
	static const auto GL_UNPACK_IMAGE_DEPTH_SGIS        = 0x8133;
	static const auto GL_TEXTURE_4D_SGIS                = 0x8134;
	static const auto GL_PROXY_TEXTURE_4D_SGIS          = 0x8135;
	static const auto GL_TEXTURE_4DSIZE_SGIS            = 0x8136;
	static const auto GL_TEXTURE_WRAP_Q_SGIS            = 0x8137;
	static const auto GL_MAX_4D_TEXTURE_SIZE_SGIS       = 0x8138;
	static const auto GL_TEXTURE_4D_BINDING_SGIS        = 0x814f;
}

version(GL_SGI_texture_color_table) {
}
else {
	static const auto GL_TEXTURE_COLOR_TABLE_SGI        = 0x80Bc;
	static const auto GL_PROXY_TEXTURE_COLOR_TABLE_SGI  = 0x80Bd;
}

version(GL_EXT_cmyka) {
}
else {
	static const auto GL_CMYK_EXT                       = 0x800c;
	static const auto GL_CMYKA_EXT                      = 0x800d;
	static const auto GL_PACK_CMYK_HINT_EXT             = 0x800e;
	static const auto GL_UNPACK_CMYK_HINT_EXT           = 0x800f;
}

version(GL_EXT_texture_object) {
}
else {
	static const auto GL_TEXTURE_PRIORITY_EXT           = 0x8066;
	static const auto GL_TEXTURE_RESIDENT_EXT           = 0x8067;
	static const auto GL_TEXTURE_1D_BINDING_EXT         = 0x8068;
	static const auto GL_TEXTURE_2D_BINDING_EXT         = 0x8069;
	static const auto GL_TEXTURE_3D_BINDING_EXT         = 0x806a;
}

version(GL_SGIS_detail_texture) {
}
else {
	static const auto GL_DETAIL_TEXTURE_2D_SGIS         = 0x8095;
	static const auto GL_DETAIL_TEXTURE_2D_BINDING_SGIS = 0x8096;
	static const auto GL_LINEAR_DETAIL_SGIS             = 0x8097;
	static const auto GL_LINEAR_DETAIL_ALPHA_SGIS       = 0x8098;
	static const auto GL_LINEAR_DETAIL_COLOR_SGIS       = 0x8099;
	static const auto GL_DETAIL_TEXTURE_LEVEL_SGIS      = 0x809a;
	static const auto GL_DETAIL_TEXTURE_MODE_SGIS       = 0x809b;
	static const auto GL_DETAIL_TEXTURE_FUNC_POINTS_SGIS = 0x809c;
}

version(GL_SGIS_sharpen_texture) {
}
else {
	static const auto GL_LINEAR_SHARPEN_SGIS            = 0x80Ad;
	static const auto GL_LINEAR_SHARPEN_ALPHA_SGIS      = 0x80Ae;
	static const auto GL_LINEAR_SHARPEN_COLOR_SGIS      = 0x80Af;
	static const auto GL_SHARPEN_TEXTURE_FUNC_POINTS_SGIS = 0x80B0;
}

version(GL_EXT_packed_pixels) {
}
else {
	static const auto GL_UNSIGNED_BYTE_3_3_2_EXT        = 0x8032;
	static const auto GL_UNSIGNED_SHORT_4_4_4_4_EXT     = 0x8033;
	static const auto GL_UNSIGNED_SHORT_5_5_5_1_EXT     = 0x8034;
	static const auto GL_UNSIGNED_INT_8_8_8_8_EXT       = 0x8035;
	static const auto GL_UNSIGNED_INT_10_10_10_2_EXT    = 0x8036;
}

version(GL_SGIS_texture_lod) {
}
else {
	static const auto GL_TEXTURE_MIN_LOD_SGIS           = 0x813a;
	static const auto GL_TEXTURE_MAX_LOD_SGIS           = 0x813b;
	static const auto GL_TEXTURE_BASE_LEVEL_SGIS        = 0x813c;
	static const auto GL_TEXTURE_MAX_LEVEL_SGIS         = 0x813d;
}

version(GL_SGIS_multisample) {
}
else {
	static const auto GL_MULTISAMPLE_SGIS               = 0x809d;
	static const auto GL_SAMPLE_ALPHA_TO_MASK_SGIS      = 0x809e;
	static const auto GL_SAMPLE_ALPHA_TO_ONE_SGIS       = 0x809f;
	static const auto GL_SAMPLE_MASK_SGIS               = 0x80A0;
	static const auto GL_1PASS_SGIS                     = 0x80A1;
	static const auto GL_2PASS_0_SGIS                   = 0x80A2;
	static const auto GL_2PASS_1_SGIS                   = 0x80A3;
	static const auto GL_4PASS_0_SGIS                   = 0x80A4;
	static const auto GL_4PASS_1_SGIS                   = 0x80A5;
	static const auto GL_4PASS_2_SGIS                   = 0x80A6;
	static const auto GL_4PASS_3_SGIS                   = 0x80A7;
	static const auto GL_SAMPLE_BUFFERS_SGIS            = 0x80A8;
	static const auto GL_SAMPLES_SGIS                   = 0x80A9;
	static const auto GL_SAMPLE_MASK_VALUE_SGIS         = 0x80Aa;
	static const auto GL_SAMPLE_MASK_INVERT_SGIS        = 0x80Ab;
	static const auto GL_SAMPLE_PATTERN_SGIS            = 0x80Ac;
}

version(GL_EXT_rescale_normal) {
}
else {
	static const auto GL_RESCALE_NORMAL_EXT             = 0x803a;
}

version(GL_EXT_vertex_array) {
}
else {
	static const auto GL_VERTEX_ARRAY_EXT               = 0x8074;
	static const auto GL_NORMAL_ARRAY_EXT               = 0x8075;
	static const auto GL_COLOR_ARRAY_EXT                = 0x8076;
	static const auto GL_INDEX_ARRAY_EXT                = 0x8077;
	static const auto GL_TEXTURE_COORD_ARRAY_EXT        = 0x8078;
	static const auto GL_EDGE_FLAG_ARRAY_EXT            = 0x8079;
	static const auto GL_VERTEX_ARRAY_SIZE_EXT          = 0x807a;
	static const auto GL_VERTEX_ARRAY_TYPE_EXT          = 0x807b;
	static const auto GL_VERTEX_ARRAY_STRIDE_EXT        = 0x807c;
	static const auto GL_VERTEX_ARRAY_COUNT_EXT         = 0x807d;
	static const auto GL_NORMAL_ARRAY_TYPE_EXT          = 0x807e;
	static const auto GL_NORMAL_ARRAY_STRIDE_EXT        = 0x807f;
	static const auto GL_NORMAL_ARRAY_COUNT_EXT         = 0x8080;
	static const auto GL_COLOR_ARRAY_SIZE_EXT           = 0x8081;
	static const auto GL_COLOR_ARRAY_TYPE_EXT           = 0x8082;
	static const auto GL_COLOR_ARRAY_STRIDE_EXT         = 0x8083;
	static const auto GL_COLOR_ARRAY_COUNT_EXT          = 0x8084;
	static const auto GL_INDEX_ARRAY_TYPE_EXT           = 0x8085;
	static const auto GL_INDEX_ARRAY_STRIDE_EXT         = 0x8086;
	static const auto GL_INDEX_ARRAY_COUNT_EXT          = 0x8087;
	static const auto GL_TEXTURE_COORD_ARRAY_SIZE_EXT   = 0x8088;
	static const auto GL_TEXTURE_COORD_ARRAY_TYPE_EXT   = 0x8089;
	static const auto GL_TEXTURE_COORD_ARRAY_STRIDE_EXT = 0x808a;
	static const auto GL_TEXTURE_COORD_ARRAY_COUNT_EXT  = 0x808b;
	static const auto GL_EDGE_FLAG_ARRAY_STRIDE_EXT     = 0x808c;
	static const auto GL_EDGE_FLAG_ARRAY_COUNT_EXT      = 0x808d;
	static const auto GL_VERTEX_ARRAY_POINTER_EXT       = 0x808e;
	static const auto GL_NORMAL_ARRAY_POINTER_EXT       = 0x808f;
	static const auto GL_COLOR_ARRAY_POINTER_EXT        = 0x8090;
	static const auto GL_INDEX_ARRAY_POINTER_EXT        = 0x8091;
	static const auto GL_TEXTURE_COORD_ARRAY_POINTER_EXT = 0x8092;
	static const auto GL_EDGE_FLAG_ARRAY_POINTER_EXT    = 0x8093;
}

version(GL_EXT_misc_attribute) {
}
else {
}

version(GL_SGIS_generate_mipmap) {
}
else {
	static const auto GL_GENERATE_MIPMAP_SGIS           = 0x8191;
	static const auto GL_GENERATE_MIPMAP_HINT_SGIS      = 0x8192;
}

version(GL_SGIX_clipmap) {
}
else {
	static const auto GL_LINEAR_CLIPMAP_LINEAR_SGIX     = 0x8170;
	static const auto GL_TEXTURE_CLIPMAP_CENTER_SGIX    = 0x8171;
	static const auto GL_TEXTURE_CLIPMAP_FRAME_SGIX     = 0x8172;
	static const auto GL_TEXTURE_CLIPMAP_OFFSET_SGIX    = 0x8173;
	static const auto GL_TEXTURE_CLIPMAP_VIRTUAL_DEPTH_SGIX = 0x8174;
	static const auto GL_TEXTURE_CLIPMAP_LOD_OFFSET_SGIX = 0x8175;
	static const auto GL_TEXTURE_CLIPMAP_DEPTH_SGIX     = 0x8176;
	static const auto GL_MAX_CLIPMAP_DEPTH_SGIX         = 0x8177;
	static const auto GL_MAX_CLIPMAP_VIRTUAL_DEPTH_SGIX = 0x8178;
	static const auto GL_NEAREST_CLIPMAP_NEAREST_SGIX   = 0x844d;
	static const auto GL_NEAREST_CLIPMAP_LINEAR_SGIX    = 0x844e;
	static const auto GL_LINEAR_CLIPMAP_NEAREST_SGIX    = 0x844f;
}

version(GL_SGIX_shadow) {
}
else {
	static const auto GL_TEXTURE_COMPARE_SGIX           = 0x819a;
	static const auto GL_TEXTURE_COMPARE_OPERATOR_SGIX  = 0x819b;
	static const auto GL_TEXTURE_LEQUAL_R_SGIX          = 0x819c;
	static const auto GL_TEXTURE_GEQUAL_R_SGIX          = 0x819d;
}

version(GL_SGIS_texture_edge_clamp) {
}
else {
	static const auto GL_CLAMP_TO_EDGE_SGIS             = 0x812f;
}

version(GL_SGIS_texture_border_clamp) {
}
else {
	static const auto GL_CLAMP_TO_BORDER_SGIS           = 0x812d;
}

version(GL_EXT_blend_minmax) {
}
else {
	static const auto GL_FUNC_ADD_EXT                   = 0x8006;
	static const auto GL_MIN_EXT                        = 0x8007;
	static const auto GL_MAX_EXT                        = 0x8008;
	static const auto GL_BLEND_EQUATION_EXT             = 0x8009;
}

version(GL_EXT_blend_subtract) {
}
else {
	static const auto GL_FUNC_SUBTRACT_EXT              = 0x800a;
	static const auto GL_FUNC_REVERSE_SUBTRACT_EXT      = 0x800b;
}

version(GL_EXT_blend_logic_op) {
}
else {
}

version(GL_SGIX_interlace) {
}
else {
	static const auto GL_INTERLACE_SGIX                 = 0x8094;
}

version(GL_SGIX_pixel_tiles) {
}
else {
	static const auto GL_PIXEL_TILE_BEST_ALIGNMENT_SGIX = 0x813e;
	static const auto GL_PIXEL_TILE_CACHE_INCREMENT_SGIX = 0x813f;
	static const auto GL_PIXEL_TILE_WIDTH_SGIX          = 0x8140;
	static const auto GL_PIXEL_TILE_HEIGHT_SGIX         = 0x8141;
	static const auto GL_PIXEL_TILE_GRID_WIDTH_SGIX     = 0x8142;
	static const auto GL_PIXEL_TILE_GRID_HEIGHT_SGIX    = 0x8143;
	static const auto GL_PIXEL_TILE_GRID_DEPTH_SGIX     = 0x8144;
	static const auto GL_PIXEL_TILE_CACHE_SIZE_SGIX     = 0x8145;
}

version(GL_SGIS_texture_select) {
}
else {
	static const auto GL_DUAL_ALPHA4_SGIS               = 0x8110;
	static const auto GL_DUAL_ALPHA8_SGIS               = 0x8111;
	static const auto GL_DUAL_ALPHA12_SGIS              = 0x8112;
	static const auto GL_DUAL_ALPHA16_SGIS              = 0x8113;
	static const auto GL_DUAL_LUMINANCE4_SGIS           = 0x8114;
	static const auto GL_DUAL_LUMINANCE8_SGIS           = 0x8115;
	static const auto GL_DUAL_LUMINANCE12_SGIS          = 0x8116;
	static const auto GL_DUAL_LUMINANCE16_SGIS          = 0x8117;
	static const auto GL_DUAL_INTENSITY4_SGIS           = 0x8118;
	static const auto GL_DUAL_INTENSITY8_SGIS           = 0x8119;
	static const auto GL_DUAL_INTENSITY12_SGIS          = 0x811a;
	static const auto GL_DUAL_INTENSITY16_SGIS          = 0x811b;
	static const auto GL_DUAL_LUMINANCE_ALPHA4_SGIS     = 0x811c;
	static const auto GL_DUAL_LUMINANCE_ALPHA8_SGIS     = 0x811d;
	static const auto GL_QUAD_ALPHA4_SGIS               = 0x811e;
	static const auto GL_QUAD_ALPHA8_SGIS               = 0x811f;
	static const auto GL_QUAD_LUMINANCE4_SGIS           = 0x8120;
	static const auto GL_QUAD_LUMINANCE8_SGIS           = 0x8121;
	static const auto GL_QUAD_INTENSITY4_SGIS           = 0x8122;
	static const auto GL_QUAD_INTENSITY8_SGIS           = 0x8123;
	static const auto GL_DUAL_TEXTURE_SELECT_SGIS       = 0x8124;
	static const auto GL_QUAD_TEXTURE_SELECT_SGIS       = 0x8125;
}

version(GL_SGIX_sprite) {
}
else {
	static const auto GL_SPRITE_SGIX                    = 0x8148;
	static const auto GL_SPRITE_MODE_SGIX               = 0x8149;
	static const auto GL_SPRITE_AXIS_SGIX               = 0x814a;
	static const auto GL_SPRITE_TRANSLATION_SGIX        = 0x814b;
	static const auto GL_SPRITE_AXIAL_SGIX              = 0x814c;
	static const auto GL_SPRITE_OBJECT_ALIGNED_SGIX     = 0x814d;
	static const auto GL_SPRITE_EYE_ALIGNED_SGIX        = 0x814e;
}

version(GL_SGIX_texture_multi_buffer) {
}
else {
	static const auto GL_TEXTURE_MULTI_BUFFER_HINT_SGIX = 0x812e;
}

version(GL_EXT_point_parameters) {
}
else {
	static const auto GL_POINT_SIZE_MIN_EXT             = 0x8126;
	static const auto GL_POINT_SIZE_MAX_EXT             = 0x8127;
	static const auto GL_POINT_FADE_THRESHOLD_SIZE_EXT  = 0x8128;
	static const auto GL_DISTANCE_ATTENUATION_EXT       = 0x8129;
}

version(GL_SGIS_point_parameters) {
}
else {
	static const auto GL_POINT_SIZE_MIN_SGIS            = 0x8126;
	static const auto GL_POINT_SIZE_MAX_SGIS            = 0x8127;
	static const auto GL_POINT_FADE_THRESHOLD_SIZE_SGIS = 0x8128;
	static const auto GL_DISTANCE_ATTENUATION_SGIS      = 0x8129;
}

version(GL_SGIX_instruments) {
}
else {
	static const auto GL_INSTRUMENT_BUFFER_POINTER_SGIX = 0x8180;
	static const auto GL_INSTRUMENT_MEASUREMENTS_SGIX   = 0x8181;
}

version(GL_SGIX_texture_scale_bias) {
}
else {
	static const auto GL_POST_TEXTURE_FILTER_BIAS_SGIX  = 0x8179;
	static const auto GL_POST_TEXTURE_FILTER_SCALE_SGIX = 0x817a;
	static const auto GL_POST_TEXTURE_FILTER_BIAS_RANGE_SGIX = 0x817b;
	static const auto GL_POST_TEXTURE_FILTER_SCALE_RANGE_SGIX = 0x817c;
}

version(GL_SGIX_framezoom) {
}
else {
	static const auto GL_FRAMEZOOM_SGIX                 = 0x818b;
	static const auto GL_FRAMEZOOM_FACTOR_SGIX          = 0x818c;
	static const auto GL_MAX_FRAMEZOOM_FACTOR_SGIX      = 0x818d;
}

version(GL_SGIX_tag_sample_buffer) {
}
else {
}

version(GL_FfdMaskSGIX) {
}
else {
	static const auto GL_TEXTURE_DEFORMATION_BIT_SGIX   = 0x00000001;
	static const auto GL_GEOMETRY_DEFORMATION_BIT_SGIX  = 0x00000002;
}

version(GL_SGIX_polynomial_ffd) {
}
else {
	static const auto GL_GEOMETRY_DEFORMATION_SGIX      = 0x8194;
	static const auto GL_TEXTURE_DEFORMATION_SGIX       = 0x8195;
	static const auto GL_DEFORMATIONS_MASK_SGIX         = 0x8196;
	static const auto GL_MAX_DEFORMATION_ORDER_SGIX     = 0x8197;
}

version(GL_SGIX_reference_plane) {
}
else {
	static const auto GL_REFERENCE_PLANE_SGIX           = 0x817d;
	static const auto GL_REFERENCE_PLANE_EQUATION_SGIX  = 0x817e;
}

version(GL_SGIX_flush_raster) {
}
else {
}

version(GL_SGIX_depth_texture) {
}
else {
	static const auto GL_DEPTH_COMPONENT16_SGIX         = 0x81A5;
	static const auto GL_DEPTH_COMPONENT24_SGIX         = 0x81A6;
	static const auto GL_DEPTH_COMPONENT32_SGIX         = 0x81A7;
}

version(GL_SGIS_fog_function) {
}
else {
	static const auto GL_FOG_FUNC_SGIS                  = 0x812a;
	static const auto GL_FOG_FUNC_POINTS_SGIS           = 0x812b;
	static const auto GL_MAX_FOG_FUNC_POINTS_SGIS       = 0x812c;
}

version(GL_SGIX_fog_offset) {
}
else {
	static const auto GL_FOG_OFFSET_SGIX                = 0x8198;
	static const auto GL_FOG_OFFSET_VALUE_SGIX          = 0x8199;
}

version(GL_HP_image_transform) {
}
else {
	static const auto GL_IMAGE_SCALE_X_HP               = 0x8155;
	static const auto GL_IMAGE_SCALE_Y_HP               = 0x8156;
	static const auto GL_IMAGE_TRANSLATE_X_HP           = 0x8157;
	static const auto GL_IMAGE_TRANSLATE_Y_HP           = 0x8158;
	static const auto GL_IMAGE_ROTATE_ANGLE_HP          = 0x8159;
	static const auto GL_IMAGE_ROTATE_ORIGIN_X_HP       = 0x815a;
	static const auto GL_IMAGE_ROTATE_ORIGIN_Y_HP       = 0x815b;
	static const auto GL_IMAGE_MAG_FILTER_HP            = 0x815c;
	static const auto GL_IMAGE_MIN_FILTER_HP            = 0x815d;
	static const auto GL_IMAGE_CUBIC_WEIGHT_HP          = 0x815e;
	static const auto GL_CUBIC_HP                       = 0x815f;
	static const auto GL_AVERAGE_HP                     = 0x8160;
	static const auto GL_IMAGE_TRANSFORM_2D_HP          = 0x8161;
	static const auto GL_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP = 0x8162;
	static const auto GL_PROXY_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP = 0x8163;
}

version(GL_HP_convolution_border_modes) {
}
else {
	static const auto GL_IGNORE_BORDER_HP               = 0x8150;
	static const auto GL_CONSTANT_BORDER_HP             = 0x8151;
	static const auto GL_REPLICATE_BORDER_HP            = 0x8153;
	static const auto GL_CONVOLUTION_BORDER_COLOR_HP    = 0x8154;
}

version(GL_INGR_palette_buffer) {
}
else {
}

version(GL_SGIX_texture_add_env) {
}
else {
	static const auto GL_TEXTURE_ENV_BIAS_SGIX          = 0x80Be;
}

version(GL_EXT_color_subtable) {
}
else {
}

version(GL_PGI_vertex_hints) {
}
else {
	static const auto GL_VERTEX_DATA_HINT_PGI           = 0x1A22a;
	static const auto GL_VERTEX_CONSISTENT_HINT_PGI     = 0x1A22b;
	static const auto GL_MATERIAL_SIDE_HINT_PGI         = 0x1A22c;
	static const auto GL_MAX_VERTEX_HINT_PGI            = 0x1A22d;
	static const auto GL_COLOR3_BIT_PGI                 = 0x00010000;
	static const auto GL_COLOR4_BIT_PGI                 = 0x00020000;
	static const auto GL_EDGEFLAG_BIT_PGI               = 0x00040000;
	static const auto GL_INDEX_BIT_PGI                  = 0x00080000;
	static const auto GL_MAT_AMBIENT_BIT_PGI            = 0x00100000;
	static const auto GL_MAT_AMBIENT_AND_DIFFUSE_BIT_PGI = 0x00200000;
	static const auto GL_MAT_DIFFUSE_BIT_PGI            = 0x00400000;
	static const auto GL_MAT_EMISSION_BIT_PGI           = 0x00800000;
	static const auto GL_MAT_COLOR_INDEXES_BIT_PGI      = 0x01000000;
	static const auto GL_MAT_SHININESS_BIT_PGI          = 0x02000000;
	static const auto GL_MAT_SPECULAR_BIT_PGI           = 0x04000000;
	static const auto GL_NORMAL_BIT_PGI                 = 0x08000000;
	static const auto GL_TEXCOORD1_BIT_PGI              = 0x10000000;
	static const auto GL_TEXCOORD2_BIT_PGI              = 0x20000000;
	static const auto GL_TEXCOORD3_BIT_PGI              = 0x40000000;
	static const auto GL_TEXCOORD4_BIT_PGI              = 0x80000000;
	static const auto GL_VERTEX23_BIT_PGI               = 0x00000004;
	static const auto GL_VERTEX4_BIT_PGI                = 0x00000008;
}

version(GL_PGI_misc_hints) {
}
else {
	static const auto GL_PREFER_DOUBLEBUFFER_HINT_PGI   = 0x1A1F8;
	static const auto GL_CONSERVE_MEMORY_HINT_PGI       = 0x1A1Fd;
	static const auto GL_RECLAIM_MEMORY_HINT_PGI        = 0x1A1Fe;
	static const auto GL_NATIVE_GRAPHICS_HANDLE_PGI     = 0x1A202;
	static const auto GL_NATIVE_GRAPHICS_BEGIN_HINT_PGI = 0x1A203;
	static const auto GL_NATIVE_GRAPHICS_END_HINT_PGI   = 0x1A204;
	static const auto GL_ALWAYS_FAST_HINT_PGI           = 0x1A20c;
	static const auto GL_ALWAYS_SOFT_HINT_PGI           = 0x1A20d;
	static const auto GL_ALLOW_DRAW_OBJ_HINT_PGI        = 0x1A20e;
	static const auto GL_ALLOW_DRAW_WIN_HINT_PGI        = 0x1A20f;
	static const auto GL_ALLOW_DRAW_FRG_HINT_PGI        = 0x1A210;
	static const auto GL_ALLOW_DRAW_MEM_HINT_PGI        = 0x1A211;
	static const auto GL_STRICT_DEPTHFUNC_HINT_PGI      = 0x1A216;
	static const auto GL_STRICT_LIGHTING_HINT_PGI       = 0x1A217;
	static const auto GL_STRICT_SCISSOR_HINT_PGI        = 0x1A218;
	static const auto GL_FULL_STIPPLE_HINT_PGI          = 0x1A219;
	static const auto GL_CLIP_NEAR_HINT_PGI             = 0x1A220;
	static const auto GL_CLIP_FAR_HINT_PGI              = 0x1A221;
	static const auto GL_WIDE_LINE_HINT_PGI             = 0x1A222;
	static const auto GL_BACK_NORMALS_HINT_PGI          = 0x1A223;
}

version(GL_EXT_paletted_texture) {
}
else {
	static const auto GL_COLOR_INDEX1_EXT               = 0x80E2;
	static const auto GL_COLOR_INDEX2_EXT               = 0x80E3;
	static const auto GL_COLOR_INDEX4_EXT               = 0x80E4;
	static const auto GL_COLOR_INDEX8_EXT               = 0x80E5;
	static const auto GL_COLOR_INDEX12_EXT              = 0x80E6;
	static const auto GL_COLOR_INDEX16_EXT              = 0x80E7;
	static const auto GL_TEXTURE_INDEX_SIZE_EXT         = 0x80Ed;
}

version(GL_EXT_clip_volume_hint) {
}
else {
	static const auto GL_CLIP_VOLUME_CLIPPING_HINT_EXT  = 0x80F0;
}

version(GL_SGIX_list_priority) {
}
else {
	static const auto GL_LIST_PRIORITY_SGIX             = 0x8182;
}

version(GL_SGIX_ir_instrument1) {
}
else {
	static const auto GL_IR_INSTRUMENT1_SGIX            = 0x817f;
}

version(GL_SGIX_calligraphic_fragment) {
}
else {
	static const auto GL_CALLIGRAPHIC_FRAGMENT_SGIX     = 0x8183;
}

version(GL_SGIX_texture_lod_bias) {
}
else {
	static const auto GL_TEXTURE_LOD_BIAS_S_SGIX        = 0x818e;
	static const auto GL_TEXTURE_LOD_BIAS_T_SGIX        = 0x818f;
	static const auto GL_TEXTURE_LOD_BIAS_R_SGIX        = 0x8190;
}

version(GL_SGIX_shadow_ambient) {
}
else {
	static const auto GL_SHADOW_AMBIENT_SGIX            = 0x80Bf;
}

version(GL_EXT_index_texture) {
}
else {
}

version(GL_EXT_index_material) {
}
else {
	static const auto GL_INDEX_MATERIAL_EXT             = 0x81B8;
	static const auto GL_INDEX_MATERIAL_PARAMETER_EXT   = 0x81B9;
	static const auto GL_INDEX_MATERIAL_FACE_EXT        = 0x81Ba;
}

version(GL_EXT_index_func) {
}
else {
	static const auto GL_INDEX_TEST_EXT                 = 0x81B5;
	static const auto GL_INDEX_TEST_FUNC_EXT            = 0x81B6;
	static const auto GL_INDEX_TEST_REF_EXT             = 0x81B7;
}

version(GL_EXT_index_array_formats) {
}
else {
	static const auto GL_IUI_V2F_EXT                    = 0x81Ad;
	static const auto GL_IUI_V3F_EXT                    = 0x81Ae;
	static const auto GL_IUI_N3F_V2F_EXT                = 0x81Af;
	static const auto GL_IUI_N3F_V3F_EXT                = 0x81B0;
	static const auto GL_T2F_IUI_V2F_EXT                = 0x81B1;
	static const auto GL_T2F_IUI_V3F_EXT                = 0x81B2;
	static const auto GL_T2F_IUI_N3F_V2F_EXT            = 0x81B3;
	static const auto GL_T2F_IUI_N3F_V3F_EXT            = 0x81B4;
}

version(GL_EXT_compiled_vertex_array) {
}
else {
	static const auto GL_ARRAY_ELEMENT_LOCK_FIRST_EXT   = 0x81A8;
	static const auto GL_ARRAY_ELEMENT_LOCK_COUNT_EXT   = 0x81A9;
}

version(GL_EXT_cull_vertex) {
}
else {
	static const auto GL_CULL_VERTEX_EXT                = 0x81Aa;
	static const auto GL_CULL_VERTEX_EYE_POSITION_EXT   = 0x81Ab;
	static const auto GL_CULL_VERTEX_OBJECT_POSITION_EXT = 0x81Ac;
}

version(GL_SGIX_ycrcb) {
}
else {
	static const auto GL_YCRCB_422_SGIX                 = 0x81Bb;
	static const auto GL_YCRCB_444_SGIX                 = 0x81Bc;
}

version(GL_SGIX_fragment_lighting) {
}
else {
	static const auto GL_FRAGMENT_LIGHTING_SGIX         = 0x8400;
	static const auto GL_FRAGMENT_COLOR_MATERIAL_SGIX   = 0x8401;
	static const auto GL_FRAGMENT_COLOR_MATERIAL_FACE_SGIX = 0x8402;
	static const auto GL_FRAGMENT_COLOR_MATERIAL_PARAMETER_SGIX = 0x8403;
	static const auto GL_MAX_FRAGMENT_LIGHTS_SGIX       = 0x8404;
	static const auto GL_MAX_ACTIVE_LIGHTS_SGIX         = 0x8405;
	static const auto GL_CURRENT_RASTER_NORMAL_SGIX     = 0x8406;
	static const auto GL_LIGHT_ENV_MODE_SGIX            = 0x8407;
	static const auto GL_FRAGMENT_LIGHT_MODEL_LOCAL_VIEWER_SGIX = 0x8408;
	static const auto GL_FRAGMENT_LIGHT_MODEL_TWO_SIDE_SGIX = 0x8409;
	static const auto GL_FRAGMENT_LIGHT_MODEL_AMBIENT_SGIX = 0x840a;
	static const auto GL_FRAGMENT_LIGHT_MODEL_NORMAL_INTERPOLATION_SGIX = 0x840b;
	static const auto GL_FRAGMENT_LIGHT0_SGIX           = 0x840c;
	static const auto GL_FRAGMENT_LIGHT1_SGIX           = 0x840d;
	static const auto GL_FRAGMENT_LIGHT2_SGIX           = 0x840e;
	static const auto GL_FRAGMENT_LIGHT3_SGIX           = 0x840f;
	static const auto GL_FRAGMENT_LIGHT4_SGIX           = 0x8410;
	static const auto GL_FRAGMENT_LIGHT5_SGIX           = 0x8411;
	static const auto GL_FRAGMENT_LIGHT6_SGIX           = 0x8412;
	static const auto GL_FRAGMENT_LIGHT7_SGIX           = 0x8413;
}

version(GL_IBM_rasterpos_clip) {
}
else {
	static const auto GL_RASTER_POSITION_UNCLIPPED_IBM  = 0x19262;
}

version(GL_HP_texture_lighting) {
}
else {
	static const auto GL_TEXTURE_LIGHTING_MODE_HP       = 0x8167;
	static const auto GL_TEXTURE_POST_SPECULAR_HP       = 0x8168;
	static const auto GL_TEXTURE_PRE_SPECULAR_HP        = 0x8169;
}

version(GL_EXT_draw_range_elements) {
}
else {
	static const auto GL_MAX_ELEMENTS_VERTICES_EXT      = 0x80E8;
	static const auto GL_MAX_ELEMENTS_INDICES_EXT       = 0x80E9;
}

version(GL_WIN_phong_shading) {
}
else {
	static const auto GL_PHONG_WIN                      = 0x80Ea;
	static const auto GL_PHONG_HINT_WIN                 = 0x80Eb;
}

version(GL_WIN_specular_fog) {
}
else {
	static const auto GL_FOG_SPECULAR_TEXTURE_WIN       = 0x80Ec;
}

version(GL_EXT_light_texture) {
}
else {
	static const auto GL_FRAGMENT_MATERIAL_EXT          = 0x8349;
	static const auto GL_FRAGMENT_NORMAL_EXT            = 0x834a;
	static const auto GL_FRAGMENT_COLOR_EXT             = 0x834c;
	static const auto GL_ATTENUATION_EXT                = 0x834d;
	static const auto GL_SHADOW_ATTENUATION_EXT         = 0x834e;
	static const auto GL_TEXTURE_APPLICATION_MODE_EXT   = 0x834f;
	static const auto GL_TEXTURE_LIGHT_EXT              = 0x8350;
	static const auto GL_TEXTURE_MATERIAL_FACE_EXT      = 0x8351;
	static const auto GL_TEXTURE_MATERIAL_PARAMETER_EXT = 0x8352;
	/* reuse GL_FRAGMENT_DEPTH_EXT */
}

version(GL_SGIX_blend_alpha_minmax) {
}
else {
	static const auto GL_ALPHA_MIN_SGIX                 = 0x8320;
	static const auto GL_ALPHA_MAX_SGIX                 = 0x8321;
}

version(GL_SGIX_impact_pixel_texture) {
}
else {
	static const auto GL_PIXEL_TEX_GEN_Q_CEILING_SGIX   = 0x8184;
	static const auto GL_PIXEL_TEX_GEN_Q_ROUND_SGIX     = 0x8185;
	static const auto GL_PIXEL_TEX_GEN_Q_FLOOR_SGIX     = 0x8186;
	static const auto GL_PIXEL_TEX_GEN_ALPHA_REPLACE_SGIX = 0x8187;
	static const auto GL_PIXEL_TEX_GEN_ALPHA_NO_REPLACE_SGIX = 0x8188;
	static const auto GL_PIXEL_TEX_GEN_ALPHA_LS_SGIX    = 0x8189;
	static const auto GL_PIXEL_TEX_GEN_ALPHA_MS_SGIX    = 0x818a;
}

version(GL_EXT_bgra) {
}
else {
	static const auto GL_BGR_EXT                        = 0x80E0;
	static const auto GL_BGRA_EXT                       = 0x80E1;
}

version(GL_SGIX_async) {
}
else {
	static const auto GL_ASYNC_MARKER_SGIX              = 0x8329;
}

version(GL_SGIX_async_pixel) {
}
else {
	static const auto GL_ASYNC_TEX_IMAGE_SGIX           = 0x835c;
	static const auto GL_ASYNC_DRAW_PIXELS_SGIX         = 0x835d;
	static const auto GL_ASYNC_READ_PIXELS_SGIX         = 0x835e;
	static const auto GL_MAX_ASYNC_TEX_IMAGE_SGIX       = 0x835f;
	static const auto GL_MAX_ASYNC_DRAW_PIXELS_SGIX     = 0x8360;
	static const auto GL_MAX_ASYNC_READ_PIXELS_SGIX     = 0x8361;
}

version(GL_SGIX_async_histogram) {
}
else {
	static const auto GL_ASYNC_HISTOGRAM_SGIX           = 0x832c;
	static const auto GL_MAX_ASYNC_HISTOGRAM_SGIX       = 0x832d;
}

version(GL_INTEL_texture_scissor) {
}
else {
}

version(GL_INTEL_parallel_arrays) {
}
else {
	static const auto GL_PARALLEL_ARRAYS_INTEL          = 0x83F4;
	static const auto GL_VERTEX_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F5;
	static const auto GL_NORMAL_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F6;
	static const auto GL_COLOR_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F7;
	static const auto GL_TEXTURE_COORD_ARRAY_PARALLEL_POINTERS_INTEL = 0x83F8;
}

version(GL_HP_occlusion_test) {
}
else {
	static const auto GL_OCCLUSION_TEST_HP              = 0x8165;
	static const auto GL_OCCLUSION_TEST_RESULT_HP       = 0x8166;
}

version(GL_EXT_pixel_transform) {
}
else {
	static const auto GL_PIXEL_TRANSFORM_2D_EXT         = 0x8330;
	static const auto GL_PIXEL_MAG_FILTER_EXT           = 0x8331;
	static const auto GL_PIXEL_MIN_FILTER_EXT           = 0x8332;
	static const auto GL_PIXEL_CUBIC_WEIGHT_EXT         = 0x8333;
	static const auto GL_CUBIC_EXT                      = 0x8334;
	static const auto GL_AVERAGE_EXT                    = 0x8335;
	static const auto GL_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT = 0x8336;
	static const auto GL_MAX_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT = 0x8337;
	static const auto GL_PIXEL_TRANSFORM_2D_MATRIX_EXT  = 0x8338;
}

version(GL_EXT_pixel_transform_color_table) {
}
else {
}

version(GL_EXT_shared_texture_palette) {
}
else {
	static const auto GL_SHARED_TEXTURE_PALETTE_EXT     = 0x81Fb;
}

version(GL_EXT_separate_specular_color) {
}
else {
	static const auto GL_LIGHT_MODEL_COLOR_CONTROL_EXT  = 0x81F8;
	static const auto GL_SINGLE_COLOR_EXT               = 0x81F9;
	static const auto GL_SEPARATE_SPECULAR_COLOR_EXT    = 0x81Fa;
}

version(GL_EXT_secondary_color) {
}
else {
	static const auto GL_COLOR_SUM_EXT                  = 0x8458;
	static const auto GL_CURRENT_SECONDARY_COLOR_EXT    = 0x8459;
	static const auto GL_SECONDARY_COLOR_ARRAY_SIZE_EXT = 0x845a;
	static const auto GL_SECONDARY_COLOR_ARRAY_TYPE_EXT = 0x845b;
	static const auto GL_SECONDARY_COLOR_ARRAY_STRIDE_EXT = 0x845c;
	static const auto GL_SECONDARY_COLOR_ARRAY_POINTER_EXT = 0x845d;
	static const auto GL_SECONDARY_COLOR_ARRAY_EXT      = 0x845e;
}

version(GL_EXT_texture_perturb_normal) {
}
else {
	static const auto GL_PERTURB_EXT                    = 0x85Ae;
	static const auto GL_TEXTURE_NORMAL_EXT             = 0x85Af;
}

version(GL_EXT_multi_draw_arrays) {
}
else {
}

version(GL_EXT_fog_coord) {
}
else {
	static const auto GL_FOG_COORDINATE_SOURCE_EXT      = 0x8450;
	static const auto GL_FOG_COORDINATE_EXT             = 0x8451;
	static const auto GL_FRAGMENT_DEPTH_EXT             = 0x8452;
	static const auto GL_CURRENT_FOG_COORDINATE_EXT     = 0x8453;
	static const auto GL_FOG_COORDINATE_ARRAY_TYPE_EXT  = 0x8454;
	static const auto GL_FOG_COORDINATE_ARRAY_STRIDE_EXT = 0x8455;
	static const auto GL_FOG_COORDINATE_ARRAY_POINTER_EXT = 0x8456;
	static const auto GL_FOG_COORDINATE_ARRAY_EXT       = 0x8457;
}

version(GL_REND_screen_coordinates) {
}
else {
	static const auto GL_SCREEN_COORDINATES_REND        = 0x8490;
	static const auto GL_INVERTED_SCREEN_W_REND         = 0x8491;
}

version(GL_EXT_coordinate_frame) {
}
else {
	static const auto GL_TANGENT_ARRAY_EXT              = 0x8439;
	static const auto GL_BINORMAL_ARRAY_EXT             = 0x843a;
	static const auto GL_CURRENT_TANGENT_EXT            = 0x843b;
	static const auto GL_CURRENT_BINORMAL_EXT           = 0x843c;
	static const auto GL_TANGENT_ARRAY_TYPE_EXT         = 0x843e;
	static const auto GL_TANGENT_ARRAY_STRIDE_EXT       = 0x843f;
	static const auto GL_BINORMAL_ARRAY_TYPE_EXT        = 0x8440;
	static const auto GL_BINORMAL_ARRAY_STRIDE_EXT      = 0x8441;
	static const auto GL_TANGENT_ARRAY_POINTER_EXT      = 0x8442;
	static const auto GL_BINORMAL_ARRAY_POINTER_EXT     = 0x8443;
	static const auto GL_MAP1_TANGENT_EXT               = 0x8444;
	static const auto GL_MAP2_TANGENT_EXT               = 0x8445;
	static const auto GL_MAP1_BINORMAL_EXT              = 0x8446;
	static const auto GL_MAP2_BINORMAL_EXT              = 0x8447;
}

version(GL_EXT_texture_env_combine) {
}
else {
	static const auto GL_COMBINE_EXT                    = 0x8570;
	static const auto GL_COMBINE_RGB_EXT                = 0x8571;
	static const auto GL_COMBINE_ALPHA_EXT              = 0x8572;
	static const auto GL_RGB_SCALE_EXT                  = 0x8573;
	static const auto GL_ADD_SIGNED_EXT                 = 0x8574;
	static const auto GL_INTERPOLATE_EXT                = 0x8575;
	static const auto GL_CONSTANT_EXT                   = 0x8576;
	static const auto GL_PRIMARY_COLOR_EXT              = 0x8577;
	static const auto GL_PREVIOUS_EXT                   = 0x8578;
	static const auto GL_SOURCE0_RGB_EXT                = 0x8580;
	static const auto GL_SOURCE1_RGB_EXT                = 0x8581;
	static const auto GL_SOURCE2_RGB_EXT                = 0x8582;
	static const auto GL_SOURCE0_ALPHA_EXT              = 0x8588;
	static const auto GL_SOURCE1_ALPHA_EXT              = 0x8589;
	static const auto GL_SOURCE2_ALPHA_EXT              = 0x858a;
	static const auto GL_OPERAND0_RGB_EXT               = 0x8590;
	static const auto GL_OPERAND1_RGB_EXT               = 0x8591;
	static const auto GL_OPERAND2_RGB_EXT               = 0x8592;
	static const auto GL_OPERAND0_ALPHA_EXT             = 0x8598;
	static const auto GL_OPERAND1_ALPHA_EXT             = 0x8599;
	static const auto GL_OPERAND2_ALPHA_EXT             = 0x859a;
}

version(GL_APPLE_specular_vector) {
}
else {
	static const auto GL_LIGHT_MODEL_SPECULAR_VECTOR_APPLE = 0x85B0;
}

version(GL_APPLE_transform_hint) {
}
else {
	static const auto GL_TRANSFORM_HINT_APPLE           = 0x85B1;
}

version(GL_SGIX_fog_scale) {
}
else {
	static const auto GL_FOG_SCALE_SGIX                 = 0x81Fc;
	static const auto GL_FOG_SCALE_VALUE_SGIX           = 0x81Fd;
}

version(GL_SUNX_constant_data) {
}
else {
	static const auto GL_UNPACK_CONSTANT_DATA_SUNX      = 0x81D5;
	static const auto GL_TEXTURE_CONSTANT_DATA_SUNX     = 0x81D6;
}

version(GL_SUN_global_alpha) {
}
else {
	static const auto GL_GLOBAL_ALPHA_SUN               = 0x81D9;
	static const auto GL_GLOBAL_ALPHA_FACTOR_SUN        = 0x81Da;
}

version(GL_SUN_triangle_list) {
}
else {
	static const auto GL_RESTART_SUN                    = 0x0001;
	static const auto GL_REPLACE_MIDDLE_SUN             = 0x0002;
	static const auto GL_REPLACE_OLDEST_SUN             = 0x0003;
	static const auto GL_TRIANGLE_LIST_SUN              = 0x81D7;
	static const auto GL_REPLACEMENT_CODE_SUN           = 0x81D8;
	static const auto GL_REPLACEMENT_CODE_ARRAY_SUN     = 0x85C0;
	static const auto GL_REPLACEMENT_CODE_ARRAY_TYPE_SUN = 0x85C1;
	static const auto GL_REPLACEMENT_CODE_ARRAY_STRIDE_SUN = 0x85C2;
	static const auto GL_REPLACEMENT_CODE_ARRAY_POINTER_SUN = 0x85C3;
	static const auto GL_R1UI_V3F_SUN                   = 0x85C4;
	static const auto GL_R1UI_C4UB_V3F_SUN              = 0x85C5;
	static const auto GL_R1UI_C3F_V3F_SUN               = 0x85C6;
	static const auto GL_R1UI_N3F_V3F_SUN               = 0x85C7;
	static const auto GL_R1UI_C4F_N3F_V3F_SUN           = 0x85C8;
	static const auto GL_R1UI_T2F_V3F_SUN               = 0x85C9;
	static const auto GL_R1UI_T2F_N3F_V3F_SUN           = 0x85Ca;
	static const auto GL_R1UI_T2F_C4F_N3F_V3F_SUN       = 0x85Cb;
}

version(GL_SUN_vertex) {
}
else {
}

version(GL_EXT_blend_func_separate) {
}
else {
	static const auto GL_BLEND_DST_RGB_EXT              = 0x80C8;
	static const auto GL_BLEND_SRC_RGB_EXT              = 0x80C9;
	static const auto GL_BLEND_DST_ALPHA_EXT            = 0x80Ca;
	static const auto GL_BLEND_SRC_ALPHA_EXT            = 0x80Cb;
}

version(GL_INGR_color_clamp) {
}
else {
	static const auto GL_RED_MIN_CLAMP_INGR             = 0x8560;
	static const auto GL_GREEN_MIN_CLAMP_INGR           = 0x8561;
	static const auto GL_BLUE_MIN_CLAMP_INGR            = 0x8562;
	static const auto GL_ALPHA_MIN_CLAMP_INGR           = 0x8563;
	static const auto GL_RED_MAX_CLAMP_INGR             = 0x8564;
	static const auto GL_GREEN_MAX_CLAMP_INGR           = 0x8565;
	static const auto GL_BLUE_MAX_CLAMP_INGR            = 0x8566;
	static const auto GL_ALPHA_MAX_CLAMP_INGR           = 0x8567;
}

version(GL_INGR_interlace_read) {
}
else {
	static const auto GL_INTERLACE_READ_INGR            = 0x8568;
}

version(GL_EXT_stencil_wrap) {
}
else {
	static const auto GL_INCR_WRAP_EXT                  = 0x8507;
	static const auto GL_DECR_WRAP_EXT                  = 0x8508;
}

version(GL_EXT_422_pixels) {
}
else {
	static const auto GL_422_EXT                        = 0x80Cc;
	static const auto GL_422_REV_EXT                    = 0x80Cd;
	static const auto GL_422_AVERAGE_EXT                = 0x80Ce;
	static const auto GL_422_REV_AVERAGE_EXT            = 0x80Cf;
}

version(GL_NV_texgen_reflection) {
}
else {
	static const auto GL_NORMAL_MAP_NV                  = 0x8511;
	static const auto GL_REFLECTION_MAP_NV              = 0x8512;
}

version(GL_EXT_texture_cube_map) {
}
else {
	static const auto GL_NORMAL_MAP_EXT                 = 0x8511;
	static const auto GL_REFLECTION_MAP_EXT             = 0x8512;
	static const auto GL_TEXTURE_CUBE_MAP_EXT           = 0x8513;
	static const auto GL_TEXTURE_BINDING_CUBE_MAP_EXT   = 0x8514;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_X_EXT = 0x8515;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_X_EXT = 0x8516;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_Y_EXT = 0x8517;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_EXT = 0x8518;
	static const auto GL_TEXTURE_CUBE_MAP_POSITIVE_Z_EXT = 0x8519;
	static const auto GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_EXT = 0x851a;
	static const auto GL_PROXY_TEXTURE_CUBE_MAP_EXT     = 0x851b;
	static const auto GL_MAX_CUBE_MAP_TEXTURE_SIZE_EXT  = 0x851c;
}

version(GL_SUN_convolution_border_modes) {
}
else {
	static const auto GL_WRAP_BORDER_SUN                = 0x81D4;
}

version(GL_EXT_texture_env_add) {
}
else {
}

version(GL_EXT_texture_lod_bias) {
}
else {
	static const auto GL_MAX_TEXTURE_LOD_BIAS_EXT       = 0x84Fd;
	static const auto GL_TEXTURE_FILTER_CONTROL_EXT     = 0x8500;
	static const auto GL_TEXTURE_LOD_BIAS_EXT           = 0x8501;
}

version(GL_EXT_texture_filter_anisotropic) {
}
else {
	static const auto GL_TEXTURE_MAX_ANISOTROPY_EXT     = 0x84Fe;
	static const auto GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT = 0x84Ff;
}

version(GL_EXT_vertex_weighting) {
}
else {
	static const auto GL_MODELVIEW0_STACK_DEPTH_EXT     = GL_MODELVIEW_STACK_DEPTH;
	static const auto GL_MODELVIEW1_STACK_DEPTH_EXT     = 0x8502;
	static const auto GL_MODELVIEW0_MATRIX_EXT          = GL_MODELVIEW_MATRIX;
	static const auto GL_MODELVIEW1_MATRIX_EXT          = 0x8506;
	static const auto GL_VERTEX_WEIGHTING_EXT           = 0x8509;
	static const auto GL_MODELVIEW0_EXT                 = GL_MODELVIEW;
	static const auto GL_MODELVIEW1_EXT                 = 0x850a;
	static const auto GL_CURRENT_VERTEX_WEIGHT_EXT      = 0x850b;
	static const auto GL_VERTEX_WEIGHT_ARRAY_EXT        = 0x850c;
	static const auto GL_VERTEX_WEIGHT_ARRAY_SIZE_EXT   = 0x850d;
	static const auto GL_VERTEX_WEIGHT_ARRAY_TYPE_EXT   = 0x850e;
	static const auto GL_VERTEX_WEIGHT_ARRAY_STRIDE_EXT = 0x850f;
	static const auto GL_VERTEX_WEIGHT_ARRAY_POINTER_EXT = 0x8510;
}

version(GL_NV_light_max_exponent) {
}
else {
	static const auto GL_MAX_SHININESS_NV               = 0x8504;
	static const auto GL_MAX_SPOT_EXPONENT_NV           = 0x8505;
}

version(GL_NV_vertex_array_range) {
}
else {
	static const auto GL_VERTEX_ARRAY_RANGE_NV          = 0x851d;
	static const auto GL_VERTEX_ARRAY_RANGE_LENGTH_NV   = 0x851e;
	static const auto GL_VERTEX_ARRAY_RANGE_VALID_NV    = 0x851f;
	static const auto GL_MAX_VERTEX_ARRAY_RANGE_ELEMENT_NV = 0x8520;
	static const auto GL_VERTEX_ARRAY_RANGE_POINTER_NV  = 0x8521;
}

version(GL_NV_register_combiners) {
}
else {
	static const auto GL_REGISTER_COMBINERS_NV          = 0x8522;
	static const auto GL_VARIABLE_A_NV                  = 0x8523;
	static const auto GL_VARIABLE_B_NV                  = 0x8524;
	static const auto GL_VARIABLE_C_NV                  = 0x8525;
	static const auto GL_VARIABLE_D_NV                  = 0x8526;
	static const auto GL_VARIABLE_E_NV                  = 0x8527;
	static const auto GL_VARIABLE_F_NV                  = 0x8528;
	static const auto GL_VARIABLE_G_NV                  = 0x8529;
	static const auto GL_CONSTANT_COLOR0_NV             = 0x852a;
	static const auto GL_CONSTANT_COLOR1_NV             = 0x852b;
	static const auto GL_PRIMARY_COLOR_NV               = 0x852c;
	static const auto GL_SECONDARY_COLOR_NV             = 0x852d;
	static const auto GL_SPARE0_NV                      = 0x852e;
	static const auto GL_SPARE1_NV                      = 0x852f;
	static const auto GL_DISCARD_NV                     = 0x8530;
	static const auto GL_E_TIMES_F_NV                   = 0x8531;
	static const auto GL_SPARE0_PLUS_SECONDARY_COLOR_NV = 0x8532;
	static const auto GL_UNSIGNED_IDENTITY_NV           = 0x8536;
	static const auto GL_UNSIGNED_INVERT_NV             = 0x8537;
	static const auto GL_EXPAND_NORMAL_NV               = 0x8538;
	static const auto GL_EXPAND_NEGATE_NV               = 0x8539;
	static const auto GL_HALF_BIAS_NORMAL_NV            = 0x853a;
	static const auto GL_HALF_BIAS_NEGATE_NV            = 0x853b;
	static const auto GL_SIGNED_IDENTITY_NV             = 0x853c;
	static const auto GL_SIGNED_NEGATE_NV               = 0x853d;
	static const auto GL_SCALE_BY_TWO_NV                = 0x853e;
	static const auto GL_SCALE_BY_FOUR_NV               = 0x853f;
	static const auto GL_SCALE_BY_ONE_HALF_NV           = 0x8540;
	static const auto GL_BIAS_BY_NEGATIVE_ONE_HALF_NV   = 0x8541;
	static const auto GL_COMBINER_INPUT_NV              = 0x8542;
	static const auto GL_COMBINER_MAPPING_NV            = 0x8543;
	static const auto GL_COMBINER_COMPONENT_USAGE_NV    = 0x8544;
	static const auto GL_COMBINER_AB_DOT_PRODUCT_NV     = 0x8545;
	static const auto GL_COMBINER_CD_DOT_PRODUCT_NV     = 0x8546;
	static const auto GL_COMBINER_MUX_SUM_NV            = 0x8547;
	static const auto GL_COMBINER_SCALE_NV              = 0x8548;
	static const auto GL_COMBINER_BIAS_NV               = 0x8549;
	static const auto GL_COMBINER_AB_OUTPUT_NV          = 0x854a;
	static const auto GL_COMBINER_CD_OUTPUT_NV          = 0x854b;
	static const auto GL_COMBINER_SUM_OUTPUT_NV         = 0x854c;
	static const auto GL_MAX_GENERAL_COMBINERS_NV       = 0x854d;
	static const auto GL_NUM_GENERAL_COMBINERS_NV       = 0x854e;
	static const auto GL_COLOR_SUM_CLAMP_NV             = 0x854f;
	static const auto GL_COMBINER0_NV                   = 0x8550;
	static const auto GL_COMBINER1_NV                   = 0x8551;
	static const auto GL_COMBINER2_NV                   = 0x8552;
	static const auto GL_COMBINER3_NV                   = 0x8553;
	static const auto GL_COMBINER4_NV                   = 0x8554;
	static const auto GL_COMBINER5_NV                   = 0x8555;
	static const auto GL_COMBINER6_NV                   = 0x8556;
	static const auto GL_COMBINER7_NV                   = 0x8557;
	/* reuse GL_TEXTURE0_ARB */
	/* reuse GL_TEXTURE1_ARB */
	/* reuse GL_ZERO */
	/* reuse GL_NONE */
	/* reuse GL_FOG */
}

version(GL_NV_fog_distance) {
}
else {
	static const auto GL_FOG_DISTANCE_MODE_NV           = 0x855a;
	static const auto GL_EYE_RADIAL_NV                  = 0x855b;
	static const auto GL_EYE_PLANE_ABSOLUTE_NV          = 0x855c;
	/* reuse GL_EYE_PLANE */
}

version(GL_NV_texgen_emboss) {
}
else {
	static const auto GL_EMBOSS_LIGHT_NV                = 0x855d;
	static const auto GL_EMBOSS_CONSTANT_NV             = 0x855e;
	static const auto GL_EMBOSS_MAP_NV                  = 0x855f;
}

version(GL_NV_blend_square) {
}
else {
}

version(GL_NV_texture_env_combine4) {
}
else {
	static const auto GL_COMBINE4_NV                    = 0x8503;
	static const auto GL_SOURCE3_RGB_NV                 = 0x8583;
	static const auto GL_SOURCE3_ALPHA_NV               = 0x858b;
	static const auto GL_OPERAND3_RGB_NV                = 0x8593;
	static const auto GL_OPERAND3_ALPHA_NV              = 0x859b;
}

version(GL_MESA_resize_buffers) {
}
else {
}

version(GL_MESA_window_pos) {
}
else {
}

version(GL_EXT_texture_compression_s3tc) {
}
else {
	static const auto GL_COMPRESSED_RGB_S3TC_DXT1_EXT   = 0x83F0;
	static const auto GL_COMPRESSED_RGBA_S3TC_DXT1_EXT  = 0x83F1;
	static const auto GL_COMPRESSED_RGBA_S3TC_DXT3_EXT  = 0x83F2;
	static const auto GL_COMPRESSED_RGBA_S3TC_DXT5_EXT  = 0x83F3;
}

version(GL_IBM_cull_vertex) {
}
else {
	static const auto GL_CULL_VERTEX_IBM                = 103050;
}

version(GL_IBM_multimode_draw_arrays) {
}
else {
}

version(GL_IBM_vertex_array_lists) {
}
else {
	static const auto GL_VERTEX_ARRAY_LIST_IBM          = 103070;
	static const auto GL_NORMAL_ARRAY_LIST_IBM          = 103071;
	static const auto GL_COLOR_ARRAY_LIST_IBM           = 103072;
	static const auto GL_INDEX_ARRAY_LIST_IBM           = 103073;
	static const auto GL_TEXTURE_COORD_ARRAY_LIST_IBM   = 103074;
	static const auto GL_EDGE_FLAG_ARRAY_LIST_IBM       = 103075;
	static const auto GL_FOG_COORDINATE_ARRAY_LIST_IBM  = 103076;
	static const auto GL_SECONDARY_COLOR_ARRAY_LIST_IBM = 103077;
	static const auto GL_VERTEX_ARRAY_LIST_STRIDE_IBM   = 103080;
	static const auto GL_NORMAL_ARRAY_LIST_STRIDE_IBM   = 103081;
	static const auto GL_COLOR_ARRAY_LIST_STRIDE_IBM    = 103082;
	static const auto GL_INDEX_ARRAY_LIST_STRIDE_IBM    = 103083;
	static const auto GL_TEXTURE_COORD_ARRAY_LIST_STRIDE_IBM = 103084;
	static const auto GL_EDGE_FLAG_ARRAY_LIST_STRIDE_IBM = 103085;
	static const auto GL_FOG_COORDINATE_ARRAY_LIST_STRIDE_IBM = 103086;
	static const auto GL_SECONDARY_COLOR_ARRAY_LIST_STRIDE_IBM = 103087;
}

version(GL_SGIX_subsample) {
}
else {
	static const auto GL_PACK_SUBSAMPLE_RATE_SGIX       = 0x85A0;
	static const auto GL_UNPACK_SUBSAMPLE_RATE_SGIX     = 0x85A1;
	static const auto GL_PIXEL_SUBSAMPLE_4444_SGIX      = 0x85A2;
	static const auto GL_PIXEL_SUBSAMPLE_2424_SGIX      = 0x85A3;
	static const auto GL_PIXEL_SUBSAMPLE_4242_SGIX      = 0x85A4;
}

version(GL_SGIX_ycrcb_subsample) {
}
else {
}

version(GL_SGIX_ycrcba) {
}
else {
	static const auto GL_YCRCB_SGIX                     = 0x8318;
	static const auto GL_YCRCBA_SGIX                    = 0x8319;
}

version(GL_SGI_depth_pass_instrument) {
}
else {
	static const auto GL_DEPTH_PASS_INSTRUMENT_SGIX     = 0x8310;
	static const auto GL_DEPTH_PASS_INSTRUMENT_COUNTERS_SGIX = 0x8311;
	static const auto GL_DEPTH_PASS_INSTRUMENT_MAX_SGIX = 0x8312;
}

version(GL_3DFX_texture_compression_FXT1) {
}
else {
	static const auto GL_COMPRESSED_RGB_FXT1_3DFX       = 0x86B0;
	static const auto GL_COMPRESSED_RGBA_FXT1_3DFX      = 0x86B1;
}

version(GL_3DFX_multisample) {
}
else {
	static const auto GL_MULTISAMPLE_3DFX               = 0x86B2;
	static const auto GL_SAMPLE_BUFFERS_3DFX            = 0x86B3;
	static const auto GL_SAMPLES_3DFX                   = 0x86B4;
	static const auto GL_MULTISAMPLE_BIT_3DFX           = 0x20000000;
}

version(GL_3DFX_tbuffer) {
}
else {
}

version(GL_EXT_multisample) {
}
else {
	static const auto GL_MULTISAMPLE_EXT                = 0x809d;
	static const auto GL_SAMPLE_ALPHA_TO_MASK_EXT       = 0x809e;
	static const auto GL_SAMPLE_ALPHA_TO_ONE_EXT        = 0x809f;
	static const auto GL_SAMPLE_MASK_EXT                = 0x80A0;
	static const auto GL_1PASS_EXT                      = 0x80A1;
	static const auto GL_2PASS_0_EXT                    = 0x80A2;
	static const auto GL_2PASS_1_EXT                    = 0x80A3;
	static const auto GL_4PASS_0_EXT                    = 0x80A4;
	static const auto GL_4PASS_1_EXT                    = 0x80A5;
	static const auto GL_4PASS_2_EXT                    = 0x80A6;
	static const auto GL_4PASS_3_EXT                    = 0x80A7;
	static const auto GL_SAMPLE_BUFFERS_EXT             = 0x80A8;
	static const auto GL_SAMPLES_EXT                    = 0x80A9;
	static const auto GL_SAMPLE_MASK_VALUE_EXT          = 0x80Aa;
	static const auto GL_SAMPLE_MASK_INVERT_EXT         = 0x80Ab;
	static const auto GL_SAMPLE_PATTERN_EXT             = 0x80Ac;
	static const auto GL_MULTISAMPLE_BIT_EXT            = 0x20000000;
}

version(GL_SGIX_vertex_preclip) {
}
else {
	static const auto GL_VERTEX_PRECLIP_SGIX            = 0x83Ee;
	static const auto GL_VERTEX_PRECLIP_HINT_SGIX       = 0x83Ef;
}

version(GL_SGIX_convolution_accuracy) {
}
else {
	static const auto GL_CONVOLUTION_HINT_SGIX          = 0x8316;
}

version(GL_SGIX_resample) {
}
else {
	static const auto GL_PACK_RESAMPLE_SGIX             = 0x842c;
	static const auto GL_UNPACK_RESAMPLE_SGIX           = 0x842d;
	static const auto GL_RESAMPLE_REPLICATE_SGIX        = 0x842e;
	static const auto GL_RESAMPLE_ZERO_FILL_SGIX        = 0x842f;
	static const auto GL_RESAMPLE_DECIMATE_SGIX         = 0x8430;
}

version(GL_SGIS_point_line_texgen) {
}
else {
	static const auto GL_EYE_DISTANCE_TO_POINT_SGIS     = 0x81F0;
	static const auto GL_OBJECT_DISTANCE_TO_POINT_SGIS  = 0x81F1;
	static const auto GL_EYE_DISTANCE_TO_LINE_SGIS      = 0x81F2;
	static const auto GL_OBJECT_DISTANCE_TO_LINE_SGIS   = 0x81F3;
	static const auto GL_EYE_POINT_SGIS                 = 0x81F4;
	static const auto GL_OBJECT_POINT_SGIS              = 0x81F5;
	static const auto GL_EYE_LINE_SGIS                  = 0x81F6;
	static const auto GL_OBJECT_LINE_SGIS               = 0x81F7;
}

version(GL_SGIS_texture_color_mask) {
}
else {
	static const auto GL_TEXTURE_COLOR_WRITEMASK_SGIS   = 0x81Ef;
}

version(GL_EXT_texture_env_dot3) {
}
else {
	static const auto GL_DOT3_RGB_EXT                   = 0x8740;
	static const auto GL_DOT3_RGBA_EXT                  = 0x8741;
}

version(GL_ATI_texture_mirror_once) {
}
else {
	static const auto GL_MIRROR_CLAMP_ATI               = 0x8742;
	static const auto GL_MIRROR_CLAMP_TO_EDGE_ATI       = 0x8743;
}

version(GL_NV_fence) {
}
else {
	static const auto GL_ALL_COMPLETED_NV               = 0x84F2;
	static const auto GL_FENCE_STATUS_NV                = 0x84F3;
	static const auto GL_FENCE_CONDITION_NV             = 0x84F4;
}

version(GL_IBM_texture_mirrored_repeat) {
}
else {
	static const auto GL_MIRRORED_REPEAT_IBM            = 0x8370;
}

version(GL_NV_evaluators) {
}
else {
	static const auto GL_EVAL_2D_NV                     = 0x86C0;
	static const auto GL_EVAL_TRIANGULAR_2D_NV          = 0x86C1;
	static const auto GL_MAP_TESSELLATION_NV            = 0x86C2;
	static const auto GL_MAP_ATTRIB_U_ORDER_NV          = 0x86C3;
	static const auto GL_MAP_ATTRIB_V_ORDER_NV          = 0x86C4;
	static const auto GL_EVAL_FRACTIONAL_TESSELLATION_NV = 0x86C5;
	static const auto GL_EVAL_VERTEX_ATTRIB0_NV         = 0x86C6;
	static const auto GL_EVAL_VERTEX_ATTRIB1_NV         = 0x86C7;
	static const auto GL_EVAL_VERTEX_ATTRIB2_NV         = 0x86C8;
	static const auto GL_EVAL_VERTEX_ATTRIB3_NV         = 0x86C9;
	static const auto GL_EVAL_VERTEX_ATTRIB4_NV         = 0x86Ca;
	static const auto GL_EVAL_VERTEX_ATTRIB5_NV         = 0x86Cb;
	static const auto GL_EVAL_VERTEX_ATTRIB6_NV         = 0x86Cc;
	static const auto GL_EVAL_VERTEX_ATTRIB7_NV         = 0x86Cd;
	static const auto GL_EVAL_VERTEX_ATTRIB8_NV         = 0x86Ce;
	static const auto GL_EVAL_VERTEX_ATTRIB9_NV         = 0x86Cf;
	static const auto GL_EVAL_VERTEX_ATTRIB10_NV        = 0x86D0;
	static const auto GL_EVAL_VERTEX_ATTRIB11_NV        = 0x86D1;
	static const auto GL_EVAL_VERTEX_ATTRIB12_NV        = 0x86D2;
	static const auto GL_EVAL_VERTEX_ATTRIB13_NV        = 0x86D3;
	static const auto GL_EVAL_VERTEX_ATTRIB14_NV        = 0x86D4;
	static const auto GL_EVAL_VERTEX_ATTRIB15_NV        = 0x86D5;
	static const auto GL_MAX_MAP_TESSELLATION_NV        = 0x86D6;
	static const auto GL_MAX_RATIONAL_EVAL_ORDER_NV     = 0x86D7;
}

version(GL_NV_packed_depth_stencil) {
}
else {
	static const auto GL_DEPTH_STENCIL_NV               = 0x84F9;
	static const auto GL_UNSIGNED_INT_24_8_NV           = 0x84Fa;
}

version(GL_NV_register_combiners2) {
}
else {
	static const auto GL_PER_STAGE_CONSTANTS_NV         = 0x8535;
}

version(GL_NV_texture_compression_vtc) {
}
else {
}

version(GL_NV_texture_rectangle) {
}
else {
	static const auto GL_TEXTURE_RECTANGLE_NV           = 0x84F5;
	static const auto GL_TEXTURE_BINDING_RECTANGLE_NV   = 0x84F6;
	static const auto GL_PROXY_TEXTURE_RECTANGLE_NV     = 0x84F7;
	static const auto GL_MAX_RECTANGLE_TEXTURE_SIZE_NV  = 0x84F8;
}

version(GL_NV_texture_shader) {
}
else {
	static const auto GL_OFFSET_TEXTURE_RECTANGLE_NV    = 0x864c;
	static const auto GL_OFFSET_TEXTURE_RECTANGLE_SCALE_NV = 0x864d;
	static const auto GL_DOT_PRODUCT_TEXTURE_RECTANGLE_NV = 0x864e;
	static const auto GL_RGBA_UNSIGNED_DOT_PRODUCT_MAPPING_NV = 0x86D9;
	static const auto GL_UNSIGNED_INT_S8_S8_8_8_NV      = 0x86Da;
	static const auto GL_UNSIGNED_INT_8_8_S8_S8_REV_NV  = 0x86Db;
	static const auto GL_DSDT_MAG_INTENSITY_NV          = 0x86Dc;
	static const auto GL_SHADER_CONSISTENT_NV           = 0x86Dd;
	static const auto GL_TEXTURE_SHADER_NV              = 0x86De;
	static const auto GL_SHADER_OPERATION_NV            = 0x86Df;
	static const auto GL_CULL_MODES_NV                  = 0x86E0;
	static const auto GL_OFFSET_TEXTURE_MATRIX_NV       = 0x86E1;
	static const auto GL_OFFSET_TEXTURE_SCALE_NV        = 0x86E2;
	static const auto GL_OFFSET_TEXTURE_BIAS_NV         = 0x86E3;
	static const auto GL_OFFSET_TEXTURE_2D_MATRIX_NV    = GL_OFFSET_TEXTURE_MATRIX_NV;
	static const auto GL_OFFSET_TEXTURE_2D_SCALE_NV     = GL_OFFSET_TEXTURE_SCALE_NV;
	static const auto GL_OFFSET_TEXTURE_2D_BIAS_NV      = GL_OFFSET_TEXTURE_BIAS_NV;
	static const auto GL_PREVIOUS_TEXTURE_INPUT_NV      = 0x86E4;
	static const auto GL_CONST_EYE_NV                   = 0x86E5;
	static const auto GL_PASS_THROUGH_NV                = 0x86E6;
	static const auto GL_CULL_FRAGMENT_NV               = 0x86E7;
	static const auto GL_OFFSET_TEXTURE_2D_NV           = 0x86E8;
	static const auto GL_DEPENDENT_AR_TEXTURE_2D_NV     = 0x86E9;
	static const auto GL_DEPENDENT_GB_TEXTURE_2D_NV     = 0x86Ea;
	static const auto GL_DOT_PRODUCT_NV                 = 0x86Ec;
	static const auto GL_DOT_PRODUCT_DEPTH_REPLACE_NV   = 0x86Ed;
	static const auto GL_DOT_PRODUCT_TEXTURE_2D_NV      = 0x86Ee;
	static const auto GL_DOT_PRODUCT_TEXTURE_CUBE_MAP_NV = 0x86F0;
	static const auto GL_DOT_PRODUCT_DIFFUSE_CUBE_MAP_NV = 0x86F1;
	static const auto GL_DOT_PRODUCT_REFLECT_CUBE_MAP_NV = 0x86F2;
	static const auto GL_DOT_PRODUCT_CONST_EYE_REFLECT_CUBE_MAP_NV = 0x86F3;
	static const auto GL_HILO_NV                        = 0x86F4;
	static const auto GL_DSDT_NV                        = 0x86F5;
	static const auto GL_DSDT_MAG_NV                    = 0x86F6;
	static const auto GL_DSDT_MAG_VIB_NV                = 0x86F7;
	static const auto GL_HILO16_NV                      = 0x86F8;
	static const auto GL_SIGNED_HILO_NV                 = 0x86F9;
	static const auto GL_SIGNED_HILO16_NV               = 0x86Fa;
	static const auto GL_SIGNED_RGBA_NV                 = 0x86Fb;
	static const auto GL_SIGNED_RGBA8_NV                = 0x86Fc;
	static const auto GL_SIGNED_RGB_NV                  = 0x86Fe;
	static const auto GL_SIGNED_RGB8_NV                 = 0x86Ff;
	static const auto GL_SIGNED_LUMINANCE_NV            = 0x8701;
	static const auto GL_SIGNED_LUMINANCE8_NV           = 0x8702;
	static const auto GL_SIGNED_LUMINANCE_ALPHA_NV      = 0x8703;
	static const auto GL_SIGNED_LUMINANCE8_ALPHA8_NV    = 0x8704;
	static const auto GL_SIGNED_ALPHA_NV                = 0x8705;
	static const auto GL_SIGNED_ALPHA8_NV               = 0x8706;
	static const auto GL_SIGNED_INTENSITY_NV            = 0x8707;
	static const auto GL_SIGNED_INTENSITY8_NV           = 0x8708;
	static const auto GL_DSDT8_NV                       = 0x8709;
	static const auto GL_DSDT8_MAG8_NV                  = 0x870a;
	static const auto GL_DSDT8_MAG8_INTENSITY8_NV       = 0x870b;
	static const auto GL_SIGNED_RGB_UNSIGNED_ALPHA_NV   = 0x870c;
	static const auto GL_SIGNED_RGB8_UNSIGNED_ALPHA8_NV = 0x870d;
	static const auto GL_HI_SCALE_NV                    = 0x870e;
	static const auto GL_LO_SCALE_NV                    = 0x870f;
	static const auto GL_DS_SCALE_NV                    = 0x8710;
	static const auto GL_DT_SCALE_NV                    = 0x8711;
	static const auto GL_MAGNITUDE_SCALE_NV             = 0x8712;
	static const auto GL_VIBRANCE_SCALE_NV              = 0x8713;
	static const auto GL_HI_BIAS_NV                     = 0x8714;
	static const auto GL_LO_BIAS_NV                     = 0x8715;
	static const auto GL_DS_BIAS_NV                     = 0x8716;
	static const auto GL_DT_BIAS_NV                     = 0x8717;
	static const auto GL_MAGNITUDE_BIAS_NV              = 0x8718;
	static const auto GL_VIBRANCE_BIAS_NV               = 0x8719;
	static const auto GL_TEXTURE_BORDER_VALUES_NV       = 0x871a;
	static const auto GL_TEXTURE_HI_SIZE_NV             = 0x871b;
	static const auto GL_TEXTURE_LO_SIZE_NV             = 0x871c;
	static const auto GL_TEXTURE_DS_SIZE_NV             = 0x871d;
	static const auto GL_TEXTURE_DT_SIZE_NV             = 0x871e;
	static const auto GL_TEXTURE_MAG_SIZE_NV            = 0x871f;
}

version(GL_NV_texture_shader2) {
}
else {
	static const auto GL_DOT_PRODUCT_TEXTURE_3D_NV      = 0x86Ef;
}

version(GL_NV_vertex_array_range2) {
}
else {
	static const auto GL_VERTEX_ARRAY_RANGE_WITHOUT_FLUSH_NV = 0x8533;
}

version(GL_NV_vertex_program) {
}
else {
	static const auto GL_VERTEX_PROGRAM_NV              = 0x8620;
	static const auto GL_VERTEX_STATE_PROGRAM_NV        = 0x8621;
	static const auto GL_ATTRIB_ARRAY_SIZE_NV           = 0x8623;
	static const auto GL_ATTRIB_ARRAY_STRIDE_NV         = 0x8624;
	static const auto GL_ATTRIB_ARRAY_TYPE_NV           = 0x8625;
	static const auto GL_CURRENT_ATTRIB_NV              = 0x8626;
	static const auto GL_PROGRAM_LENGTH_NV              = 0x8627;
	static const auto GL_PROGRAM_STRING_NV              = 0x8628;
	static const auto GL_MODELVIEW_PROJECTION_NV        = 0x8629;
	static const auto GL_IDENTITY_NV                    = 0x862a;
	static const auto GL_INVERSE_NV                     = 0x862b;
	static const auto GL_TRANSPOSE_NV                   = 0x862c;
	static const auto GL_INVERSE_TRANSPOSE_NV           = 0x862d;
	static const auto GL_MAX_TRACK_MATRIX_STACK_DEPTH_NV = 0x862e;
	static const auto GL_MAX_TRACK_MATRICES_NV          = 0x862f;
	static const auto GL_MATRIX0_NV                     = 0x8630;
	static const auto GL_MATRIX1_NV                     = 0x8631;
	static const auto GL_MATRIX2_NV                     = 0x8632;
	static const auto GL_MATRIX3_NV                     = 0x8633;
	static const auto GL_MATRIX4_NV                     = 0x8634;
	static const auto GL_MATRIX5_NV                     = 0x8635;
	static const auto GL_MATRIX6_NV                     = 0x8636;
	static const auto GL_MATRIX7_NV                     = 0x8637;
	static const auto GL_CURRENT_MATRIX_STACK_DEPTH_NV  = 0x8640;
	static const auto GL_CURRENT_MATRIX_NV              = 0x8641;
	static const auto GL_VERTEX_PROGRAM_POINT_SIZE_NV   = 0x8642;
	static const auto GL_VERTEX_PROGRAM_TWO_SIDE_NV     = 0x8643;
	static const auto GL_PROGRAM_PARAMETER_NV           = 0x8644;
	static const auto GL_ATTRIB_ARRAY_POINTER_NV        = 0x8645;
	static const auto GL_PROGRAM_TARGET_NV              = 0x8646;
	static const auto GL_PROGRAM_RESIDENT_NV            = 0x8647;
	static const auto GL_TRACK_MATRIX_NV                = 0x8648;
	static const auto GL_TRACK_MATRIX_TRANSFORM_NV      = 0x8649;
	static const auto GL_VERTEX_PROGRAM_BINDING_NV      = 0x864a;
	static const auto GL_PROGRAM_ERROR_POSITION_NV      = 0x864b;
	static const auto GL_VERTEX_ATTRIB_ARRAY0_NV        = 0x8650;
	static const auto GL_VERTEX_ATTRIB_ARRAY1_NV        = 0x8651;
	static const auto GL_VERTEX_ATTRIB_ARRAY2_NV        = 0x8652;
	static const auto GL_VERTEX_ATTRIB_ARRAY3_NV        = 0x8653;
	static const auto GL_VERTEX_ATTRIB_ARRAY4_NV        = 0x8654;
	static const auto GL_VERTEX_ATTRIB_ARRAY5_NV        = 0x8655;
	static const auto GL_VERTEX_ATTRIB_ARRAY6_NV        = 0x8656;
	static const auto GL_VERTEX_ATTRIB_ARRAY7_NV        = 0x8657;
	static const auto GL_VERTEX_ATTRIB_ARRAY8_NV        = 0x8658;
	static const auto GL_VERTEX_ATTRIB_ARRAY9_NV        = 0x8659;
	static const auto GL_VERTEX_ATTRIB_ARRAY10_NV       = 0x865a;
	static const auto GL_VERTEX_ATTRIB_ARRAY11_NV       = 0x865b;
	static const auto GL_VERTEX_ATTRIB_ARRAY12_NV       = 0x865c;
	static const auto GL_VERTEX_ATTRIB_ARRAY13_NV       = 0x865d;
	static const auto GL_VERTEX_ATTRIB_ARRAY14_NV       = 0x865e;
	static const auto GL_VERTEX_ATTRIB_ARRAY15_NV       = 0x865f;
	static const auto GL_MAP1_VERTEX_ATTRIB0_4_NV       = 0x8660;
	static const auto GL_MAP1_VERTEX_ATTRIB1_4_NV       = 0x8661;
	static const auto GL_MAP1_VERTEX_ATTRIB2_4_NV       = 0x8662;
	static const auto GL_MAP1_VERTEX_ATTRIB3_4_NV       = 0x8663;
	static const auto GL_MAP1_VERTEX_ATTRIB4_4_NV       = 0x8664;
	static const auto GL_MAP1_VERTEX_ATTRIB5_4_NV       = 0x8665;
	static const auto GL_MAP1_VERTEX_ATTRIB6_4_NV       = 0x8666;
	static const auto GL_MAP1_VERTEX_ATTRIB7_4_NV       = 0x8667;
	static const auto GL_MAP1_VERTEX_ATTRIB8_4_NV       = 0x8668;
	static const auto GL_MAP1_VERTEX_ATTRIB9_4_NV       = 0x8669;
	static const auto GL_MAP1_VERTEX_ATTRIB10_4_NV      = 0x866a;
	static const auto GL_MAP1_VERTEX_ATTRIB11_4_NV      = 0x866b;
	static const auto GL_MAP1_VERTEX_ATTRIB12_4_NV      = 0x866c;
	static const auto GL_MAP1_VERTEX_ATTRIB13_4_NV      = 0x866d;
	static const auto GL_MAP1_VERTEX_ATTRIB14_4_NV      = 0x866e;
	static const auto GL_MAP1_VERTEX_ATTRIB15_4_NV      = 0x866f;
	static const auto GL_MAP2_VERTEX_ATTRIB0_4_NV       = 0x8670;
	static const auto GL_MAP2_VERTEX_ATTRIB1_4_NV       = 0x8671;
	static const auto GL_MAP2_VERTEX_ATTRIB2_4_NV       = 0x8672;
	static const auto GL_MAP2_VERTEX_ATTRIB3_4_NV       = 0x8673;
	static const auto GL_MAP2_VERTEX_ATTRIB4_4_NV       = 0x8674;
	static const auto GL_MAP2_VERTEX_ATTRIB5_4_NV       = 0x8675;
	static const auto GL_MAP2_VERTEX_ATTRIB6_4_NV       = 0x8676;
	static const auto GL_MAP2_VERTEX_ATTRIB7_4_NV       = 0x8677;
	static const auto GL_MAP2_VERTEX_ATTRIB8_4_NV       = 0x8678;
	static const auto GL_MAP2_VERTEX_ATTRIB9_4_NV       = 0x8679;
	static const auto GL_MAP2_VERTEX_ATTRIB10_4_NV      = 0x867a;
	static const auto GL_MAP2_VERTEX_ATTRIB11_4_NV      = 0x867b;
	static const auto GL_MAP2_VERTEX_ATTRIB12_4_NV      = 0x867c;
	static const auto GL_MAP2_VERTEX_ATTRIB13_4_NV      = 0x867d;
	static const auto GL_MAP2_VERTEX_ATTRIB14_4_NV      = 0x867e;
	static const auto GL_MAP2_VERTEX_ATTRIB15_4_NV      = 0x867f;
}

version(GL_SGIX_texture_coordinate_clamp) {
}
else {
	static const auto GL_TEXTURE_MAX_CLAMP_S_SGIX       = 0x8369;
	static const auto GL_TEXTURE_MAX_CLAMP_T_SGIX       = 0x836a;
	static const auto GL_TEXTURE_MAX_CLAMP_R_SGIX       = 0x836b;
}

version(GL_SGIX_scalebias_hint) {
}
else {
	static const auto GL_SCALEBIAS_HINT_SGIX            = 0x8322;
}

version(GL_OML_interlace) {
}
else {
	static const auto GL_INTERLACE_OML                  = 0x8980;
	static const auto GL_INTERLACE_READ_OML             = 0x8981;
}

version(GL_OML_subsample) {
}
else {
	static const auto GL_FORMAT_SUBSAMPLE_24_24_OML     = 0x8982;
	static const auto GL_FORMAT_SUBSAMPLE_244_244_OML   = 0x8983;
}

version(GL_OML_resample) {
}
else {
	static const auto GL_PACK_RESAMPLE_OML              = 0x8984;
	static const auto GL_UNPACK_RESAMPLE_OML            = 0x8985;
	static const auto GL_RESAMPLE_REPLICATE_OML         = 0x8986;
	static const auto GL_RESAMPLE_ZERO_FILL_OML         = 0x8987;
	static const auto GL_RESAMPLE_AVERAGE_OML           = 0x8988;
	static const auto GL_RESAMPLE_DECIMATE_OML          = 0x8989;
}

version(GL_NV_copy_depth_to_color) {
}
else {
	static const auto GL_DEPTH_STENCIL_TO_RGBA_NV       = 0x886e;
	static const auto GL_DEPTH_STENCIL_TO_BGRA_NV       = 0x886f;
}

version(GL_ATI_envmap_bumpmap) {
}
else {
	static const auto GL_BUMP_ROT_MATRIX_ATI            = 0x8775;
	static const auto GL_BUMP_ROT_MATRIX_SIZE_ATI       = 0x8776;
	static const auto GL_BUMP_NUM_TEX_UNITS_ATI         = 0x8777;
	static const auto GL_BUMP_TEX_UNITS_ATI             = 0x8778;
	static const auto GL_DUDV_ATI                       = 0x8779;
	static const auto GL_DU8DV8_ATI                     = 0x877a;
	static const auto GL_BUMP_ENVMAP_ATI                = 0x877b;
	static const auto GL_BUMP_TARGET_ATI                = 0x877c;
}

version(GL_ATI_fragment_shader) {
}
else {
	static const auto GL_FRAGMENT_SHADER_ATI            = 0x8920;
	static const auto GL_REG_0_ATI                      = 0x8921;
	static const auto GL_REG_1_ATI                      = 0x8922;
	static const auto GL_REG_2_ATI                      = 0x8923;
	static const auto GL_REG_3_ATI                      = 0x8924;
	static const auto GL_REG_4_ATI                      = 0x8925;
	static const auto GL_REG_5_ATI                      = 0x8926;
	static const auto GL_REG_6_ATI                      = 0x8927;
	static const auto GL_REG_7_ATI                      = 0x8928;
	static const auto GL_REG_8_ATI                      = 0x8929;
	static const auto GL_REG_9_ATI                      = 0x892a;
	static const auto GL_REG_10_ATI                     = 0x892b;
	static const auto GL_REG_11_ATI                     = 0x892c;
	static const auto GL_REG_12_ATI                     = 0x892d;
	static const auto GL_REG_13_ATI                     = 0x892e;
	static const auto GL_REG_14_ATI                     = 0x892f;
	static const auto GL_REG_15_ATI                     = 0x8930;
	static const auto GL_REG_16_ATI                     = 0x8931;
	static const auto GL_REG_17_ATI                     = 0x8932;
	static const auto GL_REG_18_ATI                     = 0x8933;
	static const auto GL_REG_19_ATI                     = 0x8934;
	static const auto GL_REG_20_ATI                     = 0x8935;
	static const auto GL_REG_21_ATI                     = 0x8936;
	static const auto GL_REG_22_ATI                     = 0x8937;
	static const auto GL_REG_23_ATI                     = 0x8938;
	static const auto GL_REG_24_ATI                     = 0x8939;
	static const auto GL_REG_25_ATI                     = 0x893a;
	static const auto GL_REG_26_ATI                     = 0x893b;
	static const auto GL_REG_27_ATI                     = 0x893c;
	static const auto GL_REG_28_ATI                     = 0x893d;
	static const auto GL_REG_29_ATI                     = 0x893e;
	static const auto GL_REG_30_ATI                     = 0x893f;
	static const auto GL_REG_31_ATI                     = 0x8940;
	static const auto GL_CON_0_ATI                      = 0x8941;
	static const auto GL_CON_1_ATI                      = 0x8942;
	static const auto GL_CON_2_ATI                      = 0x8943;
	static const auto GL_CON_3_ATI                      = 0x8944;
	static const auto GL_CON_4_ATI                      = 0x8945;
	static const auto GL_CON_5_ATI                      = 0x8946;
	static const auto GL_CON_6_ATI                      = 0x8947;
	static const auto GL_CON_7_ATI                      = 0x8948;
	static const auto GL_CON_8_ATI                      = 0x8949;
	static const auto GL_CON_9_ATI                      = 0x894a;
	static const auto GL_CON_10_ATI                     = 0x894b;
	static const auto GL_CON_11_ATI                     = 0x894c;
	static const auto GL_CON_12_ATI                     = 0x894d;
	static const auto GL_CON_13_ATI                     = 0x894e;
	static const auto GL_CON_14_ATI                     = 0x894f;
	static const auto GL_CON_15_ATI                     = 0x8950;
	static const auto GL_CON_16_ATI                     = 0x8951;
	static const auto GL_CON_17_ATI                     = 0x8952;
	static const auto GL_CON_18_ATI                     = 0x8953;
	static const auto GL_CON_19_ATI                     = 0x8954;
	static const auto GL_CON_20_ATI                     = 0x8955;
	static const auto GL_CON_21_ATI                     = 0x8956;
	static const auto GL_CON_22_ATI                     = 0x8957;
	static const auto GL_CON_23_ATI                     = 0x8958;
	static const auto GL_CON_24_ATI                     = 0x8959;
	static const auto GL_CON_25_ATI                     = 0x895a;
	static const auto GL_CON_26_ATI                     = 0x895b;
	static const auto GL_CON_27_ATI                     = 0x895c;
	static const auto GL_CON_28_ATI                     = 0x895d;
	static const auto GL_CON_29_ATI                     = 0x895e;
	static const auto GL_CON_30_ATI                     = 0x895f;
	static const auto GL_CON_31_ATI                     = 0x8960;
	static const auto GL_MOV_ATI                        = 0x8961;
	static const auto GL_ADD_ATI                        = 0x8963;
	static const auto GL_MUL_ATI                        = 0x8964;
	static const auto GL_SUB_ATI                        = 0x8965;
	static const auto GL_DOT3_ATI                       = 0x8966;
	static const auto GL_DOT4_ATI                       = 0x8967;
	static const auto GL_MAD_ATI                        = 0x8968;
	static const auto GL_LERP_ATI                       = 0x8969;
	static const auto GL_CND_ATI                        = 0x896a;
	static const auto GL_CND0_ATI                       = 0x896b;
	static const auto GL_DOT2_ADD_ATI                   = 0x896c;
	static const auto GL_SECONDARY_INTERPOLATOR_ATI     = 0x896d;
	static const auto GL_NUM_FRAGMENT_REGISTERS_ATI     = 0x896e;
	static const auto GL_NUM_FRAGMENT_CONSTANTS_ATI     = 0x896f;
	static const auto GL_NUM_PASSES_ATI                 = 0x8970;
	static const auto GL_NUM_INSTRUCTIONS_PER_PASS_ATI  = 0x8971;
	static const auto GL_NUM_INSTRUCTIONS_TOTAL_ATI     = 0x8972;
	static const auto GL_NUM_INPUT_INTERPOLATOR_COMPONENTS_ATI = 0x8973;
	static const auto GL_NUM_LOOPBACK_COMPONENTS_ATI    = 0x8974;
	static const auto GL_COLOR_ALPHA_PAIRING_ATI        = 0x8975;
	static const auto GL_SWIZZLE_STR_ATI                = 0x8976;
	static const auto GL_SWIZZLE_STQ_ATI                = 0x8977;
	static const auto GL_SWIZZLE_STR_DR_ATI             = 0x8978;
	static const auto GL_SWIZZLE_STQ_DQ_ATI             = 0x8979;
	static const auto GL_SWIZZLE_STRQ_ATI               = 0x897a;
	static const auto GL_SWIZZLE_STRQ_DQ_ATI            = 0x897b;
	static const auto GL_RED_BIT_ATI                    = 0x00000001;
	static const auto GL_GREEN_BIT_ATI                  = 0x00000002;
	static const auto GL_BLUE_BIT_ATI                   = 0x00000004;
	static const auto GL_2X_BIT_ATI                     = 0x00000001;
	static const auto GL_4X_BIT_ATI                     = 0x00000002;
	static const auto GL_8X_BIT_ATI                     = 0x00000004;
	static const auto GL_HALF_BIT_ATI                   = 0x00000008;
	static const auto GL_QUARTER_BIT_ATI                = 0x00000010;
	static const auto GL_EIGHTH_BIT_ATI                 = 0x00000020;
	static const auto GL_SATURATE_BIT_ATI               = 0x00000040;
	static const auto GL_COMP_BIT_ATI                   = 0x00000002;
	static const auto GL_NEGATE_BIT_ATI                 = 0x00000004;
	static const auto GL_BIAS_BIT_ATI                   = 0x00000008;
}

version(GL_ATI_pn_triangles) {
}
else {
	static const auto GL_PN_TRIANGLES_ATI               = 0x87F0;
	static const auto GL_MAX_PN_TRIANGLES_TESSELATION_LEVEL_ATI = 0x87F1;
	static const auto GL_PN_TRIANGLES_POINT_MODE_ATI    = 0x87F2;
	static const auto GL_PN_TRIANGLES_NORMAL_MODE_ATI   = 0x87F3;
	static const auto GL_PN_TRIANGLES_TESSELATION_LEVEL_ATI = 0x87F4;
	static const auto GL_PN_TRIANGLES_POINT_MODE_LINEAR_ATI = 0x87F5;
	static const auto GL_PN_TRIANGLES_POINT_MODE_CUBIC_ATI = 0x87F6;
	static const auto GL_PN_TRIANGLES_NORMAL_MODE_LINEAR_ATI = 0x87F7;
	static const auto GL_PN_TRIANGLES_NORMAL_MODE_QUADRATIC_ATI = 0x87F8;
}

version(GL_ATI_vertex_array_object) {
}
else {
	static const auto GL_STATIC_ATI                     = 0x8760;
	static const auto GL_DYNAMIC_ATI                    = 0x8761;
	static const auto GL_PRESERVE_ATI                   = 0x8762;
	static const auto GL_DISCARD_ATI                    = 0x8763;
	static const auto GL_OBJECT_BUFFER_SIZE_ATI         = 0x8764;
	static const auto GL_OBJECT_BUFFER_USAGE_ATI        = 0x8765;
	static const auto GL_ARRAY_OBJECT_BUFFER_ATI        = 0x8766;
	static const auto GL_ARRAY_OBJECT_OFFSET_ATI        = 0x8767;
}

version(GL_EXT_vertex_shader) {
}
else {
	static const auto GL_VERTEX_SHADER_EXT              = 0x8780;
	static const auto GL_VERTEX_SHADER_BINDING_EXT      = 0x8781;
	static const auto GL_OP_INDEX_EXT                   = 0x8782;
	static const auto GL_OP_NEGATE_EXT                  = 0x8783;
	static const auto GL_OP_DOT3_EXT                    = 0x8784;
	static const auto GL_OP_DOT4_EXT                    = 0x8785;
	static const auto GL_OP_MUL_EXT                     = 0x8786;
	static const auto GL_OP_ADD_EXT                     = 0x8787;
	static const auto GL_OP_MADD_EXT                    = 0x8788;
	static const auto GL_OP_FRAC_EXT                    = 0x8789;
	static const auto GL_OP_MAX_EXT                     = 0x878a;
	static const auto GL_OP_MIN_EXT                     = 0x878b;
	static const auto GL_OP_SET_GE_EXT                  = 0x878c;
	static const auto GL_OP_SET_LT_EXT                  = 0x878d;
	static const auto GL_OP_CLAMP_EXT                   = 0x878e;
	static const auto GL_OP_FLOOR_EXT                   = 0x878f;
	static const auto GL_OP_ROUND_EXT                   = 0x8790;
	static const auto GL_OP_EXP_BASE_2_EXT              = 0x8791;
	static const auto GL_OP_LOG_BASE_2_EXT              = 0x8792;
	static const auto GL_OP_POWER_EXT                   = 0x8793;
	static const auto GL_OP_RECIP_EXT                   = 0x8794;
	static const auto GL_OP_RECIP_SQRT_EXT              = 0x8795;
	static const auto GL_OP_SUB_EXT                     = 0x8796;
	static const auto GL_OP_CROSS_PRODUCT_EXT           = 0x8797;
	static const auto GL_OP_MULTIPLY_MATRIX_EXT         = 0x8798;
	static const auto GL_OP_MOV_EXT                     = 0x8799;
	static const auto GL_OUTPUT_VERTEX_EXT              = 0x879a;
	static const auto GL_OUTPUT_COLOR0_EXT              = 0x879b;
	static const auto GL_OUTPUT_COLOR1_EXT              = 0x879c;
	static const auto GL_OUTPUT_TEXTURE_COORD0_EXT      = 0x879d;
	static const auto GL_OUTPUT_TEXTURE_COORD1_EXT      = 0x879e;
	static const auto GL_OUTPUT_TEXTURE_COORD2_EXT      = 0x879f;
	static const auto GL_OUTPUT_TEXTURE_COORD3_EXT      = 0x87A0;
	static const auto GL_OUTPUT_TEXTURE_COORD4_EXT      = 0x87A1;
	static const auto GL_OUTPUT_TEXTURE_COORD5_EXT      = 0x87A2;
	static const auto GL_OUTPUT_TEXTURE_COORD6_EXT      = 0x87A3;
	static const auto GL_OUTPUT_TEXTURE_COORD7_EXT      = 0x87A4;
	static const auto GL_OUTPUT_TEXTURE_COORD8_EXT      = 0x87A5;
	static const auto GL_OUTPUT_TEXTURE_COORD9_EXT      = 0x87A6;
	static const auto GL_OUTPUT_TEXTURE_COORD10_EXT     = 0x87A7;
	static const auto GL_OUTPUT_TEXTURE_COORD11_EXT     = 0x87A8;
	static const auto GL_OUTPUT_TEXTURE_COORD12_EXT     = 0x87A9;
	static const auto GL_OUTPUT_TEXTURE_COORD13_EXT     = 0x87Aa;
	static const auto GL_OUTPUT_TEXTURE_COORD14_EXT     = 0x87Ab;
	static const auto GL_OUTPUT_TEXTURE_COORD15_EXT     = 0x87Ac;
	static const auto GL_OUTPUT_TEXTURE_COORD16_EXT     = 0x87Ad;
	static const auto GL_OUTPUT_TEXTURE_COORD17_EXT     = 0x87Ae;
	static const auto GL_OUTPUT_TEXTURE_COORD18_EXT     = 0x87Af;
	static const auto GL_OUTPUT_TEXTURE_COORD19_EXT     = 0x87B0;
	static const auto GL_OUTPUT_TEXTURE_COORD20_EXT     = 0x87B1;
	static const auto GL_OUTPUT_TEXTURE_COORD21_EXT     = 0x87B2;
	static const auto GL_OUTPUT_TEXTURE_COORD22_EXT     = 0x87B3;
	static const auto GL_OUTPUT_TEXTURE_COORD23_EXT     = 0x87B4;
	static const auto GL_OUTPUT_TEXTURE_COORD24_EXT     = 0x87B5;
	static const auto GL_OUTPUT_TEXTURE_COORD25_EXT     = 0x87B6;
	static const auto GL_OUTPUT_TEXTURE_COORD26_EXT     = 0x87B7;
	static const auto GL_OUTPUT_TEXTURE_COORD27_EXT     = 0x87B8;
	static const auto GL_OUTPUT_TEXTURE_COORD28_EXT     = 0x87B9;
	static const auto GL_OUTPUT_TEXTURE_COORD29_EXT     = 0x87Ba;
	static const auto GL_OUTPUT_TEXTURE_COORD30_EXT     = 0x87Bb;
	static const auto GL_OUTPUT_TEXTURE_COORD31_EXT     = 0x87Bc;
	static const auto GL_OUTPUT_FOG_EXT                 = 0x87Bd;
	static const auto GL_SCALAR_EXT                     = 0x87Be;
	static const auto GL_VECTOR_EXT                     = 0x87Bf;
	static const auto GL_MATRIX_EXT                     = 0x87C0;
	static const auto GL_VARIANT_EXT                    = 0x87C1;
	static const auto GL_INVARIANT_EXT                  = 0x87C2;
	static const auto GL_LOCAL_CONSTANT_EXT             = 0x87C3;
	static const auto GL_LOCAL_EXT                      = 0x87C4;
	static const auto GL_MAX_VERTEX_SHADER_INSTRUCTIONS_EXT = 0x87C5;
	static const auto GL_MAX_VERTEX_SHADER_VARIANTS_EXT = 0x87C6;
	static const auto GL_MAX_VERTEX_SHADER_INVARIANTS_EXT = 0x87C7;
	static const auto GL_MAX_VERTEX_SHADER_LOCAL_CONSTANTS_EXT = 0x87C8;
	static const auto GL_MAX_VERTEX_SHADER_LOCALS_EXT   = 0x87C9;
	static const auto GL_MAX_OPTIMIZED_VERTEX_SHADER_INSTRUCTIONS_EXT = 0x87Ca;
	static const auto GL_MAX_OPTIMIZED_VERTEX_SHADER_VARIANTS_EXT = 0x87Cb;
	static const auto GL_MAX_OPTIMIZED_VERTEX_SHADER_LOCAL_CONSTANTS_EXT = 0x87Cc;
	static const auto GL_MAX_OPTIMIZED_VERTEX_SHADER_INVARIANTS_EXT = 0x87Cd;
	static const auto GL_MAX_OPTIMIZED_VERTEX_SHADER_LOCALS_EXT = 0x87Ce;
	static const auto GL_VERTEX_SHADER_INSTRUCTIONS_EXT = 0x87Cf;
	static const auto GL_VERTEX_SHADER_VARIANTS_EXT     = 0x87D0;
	static const auto GL_VERTEX_SHADER_INVARIANTS_EXT   = 0x87D1;
	static const auto GL_VERTEX_SHADER_LOCAL_CONSTANTS_EXT = 0x87D2;
	static const auto GL_VERTEX_SHADER_LOCALS_EXT       = 0x87D3;
	static const auto GL_VERTEX_SHADER_OPTIMIZED_EXT    = 0x87D4;
	static const auto GL_X_EXT                          = 0x87D5;
	static const auto GL_Y_EXT                          = 0x87D6;
	static const auto GL_Z_EXT                          = 0x87D7;
	static const auto GL_W_EXT                          = 0x87D8;
	static const auto GL_NEGATIVE_X_EXT                 = 0x87D9;
	static const auto GL_NEGATIVE_Y_EXT                 = 0x87Da;
	static const auto GL_NEGATIVE_Z_EXT                 = 0x87Db;
	static const auto GL_NEGATIVE_W_EXT                 = 0x87Dc;
	static const auto GL_ZERO_EXT                       = 0x87Dd;
	static const auto GL_ONE_EXT                        = 0x87De;
	static const auto GL_NEGATIVE_ONE_EXT               = 0x87Df;
	static const auto GL_NORMALIZED_RANGE_EXT           = 0x87E0;
	static const auto GL_FULL_RANGE_EXT                 = 0x87E1;
	static const auto GL_CURRENT_VERTEX_EXT             = 0x87E2;
	static const auto GL_MVP_MATRIX_EXT                 = 0x87E3;
	static const auto GL_VARIANT_VALUE_EXT              = 0x87E4;
	static const auto GL_VARIANT_DATATYPE_EXT           = 0x87E5;
	static const auto GL_VARIANT_ARRAY_STRIDE_EXT       = 0x87E6;
	static const auto GL_VARIANT_ARRAY_TYPE_EXT         = 0x87E7;
	static const auto GL_VARIANT_ARRAY_EXT              = 0x87E8;
	static const auto GL_VARIANT_ARRAY_POINTER_EXT      = 0x87E9;
	static const auto GL_INVARIANT_VALUE_EXT            = 0x87Ea;
	static const auto GL_INVARIANT_DATATYPE_EXT         = 0x87Eb;
	static const auto GL_LOCAL_CONSTANT_VALUE_EXT       = 0x87Ec;
	static const auto GL_LOCAL_CONSTANT_DATATYPE_EXT    = 0x87Ed;
}

version(GL_ATI_vertex_streams) {
}
else {
	static const auto GL_MAX_VERTEX_STREAMS_ATI         = 0x876b;
	static const auto GL_VERTEX_STREAM0_ATI             = 0x876c;
	static const auto GL_VERTEX_STREAM1_ATI             = 0x876d;
	static const auto GL_VERTEX_STREAM2_ATI             = 0x876e;
	static const auto GL_VERTEX_STREAM3_ATI             = 0x876f;
	static const auto GL_VERTEX_STREAM4_ATI             = 0x8770;
	static const auto GL_VERTEX_STREAM5_ATI             = 0x8771;
	static const auto GL_VERTEX_STREAM6_ATI             = 0x8772;
	static const auto GL_VERTEX_STREAM7_ATI             = 0x8773;
	static const auto GL_VERTEX_SOURCE_ATI              = 0x8774;
}

version(GL_ATI_element_array) {
}
else {
	static const auto GL_ELEMENT_ARRAY_ATI              = 0x8768;
	static const auto GL_ELEMENT_ARRAY_TYPE_ATI         = 0x8769;
	static const auto GL_ELEMENT_ARRAY_POINTER_ATI      = 0x876a;
}

version(GL_SUN_mesh_array) {
}
else {
	static const auto GL_QUAD_MESH_SUN                  = 0x8614;
	static const auto GL_TRIANGLE_MESH_SUN              = 0x8615;
}

version(GL_SUN_slice_accum) {
}
else {
	static const auto GL_SLICE_ACCUM_SUN                = 0x85Cc;
}

version(GL_NV_multisample_filter_hint) {
}
else {
	static const auto GL_MULTISAMPLE_FILTER_HINT_NV     = 0x8534;
}

version(GL_NV_depth_clamp) {
}
else {
	static const auto GL_DEPTH_CLAMP_NV                 = 0x864f;
}

version(GL_NV_occlusion_query) {
}
else {
	static const auto GL_PIXEL_COUNTER_BITS_NV          = 0x8864;
	static const auto GL_CURRENT_OCCLUSION_QUERY_ID_NV  = 0x8865;
	static const auto GL_PIXEL_COUNT_NV                 = 0x8866;
	static const auto GL_PIXEL_COUNT_AVAILABLE_NV       = 0x8867;
}

version(GL_NV_point_sprite) {
}
else {
	static const auto GL_POINT_SPRITE_NV                = 0x8861;
	static const auto GL_COORD_REPLACE_NV               = 0x8862;
	static const auto GL_POINT_SPRITE_R_MODE_NV         = 0x8863;
}

version(GL_NV_texture_shader3) {
}
else {
	static const auto GL_OFFSET_PROJECTIVE_TEXTURE_2D_NV = 0x8850;
	static const auto GL_OFFSET_PROJECTIVE_TEXTURE_2D_SCALE_NV = 0x8851;
	static const auto GL_OFFSET_PROJECTIVE_TEXTURE_RECTANGLE_NV = 0x8852;
	static const auto GL_OFFSET_PROJECTIVE_TEXTURE_RECTANGLE_SCALE_NV = 0x8853;
	static const auto GL_OFFSET_HILO_TEXTURE_2D_NV      = 0x8854;
	static const auto GL_OFFSET_HILO_TEXTURE_RECTANGLE_NV = 0x8855;
	static const auto GL_OFFSET_HILO_PROJECTIVE_TEXTURE_2D_NV = 0x8856;
	static const auto GL_OFFSET_HILO_PROJECTIVE_TEXTURE_RECTANGLE_NV = 0x8857;
	static const auto GL_DEPENDENT_HILO_TEXTURE_2D_NV   = 0x8858;
	static const auto GL_DEPENDENT_RGB_TEXTURE_3D_NV    = 0x8859;
	static const auto GL_DEPENDENT_RGB_TEXTURE_CUBE_MAP_NV = 0x885a;
	static const auto GL_DOT_PRODUCT_PASS_THROUGH_NV    = 0x885b;
	static const auto GL_DOT_PRODUCT_TEXTURE_1D_NV      = 0x885c;
	static const auto GL_DOT_PRODUCT_AFFINE_DEPTH_REPLACE_NV = 0x885d;
	static const auto GL_HILO8_NV                       = 0x885e;
	static const auto GL_SIGNED_HILO8_NV                = 0x885f;
	static const auto GL_FORCE_BLUE_TO_ONE_NV           = 0x8860;
}

version(GL_NV_vertex_program1_1) {
}
else {
}

version(GL_EXT_shadow_funcs) {
}
else {
}

version(GL_EXT_stencil_two_side) {
}
else {
	static const auto GL_STENCIL_TEST_TWO_SIDE_EXT      = 0x8910;
	static const auto GL_ACTIVE_STENCIL_FACE_EXT        = 0x8911;
}

version(GL_ATI_text_fragment_shader) {
}
else {
	static const auto GL_TEXT_FRAGMENT_SHADER_ATI       = 0x8200;
}

version(GL_APPLE_client_storage) {
}
else {
	static const auto GL_UNPACK_CLIENT_STORAGE_APPLE    = 0x85B2;
}

version(GL_APPLE_element_array) {
}
else {
	static const auto GL_ELEMENT_ARRAY_APPLE            = 0x8A0c;
	static const auto GL_ELEMENT_ARRAY_TYPE_APPLE       = 0x8A0d;
	static const auto GL_ELEMENT_ARRAY_POINTER_APPLE    = 0x8A0e;
}

version(GL_APPLE_fence) {
}
else {
	static const auto GL_DRAW_PIXELS_APPLE              = 0x8A0a;
	static const auto GL_FENCE_APPLE                    = 0x8A0b;
}

version(GL_APPLE_vertex_array_object) {
}
else {
	static const auto GL_VERTEX_ARRAY_BINDING_APPLE     = 0x85B5;
}

version(GL_APPLE_vertex_array_range) {
}
else {
	static const auto GL_VERTEX_ARRAY_RANGE_APPLE       = 0x851d;
	static const auto GL_VERTEX_ARRAY_RANGE_LENGTH_APPLE = 0x851e;
	static const auto GL_VERTEX_ARRAY_STORAGE_HINT_APPLE = 0x851f;
	static const auto GL_VERTEX_ARRAY_RANGE_POINTER_APPLE = 0x8521;
	static const auto GL_STORAGE_CLIENT_APPLE           = 0x85B4;
	static const auto GL_STORAGE_CACHED_APPLE           = 0x85Be;
	static const auto GL_STORAGE_SHARED_APPLE           = 0x85Bf;
}

version(GL_APPLE_ycbcr_422) {
}
else {
	static const auto GL_YCBCR_422_APPLE                = 0x85B9;
	static const auto GL_UNSIGNED_SHORT_8_8_APPLE       = 0x85Ba;
	static const auto GL_UNSIGNED_SHORT_8_8_REV_APPLE   = 0x85Bb;
}

version(GL_S3_s3tc) {
}
else {
	static const auto GL_RGB_S3TC                       = 0x83A0;
	static const auto GL_RGB4_S3TC                      = 0x83A1;
	static const auto GL_RGBA_S3TC                      = 0x83A2;
	static const auto GL_RGBA4_S3TC                     = 0x83A3;
}

version(GL_ATI_draw_buffers) {
}
else {
	static const auto GL_MAX_DRAW_BUFFERS_ATI           = 0x8824;
	static const auto GL_DRAW_BUFFER0_ATI               = 0x8825;
	static const auto GL_DRAW_BUFFER1_ATI               = 0x8826;
	static const auto GL_DRAW_BUFFER2_ATI               = 0x8827;
	static const auto GL_DRAW_BUFFER3_ATI               = 0x8828;
	static const auto GL_DRAW_BUFFER4_ATI               = 0x8829;
	static const auto GL_DRAW_BUFFER5_ATI               = 0x882a;
	static const auto GL_DRAW_BUFFER6_ATI               = 0x882b;
	static const auto GL_DRAW_BUFFER7_ATI               = 0x882c;
	static const auto GL_DRAW_BUFFER8_ATI               = 0x882d;
	static const auto GL_DRAW_BUFFER9_ATI               = 0x882e;
	static const auto GL_DRAW_BUFFER10_ATI              = 0x882f;
	static const auto GL_DRAW_BUFFER11_ATI              = 0x8830;
	static const auto GL_DRAW_BUFFER12_ATI              = 0x8831;
	static const auto GL_DRAW_BUFFER13_ATI              = 0x8832;
	static const auto GL_DRAW_BUFFER14_ATI              = 0x8833;
	static const auto GL_DRAW_BUFFER15_ATI              = 0x8834;
}

version(GL_ATI_pixel_format_float) {
}
else {
	static const auto GL_TYPE_RGBA_FLOAT_ATI            = 0x8820;
	static const auto GL_COLOR_CLEAR_UNCLAMPED_VALUE_ATI = 0x8835;
}

version(GL_ATI_texture_env_combine3) {
}
else {
	static const auto GL_MODULATE_ADD_ATI               = 0x8744;
	static const auto GL_MODULATE_SIGNED_ADD_ATI        = 0x8745;
	static const auto GL_MODULATE_SUBTRACT_ATI          = 0x8746;
}

version(GL_ATI_texture_float) {
}
else {
	static const auto GL_RGBA_FLOAT32_ATI               = 0x8814;
	static const auto GL_RGB_FLOAT32_ATI                = 0x8815;
	static const auto GL_ALPHA_FLOAT32_ATI              = 0x8816;
	static const auto GL_INTENSITY_FLOAT32_ATI          = 0x8817;
	static const auto GL_LUMINANCE_FLOAT32_ATI          = 0x8818;
	static const auto GL_LUMINANCE_ALPHA_FLOAT32_ATI    = 0x8819;
	static const auto GL_RGBA_FLOAT16_ATI               = 0x881a;
	static const auto GL_RGB_FLOAT16_ATI                = 0x881b;
	static const auto GL_ALPHA_FLOAT16_ATI              = 0x881c;
	static const auto GL_INTENSITY_FLOAT16_ATI          = 0x881d;
	static const auto GL_LUMINANCE_FLOAT16_ATI          = 0x881e;
	static const auto GL_LUMINANCE_ALPHA_FLOAT16_ATI    = 0x881f;
}

version(GL_NV_float_buffer) {
}
else {
	static const auto GL_FLOAT_R_NV                     = 0x8880;
	static const auto GL_FLOAT_RG_NV                    = 0x8881;
	static const auto GL_FLOAT_RGB_NV                   = 0x8882;
	static const auto GL_FLOAT_RGBA_NV                  = 0x8883;
	static const auto GL_FLOAT_R16_NV                   = 0x8884;
	static const auto GL_FLOAT_R32_NV                   = 0x8885;
	static const auto GL_FLOAT_RG16_NV                  = 0x8886;
	static const auto GL_FLOAT_RG32_NV                  = 0x8887;
	static const auto GL_FLOAT_RGB16_NV                 = 0x8888;
	static const auto GL_FLOAT_RGB32_NV                 = 0x8889;
	static const auto GL_FLOAT_RGBA16_NV                = 0x888a;
	static const auto GL_FLOAT_RGBA32_NV                = 0x888b;
	static const auto GL_TEXTURE_FLOAT_COMPONENTS_NV    = 0x888c;
	static const auto GL_FLOAT_CLEAR_COLOR_VALUE_NV     = 0x888d;
	static const auto GL_FLOAT_RGBA_MODE_NV             = 0x888e;
}

version(GL_NV_fragment_program) {
}
else {
	static const auto GL_MAX_FRAGMENT_PROGRAM_LOCAL_PARAMETERS_NV = 0x8868;
	static const auto GL_FRAGMENT_PROGRAM_NV            = 0x8870;
	static const auto GL_MAX_TEXTURE_COORDS_NV          = 0x8871;
	static const auto GL_MAX_TEXTURE_IMAGE_UNITS_NV     = 0x8872;
	static const auto GL_FRAGMENT_PROGRAM_BINDING_NV    = 0x8873;
	static const auto GL_PROGRAM_ERROR_STRING_NV        = 0x8874;
}

version(GL_NV_half_float) {
}
else {
	static const auto GL_HALF_FLOAT_NV                  = 0x140b;
}

version(GL_NV_pixel_data_range) {
}
else {
	static const auto GL_WRITE_PIXEL_DATA_RANGE_NV      = 0x8878;
	static const auto GL_READ_PIXEL_DATA_RANGE_NV       = 0x8879;
	static const auto GL_WRITE_PIXEL_DATA_RANGE_LENGTH_NV = 0x887a;
	static const auto GL_READ_PIXEL_DATA_RANGE_LENGTH_NV = 0x887b;
	static const auto GL_WRITE_PIXEL_DATA_RANGE_POINTER_NV = 0x887c;
	static const auto GL_READ_PIXEL_DATA_RANGE_POINTER_NV = 0x887d;
}

version(GL_NV_primitive_restart) {
}
else {
	static const auto GL_PRIMITIVE_RESTART_NV           = 0x8558;
	static const auto GL_PRIMITIVE_RESTART_INDEX_NV     = 0x8559;
}

version(GL_NV_texture_expand_normal) {
}
else {
	static const auto GL_TEXTURE_UNSIGNED_REMAP_MODE_NV = 0x888f;
}

version(GL_NV_vertex_program2) {
}
else {
}

version(GL_ATI_map_object_buffer) {
}
else {
}

version(GL_ATI_separate_stencil) {
}
else {
	static const auto GL_STENCIL_BACK_FUNC_ATI          = 0x8800;
	static const auto GL_STENCIL_BACK_FAIL_ATI          = 0x8801;
	static const auto GL_STENCIL_BACK_PASS_DEPTH_FAIL_ATI = 0x8802;
	static const auto GL_STENCIL_BACK_PASS_DEPTH_PASS_ATI = 0x8803;
}

version(GL_ATI_vertex_attrib_array_object) {
}
else {
}

version(GL_OES_read_format) {
}
else {
	static const auto GL_IMPLEMENTATION_COLOR_READ_TYPE_OES = 0x8B9a;
	static const auto GL_IMPLEMENTATION_COLOR_READ_FORMAT_OES = 0x8B9b;
}

version(GL_EXT_depth_bounds_test) {
}
else {
	static const auto GL_DEPTH_BOUNDS_TEST_EXT          = 0x8890;
	static const auto GL_DEPTH_BOUNDS_EXT               = 0x8891;
}

version(GL_EXT_texture_mirror_clamp) {
}
else {
	static const auto GL_MIRROR_CLAMP_EXT               = 0x8742;
	static const auto GL_MIRROR_CLAMP_TO_EDGE_EXT       = 0x8743;
	static const auto GL_MIRROR_CLAMP_TO_BORDER_EXT     = 0x8912;
}

version(GL_EXT_blend_equation_separate) {
}
else {
	static const auto GL_BLEND_EQUATION_RGB_EXT         = 0x8009;
	static const auto GL_BLEND_EQUATION_ALPHA_EXT       = 0x883d;
}

version(GL_MESA_pack_invert) {
}
else {
	static const auto GL_PACK_INVERT_MESA               = 0x8758;
}

version(GL_MESA_ycbcr_texture) {
}
else {
	static const auto GL_UNSIGNED_SHORT_8_8_MESA        = 0x85Ba;
	static const auto GL_UNSIGNED_SHORT_8_8_REV_MESA    = 0x85Bb;
	static const auto GL_YCBCR_MESA                     = 0x8757;
}

version(GL_EXT_pixel_buffer_object) {
}
else {
	static const auto GL_PIXEL_PACK_BUFFER_EXT          = 0x88Eb;
	static const auto GL_PIXEL_UNPACK_BUFFER_EXT        = 0x88Ec;
	static const auto GL_PIXEL_PACK_BUFFER_BINDING_EXT  = 0x88Ed;
	static const auto GL_PIXEL_UNPACK_BUFFER_BINDING_EXT = 0x88Ef;
}

version(GL_NV_fragment_program_option) {
}
else {
}

version(GL_NV_fragment_program2) {
}
else {
	static const auto GL_MAX_PROGRAM_EXEC_INSTRUCTIONS_NV = 0x88F4;
	static const auto GL_MAX_PROGRAM_CALL_DEPTH_NV      = 0x88F5;
	static const auto GL_MAX_PROGRAM_IF_DEPTH_NV        = 0x88F6;
	static const auto GL_MAX_PROGRAM_LOOP_DEPTH_NV      = 0x88F7;
	static const auto GL_MAX_PROGRAM_LOOP_COUNT_NV      = 0x88F8;
}

version(GL_NV_vertex_program2_option) {
}
else {
	/* reuse GL_MAX_PROGRAM_EXEC_INSTRUCTIONS_NV */
	/* reuse GL_MAX_PROGRAM_CALL_DEPTH_NV */
}

version(GL_NV_vertex_program3) {
}
else {
	/* reuse GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS_ARB */
}

version(GL_EXT_framebuffer_object) {
}
else {
	static const auto GL_INVALID_FRAMEBUFFER_OPERATION_EXT = 0x0506;
	static const auto GL_MAX_RENDERBUFFER_SIZE_EXT      = 0x84E8;
	static const auto GL_FRAMEBUFFER_BINDING_EXT        = 0x8CA6;
	static const auto GL_RENDERBUFFER_BINDING_EXT       = 0x8CA7;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE_EXT = 0x8CD0;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT = 0x8CD1;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT = 0x8CD2;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE_EXT = 0x8CD3;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_3D_ZOFFSET_EXT = 0x8CD4;
	static const auto GL_FRAMEBUFFER_COMPLETE_EXT       = 0x8CD5;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT = 0x8CD6;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT = 0x8CD7;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT = 0x8CD9;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT = 0x8CDa;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT = 0x8CDb;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT = 0x8CDc;
	static const auto GL_FRAMEBUFFER_UNSUPPORTED_EXT    = 0x8CDd;
	static const auto GL_MAX_COLOR_ATTACHMENTS_EXT      = 0x8CDf;
	static const auto GL_COLOR_ATTACHMENT0_EXT          = 0x8CE0;
	static const auto GL_COLOR_ATTACHMENT1_EXT          = 0x8CE1;
	static const auto GL_COLOR_ATTACHMENT2_EXT          = 0x8CE2;
	static const auto GL_COLOR_ATTACHMENT3_EXT          = 0x8CE3;
	static const auto GL_COLOR_ATTACHMENT4_EXT          = 0x8CE4;
	static const auto GL_COLOR_ATTACHMENT5_EXT          = 0x8CE5;
	static const auto GL_COLOR_ATTACHMENT6_EXT          = 0x8CE6;
	static const auto GL_COLOR_ATTACHMENT7_EXT          = 0x8CE7;
	static const auto GL_COLOR_ATTACHMENT8_EXT          = 0x8CE8;
	static const auto GL_COLOR_ATTACHMENT9_EXT          = 0x8CE9;
	static const auto GL_COLOR_ATTACHMENT10_EXT         = 0x8CEa;
	static const auto GL_COLOR_ATTACHMENT11_EXT         = 0x8CEb;
	static const auto GL_COLOR_ATTACHMENT12_EXT         = 0x8CEc;
	static const auto GL_COLOR_ATTACHMENT13_EXT         = 0x8CEd;
	static const auto GL_COLOR_ATTACHMENT14_EXT         = 0x8CEe;
	static const auto GL_COLOR_ATTACHMENT15_EXT         = 0x8CEf;
	static const auto GL_DEPTH_ATTACHMENT_EXT           = 0x8D00;
	static const auto GL_STENCIL_ATTACHMENT_EXT         = 0x8D20;
	static const auto GL_FRAMEBUFFER_EXT                = 0x8D40;
	static const auto GL_RENDERBUFFER_EXT               = 0x8D41;
	static const auto GL_RENDERBUFFER_WIDTH_EXT         = 0x8D42;
	static const auto GL_RENDERBUFFER_HEIGHT_EXT        = 0x8D43;
	static const auto GL_RENDERBUFFER_INTERNAL_FORMAT_EXT = 0x8D44;
	static const auto GL_STENCIL_INDEX1_EXT             = 0x8D46;
	static const auto GL_STENCIL_INDEX4_EXT             = 0x8D47;
	static const auto GL_STENCIL_INDEX8_EXT             = 0x8D48;
	static const auto GL_STENCIL_INDEX16_EXT            = 0x8D49;
	static const auto GL_RENDERBUFFER_RED_SIZE_EXT      = 0x8D50;
	static const auto GL_RENDERBUFFER_GREEN_SIZE_EXT    = 0x8D51;
	static const auto GL_RENDERBUFFER_BLUE_SIZE_EXT     = 0x8D52;
	static const auto GL_RENDERBUFFER_ALPHA_SIZE_EXT    = 0x8D53;
	static const auto GL_RENDERBUFFER_DEPTH_SIZE_EXT    = 0x8D54;
	static const auto GL_RENDERBUFFER_STENCIL_SIZE_EXT  = 0x8D55;
}

version(GL_GREMEDY_string_marker) {
}
else {
}

version(GL_EXT_packed_depth_stencil) {
}
else {
	static const auto GL_DEPTH_STENCIL_EXT              = 0x84F9;
	static const auto GL_UNSIGNED_INT_24_8_EXT          = 0x84Fa;
	static const auto GL_DEPTH24_STENCIL8_EXT           = 0x88F0;
	static const auto GL_TEXTURE_STENCIL_SIZE_EXT       = 0x88F1;
}

version(GL_EXT_stencil_clear_tag) {
}
else {
	static const auto GL_STENCIL_TAG_BITS_EXT           = 0x88F2;
	static const auto GL_STENCIL_CLEAR_TAG_VALUE_EXT    = 0x88F3;
}

version(GL_EXT_texture_sRGB) {
}
else {
	static const auto GL_SRGB_EXT                       = 0x8C40;
	static const auto GL_SRGB8_EXT                      = 0x8C41;
	static const auto GL_SRGB_ALPHA_EXT                 = 0x8C42;
	static const auto GL_SRGB8_ALPHA8_EXT               = 0x8C43;
	static const auto GL_SLUMINANCE_ALPHA_EXT           = 0x8C44;
	static const auto GL_SLUMINANCE8_ALPHA8_EXT         = 0x8C45;
	static const auto GL_SLUMINANCE_EXT                 = 0x8C46;
	static const auto GL_SLUMINANCE8_EXT                = 0x8C47;
	static const auto GL_COMPRESSED_SRGB_EXT            = 0x8C48;
	static const auto GL_COMPRESSED_SRGB_ALPHA_EXT      = 0x8C49;
	static const auto GL_COMPRESSED_SLUMINANCE_EXT      = 0x8C4a;
	static const auto GL_COMPRESSED_SLUMINANCE_ALPHA_EXT = 0x8C4b;
	static const auto GL_COMPRESSED_SRGB_S3TC_DXT1_EXT  = 0x8C4c;
	static const auto GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT1_EXT = 0x8C4d;
	static const auto GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT = 0x8C4e;
	static const auto GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT = 0x8C4f;
}

version(GL_EXT_framebuffer_blit) {
}
else {
	static const auto GL_READ_FRAMEBUFFER_EXT           = 0x8CA8;
	static const auto GL_DRAW_FRAMEBUFFER_EXT           = 0x8CA9;
	static const auto GL_DRAW_FRAMEBUFFER_BINDING_EXT   = GL_FRAMEBUFFER_BINDING_EXT;
	static const auto GL_READ_FRAMEBUFFER_BINDING_EXT   = 0x8CAa;
}

version(GL_EXT_framebuffer_multisample) {
}
else {
	static const auto GL_RENDERBUFFER_SAMPLES_EXT       = 0x8CAb;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_EXT = 0x8D56;
	static const auto GL_MAX_SAMPLES_EXT                = 0x8D57;
}

version(GL_MESAX_texture_stack) {
}
else {
	static const auto GL_TEXTURE_1D_STACK_MESAX         = 0x8759;
	static const auto GL_TEXTURE_2D_STACK_MESAX         = 0x875a;
	static const auto GL_PROXY_TEXTURE_1D_STACK_MESAX   = 0x875b;
	static const auto GL_PROXY_TEXTURE_2D_STACK_MESAX   = 0x875c;
	static const auto GL_TEXTURE_1D_STACK_BINDING_MESAX = 0x875d;
	static const auto GL_TEXTURE_2D_STACK_BINDING_MESAX = 0x875e;
}

version(GL_EXT_timer_query) {
}
else {
	static const auto GL_TIME_ELAPSED_EXT               = 0x88Bf;
}

version(GL_EXT_gpu_program_parameters) {
}
else {
}

version(GL_APPLE_flush_buffer_range) {
}
else {
	static const auto GL_BUFFER_SERIALIZED_MODIFY_APPLE = 0x8A12;
	static const auto GL_BUFFER_FLUSHING_UNMAP_APPLE    = 0x8A13;
}

version(GL_NV_gpu_program4) {
}
else {
	static const auto GL_MIN_PROGRAM_TEXEL_OFFSET_NV    = 0x8904;
	static const auto GL_MAX_PROGRAM_TEXEL_OFFSET_NV    = 0x8905;
	static const auto GL_PROGRAM_ATTRIB_COMPONENTS_NV   = 0x8906;
	static const auto GL_PROGRAM_RESULT_COMPONENTS_NV   = 0x8907;
	static const auto GL_MAX_PROGRAM_ATTRIB_COMPONENTS_NV = 0x8908;
	static const auto GL_MAX_PROGRAM_RESULT_COMPONENTS_NV = 0x8909;
	static const auto GL_MAX_PROGRAM_GENERIC_ATTRIBS_NV = 0x8DA5;
	static const auto GL_MAX_PROGRAM_GENERIC_RESULTS_NV = 0x8DA6;
}

version(GL_NV_geometry_program4) {
}
else {
	static const auto GL_LINES_ADJACENCY_EXT            = 0x000a;
	static const auto GL_LINE_STRIP_ADJACENCY_EXT       = 0x000b;
	static const auto GL_TRIANGLES_ADJACENCY_EXT        = 0x000c;
	static const auto GL_TRIANGLE_STRIP_ADJACENCY_EXT   = 0x000d;
	static const auto GL_GEOMETRY_PROGRAM_NV            = 0x8C26;
	static const auto GL_MAX_PROGRAM_OUTPUT_VERTICES_NV = 0x8C27;
	static const auto GL_MAX_PROGRAM_TOTAL_OUTPUT_COMPONENTS_NV = 0x8C28;
	static const auto GL_GEOMETRY_VERTICES_OUT_EXT      = 0x8DDa;
	static const auto GL_GEOMETRY_INPUT_TYPE_EXT        = 0x8DDb;
	static const auto GL_GEOMETRY_OUTPUT_TYPE_EXT       = 0x8DDc;
	static const auto GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_EXT = 0x8C29;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_LAYERED_EXT = 0x8DA7;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_EXT = 0x8DA8;
	static const auto GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_EXT = 0x8DA9;
	static const auto GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT = 0x8CD4;
	static const auto GL_PROGRAM_POINT_SIZE_EXT         = 0x8642;
}

version(GL_EXT_geometry_shader4) {
}
else {
	static const auto GL_GEOMETRY_SHADER_EXT            = 0x8DD9;
	/* reuse GL_GEOMETRY_VERTICES_OUT_EXT */
	/* reuse GL_GEOMETRY_INPUT_TYPE_EXT */
	/* reuse GL_GEOMETRY_OUTPUT_TYPE_EXT */
	/* reuse GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_EXT */
	static const auto GL_MAX_GEOMETRY_VARYING_COMPONENTS_EXT = 0x8DDd;
	static const auto GL_MAX_VERTEX_VARYING_COMPONENTS_EXT = 0x8DDe;
	static const auto GL_MAX_VARYING_COMPONENTS_EXT     = 0x8B4b;
	static const auto GL_MAX_GEOMETRY_UNIFORM_COMPONENTS_EXT = 0x8DDf;
	static const auto GL_MAX_GEOMETRY_OUTPUT_VERTICES_EXT = 0x8DE0;
	static const auto GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS_EXT = 0x8DE1;
	/* reuse GL_LINES_ADJACENCY_EXT */
	/* reuse GL_LINE_STRIP_ADJACENCY_EXT */
	/* reuse GL_TRIANGLES_ADJACENCY_EXT */
	/* reuse GL_TRIANGLE_STRIP_ADJACENCY_EXT */
	/* reuse GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_EXT */
	/* reuse GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_EXT */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_LAYERED_EXT */
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT */
	/* reuse GL_PROGRAM_POINT_SIZE_EXT */
}

version(GL_NV_vertex_program4) {
}
else {
	static const auto GL_VERTEX_ATTRIB_ARRAY_INTEGER_NV = 0x88Fd;
}

version(GL_EXT_gpu_shader4) {
}
else {
	static const auto GL_SAMPLER_1D_ARRAY_EXT           = 0x8DC0;
	static const auto GL_SAMPLER_2D_ARRAY_EXT           = 0x8DC1;
	static const auto GL_SAMPLER_BUFFER_EXT             = 0x8DC2;
	static const auto GL_SAMPLER_1D_ARRAY_SHADOW_EXT    = 0x8DC3;
	static const auto GL_SAMPLER_2D_ARRAY_SHADOW_EXT    = 0x8DC4;
	static const auto GL_SAMPLER_CUBE_SHADOW_EXT        = 0x8DC5;
	static const auto GL_UNSIGNED_INT_VEC2_EXT          = 0x8DC6;
	static const auto GL_UNSIGNED_INT_VEC3_EXT          = 0x8DC7;
	static const auto GL_UNSIGNED_INT_VEC4_EXT          = 0x8DC8;
	static const auto GL_INT_SAMPLER_1D_EXT             = 0x8DC9;
	static const auto GL_INT_SAMPLER_2D_EXT             = 0x8DCa;
	static const auto GL_INT_SAMPLER_3D_EXT             = 0x8DCb;
	static const auto GL_INT_SAMPLER_CUBE_EXT           = 0x8DCc;
	static const auto GL_INT_SAMPLER_2D_RECT_EXT        = 0x8DCd;
	static const auto GL_INT_SAMPLER_1D_ARRAY_EXT       = 0x8DCe;
	static const auto GL_INT_SAMPLER_2D_ARRAY_EXT       = 0x8DCf;
	static const auto GL_INT_SAMPLER_BUFFER_EXT         = 0x8DD0;
	static const auto GL_UNSIGNED_INT_SAMPLER_1D_EXT    = 0x8DD1;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D_EXT    = 0x8DD2;
	static const auto GL_UNSIGNED_INT_SAMPLER_3D_EXT    = 0x8DD3;
	static const auto GL_UNSIGNED_INT_SAMPLER_CUBE_EXT  = 0x8DD4;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D_RECT_EXT = 0x8DD5;
	static const auto GL_UNSIGNED_INT_SAMPLER_1D_ARRAY_EXT = 0x8DD6;
	static const auto GL_UNSIGNED_INT_SAMPLER_2D_ARRAY_EXT = 0x8DD7;
	static const auto GL_UNSIGNED_INT_SAMPLER_BUFFER_EXT = 0x8DD8;
}

version(GL_EXT_draw_instanced) {
}
else {
}

version(GL_EXT_packed_float) {
}
else {
	static const auto GL_R11F_G11F_B10F_EXT             = 0x8C3a;
	static const auto GL_UNSIGNED_INT_10F_11F_11F_REV_EXT = 0x8C3b;
	static const auto GL_RGBA_SIGNED_COMPONENTS_EXT     = 0x8C3c;
}

version(GL_EXT_texture_array) {
}
else {
	static const auto GL_TEXTURE_1D_ARRAY_EXT           = 0x8C18;
	static const auto GL_PROXY_TEXTURE_1D_ARRAY_EXT     = 0x8C19;
	static const auto GL_TEXTURE_2D_ARRAY_EXT           = 0x8C1a;
	static const auto GL_PROXY_TEXTURE_2D_ARRAY_EXT     = 0x8C1b;
	static const auto GL_TEXTURE_BINDING_1D_ARRAY_EXT   = 0x8C1c;
	static const auto GL_TEXTURE_BINDING_2D_ARRAY_EXT   = 0x8C1d;
	static const auto GL_MAX_ARRAY_TEXTURE_LAYERS_EXT   = 0x88Ff;
	static const auto GL_COMPARE_REF_DEPTH_TO_TEXTURE_EXT = 0x884e;
	/* reuse GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER_EXT */
}

version(GL_EXT_texture_buffer_object) {
}
else {
	static const auto GL_TEXTURE_BUFFER_EXT             = 0x8C2a;
	static const auto GL_MAX_TEXTURE_BUFFER_SIZE_EXT    = 0x8C2b;
	static const auto GL_TEXTURE_BINDING_BUFFER_EXT     = 0x8C2c;
	static const auto GL_TEXTURE_BUFFER_DATA_STORE_BINDING_EXT = 0x8C2d;
	static const auto GL_TEXTURE_BUFFER_FORMAT_EXT      = 0x8C2e;
}

version(GL_EXT_texture_compression_latc) {
}
else {
	static const auto GL_COMPRESSED_LUMINANCE_LATC1_EXT = 0x8C70;
	static const auto GL_COMPRESSED_SIGNED_LUMINANCE_LATC1_EXT = 0x8C71;
	static const auto GL_COMPRESSED_LUMINANCE_ALPHA_LATC2_EXT = 0x8C72;
	static const auto GL_COMPRESSED_SIGNED_LUMINANCE_ALPHA_LATC2_EXT = 0x8C73;
}

version(GL_EXT_texture_compression_rgtc) {
}
else {
	static const auto GL_COMPRESSED_RED_RGTC1_EXT       = 0x8DBb;
	static const auto GL_COMPRESSED_SIGNED_RED_RGTC1_EXT = 0x8DBc;
	static const auto GL_COMPRESSED_RED_GREEN_RGTC2_EXT = 0x8DBd;
	static const auto GL_COMPRESSED_SIGNED_RED_GREEN_RGTC2_EXT = 0x8DBe;
}

version(GL_EXT_texture_shared_exponent) {
}
else {
	static const auto GL_RGB9_E5_EXT                    = 0x8C3d;
	static const auto GL_UNSIGNED_INT_5_9_9_9_REV_EXT   = 0x8C3e;
	static const auto GL_TEXTURE_SHARED_SIZE_EXT        = 0x8C3f;
}

version(GL_NV_depth_buffer_float) {
}
else {
	static const auto GL_DEPTH_COMPONENT32F_NV          = 0x8DAb;
	static const auto GL_DEPTH32F_STENCIL8_NV           = 0x8DAc;
	static const auto GL_FLOAT_32_UNSIGNED_INT_24_8_REV_NV = 0x8DAd;
	static const auto GL_DEPTH_BUFFER_FLOAT_MODE_NV     = 0x8DAf;
}

version(GL_NV_fragment_program4) {
}
else {
}

version(GL_NV_framebuffer_multisample_coverage) {
}
else {
	static const auto GL_RENDERBUFFER_COVERAGE_SAMPLES_NV = 0x8CAb;
	static const auto GL_RENDERBUFFER_COLOR_SAMPLES_NV  = 0x8E10;
	static const auto GL_MAX_MULTISAMPLE_COVERAGE_MODES_NV = 0x8E11;
	static const auto GL_MULTISAMPLE_COVERAGE_MODES_NV  = 0x8E12;
}

version(GL_EXT_framebuffer_sRGB) {
}
else {
	static const auto GL_FRAMEBUFFER_SRGB_EXT           = 0x8DB9;
	static const auto GL_FRAMEBUFFER_SRGB_CAPABLE_EXT   = 0x8DBa;
}

version(GL_NV_geometry_shader4) {
}
else {
}

version(GL_NV_parameter_buffer_object) {
}
else {
	static const auto GL_MAX_PROGRAM_PARAMETER_BUFFER_BINDINGS_NV = 0x8DA0;
	static const auto GL_MAX_PROGRAM_PARAMETER_BUFFER_SIZE_NV = 0x8DA1;
	static const auto GL_VERTEX_PROGRAM_PARAMETER_BUFFER_NV = 0x8DA2;
	static const auto GL_GEOMETRY_PROGRAM_PARAMETER_BUFFER_NV = 0x8DA3;
	static const auto GL_FRAGMENT_PROGRAM_PARAMETER_BUFFER_NV = 0x8DA4;
}

version(GL_EXT_draw_buffers2) {
}
else {
}

version(GL_NV_transform_feedback) {
}
else {
	static const auto GL_BACK_PRIMARY_COLOR_NV          = 0x8C77;
	static const auto GL_BACK_SECONDARY_COLOR_NV        = 0x8C78;
	static const auto GL_TEXTURE_COORD_NV               = 0x8C79;
	static const auto GL_CLIP_DISTANCE_NV               = 0x8C7a;
	static const auto GL_VERTEX_ID_NV                   = 0x8C7b;
	static const auto GL_PRIMITIVE_ID_NV                = 0x8C7c;
	static const auto GL_GENERIC_ATTRIB_NV              = 0x8C7d;
	static const auto GL_TRANSFORM_FEEDBACK_ATTRIBS_NV  = 0x8C7e;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_MODE_NV = 0x8C7f;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS_NV = 0x8C80;
	static const auto GL_ACTIVE_VARYINGS_NV             = 0x8C81;
	static const auto GL_ACTIVE_VARYING_MAX_LENGTH_NV   = 0x8C82;
	static const auto GL_TRANSFORM_FEEDBACK_VARYINGS_NV = 0x8C83;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_START_NV = 0x8C84;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_SIZE_NV = 0x8C85;
	static const auto GL_TRANSFORM_FEEDBACK_RECORD_NV   = 0x8C86;
	static const auto GL_PRIMITIVES_GENERATED_NV        = 0x8C87;
	static const auto GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_NV = 0x8C88;
	static const auto GL_RASTERIZER_DISCARD_NV          = 0x8C89;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_ATTRIBS_NV = 0x8C8a;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS_NV = 0x8C8b;
	static const auto GL_INTERLEAVED_ATTRIBS_NV         = 0x8C8c;
	static const auto GL_SEPARATE_ATTRIBS_NV            = 0x8C8d;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_NV   = 0x8C8e;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_BINDING_NV = 0x8C8f;
}

version(GL_EXT_bindable_uniform) {
}
else {
	static const auto GL_MAX_VERTEX_BINDABLE_UNIFORMS_EXT = 0x8DE2;
	static const auto GL_MAX_FRAGMENT_BINDABLE_UNIFORMS_EXT = 0x8DE3;
	static const auto GL_MAX_GEOMETRY_BINDABLE_UNIFORMS_EXT = 0x8DE4;
	static const auto GL_MAX_BINDABLE_UNIFORM_SIZE_EXT  = 0x8DEd;
	static const auto GL_UNIFORM_BUFFER_EXT             = 0x8DEe;
	static const auto GL_UNIFORM_BUFFER_BINDING_EXT     = 0x8DEf;
}

version(GL_EXT_texture_integer) {
}
else {
	static const auto GL_RGBA32UI_EXT                   = 0x8D70;
	static const auto GL_RGB32UI_EXT                    = 0x8D71;
	static const auto GL_ALPHA32UI_EXT                  = 0x8D72;
	static const auto GL_INTENSITY32UI_EXT              = 0x8D73;
	static const auto GL_LUMINANCE32UI_EXT              = 0x8D74;
	static const auto GL_LUMINANCE_ALPHA32UI_EXT        = 0x8D75;
	static const auto GL_RGBA16UI_EXT                   = 0x8D76;
	static const auto GL_RGB16UI_EXT                    = 0x8D77;
	static const auto GL_ALPHA16UI_EXT                  = 0x8D78;
	static const auto GL_INTENSITY16UI_EXT              = 0x8D79;
	static const auto GL_LUMINANCE16UI_EXT              = 0x8D7a;
	static const auto GL_LUMINANCE_ALPHA16UI_EXT        = 0x8D7b;
	static const auto GL_RGBA8UI_EXT                    = 0x8D7c;
	static const auto GL_RGB8UI_EXT                     = 0x8D7d;
	static const auto GL_ALPHA8UI_EXT                   = 0x8D7e;
	static const auto GL_INTENSITY8UI_EXT               = 0x8D7f;
	static const auto GL_LUMINANCE8UI_EXT               = 0x8D80;
	static const auto GL_LUMINANCE_ALPHA8UI_EXT         = 0x8D81;
	static const auto GL_RGBA32I_EXT                    = 0x8D82;
	static const auto GL_RGB32I_EXT                     = 0x8D83;
	static const auto GL_ALPHA32I_EXT                   = 0x8D84;
	static const auto GL_INTENSITY32I_EXT               = 0x8D85;
	static const auto GL_LUMINANCE32I_EXT               = 0x8D86;
	static const auto GL_LUMINANCE_ALPHA32I_EXT         = 0x8D87;
	static const auto GL_RGBA16I_EXT                    = 0x8D88;
	static const auto GL_RGB16I_EXT                     = 0x8D89;
	static const auto GL_ALPHA16I_EXT                   = 0x8D8a;
	static const auto GL_INTENSITY16I_EXT               = 0x8D8b;
	static const auto GL_LUMINANCE16I_EXT               = 0x8D8c;
	static const auto GL_LUMINANCE_ALPHA16I_EXT         = 0x8D8d;
	static const auto GL_RGBA8I_EXT                     = 0x8D8e;
	static const auto GL_RGB8I_EXT                      = 0x8D8f;
	static const auto GL_ALPHA8I_EXT                    = 0x8D90;
	static const auto GL_INTENSITY8I_EXT                = 0x8D91;
	static const auto GL_LUMINANCE8I_EXT                = 0x8D92;
	static const auto GL_LUMINANCE_ALPHA8I_EXT          = 0x8D93;
	static const auto GL_RED_INTEGER_EXT                = 0x8D94;
	static const auto GL_GREEN_INTEGER_EXT              = 0x8D95;
	static const auto GL_BLUE_INTEGER_EXT               = 0x8D96;
	static const auto GL_ALPHA_INTEGER_EXT              = 0x8D97;
	static const auto GL_RGB_INTEGER_EXT                = 0x8D98;
	static const auto GL_RGBA_INTEGER_EXT               = 0x8D99;
	static const auto GL_BGR_INTEGER_EXT                = 0x8D9a;
	static const auto GL_BGRA_INTEGER_EXT               = 0x8D9b;
	static const auto GL_LUMINANCE_INTEGER_EXT          = 0x8D9c;
	static const auto GL_LUMINANCE_ALPHA_INTEGER_EXT    = 0x8D9d;
	static const auto GL_RGBA_INTEGER_MODE_EXT          = 0x8D9e;
}

version(GL_GREMEDY_frame_terminator) {
}
else {
}

version(GL_NV_conditional_render) {
}
else {
	static const auto GL_QUERY_WAIT_NV                  = 0x8E13;
	static const auto GL_QUERY_NO_WAIT_NV               = 0x8E14;
	static const auto GL_QUERY_BY_REGION_WAIT_NV        = 0x8E15;
	static const auto GL_QUERY_BY_REGION_NO_WAIT_NV     = 0x8E16;
}

version(GL_NV_present_video) {
}
else {
	static const auto GL_FRAME_NV                       = 0x8E26;
	static const auto GL_FIELDS_NV                      = 0x8E27;
	static const auto GL_CURRENT_TIME_NV                = 0x8E28;
	static const auto GL_NUM_FILL_STREAMS_NV            = 0x8E29;
	static const auto GL_PRESENT_TIME_NV                = 0x8E2a;
	static const auto GL_PRESENT_DURATION_NV            = 0x8E2b;
}

version(GL_EXT_transform_feedback) {
}
else {
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_EXT  = 0x8C8e;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_START_EXT = 0x8C84;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_SIZE_EXT = 0x8C85;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_BINDING_EXT = 0x8C8f;
	static const auto GL_INTERLEAVED_ATTRIBS_EXT        = 0x8C8c;
	static const auto GL_SEPARATE_ATTRIBS_EXT           = 0x8C8d;
	static const auto GL_PRIMITIVES_GENERATED_EXT       = 0x8C87;
	static const auto GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_EXT = 0x8C88;
	static const auto GL_RASTERIZER_DISCARD_EXT         = 0x8C89;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS_EXT = 0x8C8a;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS_EXT = 0x8C8b;
	static const auto GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS_EXT = 0x8C80;
	static const auto GL_TRANSFORM_FEEDBACK_VARYINGS_EXT = 0x8C83;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_MODE_EXT = 0x8C7f;
	static const auto GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH_EXT = 0x8C76;
}

version(GL_EXT_direct_state_access) {
}
else {
	static const auto GL_PROGRAM_MATRIX_EXT             = 0x8E2d;
	static const auto GL_TRANSPOSE_PROGRAM_MATRIX_EXT   = 0x8E2e;
	static const auto GL_PROGRAM_MATRIX_STACK_DEPTH_EXT = 0x8E2f;
}

version(GL_EXT_vertex_array_bgra) {
}
else {
	/* reuse GL_BGRA */
}

version(GL_EXT_texture_swizzle) {
}
else {
	static const auto GL_TEXTURE_SWIZZLE_R_EXT          = 0x8E42;
	static const auto GL_TEXTURE_SWIZZLE_G_EXT          = 0x8E43;
	static const auto GL_TEXTURE_SWIZZLE_B_EXT          = 0x8E44;
	static const auto GL_TEXTURE_SWIZZLE_A_EXT          = 0x8E45;
	static const auto GL_TEXTURE_SWIZZLE_RGBA_EXT       = 0x8E46;
}

version(GL_NV_explicit_multisample) {
}
else {
	static const auto GL_SAMPLE_POSITION_NV             = 0x8E50;
	static const auto GL_SAMPLE_MASK_NV                 = 0x8E51;
	static const auto GL_SAMPLE_MASK_VALUE_NV           = 0x8E52;
	static const auto GL_TEXTURE_BINDING_RENDERBUFFER_NV = 0x8E53;
	static const auto GL_TEXTURE_RENDERBUFFER_DATA_STORE_BINDING_NV = 0x8E54;
	static const auto GL_TEXTURE_RENDERBUFFER_NV        = 0x8E55;
	static const auto GL_SAMPLER_RENDERBUFFER_NV        = 0x8E56;
	static const auto GL_INT_SAMPLER_RENDERBUFFER_NV    = 0x8E57;
	static const auto GL_UNSIGNED_INT_SAMPLER_RENDERBUFFER_NV = 0x8E58;
	static const auto GL_MAX_SAMPLE_MASK_WORDS_NV       = 0x8E59;
}

version(GL_NV_transform_feedback2) {
}
else {
	static const auto GL_TRANSFORM_FEEDBACK_NV          = 0x8E22;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED_NV = 0x8E23;
	static const auto GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE_NV = 0x8E24;
	static const auto GL_TRANSFORM_FEEDBACK_BINDING_NV  = 0x8E25;
}

version(GL_ATI_meminfo) {
}
else {
	static const auto GL_VBO_FREE_MEMORY_ATI            = 0x87Fb;
	static const auto GL_TEXTURE_FREE_MEMORY_ATI        = 0x87Fc;
	static const auto GL_RENDERBUFFER_FREE_MEMORY_ATI   = 0x87Fd;
}

version(GL_AMD_performance_monitor) {
}
else {
	static const auto GL_COUNTER_TYPE_AMD               = 0x8BC0;
	static const auto GL_COUNTER_RANGE_AMD              = 0x8BC1;
	static const auto GL_UNSIGNED_INT64_AMD             = 0x8BC2;
	static const auto GL_PERCENTAGE_AMD                 = 0x8BC3;
	static const auto GL_PERFMON_RESULT_AVAILABLE_AMD   = 0x8BC4;
	static const auto GL_PERFMON_RESULT_SIZE_AMD        = 0x8BC5;
	static const auto GL_PERFMON_RESULT_AMD             = 0x8BC6;
}

version(GL_AMD_texture_texture4) {
}
else {
}

version(GL_AMD_vertex_shader_tesselator) {
}
else {
	static const auto GL_SAMPLER_BUFFER_AMD             = 0x9001;
	static const auto GL_INT_SAMPLER_BUFFER_AMD         = 0x9002;
	static const auto GL_UNSIGNED_INT_SAMPLER_BUFFER_AMD = 0x9003;
	static const auto GL_TESSELLATION_MODE_AMD          = 0x9004;
	static const auto GL_TESSELLATION_FACTOR_AMD        = 0x9005;
	static const auto GL_DISCRETE_AMD                   = 0x9006;
	static const auto GL_CONTINUOUS_AMD                 = 0x9007;
}

version(GL_EXT_provoking_vertex) {
}
else {
	static const auto GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION_EXT = 0x8E4c;
	static const auto GL_FIRST_VERTEX_CONVENTION_EXT    = 0x8E4d;
	static const auto GL_LAST_VERTEX_CONVENTION_EXT     = 0x8E4e;
	static const auto GL_PROVOKING_VERTEX_EXT           = 0x8E4f;
}

version(GL_EXT_texture_snorm) {
}
else {
	static const auto GL_ALPHA_SNORM                    = 0x9010;
	static const auto GL_LUMINANCE_SNORM                = 0x9011;
	static const auto GL_LUMINANCE_ALPHA_SNORM          = 0x9012;
	static const auto GL_INTENSITY_SNORM                = 0x9013;
	static const auto GL_ALPHA8_SNORM                   = 0x9014;
	static const auto GL_LUMINANCE8_SNORM               = 0x9015;
	static const auto GL_LUMINANCE8_ALPHA8_SNORM        = 0x9016;
	static const auto GL_INTENSITY8_SNORM               = 0x9017;
	static const auto GL_ALPHA16_SNORM                  = 0x9018;
	static const auto GL_LUMINANCE16_SNORM              = 0x9019;
	static const auto GL_LUMINANCE16_ALPHA16_SNORM      = 0x901a;
	static const auto GL_INTENSITY16_SNORM              = 0x901b;
	/* reuse GL_RED_SNORM */
	/* reuse GL_RG_SNORM */
	/* reuse GL_RGB_SNORM */
	/* reuse GL_RGBA_SNORM */
	/* reuse GL_R8_SNORM */
	/* reuse GL_RG8_SNORM */
	/* reuse GL_RGB8_SNORM */
	/* reuse GL_RGBA8_SNORM */
	/* reuse GL_R16_SNORM */
	/* reuse GL_RG16_SNORM */
	/* reuse GL_RGB16_SNORM */
	/* reuse GL_RGBA16_SNORM */
	/* reuse GL_SIGNED_NORMALIZED */
}

version(GL_AMD_draw_buffers_blend) {
}
else {
}

version(GL_APPLE_texture_range) {
}
else {
	static const auto GL_TEXTURE_RANGE_LENGTH_APPLE     = 0x85B7;
	static const auto GL_TEXTURE_RANGE_POINTER_APPLE    = 0x85B8;
	static const auto GL_TEXTURE_STORAGE_HINT_APPLE     = 0x85Bc;
	static const auto GL_STORAGE_PRIVATE_APPLE          = 0x85Bd;
	/* reuse GL_STORAGE_CACHED_APPLE */
	/* reuse GL_STORAGE_SHARED_APPLE */
}

version(GL_APPLE_float_pixels) {
}
else {
	static const auto GL_HALF_APPLE                     = 0x140b;
	static const auto GL_RGBA_FLOAT32_APPLE             = 0x8814;
	static const auto GL_RGB_FLOAT32_APPLE              = 0x8815;
	static const auto GL_ALPHA_FLOAT32_APPLE            = 0x8816;
	static const auto GL_INTENSITY_FLOAT32_APPLE        = 0x8817;
	static const auto GL_LUMINANCE_FLOAT32_APPLE        = 0x8818;
	static const auto GL_LUMINANCE_ALPHA_FLOAT32_APPLE  = 0x8819;
	static const auto GL_RGBA_FLOAT16_APPLE             = 0x881a;
	static const auto GL_RGB_FLOAT16_APPLE              = 0x881b;
	static const auto GL_ALPHA_FLOAT16_APPLE            = 0x881c;
	static const auto GL_INTENSITY_FLOAT16_APPLE        = 0x881d;
	static const auto GL_LUMINANCE_FLOAT16_APPLE        = 0x881e;
	static const auto GL_LUMINANCE_ALPHA_FLOAT16_APPLE  = 0x881f;
	static const auto GL_COLOR_FLOAT_APPLE              = 0x8A0f;
}

version(GL_APPLE_vertex_program_evaluators) {
}
else {
	static const auto GL_VERTEX_ATTRIB_MAP1_APPLE       = 0x8A00;
	static const auto GL_VERTEX_ATTRIB_MAP2_APPLE       = 0x8A01;
	static const auto GL_VERTEX_ATTRIB_MAP1_SIZE_APPLE  = 0x8A02;
	static const auto GL_VERTEX_ATTRIB_MAP1_COEFF_APPLE = 0x8A03;
	static const auto GL_VERTEX_ATTRIB_MAP1_ORDER_APPLE = 0x8A04;
	static const auto GL_VERTEX_ATTRIB_MAP1_DOMAIN_APPLE = 0x8A05;
	static const auto GL_VERTEX_ATTRIB_MAP2_SIZE_APPLE  = 0x8A06;
	static const auto GL_VERTEX_ATTRIB_MAP2_COEFF_APPLE = 0x8A07;
	static const auto GL_VERTEX_ATTRIB_MAP2_ORDER_APPLE = 0x8A08;
	static const auto GL_VERTEX_ATTRIB_MAP2_DOMAIN_APPLE = 0x8A09;
}

version(GL_APPLE_aux_depth_stencil) {
}
else {
	static const auto GL_AUX_DEPTH_STENCIL_APPLE        = 0x8A14;
}

version(GL_APPLE_object_purgeable) {
}
else {
	static const auto GL_BUFFER_OBJECT_APPLE            = 0x85B3;
	static const auto GL_RELEASED_APPLE                 = 0x8A19;
	static const auto GL_VOLATILE_APPLE                 = 0x8A1a;
	static const auto GL_RETAINED_APPLE                 = 0x8A1b;
	static const auto GL_UNDEFINED_APPLE                = 0x8A1c;
	static const auto GL_PURGEABLE_APPLE                = 0x8A1d;
}

version(GL_APPLE_row_bytes) {
}
else {
	static const auto GL_PACK_ROW_BYTES_APPLE           = 0x8A15;
	static const auto GL_UNPACK_ROW_BYTES_APPLE         = 0x8A16;
}

version(GL_APPLE_rgb_422) {
}
else {
	static const auto GL_RGB_422_APPLE                  = 0x8A1f;
	/* reuse GL_UNSIGNED_SHORT_8_8_APPLE */
	/* reuse GL_UNSIGNED_SHORT_8_8_REV_APPLE */
}

version(GL_NV_video_capture) {
}
else {
	static const auto GL_VIDEO_BUFFER_NV                = 0x9020;
	static const auto GL_VIDEO_BUFFER_BINDING_NV        = 0x9021;
	static const auto GL_FIELD_UPPER_NV                 = 0x9022;
	static const auto GL_FIELD_LOWER_NV                 = 0x9023;
	static const auto GL_NUM_VIDEO_CAPTURE_STREAMS_NV   = 0x9024;
	static const auto GL_NEXT_VIDEO_CAPTURE_BUFFER_STATUS_NV = 0x9025;
	static const auto GL_VIDEO_CAPTURE_TO_422_SUPPORTED_NV = 0x9026;
	static const auto GL_LAST_VIDEO_CAPTURE_STATUS_NV   = 0x9027;
	static const auto GL_VIDEO_BUFFER_PITCH_NV          = 0x9028;
	static const auto GL_VIDEO_COLOR_CONVERSION_MATRIX_NV = 0x9029;
	static const auto GL_VIDEO_COLOR_CONVERSION_MAX_NV  = 0x902a;
	static const auto GL_VIDEO_COLOR_CONVERSION_MIN_NV  = 0x902b;
	static const auto GL_VIDEO_COLOR_CONVERSION_OFFSET_NV = 0x902c;
	static const auto GL_VIDEO_BUFFER_INTERNAL_FORMAT_NV = 0x902d;
	static const auto GL_PARTIAL_SUCCESS_NV             = 0x902e;
	static const auto GL_SUCCESS_NV                     = 0x902f;
	static const auto GL_FAILURE_NV                     = 0x9030;
	static const auto GL_YCBYCR8_422_NV                 = 0x9031;
	static const auto GL_YCBAYCR8A_4224_NV              = 0x9032;
	static const auto GL_Z6Y10Z6CB10Z6Y10Z6CR10_422_NV  = 0x9033;
	static const auto GL_Z6Y10Z6CB10Z6A10Z6Y10Z6CR10Z6A10_4224_NV = 0x9034;
	static const auto GL_Z4Y12Z4CB12Z4Y12Z4CR12_422_NV  = 0x9035;
	static const auto GL_Z4Y12Z4CB12Z4A12Z4Y12Z4CR12Z4A12_4224_NV = 0x9036;
	static const auto GL_Z4Y12Z4CB12Z4CR12_444_NV       = 0x9037;
	static const auto GL_VIDEO_CAPTURE_FRAME_WIDTH_NV   = 0x9038;
	static const auto GL_VIDEO_CAPTURE_FRAME_HEIGHT_NV  = 0x9039;
	static const auto GL_VIDEO_CAPTURE_FIELD_UPPER_HEIGHT_NV = 0x903a;
	static const auto GL_VIDEO_CAPTURE_FIELD_LOWER_HEIGHT_NV = 0x903b;
	static const auto GL_VIDEO_CAPTURE_SURFACE_ORIGIN_NV = 0x903c;
}

version(GL_NV_copy_image) {
}
else {
}

version(GL_EXT_separate_shader_objects) {
}
else {
	static const auto GL_ACTIVE_PROGRAM_EXT             = 0x8B8d;
}

version(GL_NV_parameter_buffer_object2) {
}
else {
}

version(GL_NV_shader_buffer_load) {
}
else {
	static const auto GL_BUFFER_GPU_ADDRESS_NV          = 0x8F1d;
	static const auto GL_GPU_ADDRESS_NV                 = 0x8F34;
	static const auto GL_MAX_SHADER_BUFFER_ADDRESS_NV   = 0x8F35;
}

version(GL_NV_vertex_buffer_unified_memory) {
}
else {
	static const auto GL_VERTEX_ATTRIB_ARRAY_UNIFIED_NV = 0x8F1e;
	static const auto GL_ELEMENT_ARRAY_UNIFIED_NV       = 0x8F1f;
	static const auto GL_VERTEX_ATTRIB_ARRAY_ADDRESS_NV = 0x8F20;
	static const auto GL_VERTEX_ARRAY_ADDRESS_NV        = 0x8F21;
	static const auto GL_NORMAL_ARRAY_ADDRESS_NV        = 0x8F22;
	static const auto GL_COLOR_ARRAY_ADDRESS_NV         = 0x8F23;
	static const auto GL_INDEX_ARRAY_ADDRESS_NV         = 0x8F24;
	static const auto GL_TEXTURE_COORD_ARRAY_ADDRESS_NV = 0x8F25;
	static const auto GL_EDGE_FLAG_ARRAY_ADDRESS_NV     = 0x8F26;
	static const auto GL_SECONDARY_COLOR_ARRAY_ADDRESS_NV = 0x8F27;
	static const auto GL_FOG_COORD_ARRAY_ADDRESS_NV     = 0x8F28;
	static const auto GL_ELEMENT_ARRAY_ADDRESS_NV       = 0x8F29;
	static const auto GL_VERTEX_ATTRIB_ARRAY_LENGTH_NV  = 0x8F2a;
	static const auto GL_VERTEX_ARRAY_LENGTH_NV         = 0x8F2b;
	static const auto GL_NORMAL_ARRAY_LENGTH_NV         = 0x8F2c;
	static const auto GL_COLOR_ARRAY_LENGTH_NV          = 0x8F2d;
	static const auto GL_INDEX_ARRAY_LENGTH_NV          = 0x8F2e;
	static const auto GL_TEXTURE_COORD_ARRAY_LENGTH_NV  = 0x8F2f;
	static const auto GL_EDGE_FLAG_ARRAY_LENGTH_NV      = 0x8F30;
	static const auto GL_SECONDARY_COLOR_ARRAY_LENGTH_NV = 0x8F31;
	static const auto GL_FOG_COORD_ARRAY_LENGTH_NV      = 0x8F32;
	static const auto GL_ELEMENT_ARRAY_LENGTH_NV        = 0x8F33;
}
	
version(GL_NV_texture_barrier) {
}
else {
}

version(GL_AMD_shader_stencil_export) {
}
else {
}

version(GL_AMD_seamless_cubemap_per_texture) {
}
else {
	/* reuse GL_TEXTURE_CUBE_MAP_SEAMLESS_ARB */
}

version(GL_AMD_conservative_depth) {
}
else {
}


/*************************************************************/

version(GL_VERSION_2_0) {
}
else {
	/* GL type for program/shader text */
	alias char GLchar;
}

version(GL_VERSION_1_5) {
}
else {
	/* GL types for handling large vertex buffer objects */
	alias ptrdiff_t GLintptr;
	alias ptrdiff_t GLsizeiptr;
}

version(GL_ARB_vertex_buffer_object) {
}
else {
	/* GL types for handling large vertex buffer objects */
	alias ptrdiff_t GLintptrARB;
	alias ptrdiff_t GLsizeiptrARB;
}

version(GL_ARB_shader_objects) {
}
else {
	/* GL types for program/shader text and shader object handles */
	alias char GLcharARB;
	alias uint GLhandleARB;
}

/* GL type for "half" precision (s10e5) float data in host memory */
version(GL_ARB_half_float_pixel) {
}
else {
	alias ushort GLhalfARB;
}

version(GL_NV_half_float) {
}
else {
	alias ushort GLhalfNV;
}

version(GLEXT_64_TYPES_DEFINED) {
}
else {
	alias long GLint64EXT;
	alias ulong GLuint64EXT;
}

version(ARB_sync) {
}
else {
	alias long GLint64;
	alias ulong GLuint64;
	extern struct __GLsync;
	alias __GLsync *GLsync;
}

static const auto GL_VERSION_1_2 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
	void glBlendEquation (GLenum mode);
	void glDrawRangeElements (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices);
	void glTexImage3D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels);
	void glCopyTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
} /* GL_GLEXT_PROTOTYPES */

alias void function(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha) PFNGLBLENDCOLORPROC;
alias void function(GLenum mode) PFNGLBLENDEQUATIONPROC;
alias void function(GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices) PFNGLDRAWRANGEELEMENTSPROC;
alias void function(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXIMAGE3DPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXSUBIMAGE3DPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYTEXSUBIMAGE3DPROC;

static const auto GL_VERSION_1_2_DEPRECATED = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glColorTable (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *table);
	void glColorTableParameterfv (GLenum target, GLenum pname, GLfloat *params);
	void glColorTableParameteriv (GLenum target, GLenum pname, GLint *params);
	void glCopyColorTable (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
	void glGetColorTable (GLenum target, GLenum format, GLenum type, GLvoid *table);
	void glGetColorTableParameterfv (GLenum target, GLenum pname, GLfloat *params);
	void glGetColorTableParameteriv (GLenum target, GLenum pname, GLint *params);
	void glColorSubTable (GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, GLvoid *data);
	void glCopyColorSubTable (GLenum target, GLsizei start, GLint x, GLint y, GLsizei width);
	void glConvolutionFilter1D (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *image);
	void glConvolutionFilter2D (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *image);
	void glConvolutionParameterf (GLenum target, GLenum pname, GLfloat params);
	void glConvolutionParameterfv (GLenum target, GLenum pname, GLfloat *params);
	void glConvolutionParameteri (GLenum target, GLenum pname, GLint params);
	void glConvolutionParameteriv (GLenum target, GLenum pname, GLint *params);
	void glCopyConvolutionFilter1D (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
	void glCopyConvolutionFilter2D (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height);
	void glGetConvolutionFilter (GLenum target, GLenum format, GLenum type, GLvoid *image);
	void glGetConvolutionParameterfv (GLenum target, GLenum pname, GLfloat *params);
	void glGetConvolutionParameteriv (GLenum target, GLenum pname, GLint *params);
	void glGetSeparableFilter (GLenum target, GLenum format, GLenum type, GLvoid *row, GLvoid *column, GLvoid *span);
	void glSeparableFilter2D (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *row, GLvoid *column);
	void glGetHistogram (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
	void glGetHistogramParameterfv (GLenum target, GLenum pname, GLfloat *params);
	void glGetHistogramParameteriv (GLenum target, GLenum pname, GLint *params);
	void glGetMinmax (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
	void glGetMinmaxParameterfv (GLenum target, GLenum pname, GLfloat *params);
	void glGetMinmaxParameteriv (GLenum target, GLenum pname, GLint *params);
	void glHistogram (GLenum target, GLsizei width, GLenum internalformat, GLboolean sink);
	void glMinmax (GLenum target, GLenum internalformat, GLboolean sink);
	void glResetHistogram (GLenum target);
	void glResetMinmax (GLenum target);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *table) PFNGLCOLORTABLEPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLCOLORTABLEPARAMETERFVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLCOLORTABLEPARAMETERIVPROC;
alias void function(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width) PFNGLCOPYCOLORTABLEPROC;
alias void function(GLenum target, GLenum format, GLenum type, GLvoid *table) PFNGLGETCOLORTABLEPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETCOLORTABLEPARAMETERFVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETCOLORTABLEPARAMETERIVPROC;
alias void function(GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, GLvoid *data) PFNGLCOLORSUBTABLEPROC;
alias void function(GLenum target, GLsizei start, GLint x, GLint y, GLsizei width) PFNGLCOPYCOLORSUBTABLEPROC;
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *image) PFNGLCONVOLUTIONFILTER1DPROC;
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *image) PFNGLCONVOLUTIONFILTER2DPROC;
alias void function(GLenum target, GLenum pname, GLfloat params) PFNGLCONVOLUTIONPARAMETERFPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLCONVOLUTIONPARAMETERFVPROC;
alias void function(GLenum target, GLenum pname, GLint params) PFNGLCONVOLUTIONPARAMETERIPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLCONVOLUTIONPARAMETERIVPROC;
alias void function(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width) PFNGLCOPYCONVOLUTIONFILTER1DPROC;
alias void function(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYCONVOLUTIONFILTER2DPROC;
alias void function(GLenum target, GLenum format, GLenum type, GLvoid *image) PFNGLGETCONVOLUTIONFILTERPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETCONVOLUTIONPARAMETERFVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETCONVOLUTIONPARAMETERIVPROC;
alias void function(GLenum target, GLenum format, GLenum type, GLvoid *row, GLvoid *column, GLvoid *span) PFNGLGETSEPARABLEFILTERPROC;
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *row, GLvoid *column) PFNGLSEPARABLEFILTER2DPROC;
alias void function(GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values) PFNGLGETHISTOGRAMPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETHISTOGRAMPARAMETERFVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETHISTOGRAMPARAMETERIVPROC;
alias void function(GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values) PFNGLGETMINMAXPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETMINMAXPARAMETERFVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETMINMAXPARAMETERIVPROC;
alias void function(GLenum target, GLsizei width, GLenum internalformat, GLboolean sink) PFNGLHISTOGRAMPROC;
alias void function(GLenum target, GLenum internalformat, GLboolean sink) PFNGLMINMAXPROC;
alias void function(GLenum target) PFNGLRESETHISTOGRAMPROC;
alias void function(GLenum target) PFNGLRESETMINMAXPROC;

static const auto GL_VERSION_1_3 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glActiveTexture (GLenum texture);
	void glSampleCoverage (GLclampf value, GLboolean invert);
	void glCompressedTexImage3D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *data);
	void glCompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *data);
	void glCompressedTexImage1D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *data);
	void glCompressedTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *data);
	void glCompressedTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *data);
	void glCompressedTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *data);
	void glGetCompressedTexImage (GLenum target, GLint level, GLvoid *img);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum texture) PFNGLACTIVETEXTUREPROC;
alias void function(GLclampf value, GLboolean invert) PFNGLSAMPLECOVERAGEPROC;
alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXIMAGE3DPROC;
alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXIMAGE2DPROC;
alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXIMAGE1DPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXSUBIMAGE3DPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXSUBIMAGE2DPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXSUBIMAGE1DPROC;
alias void function(GLenum target, GLint level, GLvoid *img) PFNGLGETCOMPRESSEDTEXIMAGEPROC;

static const auto GL_VERSION_1_3_DEPRECATED = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glClientActiveTexture (GLenum texture);
	void glMultiTexCoord1d (GLenum target, GLdouble s);
	void glMultiTexCoord1dv (GLenum target, GLdouble *v);
	void glMultiTexCoord1f (GLenum target, GLfloat s);
	void glMultiTexCoord1fv (GLenum target, GLfloat *v);
	void glMultiTexCoord1i (GLenum target, GLint s);
	void glMultiTexCoord1iv (GLenum target, GLint *v);
	void glMultiTexCoord1s (GLenum target, GLshort s);
	void glMultiTexCoord1sv (GLenum target, GLshort *v);
	void glMultiTexCoord2d (GLenum target, GLdouble s, GLdouble t);
	void glMultiTexCoord2dv (GLenum target, GLdouble *v);
	void glMultiTexCoord2f (GLenum target, GLfloat s, GLfloat t);
	void glMultiTexCoord2fv (GLenum target, GLfloat *v);
	void glMultiTexCoord2i (GLenum target, GLint s, GLint t);
	void glMultiTexCoord2iv (GLenum target, GLint *v);
	void glMultiTexCoord2s (GLenum target, GLshort s, GLshort t);
	void glMultiTexCoord2sv (GLenum target, GLshort *v);
	void glMultiTexCoord3d (GLenum target, GLdouble s, GLdouble t, GLdouble r);
	void glMultiTexCoord3dv (GLenum target, GLdouble *v);
	void glMultiTexCoord3f (GLenum target, GLfloat s, GLfloat t, GLfloat r);
	void glMultiTexCoord3fv (GLenum target, GLfloat *v);
	void glMultiTexCoord3i (GLenum target, GLint s, GLint t, GLint r);
	void glMultiTexCoord3iv (GLenum target, GLint *v);
	void glMultiTexCoord3s (GLenum target, GLshort s, GLshort t, GLshort r);
	void glMultiTexCoord3sv (GLenum target, GLshort *v);
	void glMultiTexCoord4d (GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
	void glMultiTexCoord4dv (GLenum target, GLdouble *v);
	void glMultiTexCoord4f (GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
	void glMultiTexCoord4fv (GLenum target, GLfloat *v);
	void glMultiTexCoord4i (GLenum target, GLint s, GLint t, GLint r, GLint q);
	void glMultiTexCoord4iv (GLenum target, GLint *v);
	void glMultiTexCoord4s (GLenum target, GLshort s, GLshort t, GLshort r, GLshort q);
	void glMultiTexCoord4sv (GLenum target, GLshort *v);
	void glLoadTransposeMatrixf (GLfloat *m);
	void glLoadTransposeMatrixd (GLdouble *m);
	void glMultTransposeMatrixf (GLfloat *m);
	void glMultTransposeMatrixd (GLdouble *m);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum texture) PFNGLCLIENTACTIVETEXTUREPROC;
alias void function(GLenum target, GLdouble s) PFNGLMULTITEXCOORD1DPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD1DVPROC;
alias void function(GLenum target, GLfloat s) PFNGLMULTITEXCOORD1FPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD1FVPROC;
alias void function(GLenum target, GLint s) PFNGLMULTITEXCOORD1IPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD1IVPROC;
alias void function(GLenum target, GLshort s) PFNGLMULTITEXCOORD1SPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD1SVPROC;
alias void function(GLenum target, GLdouble s, GLdouble t) PFNGLMULTITEXCOORD2DPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD2DVPROC;
alias void function(GLenum target, GLfloat s, GLfloat t) PFNGLMULTITEXCOORD2FPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD2FVPROC;
alias void function(GLenum target, GLint s, GLint t) PFNGLMULTITEXCOORD2IPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD2IVPROC;
alias void function(GLenum target, GLshort s, GLshort t) PFNGLMULTITEXCOORD2SPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD2SVPROC;
alias void function(GLenum target, GLdouble s, GLdouble t, GLdouble r) PFNGLMULTITEXCOORD3DPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD3DVPROC;
alias void function(GLenum target, GLfloat s, GLfloat t, GLfloat r) PFNGLMULTITEXCOORD3FPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD3FVPROC;
alias void function(GLenum target, GLint s, GLint t, GLint r) PFNGLMULTITEXCOORD3IPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD3IVPROC;
alias void function(GLenum target, GLshort s, GLshort t, GLshort r) PFNGLMULTITEXCOORD3SPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD3SVPROC;
alias void function(GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q) PFNGLMULTITEXCOORD4DPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD4DVPROC;
alias void function(GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q) PFNGLMULTITEXCOORD4FPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD4FVPROC;
alias void function(GLenum target, GLint s, GLint t, GLint r, GLint q) PFNGLMULTITEXCOORD4IPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD4IVPROC;
alias void function(GLenum target, GLshort s, GLshort t, GLshort r, GLshort q) PFNGLMULTITEXCOORD4SPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD4SVPROC;
alias void function(GLfloat *m) PFNGLLOADTRANSPOSEMATRIXFPROC;
alias void function(GLdouble *m) PFNGLLOADTRANSPOSEMATRIXDPROC;
alias void function(GLfloat *m) PFNGLMULTTRANSPOSEMATRIXFPROC;
alias void function(GLdouble *m) PFNGLMULTTRANSPOSEMATRIXDPROC;

static const auto GL_VERSION_1_4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendFuncSeparate (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);
	void glMultiDrawArrays (GLenum mode, GLint *first, GLsizei *count, GLsizei primcount);
	void glMultiDrawElements (GLenum mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount);
	void glPointParameterf (GLenum pname, GLfloat param);
	void glPointParameterfv (GLenum pname, GLfloat *params);
	void glPointParameteri (GLenum pname, GLint param);
	void glPointParameteriv (GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha) PFNGLBLENDFUNCSEPARATEPROC;
alias void function(GLenum mode, GLint *first, GLsizei *count, GLsizei primcount) PFNGLMULTIDRAWARRAYSPROC;
alias void function(GLenum mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount) PFNGLMULTIDRAWELEMENTSPROC;
alias void function(GLenum pname, GLfloat param) PFNGLPOINTPARAMETERFPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLPOINTPARAMETERFVPROC;
alias void function(GLenum pname, GLint param) PFNGLPOINTPARAMETERIPROC;
alias void function(GLenum pname, GLint *params) PFNGLPOINTPARAMETERIVPROC;

static const auto GL_VERSION_1_4_DEPRECATED = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFogCoordf (GLfloat coord);
	void glFogCoordfv (GLfloat *coord);
	void glFogCoordd (GLdouble coord);
	void glFogCoorddv (GLdouble *coord);
	void glFogCoordPointer (GLenum type, GLsizei stride, GLvoid *pointer);
	void glSecondaryColor3b (GLbyte red, GLbyte green, GLbyte blue);
	void glSecondaryColor3bv (GLbyte *v);
	void glSecondaryColor3d (GLdouble red, GLdouble green, GLdouble blue);
	void glSecondaryColor3dv (GLdouble *v);
	void glSecondaryColor3f (GLfloat red, GLfloat green, GLfloat blue);
	void glSecondaryColor3fv (GLfloat *v);
	void glSecondaryColor3i (GLint red, GLint green, GLint blue);
	void glSecondaryColor3iv (GLint *v);
	void glSecondaryColor3s (GLshort red, GLshort green, GLshort blue);
	void glSecondaryColor3sv (GLshort *v);
	void glSecondaryColor3ub (GLubyte red, GLubyte green, GLubyte blue);
	void glSecondaryColor3ubv (GLubyte *v);
	void glSecondaryColor3ui (GLuint red, GLuint green, GLuint blue);
	void glSecondaryColor3uiv (GLuint *v);
	void glSecondaryColor3us (GLushort red, GLushort green, GLushort blue);
	void glSecondaryColor3usv (GLushort *v);
	void glSecondaryColorPointer (GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
	void glWindowPos2d (GLdouble x, GLdouble y);
	void glWindowPos2dv (GLdouble *v);
	void glWindowPos2f (GLfloat x, GLfloat y);
	void glWindowPos2fv (GLfloat *v);
	void glWindowPos2i (GLint x, GLint y);
	void glWindowPos2iv (GLint *v);
	void glWindowPos2s (GLshort x, GLshort y);
	void glWindowPos2sv (GLshort *v);
	void glWindowPos3d (GLdouble x, GLdouble y, GLdouble z);
	void glWindowPos3dv (GLdouble *v);
	void glWindowPos3f (GLfloat x, GLfloat y, GLfloat z);
	void glWindowPos3fv (GLfloat *v);
	void glWindowPos3i (GLint x, GLint y, GLint z);
	void glWindowPos3iv (GLint *v);
	void glWindowPos3s (GLshort x, GLshort y, GLshort z);
	void glWindowPos3sv (GLshort *v);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLfloat coord) PFNGLFOGCOORDFPROC;
alias void function(GLfloat *coord) PFNGLFOGCOORDFVPROC;
alias void function(GLdouble coord) PFNGLFOGCOORDDPROC;
alias void function(GLdouble *coord) PFNGLFOGCOORDDVPROC;
alias void function(GLenum type, GLsizei stride, GLvoid *pointer) PFNGLFOGCOORDPOINTERPROC;
alias void function(GLbyte red, GLbyte green, GLbyte blue) PFNGLSECONDARYCOLOR3BPROC;
alias void function(GLbyte *v) PFNGLSECONDARYCOLOR3BVPROC;
alias void function(GLdouble red, GLdouble green, GLdouble blue) PFNGLSECONDARYCOLOR3DPROC;
alias void function(GLdouble *v) PFNGLSECONDARYCOLOR3DVPROC;
alias void function(GLfloat red, GLfloat green, GLfloat blue) PFNGLSECONDARYCOLOR3FPROC;
alias void function(GLfloat *v) PFNGLSECONDARYCOLOR3FVPROC;
alias void function(GLint red, GLint green, GLint blue) PFNGLSECONDARYCOLOR3IPROC;
alias void function(GLint *v) PFNGLSECONDARYCOLOR3IVPROC;
alias void function(GLshort red, GLshort green, GLshort blue) PFNGLSECONDARYCOLOR3SPROC;
alias void function(GLshort *v) PFNGLSECONDARYCOLOR3SVPROC;
alias void function(GLubyte red, GLubyte green, GLubyte blue) PFNGLSECONDARYCOLOR3UBPROC;
alias void function(GLubyte *v) PFNGLSECONDARYCOLOR3UBVPROC;
alias void function(GLuint red, GLuint green, GLuint blue) PFNGLSECONDARYCOLOR3UIPROC;
alias void function(GLuint *v) PFNGLSECONDARYCOLOR3UIVPROC;
alias void function(GLushort red, GLushort green, GLushort blue) PFNGLSECONDARYCOLOR3USPROC;
alias void function(GLushort *v) PFNGLSECONDARYCOLOR3USVPROC;
alias void function(GLint size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLSECONDARYCOLORPOINTERPROC;
alias void function(GLdouble x, GLdouble y) PFNGLWINDOWPOS2DPROC;
alias void function(GLdouble *v) PFNGLWINDOWPOS2DVPROC;
alias void function(GLfloat x, GLfloat y) PFNGLWINDOWPOS2FPROC;
alias void function(GLfloat *v) PFNGLWINDOWPOS2FVPROC;
alias void function(GLint x, GLint y) PFNGLWINDOWPOS2IPROC;
alias void function(GLint *v) PFNGLWINDOWPOS2IVPROC;
alias void function(GLshort x, GLshort y) PFNGLWINDOWPOS2SPROC;
alias void function(GLshort *v) PFNGLWINDOWPOS2SVPROC;
alias void function(GLdouble x, GLdouble y, GLdouble z) PFNGLWINDOWPOS3DPROC;
alias void function(GLdouble *v) PFNGLWINDOWPOS3DVPROC;
alias void function(GLfloat x, GLfloat y, GLfloat z) PFNGLWINDOWPOS3FPROC;
alias void function(GLfloat *v) PFNGLWINDOWPOS3FVPROC;
alias void function(GLint x, GLint y, GLint z) PFNGLWINDOWPOS3IPROC;
alias void function(GLint *v) PFNGLWINDOWPOS3IVPROC;
alias void function(GLshort x, GLshort y, GLshort z) PFNGLWINDOWPOS3SPROC;
alias void function(GLshort *v) PFNGLWINDOWPOS3SVPROC;

static const auto GL_VERSION_1_5 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGenQueries (GLsizei n, GLuint *ids);
	void glDeleteQueries (GLsizei n, GLuint *ids);
	GLboolean glIsQuery (GLuint id);
	void glBeginQuery (GLenum target, GLuint id);
	void glEndQuery (GLenum target);
	void glGetQueryiv (GLenum target, GLenum pname, GLint *params);
	void glGetQueryObjectiv (GLuint id, GLenum pname, GLint *params);
	void glGetQueryObjectuiv (GLuint id, GLenum pname, GLuint *params);
	void glBindBuffer (GLenum target, GLuint buffer);
	void glDeleteBuffers (GLsizei n, GLuint *buffers);
	void glGenBuffers (GLsizei n, GLuint *buffers);
	GLboolean glIsBuffer (GLuint buffer);
	void glBufferData (GLenum target, GLsizeiptr size, GLvoid *data, GLenum usage);
	void glBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data);
	void glGetBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data);
	GLvoid* glMapBuffer (GLenum target, GLenum access);
	GLboolean glUnmapBuffer (GLenum target);
	void glGetBufferParameteriv (GLenum target, GLenum pname, GLint *params);
	void glGetBufferPointerv (GLenum target, GLenum pname, GLvoid* *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLuint *ids) PFNGLGENQUERIESPROC;
alias void function(GLsizei n, GLuint *ids) PFNGLDELETEQUERIESPROC;
alias GLboolean function(GLuint id) PFNGLISQUERYPROC;
alias void function(GLenum target, GLuint id) PFNGLBEGINQUERYPROC;
alias void function(GLenum target) PFNGLENDQUERYPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETQUERYIVPROC;
alias void function(GLuint id, GLenum pname, GLint *params) PFNGLGETQUERYOBJECTIVPROC;
alias void function(GLuint id, GLenum pname, GLuint *params) PFNGLGETQUERYOBJECTUIVPROC;
alias void function(GLenum target, GLuint buffer) PFNGLBINDBUFFERPROC;
alias void function(GLsizei n, GLuint *buffers) PFNGLDELETEBUFFERSPROC;
alias void function(GLsizei n, GLuint *buffers) PFNGLGENBUFFERSPROC;
alias GLboolean function(GLuint buffer) PFNGLISBUFFERPROC;
alias void function(GLenum target, GLsizeiptr size, GLvoid *data, GLenum usage) PFNGLBUFFERDATAPROC;
alias void function(GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data) PFNGLBUFFERSUBDATAPROC;
alias void function(GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data) PFNGLGETBUFFERSUBDATAPROC;
alias GLvoid* (PFNGLMAPBUFFERPROC) (GLenum target, GLenum access);
alias GLboolean function(GLenum target) PFNGLUNMAPBUFFERPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETBUFFERPARAMETERIVPROC;
alias void function(GLenum target, GLenum pname, GLvoid* *params) PFNGLGETBUFFERPOINTERVPROC;

static const auto GL_VERSION_2_0 = 1;

version(GL_GLEXT_PROTOTYPES) {
	void glBlendEquationSeparate (GLenum modeRGB, GLenum modeAlpha);
	void glDrawBuffers (GLsizei n, GLenum *bufs);
	void glStencilOpSeparate (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
	void glStencilFuncSeparate (GLenum frontfunc, GLenum backfunc, GLint _ref, GLuint mask);
	void glStencilMaskSeparate (GLenum face, GLuint mask);
	void glAttachShader (GLuint program, GLuint shader);
	void glBindAttribLocation (GLuint program, GLuint index, GLchar *name);
	void glCompileShader (GLuint shader);
	GLuint glCreateProgram ();
	GLuint glCreateShader (GLenum type);
	void glDeleteProgram (GLuint program);
	void glDeleteShader (GLuint shader);
	void glDetachShader (GLuint program, GLuint shader);
	void glDisableVertexAttribArray (GLuint index);
	void glEnableVertexAttribArray (GLuint index);
	void glGetActiveAttrib (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
	void glGetActiveUniform (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
	void glGetAttachedShaders (GLuint program, GLsizei maxCount, GLsizei *count, GLuint *obj);
	GLint glGetAttribLocation (GLuint program, GLchar *name);
	void glGetProgramiv (GLuint program, GLenum pname, GLint *params);
	void glGetProgramInfoLog (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
	void glGetShaderiv (GLuint shader, GLenum pname, GLint *params);
	void glGetShaderInfoLog (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
	void glGetShaderSource (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source);
	GLint glGetUniformLocation (GLuint program, GLchar *name);
	void glGetUniformfv (GLuint program, GLint location, GLfloat *params);
	void glGetUniformiv (GLuint program, GLint location, GLint *params);
	void glGetVertexAttribdv (GLuint index, GLenum pname, GLdouble *params);
	void glGetVertexAttribfv (GLuint index, GLenum pname, GLfloat *params);
	void glGetVertexAttribiv (GLuint index, GLenum pname, GLint *params);
	void glGetVertexAttribPointerv (GLuint index, GLenum pname, GLvoid* *pointer);
	GLboolean glIsProgram (GLuint program);
	GLboolean glIsShader (GLuint shader);
	void glLinkProgram (GLuint program);
	void glShaderSource (GLuint shader, GLsizei count, GLchar* *string, GLint *length);
	void glUseProgram (GLuint program);
	void glUniform1f (GLint location, GLfloat v0);
	void glUniform2f (GLint location, GLfloat v0, GLfloat v1);
	void glUniform3f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
	void glUniform4f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
	void glUniform1i (GLint location, GLint v0);
	void glUniform2i (GLint location, GLint v0, GLint v1);
	void glUniform3i (GLint location, GLint v0, GLint v1, GLint v2);
	void glUniform4i (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
	void glUniform1fv (GLint location, GLsizei count, GLfloat *value);
	void glUniform2fv (GLint location, GLsizei count, GLfloat *value);
	void glUniform3fv (GLint location, GLsizei count, GLfloat *value);
	void glUniform4fv (GLint location, GLsizei count, GLfloat *value);
	void glUniform1iv (GLint location, GLsizei count, GLint *value);
	void glUniform2iv (GLint location, GLsizei count, GLint *value);
	void glUniform3iv (GLint location, GLsizei count, GLint *value);
	void glUniform4iv (GLint location, GLsizei count, GLint *value);
	void glUniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glValidateProgram (GLuint program);
	void glVertexAttrib1d (GLuint index, GLdouble x);
	void glVertexAttrib1dv (GLuint index, GLdouble *v);
	void glVertexAttrib1f (GLuint index, GLfloat x);
	void glVertexAttrib1fv (GLuint index, GLfloat *v);
	void glVertexAttrib1s (GLuint index, GLshort x);
	void glVertexAttrib1sv (GLuint index, GLshort *v);
	void glVertexAttrib2d (GLuint index, GLdouble x, GLdouble y);
	void glVertexAttrib2dv (GLuint index, GLdouble *v);
	void glVertexAttrib2f (GLuint index, GLfloat x, GLfloat y);
	void glVertexAttrib2fv (GLuint index, GLfloat *v);
	void glVertexAttrib2s (GLuint index, GLshort x, GLshort y);
	void glVertexAttrib2sv (GLuint index, GLshort *v);
	void glVertexAttrib3d (GLuint index, GLdouble x, GLdouble y, GLdouble z);
	void glVertexAttrib3dv (GLuint index, GLdouble *v);
	void glVertexAttrib3f (GLuint index, GLfloat x, GLfloat y, GLfloat z);
	void glVertexAttrib3fv (GLuint index, GLfloat *v);
	void glVertexAttrib3s (GLuint index, GLshort x, GLshort y, GLshort z);
	void glVertexAttrib3sv (GLuint index, GLshort *v);
	void glVertexAttrib4Nbv (GLuint index, GLbyte *v);
	void glVertexAttrib4Niv (GLuint index, GLint *v);
	void glVertexAttrib4Nsv (GLuint index, GLshort *v);
	void glVertexAttrib4Nub (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
	void glVertexAttrib4Nubv (GLuint index, GLubyte *v);
	void glVertexAttrib4Nuiv (GLuint index, GLuint *v);
	void glVertexAttrib4Nusv (GLuint index, GLushort *v);
	void glVertexAttrib4bv (GLuint index, GLbyte *v);
	void glVertexAttrib4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glVertexAttrib4dv (GLuint index, GLdouble *v);
	void glVertexAttrib4f (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glVertexAttrib4fv (GLuint index, GLfloat *v);
	void glVertexAttrib4iv (GLuint index, GLint *v);
	void glVertexAttrib4s (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
	void glVertexAttrib4sv (GLuint index, GLshort *v);
	void glVertexAttrib4ubv (GLuint index, GLubyte *v);
	void glVertexAttrib4uiv (GLuint index, GLuint *v);
	void glVertexAttrib4usv (GLuint index, GLushort *v);
	void glVertexAttribPointer (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum modeRG, GLenum modeAlpha) PFNGLBLENDEQUATIONSEPARATEPROC;
alias void function(GLsizei n, GLenum *bufs) PFNGLDRAWBUFFERSPROC;
alias void function(GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass) PFNGLSTENCILOPSEPARATEPROC;
alias void function(GLenum frontfunc, GLenum backfunc, GLint _ref, GLuint mask) PFNGLSTENCILFUNCSEPARATEPROC;
alias void function(GLenum face, GLuint mask) PFNGLSTENCILMASKSEPARATEPROC;
alias void function(GLuint program, GLuint shader) PFNGLATTACHSHADERPROC;
alias void function(GLuint program, GLuint index, GLchar *name) PFNGLBINDATTRIBLOCATIONPROC;
alias void function(GLuint shader) PFNGLCOMPILESHADERPROC;
alias GLuint function() PFNGLCREATEPROGRAMPROC;
alias GLuint function(GLenum type) PFNGLCREATESHADERPROC;
alias void function(GLuint program) PFNGLDELETEPROGRAMPROC;
alias void function(GLuint shader) PFNGLDELETESHADERPROC;
alias void function(GLuint program, GLuint shader) PFNGLDETACHSHADERPROC;
alias void function(GLuint index) PFNGLDISABLEVERTEXATTRIBARRAYPROC;
alias void function(GLuint index) PFNGLENABLEVERTEXATTRIBARRAYPROC;
alias void function(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name) PFNGLGETACTIVEATTRIBPROC;
alias void function(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name) PFNGLGETACTIVEUNIFORMPROC;
alias void function(GLuint program, GLsizei maxCount, GLsizei *count, GLuint *obj) PFNGLGETATTACHEDSHADERSPROC;
alias GLint function(GLuint program, GLchar *name) PFNGLGETATTRIBLOCATIONPROC;
alias void function(GLuint program, GLenum pname, GLint *params) PFNGLGETPROGRAMIVPROC;
alias void function(GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog) PFNGLGETPROGRAMINFOLOGPROC;
alias void function(GLuint shader, GLenum pname, GLint *params) PFNGLGETSHADERIVPROC;
alias void function(GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog) PFNGLGETSHADERINFOLOGPROC;
alias void function(GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source) PFNGLGETSHADERSOURCEPROC;
alias GLint function(GLuint program, GLchar *name) PFNGLGETUNIFORMLOCATIONPROC;
alias void function(GLuint program, GLint location, GLfloat *params) PFNGLGETUNIFORMFVPROC;
alias void function(GLuint program, GLint location, GLint *params) PFNGLGETUNIFORMIVPROC;
alias void function(GLuint index, GLenum pname, GLdouble *params) PFNGLGETVERTEXATTRIBDVPROC;
alias void function(GLuint index, GLenum pname, GLfloat *params) PFNGLGETVERTEXATTRIBFVPROC;
alias void function(GLuint index, GLenum pname, GLint *params) PFNGLGETVERTEXATTRIBIVPROC;
alias void function(GLuint index, GLenum pname, GLvoid* *pointer) PFNGLGETVERTEXATTRIBPOINTERVPROC;
alias GLboolean function(GLuint program) PFNGLISPROGRAMPROC;
alias GLboolean function(GLuint shader) PFNGLISSHADERPROC;
alias void function(GLuint program) PFNGLLINKPROGRAMPROC;
alias void function(GLuint shader, GLsizei count, GLchar* *string, GLint *length) PFNGLSHADERSOURCEPROC;
alias void function(GLuint program) PFNGLUSEPROGRAMPROC;
alias void function(GLint location, GLfloat v0) PFNGLUNIFORM1FPROC;
alias void function(GLint location, GLfloat v0, GLfloat v1) PFNGLUNIFORM2FPROC;
alias void function(GLint location, GLfloat v0, GLfloat v1, GLfloat v2) PFNGLUNIFORM3FPROC;
alias void function(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3) PFNGLUNIFORM4FPROC;
alias void function(GLint location, GLint v0) PFNGLUNIFORM1IPROC;
alias void function(GLint location, GLint v0, GLint v1) PFNGLUNIFORM2IPROC;
alias void function(GLint location, GLint v0, GLint v1, GLint v2) PFNGLUNIFORM3IPROC;
alias void function(GLint location, GLint v0, GLint v1, GLint v2, GLint v3) PFNGLUNIFORM4IPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM1FVPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM2FVPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM3FVPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM4FVPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM1IVPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM2IVPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM3IVPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM4IVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX2FVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX3FVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX4FVPROC;
alias void function(GLuint program) PFNGLVALIDATEPROGRAMPROC;
alias void function(GLuint index, GLdouble x) PFNGLVERTEXATTRIB1DPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB1DVPROC;
alias void function(GLuint index, GLfloat x) PFNGLVERTEXATTRIB1FPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB1FVPROC;
alias void function(GLuint index, GLshort x) PFNGLVERTEXATTRIB1SPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB1SVPROC;
alias void function(GLuint index, GLdouble x, GLdouble y) PFNGLVERTEXATTRIB2DPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB2DVPROC;
alias void function(GLuint index, GLfloat x, GLfloat y) PFNGLVERTEXATTRIB2FPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB2FVPROC;
alias void function(GLuint index, GLshort x, GLshort y) PFNGLVERTEXATTRIB2SPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB2SVPROC;
alias void function(GLuint index, GLdouble x, GLdouble y, GLdouble z) PFNGLVERTEXATTRIB3DPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB3DVPROC;
alias void function(GLuint index, GLfloat x, GLfloat y, GLfloat z) PFNGLVERTEXATTRIB3FPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB3FVPROC;
alias void function(GLuint index, GLshort x, GLshort y, GLshort z) PFNGLVERTEXATTRIB3SPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB3SVPROC;
alias void function(GLuint index, GLbyte *v) PFNGLVERTEXATTRIB4NBVPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIB4NIVPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB4NSVPROC;
alias void function(GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w) PFNGLVERTEXATTRIB4NUBPROC;
alias void function(GLuint index, GLubyte *v) PFNGLVERTEXATTRIB4NUBVPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIB4NUIVPROC;
alias void function(GLuint index, GLushort *v) PFNGLVERTEXATTRIB4NUSVPROC;
alias void function(GLuint index, GLbyte *v) PFNGLVERTEXATTRIB4BVPROC;
alias void function(GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLVERTEXATTRIB4DPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB4DVPROC;
alias void function(GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLVERTEXATTRIB4FPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB4FVPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIB4IVPROC;
alias void function(GLuint index, GLshort x, GLshort y, GLshort z, GLshort w) PFNGLVERTEXATTRIB4SPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB4SVPROC;
alias void function(GLuint index, GLubyte *v) PFNGLVERTEXATTRIB4UBVPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIB4UIVPROC;
alias void function(GLuint index, GLushort *v) PFNGLVERTEXATTRIB4USVPROC;
alias void function(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLvoid *pointer) PFNGLVERTEXATTRIBPOINTERPROC;

static const auto GL_VERSION_2_1 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glUniformMatrix2x3fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix3x2fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix2x4fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix4x2fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix3x4fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix4x3fv (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX2X3FVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX3X2FVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX2X4FVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX4X2FVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX3X4FVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX4X3FVPROC;

static const auto GL_VERSION_3_0 = 1;
/* OpenGL 3.0 also reuses entry points from these extensions: */
/* ARB_framebuffer_object */
/* ARB_map_buffer_range */
/* ARB_vertex_array_object */
version(GL_GLEXT_PROTOTYPES) {
	void glColorMaski (GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a);
	void glGetBooleani_v (GLenum target, GLuint index, GLboolean *data);
	void glGetIntegeri_v (GLenum target, GLuint index, GLint *data);
	void glEnablei (GLenum target, GLuint index);
	void glDisablei (GLenum target, GLuint index);
	GLboolean glIsEnabledi (GLenum target, GLuint index);
	void glBeginTransformFeedback (GLenum primitiveMode);
	void glEndTransformFeedback ();
	void glBindBufferRange (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size);
	void glBindBufferBase (GLenum target, GLuint index, GLuint buffer);
	void glTransformFeedbackVaryings (GLuint program, GLsizei count, GLchar* *varyings, GLenum bufferMode);
	void glGetTransformFeedbackVarying (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name);
	void glClampColor (GLenum target, GLenum clamp);
	void glBeginConditionalRender (GLuint id, GLenum mode);
	void glEndConditionalRender ();
	void glVertexAttribIPointer (GLuint index, GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
	void glGetVertexAttribIiv (GLuint index, GLenum pname, GLint *params);
	void glGetVertexAttribIuiv (GLuint index, GLenum pname, GLuint *params);
	void glVertexAttribI1i (GLuint index, GLint x);
	void glVertexAttribI2i (GLuint index, GLint x, GLint y);
	void glVertexAttribI3i (GLuint index, GLint x, GLint y, GLint z);
	void glVertexAttribI4i (GLuint index, GLint x, GLint y, GLint z, GLint w);
	void glVertexAttribI1ui (GLuint index, GLuint x);
	void glVertexAttribI2ui (GLuint index, GLuint x, GLuint y);
	void glVertexAttribI3ui (GLuint index, GLuint x, GLuint y, GLuint z);
	void glVertexAttribI4ui (GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
	void glVertexAttribI1iv (GLuint index, GLint *v);
	void glVertexAttribI2iv (GLuint index, GLint *v);
	void glVertexAttribI3iv (GLuint index, GLint *v);
	void glVertexAttribI4iv (GLuint index, GLint *v);
	void glVertexAttribI1uiv (GLuint index, GLuint *v);
	void glVertexAttribI2uiv (GLuint index, GLuint *v);
	void glVertexAttribI3uiv (GLuint index, GLuint *v);
	void glVertexAttribI4uiv (GLuint index, GLuint *v);
	void glVertexAttribI4bv (GLuint index, GLbyte *v);
	void glVertexAttribI4sv (GLuint index, GLshort *v);
	void glVertexAttribI4ubv (GLuint index, GLubyte *v);
	void glVertexAttribI4usv (GLuint index, GLushort *v);
	void glGetUniformuiv (GLuint program, GLint location, GLuint *params);
	void glBindFragDataLocation (GLuint program, GLuint color, GLchar *name);
	GLint glGetFragDataLocation (GLuint program, GLchar *name);
	void glUniform1ui (GLint location, GLuint v0);
	void glUniform2ui (GLint location, GLuint v0, GLuint v1);
	void glUniform3ui (GLint location, GLuint v0, GLuint v1, GLuint v2);
	void glUniform4ui (GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
	void glUniform1uiv (GLint location, GLsizei count, GLuint *value);
	void glUniform2uiv (GLint location, GLsizei count, GLuint *value);
	void glUniform3uiv (GLint location, GLsizei count, GLuint *value);
	void glUniform4uiv (GLint location, GLsizei count, GLuint *value);
	void glTexParameterIiv (GLenum target, GLenum pname, GLint *params);
	void glTexParameterIuiv (GLenum target, GLenum pname, GLuint *params);
	void glGetTexParameterIiv (GLenum target, GLenum pname, GLint *params);
	void glGetTexParameterIuiv (GLenum target, GLenum pname, GLuint *params);
	void glClearBufferiv (GLenum buffer, GLint drawbuffer, GLint *value);
	void glClearBufferuiv (GLenum buffer, GLint drawbuffer, GLuint *value);
	void glClearBufferfv (GLenum buffer, GLint drawbuffer, GLfloat *value);
	void glClearBufferfi (GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil);
	GLubyte * glGetStringi (GLenum name, GLuint index);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a) PFNGLCOLORMASKIPROC;
alias void function(GLenum target, GLuint index, GLboolean *data) PFNGLGETBOOLEANI_VPROC;
alias void function(GLenum target, GLuint index, GLint *data) PFNGLGETINTEGERI_VPROC;
alias void function(GLenum target, GLuint index) PFNGLENABLEIPROC;
alias void function(GLenum target, GLuint index) PFNGLDISABLEIPROC;
alias GLboolean function(GLenum target, GLuint index) PFNGLISENABLEDIPROC;
alias void function(GLenum primitiveMode) PFNGLBEGINTRANSFORMFEEDBACKPROC;
alias void function() PFNGLENDTRANSFORMFEEDBACKPROC;
alias void function(GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size) PFNGLBINDBUFFERRANGEPROC;
alias void function(GLenum target, GLuint index, GLuint buffer) PFNGLBINDBUFFERBASEPROC;
alias void function(GLuint program, GLsizei count, GLchar* *varyings, GLenum bufferMode) PFNGLTRANSFORMFEEDBACKVARYINGSPROC;
alias void function(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name) PFNGLGETTRANSFORMFEEDBACKVARYINGPROC;
alias void function(GLenum target, GLenum clamp) PFNGLCLAMPCOLORPROC;
alias void function(GLuint id, GLenum mode) PFNGLBEGINCONDITIONALRENDERPROC;
alias void function() PFNGLENDCONDITIONALRENDERPROC;
alias void function(GLuint index, GLint size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLVERTEXATTRIBIPOINTERPROC;
alias void function(GLuint index, GLenum pname, GLint *params) PFNGLGETVERTEXATTRIBIIVPROC;
alias void function(GLuint index, GLenum pname, GLuint *params) PFNGLGETVERTEXATTRIBIUIVPROC;
alias void function(GLuint index, GLint x) PFNGLVERTEXATTRIBI1IPROC;
alias void function(GLuint index, GLint x, GLint y) PFNGLVERTEXATTRIBI2IPROC;
alias void function(GLuint index, GLint x, GLint y, GLint z) PFNGLVERTEXATTRIBI3IPROC;
alias void function(GLuint index, GLint x, GLint y, GLint z, GLint w) PFNGLVERTEXATTRIBI4IPROC;
alias void function(GLuint index, GLuint x) PFNGLVERTEXATTRIBI1UIPROC;
alias void function(GLuint index, GLuint x, GLuint y) PFNGLVERTEXATTRIBI2UIPROC;
alias void function(GLuint index, GLuint x, GLuint y, GLuint z) PFNGLVERTEXATTRIBI3UIPROC;
alias void function(GLuint index, GLuint x, GLuint y, GLuint z, GLuint w) PFNGLVERTEXATTRIBI4UIPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI1IVPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI2IVPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI3IVPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI4IVPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI1UIVPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI2UIVPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI3UIVPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI4UIVPROC;
alias void function(GLuint index, GLbyte *v) PFNGLVERTEXATTRIBI4BVPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIBI4SVPROC;
alias void function(GLuint index, GLubyte *v) PFNGLVERTEXATTRIBI4UBVPROC;
alias void function(GLuint index, GLushort *v) PFNGLVERTEXATTRIBI4USVPROC;
alias void function(GLuint program, GLint location, GLuint *params) PFNGLGETUNIFORMUIVPROC;
alias void function(GLuint program, GLuint color, GLchar *name) PFNGLBINDFRAGDATALOCATIONPROC;
alias GLint function(GLuint program, GLchar *name) PFNGLGETFRAGDATALOCATIONPROC;
alias void function(GLint location, GLuint v0) PFNGLUNIFORM1UIPROC;
alias void function(GLint location, GLuint v0, GLuint v1) PFNGLUNIFORM2UIPROC;
alias void function(GLint location, GLuint v0, GLuint v1, GLuint v2) PFNGLUNIFORM3UIPROC;
alias void function(GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3) PFNGLUNIFORM4UIPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM1UIVPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM2UIVPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM3UIVPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM4UIVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLTEXPARAMETERIIVPROC;
alias void function(GLenum target, GLenum pname, GLuint *params) PFNGLTEXPARAMETERIUIVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETTEXPARAMETERIIVPROC;
alias void function(GLenum target, GLenum pname, GLuint *params) PFNGLGETTEXPARAMETERIUIVPROC;
alias void function(GLenum buffer, GLint drawbuffer, GLint *value) PFNGLCLEARBUFFERIVPROC;
alias void function(GLenum buffer, GLint drawbuffer, GLuint *value) PFNGLCLEARBUFFERUIVPROC;
alias void function(GLenum buffer, GLint drawbuffer, GLfloat *value) PFNGLCLEARBUFFERFVPROC;
alias void function(GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil) PFNGLCLEARBUFFERFIPROC;
alias GLubyte * (PFNGLGETSTRINGIPROC) (GLenum name, GLuint index);

static const auto GL_VERSION_3_1 = 1;
/* OpenGL 3.1 also reuses entry points from these extensions: */
/* ARB_copy_buffer */
/* ARB_uniform_buffer_object */
version(GL_GLEXT_PROTOTYPES) {
	void glDrawArraysInstanced (GLenum mode, GLint first, GLsizei count, GLsizei primcount);
	void glDrawElementsInstanced (GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount);
	void glTexBuffer (GLenum target, GLenum internalformat, GLuint buffer);
	void glPrimitiveRestartIndex (GLuint index);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLint first, GLsizei count, GLsizei primcount) PFNGLDRAWARRAYSINSTANCEDPROC;
alias void function(GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount) PFNGLDRAWELEMENTSINSTANCEDPROC;
alias void function(GLenum target, GLenum internalformat, GLuint buffer) PFNGLTEXBUFFERPROC;
alias void function(GLuint index) PFNGLPRIMITIVERESTARTINDEXPROC;


static const auto GL_VERSION_3_2 = 1;
/* OpenGL 3.2 also reuses entry points from these extensions: */
/* ARB_draw_elements_base_vertex */
/* ARB_provoking_vertex */
/* ARB_sync */
/* ARB_texture_multisample */
version(GL_GLEXT_PROTOTYPES) {
	void glGetInteger64i_v (GLenum target, GLuint index, GLint64 *data);
	void glGetBufferParameteri64v (GLenum target, GLenum pname, GLint64 *params);
	void glProgramParameteri (GLuint program, GLenum pname, GLint value);
	void glFramebufferTexture (GLenum target, GLenum attachment, GLuint texture, GLint level);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint index, GLint64 *data) PFNGLGETINTEGER64I_VPROC;
alias void function(GLenum target, GLenum pname, GLint64 *params) PFNGLGETBUFFERPARAMETERI64VPROC;
alias void function(GLuint program, GLenum pname, GLint value) PFNGLPROGRAMPARAMETERIPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level) PFNGLFRAMEBUFFERTEXTUREPROC;

static const auto GL_VERSION_3_3 = 1;
/* OpenGL 3.3 also reuses entry points from these extensions: */
/* ARB_blend_func_extended */
/* ARB_sampler_objects */
/* ARB_explicit_attrib_location, but it has none */
/* ARB_occlusion_query2 (no entry points) */
/* ARB_shader_bit_encoding (no entry points) */
/* ARB_texture_rgb10_a2ui (no entry points) */
/* ARB_texture_swizzle (no entry points) */
/* ARB_timer_query */
/* ARB_vertex_type_2_10_10_10_rev */

static const auto GL_VERSION_4_0 = 1;
/* OpenGL 4.0 also reuses entry points from these extensions: */
/* ARB_gpu_shader5 (no entry points) */
/* ARB_gpu_shader_fp64 */
/* ARB_shader_subroutine */
/* ARB_tessellation_shader */
/* ARB_texture_buffer_object_rgb32 (no entry points) */
/* ARB_transform_feedback2 */
/* ARB_transform_feedback3 */

static const auto GL_ARB_multitexture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glActiveTextureARB (GLenum texture);
	void glClientActiveTextureARB (GLenum texture);
	void glMultiTexCoord1dARB (GLenum target, GLdouble s);
	void glMultiTexCoord1dvARB (GLenum target, GLdouble *v);
	void glMultiTexCoord1fARB (GLenum target, GLfloat s);
	void glMultiTexCoord1fvARB (GLenum target, GLfloat *v);
	void glMultiTexCoord1iARB (GLenum target, GLint s);
	void glMultiTexCoord1ivARB (GLenum target, GLint *v);
	void glMultiTexCoord1sARB (GLenum target, GLshort s);
	void glMultiTexCoord1svARB (GLenum target, GLshort *v);
	void glMultiTexCoord2dARB (GLenum target, GLdouble s, GLdouble t);
	void glMultiTexCoord2dvARB (GLenum target, GLdouble *v);
	void glMultiTexCoord2fARB (GLenum target, GLfloat s, GLfloat t);
	void glMultiTexCoord2fvARB (GLenum target, GLfloat *v);
	void glMultiTexCoord2iARB (GLenum target, GLint s, GLint t);
	void glMultiTexCoord2ivARB (GLenum target, GLint *v);
	void glMultiTexCoord2sARB (GLenum target, GLshort s, GLshort t);
	void glMultiTexCoord2svARB (GLenum target, GLshort *v);
	void glMultiTexCoord3dARB (GLenum target, GLdouble s, GLdouble t, GLdouble r);
	void glMultiTexCoord3dvARB (GLenum target, GLdouble *v);
	void glMultiTexCoord3fARB (GLenum target, GLfloat s, GLfloat t, GLfloat r);
	void glMultiTexCoord3fvARB (GLenum target, GLfloat *v);
	void glMultiTexCoord3iARB (GLenum target, GLint s, GLint t, GLint r);
	void glMultiTexCoord3ivARB (GLenum target, GLint *v);
	void glMultiTexCoord3sARB (GLenum target, GLshort s, GLshort t, GLshort r);
	void glMultiTexCoord3svARB (GLenum target, GLshort *v);
	void glMultiTexCoord4dARB (GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
	void glMultiTexCoord4dvARB (GLenum target, GLdouble *v);
	void glMultiTexCoord4fARB (GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
	void glMultiTexCoord4fvARB (GLenum target, GLfloat *v);
	void glMultiTexCoord4iARB (GLenum target, GLint s, GLint t, GLint r, GLint q);
	void glMultiTexCoord4ivARB (GLenum target, GLint *v);
	void glMultiTexCoord4sARB (GLenum target, GLshort s, GLshort t, GLshort r, GLshort q);
	void glMultiTexCoord4svARB (GLenum target, GLshort *v);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum texture) PFNGLACTIVETEXTUREARBPROC;
alias void function(GLenum texture) PFNGLCLIENTACTIVETEXTUREARBPROC;
alias void function(GLenum target, GLdouble s) PFNGLMULTITEXCOORD1DARBPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD1DVARBPROC;
alias void function(GLenum target, GLfloat s) PFNGLMULTITEXCOORD1FARBPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD1FVARBPROC;
alias void function(GLenum target, GLint s) PFNGLMULTITEXCOORD1IARBPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD1IVARBPROC;
alias void function(GLenum target, GLshort s) PFNGLMULTITEXCOORD1SARBPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD1SVARBPROC;
alias void function(GLenum target, GLdouble s, GLdouble t) PFNGLMULTITEXCOORD2DARBPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD2DVARBPROC;
alias void function(GLenum target, GLfloat s, GLfloat t) PFNGLMULTITEXCOORD2FARBPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD2FVARBPROC;
alias void function(GLenum target, GLint s, GLint t) PFNGLMULTITEXCOORD2IARBPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD2IVARBPROC;
alias void function(GLenum target, GLshort s, GLshort t) PFNGLMULTITEXCOORD2SARBPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD2SVARBPROC;
alias void function(GLenum target, GLdouble s, GLdouble t, GLdouble r) PFNGLMULTITEXCOORD3DARBPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD3DVARBPROC;
alias void function(GLenum target, GLfloat s, GLfloat t, GLfloat r) PFNGLMULTITEXCOORD3FARBPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD3FVARBPROC;
alias void function(GLenum target, GLint s, GLint t, GLint r) PFNGLMULTITEXCOORD3IARBPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD3IVARBPROC;
alias void function(GLenum target, GLshort s, GLshort t, GLshort r) PFNGLMULTITEXCOORD3SARBPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD3SVARBPROC;
alias void function(GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q) PFNGLMULTITEXCOORD4DARBPROC;
alias void function(GLenum target, GLdouble *v) PFNGLMULTITEXCOORD4DVARBPROC;
alias void function(GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q) PFNGLMULTITEXCOORD4FARBPROC;
alias void function(GLenum target, GLfloat *v) PFNGLMULTITEXCOORD4FVARBPROC;
alias void function(GLenum target, GLint s, GLint t, GLint r, GLint q) PFNGLMULTITEXCOORD4IARBPROC;
alias void function(GLenum target, GLint *v) PFNGLMULTITEXCOORD4IVARBPROC;
alias void function(GLenum target, GLshort s, GLshort t, GLshort r, GLshort q) PFNGLMULTITEXCOORD4SARBPROC;
alias void function(GLenum target, GLshort *v) PFNGLMULTITEXCOORD4SVARBPROC;

static const auto GL_ARB_transpose_matrix = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glLoadTransposeMatrixfARB (GLfloat *m);
	void glLoadTransposeMatrixdARB (GLdouble *m);
	void glMultTransposeMatrixfARB (GLfloat *m);
	void glMultTransposeMatrixdARB (GLdouble *m);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLfloat *m) PFNGLLOADTRANSPOSEMATRIXFARBPROC;
alias void function(GLdouble *m) PFNGLLOADTRANSPOSEMATRIXDARBPROC;
alias void function(GLfloat *m) PFNGLMULTTRANSPOSEMATRIXFARBPROC;
alias void function(GLdouble *m) PFNGLMULTTRANSPOSEMATRIXDARBPROC;

static const auto GL_ARB_multisample = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glSampleCoverageARB (GLclampf value, GLboolean invert);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLclampf value, GLboolean invert) PFNGLSAMPLECOVERAGEARBPROC;

static const auto GL_ARB_texture_env_add = 1;

static const auto GL_ARB_texture_cube_map = 1;

static const auto GL_ARB_texture_compression = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCompressedTexImage3DARB (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *data);
	void glCompressedTexImage2DARB (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *data);
	void glCompressedTexImage1DARB (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *data);
	void glCompressedTexSubImage3DARB (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *data);
	void glCompressedTexSubImage2DARB (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *data);
	void glCompressedTexSubImage1DARB (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *data);
	void glGetCompressedTexImageARB (GLenum target, GLint level, GLvoid *img);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXIMAGE3DARBPROC;
alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXIMAGE2DARBPROC;
alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXIMAGE1DARBPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXSUBIMAGE3DARBPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXSUBIMAGE2DARBPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *data) PFNGLCOMPRESSEDTEXSUBIMAGE1DARBPROC;
alias void function(GLenum target, GLint level, GLvoid *img) PFNGLGETCOMPRESSEDTEXIMAGEARBPROC;

static const auto GL_ARB_texture_border_clamp = 1;

static const auto GL_ARB_point_parameters = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPointParameterfARB (GLenum pname, GLfloat param);
	void glPointParameterfvARB (GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLfloat param) PFNGLPOINTPARAMETERFARBPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLPOINTPARAMETERFVARBPROC;

static const auto GL_ARB_vertex_blend = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glWeightbvARB (GLint size, GLbyte *weights);
	void glWeightsvARB (GLint size, GLshort *weights);
	void glWeightivARB (GLint size, GLint *weights);
	void glWeightfvARB (GLint size, GLfloat *weights);
	void glWeightdvARB (GLint size, GLdouble *weights);
	void glWeightubvARB (GLint size, GLubyte *weights);
	void glWeightusvARB (GLint size, GLushort *weights);
	void glWeightuivARB (GLint size, GLuint *weights);
	void glWeightPointerARB (GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
	void glVertexBlendARB (GLint count);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint size, GLbyte *weights) PFNGLWEIGHTBVARBPROC;
alias void function(GLint size, GLshort *weights) PFNGLWEIGHTSVARBPROC;
alias void function(GLint size, GLint *weights) PFNGLWEIGHTIVARBPROC;
alias void function(GLint size, GLfloat *weights) PFNGLWEIGHTFVARBPROC;
alias void function(GLint size, GLdouble *weights) PFNGLWEIGHTDVARBPROC;
alias void function(GLint size, GLubyte *weights) PFNGLWEIGHTUBVARBPROC;
alias void function(GLint size, GLushort *weights) PFNGLWEIGHTUSVARBPROC;
alias void function(GLint size, GLuint *weights) PFNGLWEIGHTUIVARBPROC;
alias void function(GLint size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLWEIGHTPOINTERARBPROC;
alias void function(GLint count) PFNGLVERTEXBLENDARBPROC;

static const auto GL_ARB_matrix_palette = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCurrentPaletteMatrixARB (GLint index);
	void glMatrixIndexubvARB (GLint size, GLubyte *indices);
	void glMatrixIndexusvARB (GLint size, GLushort *indices);
	void glMatrixIndexuivARB (GLint size, GLuint *indices);
	void glMatrixIndexPointerARB (GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint index) PFNGLCURRENTPALETTEMATRIXARBPROC;
alias void function(GLint size, GLubyte *indices) PFNGLMATRIXINDEXUBVARBPROC;
alias void function(GLint size, GLushort *indices) PFNGLMATRIXINDEXUSVARBPROC;
alias void function(GLint size, GLuint *indices) PFNGLMATRIXINDEXUIVARBPROC;
alias void function(GLint size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLMATRIXINDEXPOINTERARBPROC;

static const auto GL_ARB_texture_env_combine = 1;

static const auto GL_ARB_texture_env_crossbar = 1;

static const auto GL_ARB_texture_env_dot3 = 1;

static const auto GL_ARB_texture_mirrored_repeat = 1;

static const auto GL_ARB_depth_texture = 1;

static const auto GL_ARB_shadow = 1;

static const auto GL_ARB_shadow_ambient = 1;

static const auto GL_ARB_window_pos = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glWindowPos2dARB (GLdouble x, GLdouble y);
	void glWindowPos2dvARB (GLdouble *v);
	void glWindowPos2fARB (GLfloat x, GLfloat y);
	void glWindowPos2fvARB (GLfloat *v);
	void glWindowPos2iARB (GLint x, GLint y);
	void glWindowPos2ivARB (GLint *v);
	void glWindowPos2sARB (GLshort x, GLshort y);
	void glWindowPos2svARB (GLshort *v);
	void glWindowPos3dARB (GLdouble x, GLdouble y, GLdouble z);
	void glWindowPos3dvARB (GLdouble *v);
	void glWindowPos3fARB (GLfloat x, GLfloat y, GLfloat z);
	void glWindowPos3fvARB (GLfloat *v);
	void glWindowPos3iARB (GLint x, GLint y, GLint z);
	void glWindowPos3ivARB (GLint *v);
	void glWindowPos3sARB (GLshort x, GLshort y, GLshort z);
	void glWindowPos3svARB (GLshort *v);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLdouble x, GLdouble y) PFNGLWINDOWPOS2DARBPROC;
alias void function(GLdouble *v) PFNGLWINDOWPOS2DVARBPROC;
alias void function(GLfloat x, GLfloat y) PFNGLWINDOWPOS2FARBPROC;
alias void function(GLfloat *v) PFNGLWINDOWPOS2FVARBPROC;
alias void function(GLint x, GLint y) PFNGLWINDOWPOS2IARBPROC;
alias void function(GLint *v) PFNGLWINDOWPOS2IVARBPROC;
alias void function(GLshort x, GLshort y) PFNGLWINDOWPOS2SARBPROC;
alias void function(GLshort *v) PFNGLWINDOWPOS2SVARBPROC;
alias void function(GLdouble x, GLdouble y, GLdouble z) PFNGLWINDOWPOS3DARBPROC;
alias void function(GLdouble *v) PFNGLWINDOWPOS3DVARBPROC;
alias void function(GLfloat x, GLfloat y, GLfloat z) PFNGLWINDOWPOS3FARBPROC;
alias void function(GLfloat *v) PFNGLWINDOWPOS3FVARBPROC;
alias void function(GLint x, GLint y, GLint z) PFNGLWINDOWPOS3IARBPROC;
alias void function(GLint *v) PFNGLWINDOWPOS3IVARBPROC;
alias void function(GLshort x, GLshort y, GLshort z) PFNGLWINDOWPOS3SARBPROC;
alias void function(GLshort *v) PFNGLWINDOWPOS3SVARBPROC;

static const auto GL_ARB_vertex_program = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexAttrib1dARB (GLuint index, GLdouble x);
	void glVertexAttrib1dvARB (GLuint index, GLdouble *v);
	void glVertexAttrib1fARB (GLuint index, GLfloat x);
	void glVertexAttrib1fvARB (GLuint index, GLfloat *v);
	void glVertexAttrib1sARB (GLuint index, GLshort x);
	void glVertexAttrib1svARB (GLuint index, GLshort *v);
	void glVertexAttrib2dARB (GLuint index, GLdouble x, GLdouble y);
	void glVertexAttrib2dvARB (GLuint index, GLdouble *v);
	void glVertexAttrib2fARB (GLuint index, GLfloat x, GLfloat y);
	void glVertexAttrib2fvARB (GLuint index, GLfloat *v);
	void glVertexAttrib2sARB (GLuint index, GLshort x, GLshort y);
	void glVertexAttrib2svARB (GLuint index, GLshort *v);
	void glVertexAttrib3dARB (GLuint index, GLdouble x, GLdouble y, GLdouble z);
	void glVertexAttrib3dvARB (GLuint index, GLdouble *v);
	void glVertexAttrib3fARB (GLuint index, GLfloat x, GLfloat y, GLfloat z);
	void glVertexAttrib3fvARB (GLuint index, GLfloat *v);
	void glVertexAttrib3sARB (GLuint index, GLshort x, GLshort y, GLshort z);
	void glVertexAttrib3svARB (GLuint index, GLshort *v);
	void glVertexAttrib4NbvARB (GLuint index, GLbyte *v);
	void glVertexAttrib4NivARB (GLuint index, GLint *v);
	void glVertexAttrib4NsvARB (GLuint index, GLshort *v);
	void glVertexAttrib4NubARB (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
	void glVertexAttrib4NubvARB (GLuint index, GLubyte *v);
	void glVertexAttrib4NuivARB (GLuint index, GLuint *v);
	void glVertexAttrib4NusvARB (GLuint index, GLushort *v);
	void glVertexAttrib4bvARB (GLuint index, GLbyte *v);
	void glVertexAttrib4dARB (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glVertexAttrib4dvARB (GLuint index, GLdouble *v);
	void glVertexAttrib4fARB (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glVertexAttrib4fvARB (GLuint index, GLfloat *v);
	void glVertexAttrib4ivARB (GLuint index, GLint *v);
	void glVertexAttrib4sARB (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
	void glVertexAttrib4svARB (GLuint index, GLshort *v);
	void glVertexAttrib4ubvARB (GLuint index, GLubyte *v);
	void glVertexAttrib4uivARB (GLuint index, GLuint *v);
	void glVertexAttrib4usvARB (GLuint index, GLushort *v);
	void glVertexAttribPointerARB (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLvoid *pointer);
	void glEnableVertexAttribArrayARB (GLuint index);
	void glDisableVertexAttribArrayARB (GLuint index);
	void glProgramStringARB (GLenum target, GLenum format, GLsizei len, GLvoid *string);
	void glBindProgramARB (GLenum target, GLuint program);
	void glDeleteProgramsARB (GLsizei n, GLuint *programs);
	void glGenProgramsARB (GLsizei n, GLuint *programs);
	void glProgramEnvParameter4dARB (GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glProgramEnvParameter4dvARB (GLenum target, GLuint index, GLdouble *params);
	void glProgramEnvParameter4fARB (GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glProgramEnvParameter4fvARB (GLenum target, GLuint index, GLfloat *params);
	void glProgramLocalParameter4dARB (GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glProgramLocalParameter4dvARB (GLenum target, GLuint index, GLdouble *params);
	void glProgramLocalParameter4fARB (GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glProgramLocalParameter4fvARB (GLenum target, GLuint index, GLfloat *params);
	void glGetProgramEnvParameterdvARB (GLenum target, GLuint index, GLdouble *params);
	void glGetProgramEnvParameterfvARB (GLenum target, GLuint index, GLfloat *params);
	void glGetProgramLocalParameterdvARB (GLenum target, GLuint index, GLdouble *params);
	void glGetProgramLocalParameterfvARB (GLenum target, GLuint index, GLfloat *params);
	void glGetProgramivARB (GLenum target, GLenum pname, GLint *params);
	void glGetProgramStringARB (GLenum target, GLenum pname, GLvoid *string);
	void glGetVertexAttribdvARB (GLuint index, GLenum pname, GLdouble *params);
	void glGetVertexAttribfvARB (GLuint index, GLenum pname, GLfloat *params);
	void glGetVertexAttribivARB (GLuint index, GLenum pname, GLint *params);
	void glGetVertexAttribPointervARB (GLuint index, GLenum pname, GLvoid* *pointer);
	GLboolean glIsProgramARB (GLuint program);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint index, GLdouble x) PFNGLVERTEXATTRIB1DARBPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB1DVARBPROC;
alias void function(GLuint index, GLfloat x) PFNGLVERTEXATTRIB1FARBPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB1FVARBPROC;
alias void function(GLuint index, GLshort x) PFNGLVERTEXATTRIB1SARBPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB1SVARBPROC;
alias void function(GLuint index, GLdouble x, GLdouble y) PFNGLVERTEXATTRIB2DARBPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB2DVARBPROC;
alias void function(GLuint index, GLfloat x, GLfloat y) PFNGLVERTEXATTRIB2FARBPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB2FVARBPROC;
alias void function(GLuint index, GLshort x, GLshort y) PFNGLVERTEXATTRIB2SARBPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB2SVARBPROC;
alias void function(GLuint index, GLdouble x, GLdouble y, GLdouble z) PFNGLVERTEXATTRIB3DARBPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB3DVARBPROC;
alias void function(GLuint index, GLfloat x, GLfloat y, GLfloat z) PFNGLVERTEXATTRIB3FARBPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB3FVARBPROC;
alias void function(GLuint index, GLshort x, GLshort y, GLshort z) PFNGLVERTEXATTRIB3SARBPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB3SVARBPROC;
alias void function(GLuint index, GLbyte *v) PFNGLVERTEXATTRIB4NBVARBPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIB4NIVARBPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB4NSVARBPROC;
alias void function(GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w) PFNGLVERTEXATTRIB4NUBARBPROC;
alias void function(GLuint index, GLubyte *v) PFNGLVERTEXATTRIB4NUBVARBPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIB4NUIVARBPROC;
alias void function(GLuint index, GLushort *v) PFNGLVERTEXATTRIB4NUSVARBPROC;
alias void function(GLuint index, GLbyte *v) PFNGLVERTEXATTRIB4BVARBPROC;
alias void function(GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLVERTEXATTRIB4DARBPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB4DVARBPROC;
alias void function(GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLVERTEXATTRIB4FARBPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB4FVARBPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIB4IVARBPROC;
alias void function(GLuint index, GLshort x, GLshort y, GLshort z, GLshort w) PFNGLVERTEXATTRIB4SARBPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB4SVARBPROC;
alias void function(GLuint index, GLubyte *v) PFNGLVERTEXATTRIB4UBVARBPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIB4UIVARBPROC;
alias void function(GLuint index, GLushort *v) PFNGLVERTEXATTRIB4USVARBPROC;
alias void function(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLvoid *pointer) PFNGLVERTEXATTRIBPOINTERARBPROC;
alias void function(GLuint index) PFNGLENABLEVERTEXATTRIBARRAYARBPROC;
alias void function(GLuint index) PFNGLDISABLEVERTEXATTRIBARRAYARBPROC;
alias void function(GLenum target, GLenum format, GLsizei len, GLvoid *string) PFNGLPROGRAMSTRINGARBPROC;
alias void function(GLenum target, GLuint program) PFNGLBINDPROGRAMARBPROC;
alias void function(GLsizei n, GLuint *programs) PFNGLDELETEPROGRAMSARBPROC;
alias void function(GLsizei n, GLuint *programs) PFNGLGENPROGRAMSARBPROC;
alias void function(GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLPROGRAMENVPARAMETER4DARBPROC;
alias void function(GLenum target, GLuint index, GLdouble *params) PFNGLPROGRAMENVPARAMETER4DVARBPROC;
alias void function(GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLPROGRAMENVPARAMETER4FARBPROC;
alias void function(GLenum target, GLuint index, GLfloat *params) PFNGLPROGRAMENVPARAMETER4FVARBPROC;
alias void function(GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLPROGRAMLOCALPARAMETER4DARBPROC;
alias void function(GLenum target, GLuint index, GLdouble *params) PFNGLPROGRAMLOCALPARAMETER4DVARBPROC;
alias void function(GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLPROGRAMLOCALPARAMETER4FARBPROC;
alias void function(GLenum target, GLuint index, GLfloat *params) PFNGLPROGRAMLOCALPARAMETER4FVARBPROC;
alias void function(GLenum target, GLuint index, GLdouble *params) PFNGLGETPROGRAMENVPARAMETERDVARBPROC;
alias void function(GLenum target, GLuint index, GLfloat *params) PFNGLGETPROGRAMENVPARAMETERFVARBPROC;
alias void function(GLenum target, GLuint index, GLdouble *params) PFNGLGETPROGRAMLOCALPARAMETERDVARBPROC;
alias void function(GLenum target, GLuint index, GLfloat *params) PFNGLGETPROGRAMLOCALPARAMETERFVARBPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETPROGRAMIVARBPROC;
alias void function(GLenum target, GLenum pname, GLvoid *string) PFNGLGETPROGRAMSTRINGARBPROC;
alias void function(GLuint index, GLenum pname, GLdouble *params) PFNGLGETVERTEXATTRIBDVARBPROC;
alias void function(GLuint index, GLenum pname, GLfloat *params) PFNGLGETVERTEXATTRIBFVARBPROC;
alias void function(GLuint index, GLenum pname, GLint *params) PFNGLGETVERTEXATTRIBIVARBPROC;
alias void function(GLuint index, GLenum pname, GLvoid* *pointer) PFNGLGETVERTEXATTRIBPOINTERVARBPROC;
alias GLboolean function(GLuint program) PFNGLISPROGRAMARBPROC;

static const auto GL_ARB_fragment_program = 1;
/* All ARB_fragment_program entry points are shared with ARB_vertex_program. */

static const auto GL_ARB_vertex_buffer_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBindBufferARB (GLenum target, GLuint buffer);
	void glDeleteBuffersARB (GLsizei n, GLuint *buffers);
	void glGenBuffersARB (GLsizei n, GLuint *buffers);
	GLboolean glIsBufferARB (GLuint buffer);
	void glBufferDataARB (GLenum target, GLsizeiptrARB size, GLvoid *data, GLenum usage);
	void glBufferSubDataARB (GLenum target, GLintptrARB offset, GLsizeiptrARB size, GLvoid *data);
	void glGetBufferSubDataARB (GLenum target, GLintptrARB offset, GLsizeiptrARB size, GLvoid *data);
	GLvoid* glMapBufferARB (GLenum target, GLenum access);
	GLboolean glUnmapBufferARB (GLenum target);
	void glGetBufferParameterivARB (GLenum target, GLenum pname, GLint *params);
	void glGetBufferPointervARB (GLenum target, GLenum pname, GLvoid* *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint buffer) PFNGLBINDBUFFERARBPROC;
alias void function(GLsizei n, GLuint *buffers) PFNGLDELETEBUFFERSARBPROC;
alias void function(GLsizei n, GLuint *buffers) PFNGLGENBUFFERSARBPROC;
alias GLboolean function(GLuint buffer) PFNGLISBUFFERARBPROC;
alias void function(GLenum target, GLsizeiptrARB size, GLvoid *data, GLenum usage) PFNGLBUFFERDATAARBPROC;
alias void function(GLenum target, GLintptrARB offset, GLsizeiptrARB size, GLvoid *data) PFNGLBUFFERSUBDATAARBPROC;
alias void function(GLenum target, GLintptrARB offset, GLsizeiptrARB size, GLvoid *data) PFNGLGETBUFFERSUBDATAARBPROC;
alias GLvoid* (PFNGLMAPBUFFERARBPROC) (GLenum target, GLenum access);
alias GLboolean function(GLenum target) PFNGLUNMAPBUFFERARBPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETBUFFERPARAMETERIVARBPROC;
alias void function(GLenum target, GLenum pname, GLvoid* *params) PFNGLGETBUFFERPOINTERVARBPROC;

static const auto GL_ARB_occlusion_query = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGenQueriesARB (GLsizei n, GLuint *ids);
	void glDeleteQueriesARB (GLsizei n, GLuint *ids);
	GLboolean glIsQueryARB (GLuint id);
	void glBeginQueryARB (GLenum target, GLuint id);
	void glEndQueryARB (GLenum target);
	void glGetQueryivARB (GLenum target, GLenum pname, GLint *params);
	void glGetQueryObjectivARB (GLuint id, GLenum pname, GLint *params);
	void glGetQueryObjectuivARB (GLuint id, GLenum pname, GLuint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLuint *ids) PFNGLGENQUERIESARBPROC;
alias void function(GLsizei n, GLuint *ids) PFNGLDELETEQUERIESARBPROC;
alias GLboolean function(GLuint id) PFNGLISQUERYARBPROC;
alias void function(GLenum target, GLuint id) PFNGLBEGINQUERYARBPROC;
alias void function(GLenum target) PFNGLENDQUERYARBPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETQUERYIVARBPROC;
alias void function(GLuint id, GLenum pname, GLint *params) PFNGLGETQUERYOBJECTIVARBPROC;
alias void function(GLuint id, GLenum pname, GLuint *params) PFNGLGETQUERYOBJECTUIVARBPROC;

static const auto GL_ARB_shader_objects = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDeleteObjectARB (GLhandleARB obj);
	GLhandleARB glGetHandleARB (GLenum pname);
	void glDetachObjectARB (GLhandleARB containerObj, GLhandleARB attachedObj);
	GLhandleARB glCreateShaderObjectARB (GLenum shaderType);
	void glShaderSourceARB (GLhandleARB shaderObj, GLsizei count, GLcharARB* *string, GLint *length);
	void glCompileShaderARB (GLhandleARB shaderObj);
	GLhandleARB glCreateProgramObjectARB ();
	void glAttachObjectARB (GLhandleARB containerObj, GLhandleARB obj);
	void glLinkProgramARB (GLhandleARB programObj);
	void glUseProgramObjectARB (GLhandleARB programObj);
	void glValidateProgramARB (GLhandleARB programObj);
	void glUniform1fARB (GLint location, GLfloat v0);
	void glUniform2fARB (GLint location, GLfloat v0, GLfloat v1);
	void glUniform3fARB (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
	void glUniform4fARB (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
	void glUniform1iARB (GLint location, GLint v0);
	void glUniform2iARB (GLint location, GLint v0, GLint v1);
	void glUniform3iARB (GLint location, GLint v0, GLint v1, GLint v2);
	void glUniform4iARB (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
	void glUniform1fvARB (GLint location, GLsizei count, GLfloat *value);
	void glUniform2fvARB (GLint location, GLsizei count, GLfloat *value);
	void glUniform3fvARB (GLint location, GLsizei count, GLfloat *value);
	void glUniform4fvARB (GLint location, GLsizei count, GLfloat *value);
	void glUniform1ivARB (GLint location, GLsizei count, GLint *value);
	void glUniform2ivARB (GLint location, GLsizei count, GLint *value);
	void glUniform3ivARB (GLint location, GLsizei count, GLint *value);
	void glUniform4ivARB (GLint location, GLsizei count, GLint *value);
	void glUniformMatrix2fvARB (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix3fvARB (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glUniformMatrix4fvARB (GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glGetObjectParameterfvARB (GLhandleARB obj, GLenum pname, GLfloat *params);
	void glGetObjectParameterivARB (GLhandleARB obj, GLenum pname, GLint *params);
	void glGetInfoLogARB (GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *infoLog);
	void glGetAttachedObjectsARB (GLhandleARB containerObj, GLsizei maxCount, GLsizei *count, GLhandleARB *obj);
	GLint glGetUniformLocationARB (GLhandleARB programObj, GLcharARB *name);
	void glGetActiveUniformARB (GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name);
	void glGetUniformfvARB (GLhandleARB programObj, GLint location, GLfloat *params);
	void glGetUniformivARB (GLhandleARB programObj, GLint location, GLint *params);
	void glGetShaderSourceARB (GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *source);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLhandleARB obj) PFNGLDELETEOBJECTARBPROC;
alias GLhandleARB function(GLenum pname) PFNGLGETHANDLEARBPROC;
alias void function(GLhandleARB containerObj, GLhandleARB attachedObj) PFNGLDETACHOBJECTARBPROC;
alias GLhandleARB function(GLenum shaderType) PFNGLCREATESHADEROBJECTARBPROC;
alias void function(GLhandleARB shaderObj, GLsizei count, GLcharARB* *string, GLint *length) PFNGLSHADERSOURCEARBPROC;
alias void function(GLhandleARB shaderObj) PFNGLCOMPILESHADERARBPROC;
alias GLhandleARB function() PFNGLCREATEPROGRAMOBJECTARBPROC;
alias void function(GLhandleARB containerObj, GLhandleARB obj) PFNGLATTACHOBJECTARBPROC;
alias void function(GLhandleARB programObj) PFNGLLINKPROGRAMARBPROC;
alias void function(GLhandleARB programObj) PFNGLUSEPROGRAMOBJECTARBPROC;
alias void function(GLhandleARB programObj) PFNGLVALIDATEPROGRAMARBPROC;
alias void function(GLint location, GLfloat v0) PFNGLUNIFORM1FARBPROC;
alias void function(GLint location, GLfloat v0, GLfloat v1) PFNGLUNIFORM2FARBPROC;
alias void function(GLint location, GLfloat v0, GLfloat v1, GLfloat v2) PFNGLUNIFORM3FARBPROC;
alias void function(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3) PFNGLUNIFORM4FARBPROC;
alias void function(GLint location, GLint v0) PFNGLUNIFORM1IARBPROC;
alias void function(GLint location, GLint v0, GLint v1) PFNGLUNIFORM2IARBPROC;
alias void function(GLint location, GLint v0, GLint v1, GLint v2) PFNGLUNIFORM3IARBPROC;
alias void function(GLint location, GLint v0, GLint v1, GLint v2, GLint v3) PFNGLUNIFORM4IARBPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM1FVARBPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM2FVARBPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM3FVARBPROC;
alias void function(GLint location, GLsizei count, GLfloat *value) PFNGLUNIFORM4FVARBPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM1IVARBPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM2IVARBPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM3IVARBPROC;
alias void function(GLint location, GLsizei count, GLint *value) PFNGLUNIFORM4IVARBPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX2FVARBPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX3FVARBPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLUNIFORMMATRIX4FVARBPROC;
alias void function(GLhandleARB obj, GLenum pname, GLfloat *params) PFNGLGETOBJECTPARAMETERFVARBPROC;
alias void function(GLhandleARB obj, GLenum pname, GLint *params) PFNGLGETOBJECTPARAMETERIVARBPROC;
alias void function(GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *infoLog) PFNGLGETINFOLOGARBPROC;
alias void function(GLhandleARB containerObj, GLsizei maxCount, GLsizei *count, GLhandleARB *obj) PFNGLGETATTACHEDOBJECTSARBPROC;
alias GLint function(GLhandleARB programObj, GLcharARB *name) PFNGLGETUNIFORMLOCATIONARBPROC;
alias void function(GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name) PFNGLGETACTIVEUNIFORMARBPROC;
alias void function(GLhandleARB programObj, GLint location, GLfloat *params) PFNGLGETUNIFORMFVARBPROC;
alias void function(GLhandleARB programObj, GLint location, GLint *params) PFNGLGETUNIFORMIVARBPROC;
alias void function(GLhandleARB obj, GLsizei maxLength, GLsizei *length, GLcharARB *source) PFNGLGETSHADERSOURCEARBPROC;

static const auto GL_ARB_vertex_shader = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBindAttribLocationARB (GLhandleARB programObj, GLuint index, GLcharARB *name);
	void glGetActiveAttribARB (GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name);
	GLint glGetAttribLocationARB (GLhandleARB programObj, GLcharARB *name);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLhandleARB programObj, GLuint index, GLcharARB *name) PFNGLBINDATTRIBLOCATIONARBPROC;
alias void function(GLhandleARB programObj, GLuint index, GLsizei maxLength, GLsizei *length, GLint *size, GLenum *type, GLcharARB *name) PFNGLGETACTIVEATTRIBARBPROC;
alias GLint function(GLhandleARB programObj, GLcharARB *name) PFNGLGETATTRIBLOCATIONARBPROC;

static const auto GL_ARB_fragment_shader = 1;

static const auto GL_ARB_shading_language_100 = 1;

static const auto GL_ARB_texture_non_power_of_two = 1;

static const auto GL_ARB_point_sprite = 1;

static const auto GL_ARB_fragment_program_shadow = 1;

static const auto GL_ARB_draw_buffers = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawBuffersARB (GLsizei n, GLenum *bufs);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLenum *bufs) PFNGLDRAWBUFFERSARBPROC;

static const auto GL_ARB_texture_rectangle = 1;

static const auto GL_ARB_color_buffer_float = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glClampColorARB (GLenum target, GLenum clamp);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum clamp) PFNGLCLAMPCOLORARBPROC;

static const auto GL_ARB_half_float_pixel = 1;

static const auto GL_ARB_texture_float = 1;

static const auto GL_ARB_pixel_buffer_object = 1;

static const auto GL_ARB_depth_buffer_float = 1;

static const auto GL_ARB_draw_instanced = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawArraysInstancedARB (GLenum mode, GLint first, GLsizei count, GLsizei primcount);
	void glDrawElementsInstancedARB (GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLint first, GLsizei count, GLsizei primcount) PFNGLDRAWARRAYSINSTANCEDARBPROC;
alias void function(GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount) PFNGLDRAWELEMENTSINSTANCEDARBPROC;

static const auto GL_ARB_framebuffer_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLboolean glIsRenderbuffer (GLuint renderbuffer);
	void glBindRenderbuffer (GLenum target, GLuint renderbuffer);
	void glDeleteRenderbuffers (GLsizei n, GLuint *renderbuffers);
	void glGenRenderbuffers (GLsizei n, GLuint *renderbuffers);
	void glRenderbufferStorage (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
	void glGetRenderbufferParameteriv (GLenum target, GLenum pname, GLint *params);
	GLboolean glIsFramebuffer (GLuint framebuffer);
	void glBindFramebuffer (GLenum target, GLuint framebuffer);
	void glDeleteFramebuffers (GLsizei n, GLuint *framebuffers);
	void glGenFramebuffers (GLsizei n, GLuint *framebuffers);
	GLenum glCheckFramebufferStatus (GLenum target);
	void glFramebufferTexture1D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
	void glFramebufferTexture2D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
	void glFramebufferTexture3D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset);
	void glFramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
	void glGetFramebufferAttachmentParameteriv (GLenum target, GLenum attachment, GLenum pname, GLint *params);
	void glGenerateMipmap (GLenum target);
	void glBlitFramebuffer (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
	void glRenderbufferStorageMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
	void glFramebufferTextureLayer (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer);
} /* GL_GLEXT_PROTOTYPES */
alias GLboolean function(GLuint renderbuffer) PFNGLISRENDERBUFFERPROC;
alias void function(GLenum target, GLuint renderbuffer) PFNGLBINDRENDERBUFFERPROC;
alias void function(GLsizei n, GLuint *renderbuffers) PFNGLDELETERENDERBUFFERSPROC;
alias void function(GLsizei n, GLuint *renderbuffers) PFNGLGENRENDERBUFFERSPROC;
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLsizei height) PFNGLRENDERBUFFERSTORAGEPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETRENDERBUFFERPARAMETERIVPROC;
alias GLboolean function(GLuint framebuffer) PFNGLISFRAMEBUFFERPROC;
alias void function(GLenum target, GLuint framebuffer) PFNGLBINDFRAMEBUFFERPROCGL;
alias void function(GLsizei n, GLuint *framebuffers) PFNGLDELETEFRAMEBUFFERSPROC;
alias void function(GLsizei n, GLuint *framebuffers) PFNGLGENFRAMEBUFFERSPROC;
alias GLenum function(GLenum target) PFNGLCHECKFRAMEBUFFERSTATUSPROC;
alias void function(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level) PFNGLFRAMEBUFFERTEXTURE1DPROC;
alias void function(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level) PFNGLFRAMEBUFFERTEXTURE2DPROC;
alias void function(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset) PFNGLFRAMEBUFFERTEXTURE3DPROC;
alias void function(GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer) PFNGLFRAMEBUFFERRENDERBUFFERPROC;
alias void function(GLenum target, GLenum attachment, GLenum pname, GLint *params) PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC;
alias void function(GLenum target) PFNGLGENERATEMIPMAPPROC;
alias void function(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter) PFNGLBLITFRAMEBUFFERPROC;
alias void function(GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height) PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer) PFNGLFRAMEBUFFERTEXTURELAYERPROC;

static const auto GL_ARB_framebuffer_sRGB = 1;

static const auto GL_ARB_geometry_shader4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProgramParameteriARB (GLuint program, GLenum pname, GLint value);
	void glFramebufferTextureARB (GLenum target, GLenum attachment, GLuint texture, GLint level);
	void glFramebufferTextureLayerARB (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer);
	void glFramebufferTextureFaceARB (GLenum target, GLenum attachment, GLuint texture, GLint level, GLenum face);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint program, GLenum pname, GLint value) PFNGLPROGRAMPARAMETERIARBPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level) PFNGLFRAMEBUFFERTEXTUREARBPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer) PFNGLFRAMEBUFFERTEXTURELAYERARBPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level, GLenum face) PFNGLFRAMEBUFFERTEXTUREFACEARBPROC;

static const auto GL_ARB_half_float_vertex = 1;

static const auto GL_ARB_instanced_arrays = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexAttribDivisorARB (GLuint index, GLuint divisor);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint index, GLuint divisor) PFNGLVERTEXATTRIBDIVISORARBPROC;

static const auto GL_ARB_map_buffer_range = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLvoid* glMapBufferRange (GLenum target, GLintptr offset, GLsizeiptr length, GLbitfield access);
	void glFlushMappedBufferRange (GLenum target, GLintptr offset, GLsizeiptr length);
} /* GL_GLEXT_PROTOTYPES */
alias GLvoid* (PFNGLMAPBUFFERRANGEPROC) (GLenum target, GLintptr offset, GLsizeiptr length, GLbitfield access);
alias void function(GLenum target, GLintptr offset, GLsizeiptr length) PFNGLFLUSHMAPPEDBUFFERRANGEPROC;

static const auto GL_ARB_texture_buffer_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexBufferARB (GLenum target, GLenum internalformat, GLuint buffer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum internalformat, GLuint buffer) PFNGLTEXBUFFERARBPROC;

static const auto GL_ARB_texture_compression_rgtc = 1;

static const auto GL_ARB_texture_rg = 1;

static const auto GL_ARB_vertex_array_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBindVertexArray (GLuint array);
	void glDeleteVertexArrays (GLsizei n, GLuint *arrays);
	void glGenVertexArrays (GLsizei n, GLuint *arrays);
	GLboolean glIsVertexArray (GLuint array);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint array) PFNGLBINDVERTEXARRAYPROC;
alias void function(GLsizei n, GLuint *arrays) PFNGLDELETEVERTEXARRAYSPROC;
alias void function(GLsizei n, GLuint *arrays) PFNGLGENVERTEXARRAYSPROC;
alias GLboolean function(GLuint array) PFNGLISVERTEXARRAYPROC;

static const auto GL_ARB_uniform_buffer_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetUniformIndices (GLuint program, GLsizei uniformCount, GLchar* *uniformNames, GLuint *uniformIndices);
	void glGetActiveUniformsiv (GLuint program, GLsizei uniformCount, GLuint *uniformIndices, GLenum pname, GLint *params);
	void glGetActiveUniformName (GLuint program, GLuint uniformIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformName);
	GLuint glGetUniformBlockIndex (GLuint program, GLchar *uniformBlockName);
	void glGetActiveUniformBlockiv (GLuint program, GLuint uniformBlockIndex, GLenum pname, GLint *params);
	void glGetActiveUniformBlockName (GLuint program, GLuint uniformBlockIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformBlockName);
	void glUniformBlockBinding (GLuint program, GLuint uniformBlockIndex, GLuint uniformBlockBinding);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint program, GLsizei uniformCount, GLchar* *uniformNames, GLuint *uniformIndices) PFNGLGETUNIFORMINDICESPROC;
alias void function(GLuint program, GLsizei uniformCount, GLuint *uniformIndices, GLenum pname, GLint *params) PFNGLGETACTIVEUNIFORMSIVPROC;
alias void function(GLuint program, GLuint uniformIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformName) PFNGLGETACTIVEUNIFORMNAMEPROC;
alias GLuint function(GLuint program, GLchar *uniformBlockName) PFNGLGETUNIFORMBLOCKINDEXPROC;
alias void function(GLuint program, GLuint uniformBlockIndex, GLenum pname, GLint *params) PFNGLGETACTIVEUNIFORMBLOCKIVPROC;
alias void function(GLuint program, GLuint uniformBlockIndex, GLsizei bufSize, GLsizei *length, GLchar *uniformBlockName) PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC;
alias void function(GLuint program, GLuint uniformBlockIndex, GLuint uniformBlockBinding) PFNGLUNIFORMBLOCKBINDINGPROC;

static const auto GL_ARB_compatibility = 1;

static const auto GL_ARB_copy_buffer = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCopyBufferSubData (GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size) PFNGLCOPYBUFFERSUBDATAPROC;

static const auto GL_ARB_shader_texture_lod = 1;

static const auto GL_ARB_depth_clamp = 1;

static const auto GL_ARB_draw_elements_base_vertex = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawElementsBaseVertex (GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLint basevertex);
	void glDrawRangeElementsBaseVertex (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices, GLint basevertex);
	void glDrawElementsInstancedBaseVertex (GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount, GLint basevertex);
	void glMultiDrawElementsBaseVertex (GLenum mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount, GLint *basevertex);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLint basevertex) PFNGLDRAWELEMENTSBASEVERTEXPROC;
alias void function(GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices, GLint basevertex) PFNGLDRAWRANGEELEMENTSBASEVERTEXPROC;
alias void function(GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount, GLint basevertex) PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXPROC;
alias void function(GLenum mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount, GLint *basevertex) PFNGLMULTIDRAWELEMENTSBASEVERTEXPROC;

static const auto GL_ARB_fragment_coord_conventions = 1;

static const auto GL_ARB_provoking_vertex = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProvokingVertex (GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode) PFNGLPROVOKINGVERTEXPROC;

static const auto GL_ARB_seamless_cube_map = 1;

static const auto GL_ARB_sync = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLsync glFenceSync (GLenum condition, GLbitfield flags);
	GLboolean glIsSync (GLsync sync);
	void glDeleteSync (GLsync sync);
	GLenum glClientWaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout);
	void glWaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout);
	void glGetInteger64v (GLenum pname, GLint64 *params);
	void glGetSynciv (GLsync sync, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *values);
} /* GL_GLEXT_PROTOTYPES */
alias GLsync function(GLenum condition, GLbitfield flags) PFNGLFENCESYNCPROC;
alias GLboolean function(GLsync sync) PFNGLISSYNCPROC;
alias void function(GLsync sync) PFNGLDELETESYNCPROC;
alias GLenum function(GLsync sync, GLbitfield flags, GLuint64 timeout) PFNGLCLIENTWAITSYNCPROC;
alias void function(GLsync sync, GLbitfield flags, GLuint64 timeout) PFNGLWAITSYNCPROC;
alias void function(GLenum pname, GLint64 *params) PFNGLGETINTEGER64VPROC;
alias void function(GLsync sync, GLenum pname, GLsizei bufSize, GLsizei *length, GLint *values) PFNGLGETSYNCIVPROC;

static const auto GL_ARB_texture_multisample = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexImage2DMultisample (GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations);
	void glTexImage3DMultisample (GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations);
	void glGetMultisamplefv (GLenum pname, GLuint index, GLfloat *val);
	void glSampleMaski (GLuint index, GLbitfield mask);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations) PFNGLTEXIMAGE2DMULTISAMPLEPROC;
alias void function(GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations) PFNGLTEXIMAGE3DMULTISAMPLEPROC;
alias void function(GLenum pname, GLuint index, GLfloat *val) PFNGLGETMULTISAMPLEFVPROC;
alias void function(GLuint index, GLbitfield mask) PFNGLSAMPLEMASKIPROC;

static const auto GL_ARB_vertex_array_bgra = 1;

static const auto GL_ARB_draw_buffers_blend = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendEquationi (GLuint buf, GLenum mode);
	void glBlendEquationSeparatei (GLuint buf, GLenum modeRGB, GLenum modeAlpha);
	void glBlendFunci (GLuint buf, GLenum src, GLenum dst);
	void glBlendFuncSeparatei (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint buf, GLenum mode) PFNGLBLENDEQUATIONIPROC;
alias void function(GLuint buf, GLenum modeRGB, GLenum modeAlpha) PFNGLBLENDEQUATIONSEPARATEIPROC;
alias void function(GLuint buf, GLenum src, GLenum dst) PFNGLBLENDFUNCIPROC;
alias void function(GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha) PFNGLBLENDFUNCSEPARATEIPROC;

static const auto GL_ARB_sample_shading = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glMinSampleShading (GLclampf value);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLclampf value) PFNGLMINSAMPLESHADINGPROC;

static const auto GL_ARB_texture_cube_map_array = 1;

static const auto GL_ARB_texture_gather = 1;

static const auto GL_ARB_texture_query_lod = 1;

static const auto GL_ARB_shading_language_include = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glNamedStringARB (GLenum type, GLint namelen, GLchar *name, GLint stringlen, GLchar *string);
	void glDeleteNamedStringARB (GLint namelen, GLchar *name);
	void glCompileShaderIncludeARB (GLuint shader, GLsizei count, GLchar* *path, GLint *length);
	GLboolean glIsNamedStringARB (GLint namelen, GLchar *name);
	void glGetNamedStringARB (GLint namelen, GLchar *name, GLsizei bufSize, GLint *stringlen, GLchar *string);
	void glGetNamedStringivARB (GLint namelen, GLchar *name, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum type, GLint namelen, GLchar *name, GLint stringlen, GLchar *string) PFNGLNAMEDSTRINGARBPROC;
alias void function(GLint namelen, GLchar *name) PFNGLDELETENAMEDSTRINGARBPROC;
alias void function(GLuint shader, GLsizei count, GLchar* *path, GLint *length) PFNGLCOMPILESHADERINCLUDEARBPROC;
alias GLboolean function(GLint namelen, GLchar *name) PFNGLISNAMEDSTRINGARBPROC;
alias void function(GLint namelen, GLchar *name, GLsizei bufSize, GLint *stringlen, GLchar *string) PFNGLGETNAMEDSTRINGARBPROC;
alias void function(GLint namelen, GLchar *name, GLenum pname, GLint *params) PFNGLGETNAMEDSTRINGIVARBPROC;

static const auto GL_ARB_blend_func_extended = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBindFragDataLocationIndexed (GLuint program, GLuint colorNumber, GLuint index, GLchar *name);
	GLint glGetFragDataIndex (GLuint program, GLchar *name);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint program, GLuint colorNumber, GLuint index, GLchar *name) PFNGLBINDFRAGDATALOCATIONINDEXEDPROC;
alias GLint function(GLuint program, GLchar *name) PFNGLGETFRAGDATAINDEXPROC;

static const auto GL_ARB_sampler_objects = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGenSamplers (GLsizei count, GLuint *samplers);
	void glDeleteSamplers (GLsizei count, GLuint *samplers);
	GLboolean glIsSampler (GLuint sampler);
	void glBindSampler (GLenum unit, GLuint sampler);
	void glSamplerParameteri (GLuint sampler, GLenum pname, GLint param);
	void glSamplerParameteriv (GLuint sampler, GLenum pname, GLint *param);
	void glSamplerParameterf (GLuint sampler, GLenum pname, GLfloat param);
	void glSamplerParameterfv (GLuint sampler, GLenum pname, GLfloat *param);
	void glSamplerParameterIiv (GLuint sampler, GLenum pname, GLint *param);
	void glSamplerParameterIuiv (GLuint sampler, GLenum pname, GLuint *param);
	void glGetSamplerParameteriv (GLuint sampler, GLenum pname, GLint *params);
	void glGetSamplerParameterIiv (GLuint sampler, GLenum pname, GLint *params);
	void glGetSamplerParameterfv (GLuint sampler, GLenum pname, GLfloat *params);
	void glGetSamplerParameterIfv (GLuint sampler, GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei count, GLuint *samplers) PFNGLGENSAMPLERSPROC;
alias void function(GLsizei count, GLuint *samplers) PFNGLDELETESAMPLERSPROC;
alias GLboolean function(GLuint sampler) PFNGLISSAMPLERPROC;
alias void function(GLenum unit, GLuint sampler) PFNGLBINDSAMPLERPROC;
alias void function(GLuint sampler, GLenum pname, GLint param) PFNGLSAMPLERPARAMETERIPROC;
alias void function(GLuint sampler, GLenum pname, GLint *param) PFNGLSAMPLERPARAMETERIVPROC;
alias void function(GLuint sampler, GLenum pname, GLfloat param) PFNGLSAMPLERPARAMETERFPROC;
alias void function(GLuint sampler, GLenum pname, GLfloat *param) PFNGLSAMPLERPARAMETERFVPROC;
alias void function(GLuint sampler, GLenum pname, GLint *param) PFNGLSAMPLERPARAMETERIIVPROC;
alias void function(GLuint sampler, GLenum pname, GLuint *param) PFNGLSAMPLERPARAMETERIUIVPROC;
alias void function(GLuint sampler, GLenum pname, GLint *params) PFNGLGETSAMPLERPARAMETERIVPROC;
alias void function(GLuint sampler, GLenum pname, GLint *params) PFNGLGETSAMPLERPARAMETERIIVPROC;
alias void function(GLuint sampler, GLenum pname, GLfloat *params) PFNGLGETSAMPLERPARAMETERFVPROC;
alias void function(GLuint sampler, GLenum pname, GLfloat *params) PFNGLGETSAMPLERPARAMETERIFVPROC;

static const auto GL_ARB_timer_query = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glQueryCounter (GLuint id, GLenum target);
	void glGetQueryObjecti64v (GLuint id, GLenum pname, GLint64 *params);
	void glGetQueryObjectui64v (GLuint id, GLenum pname, GLuint64 *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint id, GLenum target) PFNGLQUERYCOUNTERPROC;
alias void function(GLuint id, GLenum pname, GLint64 *params) PFNGLGETQUERYOBJECTI64VPROC;
alias void function(GLuint id, GLenum pname, GLuint64 *params) PFNGLGETQUERYOBJECTUI64VPROC;

static const auto GL_ARB_vertex_type_2_10_10_10_rev = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexP2ui (GLenum type, GLuint value);
	void glVertexP2uiv (GLenum type, GLuint *value);
	void glVertexP3ui (GLenum type, GLuint value);
	void glVertexP3uiv (GLenum type, GLuint *value);
	void glVertexP4ui (GLenum type, GLuint value);
	void glVertexP4uiv (GLenum type, GLuint *value);
	void glTexCoordP1ui (GLenum type, GLuint coords);
	void glTexCoordP1uiv (GLenum type, GLuint *coords);
	void glTexCoordP2ui (GLenum type, GLuint coords);
	void glTexCoordP2uiv (GLenum type, GLuint *coords);
	void glTexCoordP3ui (GLenum type, GLuint coords);
	void glTexCoordP3uiv (GLenum type, GLuint *coords);
	void glTexCoordP4ui (GLenum type, GLuint coords);
	void glTexCoordP4uiv (GLenum type, GLuint *coords);
	void glMultiTexCoordP1ui (GLenum texture, GLenum type, GLuint coords);
	void glMultiTexCoordP1uiv (GLenum texture, GLenum type, GLuint *coords);
	void glMultiTexCoordP2ui (GLenum texture, GLenum type, GLuint coords);
	void glMultiTexCoordP2uiv (GLenum texture, GLenum type, GLuint *coords);
	void glMultiTexCoordP3ui (GLenum texture, GLenum type, GLuint coords);
	void glMultiTexCoordP3uiv (GLenum texture, GLenum type, GLuint *coords);
	void glMultiTexCoordP4ui (GLenum texture, GLenum type, GLuint coords);
	void glMultiTexCoordP4uiv (GLenum texture, GLenum type, GLuint *coords);
	void glNormalP3ui (GLenum type, GLuint coords);
	void glNormalP3uiv (GLenum type, GLuint *coords);
	void glColorP3ui (GLenum type, GLuint color);
	void glColorP3uiv (GLenum type, GLuint *color);
	void glColorP4ui (GLenum type, GLuint color);
	void glColorP4uiv (GLenum type, GLuint *color);
	void glSecondaryColorP3ui (GLenum type, GLuint color);
	void glSecondaryColorP3uiv (GLenum type, GLuint *color);
	void glVertexAttribP1ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
	void glVertexAttribP1uiv (GLuint index, GLenum type, GLboolean normalized, GLuint *value);
	void glVertexAttribP2ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
	void glVertexAttribP2uiv (GLuint index, GLenum type, GLboolean normalized, GLuint *value);
	void glVertexAttribP3ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
	void glVertexAttribP3uiv (GLuint index, GLenum type, GLboolean normalized, GLuint *value);
	void glVertexAttribP4ui (GLuint index, GLenum type, GLboolean normalized, GLuint value);
	void glVertexAttribP4uiv (GLuint index, GLenum type, GLboolean normalized, GLuint *value);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum type, GLuint value) PFNGLVERTEXP2UIPROC;
alias void function(GLenum type, GLuint *value) PFNGLVERTEXP2UIVPROC;
alias void function(GLenum type, GLuint value) PFNGLVERTEXP3UIPROC;
alias void function(GLenum type, GLuint *value) PFNGLVERTEXP3UIVPROC;
alias void function(GLenum type, GLuint value) PFNGLVERTEXP4UIPROC;
alias void function(GLenum type, GLuint *value) PFNGLVERTEXP4UIVPROC;
alias void function(GLenum type, GLuint coords) PFNGLTEXCOORDP1UIPROC;
alias void function(GLenum type, GLuint *coords) PFNGLTEXCOORDP1UIVPROC;
alias void function(GLenum type, GLuint coords) PFNGLTEXCOORDP2UIPROC;
alias void function(GLenum type, GLuint *coords) PFNGLTEXCOORDP2UIVPROC;
alias void function(GLenum type, GLuint coords) PFNGLTEXCOORDP3UIPROC;
alias void function(GLenum type, GLuint *coords) PFNGLTEXCOORDP3UIVPROC;
alias void function(GLenum type, GLuint coords) PFNGLTEXCOORDP4UIPROC;
alias void function(GLenum type, GLuint *coords) PFNGLTEXCOORDP4UIVPROC;
alias void function(GLenum texture, GLenum type, GLuint coords) PFNGLMULTITEXCOORDP1UIPROC;
alias void function(GLenum texture, GLenum type, GLuint *coords) PFNGLMULTITEXCOORDP1UIVPROC;
alias void function(GLenum texture, GLenum type, GLuint coords) PFNGLMULTITEXCOORDP2UIPROC;
alias void function(GLenum texture, GLenum type, GLuint *coords) PFNGLMULTITEXCOORDP2UIVPROC;
alias void function(GLenum texture, GLenum type, GLuint coords) PFNGLMULTITEXCOORDP3UIPROC;
alias void function(GLenum texture, GLenum type, GLuint *coords) PFNGLMULTITEXCOORDP3UIVPROC;
alias void function(GLenum texture, GLenum type, GLuint coords) PFNGLMULTITEXCOORDP4UIPROC;
alias void function(GLenum texture, GLenum type, GLuint *coords) PFNGLMULTITEXCOORDP4UIVPROC;
alias void function(GLenum type, GLuint coords) PFNGLNORMALP3UIPROC;
alias void function(GLenum type, GLuint *coords) PFNGLNORMALP3UIVPROC;
alias void function(GLenum type, GLuint color) PFNGLCOLORP3UIPROC;
alias void function(GLenum type, GLuint *color) PFNGLCOLORP3UIVPROC;
alias void function(GLenum type, GLuint color) PFNGLCOLORP4UIPROC;
alias void function(GLenum type, GLuint *color) PFNGLCOLORP4UIVPROC;
alias void function(GLenum type, GLuint color) PFNGLSECONDARYCOLORP3UIPROC;
alias void function(GLenum type, GLuint *color) PFNGLSECONDARYCOLORP3UIVPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint value) PFNGLVERTEXATTRIBP1UIPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint *value) PFNGLVERTEXATTRIBP1UIVPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint value) PFNGLVERTEXATTRIBP2UIPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint *value) PFNGLVERTEXATTRIBP2UIVPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint value) PFNGLVERTEXATTRIBP3UIPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint *value) PFNGLVERTEXATTRIBP3UIVPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint value) PFNGLVERTEXATTRIBP4UIPROC;
alias void function(GLuint index, GLenum type, GLboolean normalized, GLuint *value) PFNGLVERTEXATTRIBP4UIVPROC;

static const auto GL_ARB_draw_indirect = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawArraysIndirect (GLenum mode, GLvoid *indirect);
	void glDrawElementsIndirect (GLenum mode, GLenum type, GLvoid *indirect);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLvoid *indirect) PFNGLDRAWARRAYSINDIRECTPROC;
alias void function(GLenum mode, GLenum type, GLvoid *indirect) PFNGLDRAWELEMENTSINDIRECTPROC;

static const auto GL_ARB_gpu_shader_fp64 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glUniform1d (GLint location, GLdouble x);
	void glUniform2d (GLint location, GLdouble x, GLdouble y);
	void glUniform3d (GLint location, GLdouble x, GLdouble y, GLdouble z);
	void glUniform4d (GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glUniform1dv (GLint location, GLsizei count, GLdouble *value);
	void glUniform2dv (GLint location, GLsizei count, GLdouble *value);
	void glUniform3dv (GLint location, GLsizei count, GLdouble *value);
	void glUniform4dv (GLint location, GLsizei count, GLdouble *value);
	void glUniformMatrix2dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix3dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix4dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix2x3dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix2x4dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix3x2dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix3x4dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix4x2dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glUniformMatrix4x3dv (GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glGetUniformdv (GLuint program, GLint location, GLdouble *params);
	void glProgramUniform1dEXT (GLuint program, GLint location, GLdouble x);
	void glProgramUniform2dEXT (GLuint program, GLint location, GLdouble x, GLdouble y);
	void glProgramUniform3dEXT (GLuint program, GLint location, GLdouble x, GLdouble y, GLdouble z);
	void glProgramUniform4dEXT (GLuint program, GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glProgramUniform1dvEXT (GLuint program, GLint location, GLsizei count, GLdouble *value);
	void glProgramUniform2dvEXT (GLuint program, GLint location, GLsizei count, GLdouble *value);
	void glProgramUniform3dvEXT (GLuint program, GLint location, GLsizei count, GLdouble *value);
	void glProgramUniform4dvEXT (GLuint program, GLint location, GLsizei count, GLdouble *value);
	void glProgramUniformMatrix2dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix3dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix4dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix2x3dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix2x4dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix3x2dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix3x4dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix4x2dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
	void glProgramUniformMatrix4x3dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint location, GLdouble x) PFNGLUNIFORM1DPROC;
alias void function(GLint location, GLdouble x, GLdouble y) PFNGLUNIFORM2DPROC;
alias void function(GLint location, GLdouble x, GLdouble y, GLdouble z) PFNGLUNIFORM3DPROC;
alias void function(GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLUNIFORM4DPROC;
alias void function(GLint location, GLsizei count, GLdouble *value) PFNGLUNIFORM1DVPROC;
alias void function(GLint location, GLsizei count, GLdouble *value) PFNGLUNIFORM2DVPROC;
alias void function(GLint location, GLsizei count, GLdouble *value) PFNGLUNIFORM3DVPROC;
alias void function(GLint location, GLsizei count, GLdouble *value) PFNGLUNIFORM4DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX2DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX3DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX4DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX2X3DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX2X4DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX3X2DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX3X4DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX4X2DVPROC;
alias void function(GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLUNIFORMMATRIX4X3DVPROC;
alias void function(GLuint program, GLint location, GLdouble *params) PFNGLGETUNIFORMDVPROC;
alias void function(GLuint program, GLint location, GLdouble x) PFNGLPROGRAMUNIFORM1DEXTPROC;
alias void function(GLuint program, GLint location, GLdouble x, GLdouble y) PFNGLPROGRAMUNIFORM2DEXTPROC;
alias void function(GLuint program, GLint location, GLdouble x, GLdouble y, GLdouble z) PFNGLPROGRAMUNIFORM3DEXTPROC;
alias void function(GLuint program, GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLPROGRAMUNIFORM4DEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLdouble *value) PFNGLPROGRAMUNIFORM1DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLdouble *value) PFNGLPROGRAMUNIFORM2DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLdouble *value) PFNGLPROGRAMUNIFORM3DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLdouble *value) PFNGLPROGRAMUNIFORM4DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX2DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX3DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX4DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX2X3DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX2X4DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX3X2DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX3X4DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX4X2DVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLdouble *value) PFNGLPROGRAMUNIFORMMATRIX4X3DVEXTPROC;

static const auto GL_ARB_shader_subroutine = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLint glGetSubroutineUniformLocation (GLuint program, GLenum shadertype, GLchar *name);
	GLuint glGetSubroutineIndex (GLuint program, GLenum shadertype, GLchar *name);
	void glGetActiveSubroutineUniformiv (GLuint program, GLenum shadertype, GLuint index, GLenum pname, GLint *values);
	void glGetActiveSubroutineUniformName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name);
	void glGetActiveSubroutineName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name);
	void glUniformSubroutinesuiv (GLenum shadertype, GLsizei count, GLuint *indices);
	void glGetUniformSubroutineuiv (GLenum shadertype, GLint location, GLuint *params);
	void glGetProgramStageiv (GLuint program, GLenum shadertype, GLenum pname, GLint *values);
} /* GL_GLEXT_PROTOTYPES */
alias GLint function(GLuint program, GLenum shadertype, GLchar *name) PFNGLGETSUBROUTINEUNIFORMLOCATIONPROC;
alias GLuint function(GLuint program, GLenum shadertype, GLchar *name) PFNGLGETSUBROUTINEINDEXPROC;
alias void function(GLuint program, GLenum shadertype, GLuint index, GLenum pname, GLint *values) PFNGLGETACTIVESUBROUTINEUNIFORMIVPROC;
alias void function(GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name) PFNGLGETACTIVESUBROUTINEUNIFORMNAMEPROC;
alias void function(GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei *length, GLchar *name) PFNGLGETACTIVESUBROUTINENAMEPROC;
alias void function(GLenum shadertype, GLsizei count, GLuint *indices) PFNGLUNIFORMSUBROUTINESUIVPROC;
alias void function(GLenum shadertype, GLint location, GLuint *params) PFNGLGETUNIFORMSUBROUTINEUIVPROC;
alias void function(GLuint program, GLenum shadertype, GLenum pname, GLint *values) PFNGLGETPROGRAMSTAGEIVPROC;

static const auto GL_ARB_tessellation_shader = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPatchParameteri (GLenum pname, GLint value);
	void glPatchParameterfv (GLenum pname, GLfloat *values);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLint value) PFNGLPATCHPARAMETERIPROC;
alias void function(GLenum pname, GLfloat *values) PFNGLPATCHPARAMETERFVPROC;

static const auto GL_ARB_transform_feedback2 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBindTransformFeedback (GLenum target, GLuint id);
	void glDeleteTransformFeedbacks (GLsizei n, GLuint *ids);
	void glGenTransformFeedbacks (GLsizei n, GLuint *ids);
	GLboolean glIsTransformFeedback (GLuint id);
	void glPauseTransformFeedback ();
	void glResumeTransformFeedback ();
	void glDrawTransformFeedback (GLenum mode, GLuint id);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint id) PFNGLBINDTRANSFORMFEEDBACKPROC;
alias void function(GLsizei n, GLuint *ids) PFNGLDELETETRANSFORMFEEDBACKSPROC;
alias void function(GLsizei n, GLuint *ids) PFNGLGENTRANSFORMFEEDBACKSPROC;
alias GLboolean function(GLuint id) PFNGLISTRANSFORMFEEDBACKPROC;
alias void function() PFNGLPAUSETRANSFORMFEEDBACKPROC;
alias void function() PFNGLRESUMETRANSFORMFEEDBACKPROC;
alias void function(GLenum mode, GLuint id) PFNGLDRAWTRANSFORMFEEDBACKPROC;

static const auto GL_ARB_transform_feedback3 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawTransformFeedbackStream (GLenum mode, GLuint id, GLuint stream);
	void glBeginQueryIndexed (GLenum target, GLuint index, GLuint id);
	void glEndQueryIndexed (GLenum target, GLuint index);
	void glGetQueryIndexediv (GLenum target, GLuint index, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLuint id, GLuint stream) PFNGLDRAWTRANSFORMFEEDBACKSTREAMPROC;
alias void function(GLenum target, GLuint index, GLuint id) PFNGLBEGINQUERYINDEXEDPROC;
alias void function(GLenum target, GLuint index) PFNGLENDQUERYINDEXEDPROC;
alias void function(GLenum target, GLuint index, GLenum pname, GLint *params) PFNGLGETQUERYINDEXEDIVPROC;

static const auto GL_EXT_abgr = 1;

static const auto GL_EXT_blend_color = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendColorEXT (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha) PFNGLBLENDCOLOREXTPROC;

static const auto GL_EXT_polygon_offset = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPolygonOffsetEXT (GLfloat factor, GLfloat bias);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLfloat factor, GLfloat bias) PFNGLPOLYGONOFFSETEXTPROC;

static const auto GL_EXT_texture = 1;

static const auto GL_EXT_texture3D = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexImage3DEXT (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glTexSubImage3DEXT (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels);
} /* GL_GLEXT_PROTOTYPES */

alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXIMAGE3DEXTPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXSUBIMAGE3DEXTPROC;

static const auto GL_SGIS_texture_filter4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetTexFilterFuncSGIS (GLenum target, GLenum filter, GLfloat *weights);
	void glTexFilterFuncSGIS (GLenum target, GLenum filter, GLsizei n, GLfloat *weights);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum filter, GLfloat *weights) PFNGLGETTEXFILTERFUNCSGISPROC;
alias void function(GLenum target, GLenum filter, GLsizei n, GLfloat *weights) PFNGLTEXFILTERFUNCSGISPROC;

static const auto GL_EXT_subtexture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexSubImage1DEXT (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels);
	void glTexSubImage2DEXT (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXSUBIMAGE1DEXTPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXSUBIMAGE2DEXTPROC;

static const auto GL_EXT_copy_texture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCopyTexImage1DEXT (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border);
	void glCopyTexImage2DEXT (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
	void glCopyTexSubImage1DEXT (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
	void glCopyTexSubImage2DEXT (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
	void glCopyTexSubImage3DEXT (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border) PFNGLCOPYTEXIMAGE1DEXTPROC;
alias void function(GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border) PFNGLCOPYTEXIMAGE2DEXTPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width) PFNGLCOPYTEXSUBIMAGE1DEXTPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYTEXSUBIMAGE2DEXTPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYTEXSUBIMAGE3DEXTPROC;

static const auto GL_EXT_histogram = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetHistogramEXT (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
	void glGetHistogramParameterfvEXT (GLenum target, GLenum pname, GLfloat *params);
	void glGetHistogramParameterivEXT (GLenum target, GLenum pname, GLint *params);
	void glGetMinmaxEXT (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
	void glGetMinmaxParameterfvEXT (GLenum target, GLenum pname, GLfloat *params);
	void glGetMinmaxParameterivEXT (GLenum target, GLenum pname, GLint *params);
	void glHistogramEXT (GLenum target, GLsizei width, GLenum internalformat, GLboolean sink);
	void glMinmaxEXT (GLenum target, GLenum internalformat, GLboolean sink);
	void glResetHistogramEXT (GLenum target);
	void glResetMinmaxEXT (GLenum target);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values) PFNGLGETHISTOGRAMEXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETHISTOGRAMPARAMETERFVEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETHISTOGRAMPARAMETERIVEXTPROC;
alias void function(GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values) PFNGLGETMINMAXEXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETMINMAXPARAMETERFVEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETMINMAXPARAMETERIVEXTPROC;
alias void function(GLenum target, GLsizei width, GLenum internalformat, GLboolean sink) PFNGLHISTOGRAMEXTPROC;
alias void function(GLenum target, GLenum internalformat, GLboolean sink) PFNGLMINMAXEXTPROC;
alias void function(GLenum target) PFNGLRESETHISTOGRAMEXTPROC;
alias void function(GLenum target) PFNGLRESETMINMAXEXTPROC;

static const auto GL_EXT_convolution = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glConvolutionFilter1DEXT (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *image);
	void glConvolutionFilter2DEXT (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *image);
	void glConvolutionParameterfEXT (GLenum target, GLenum pname, GLfloat params);
	void glConvolutionParameterfvEXT (GLenum target, GLenum pname, GLfloat *params);
	void glConvolutionParameteriEXT (GLenum target, GLenum pname, GLint params);
	void glConvolutionParameterivEXT (GLenum target, GLenum pname, GLint *params);
	void glCopyConvolutionFilter1DEXT (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
	void glCopyConvolutionFilter2DEXT (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height);
	void glGetConvolutionFilterEXT (GLenum target, GLenum format, GLenum type, GLvoid *image);
	void glGetConvolutionParameterfvEXT (GLenum target, GLenum pname, GLfloat *params);
	void glGetConvolutionParameterivEXT (GLenum target, GLenum pname, GLint *params);
	void glGetSeparableFilterEXT (GLenum target, GLenum format, GLenum type, GLvoid *row, GLvoid *column, GLvoid *span);
	void glSeparableFilter2DEXT (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *row, GLvoid *column);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *image) PFNGLCONVOLUTIONFILTER1DEXTPROC;
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *image) PFNGLCONVOLUTIONFILTER2DEXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat params) PFNGLCONVOLUTIONPARAMETERFEXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLCONVOLUTIONPARAMETERFVEXTPROC;
alias void function(GLenum target, GLenum pname, GLint params) PFNGLCONVOLUTIONPARAMETERIEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLCONVOLUTIONPARAMETERIVEXTPROC;
alias void function(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width) PFNGLCOPYCONVOLUTIONFILTER1DEXTPROC;
alias void function(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYCONVOLUTIONFILTER2DEXTPROC;
alias void function(GLenum target, GLenum format, GLenum type, GLvoid *image) PFNGLGETCONVOLUTIONFILTEREXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETCONVOLUTIONPARAMETERFVEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETCONVOLUTIONPARAMETERIVEXTPROC;
alias void function(GLenum target, GLenum format, GLenum type, GLvoid *row, GLvoid *column, GLvoid *span) PFNGLGETSEPARABLEFILTEREXTPROC;
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *row, GLvoid *column) PFNGLSEPARABLEFILTER2DEXTPROC;

static const auto GL_SGI_color_matrix = 1;

static const auto GL_SGI_color_table = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glColorTableSGI (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *table);
	void glColorTableParameterfvSGI (GLenum target, GLenum pname, GLfloat *params);
	void glColorTableParameterivSGI (GLenum target, GLenum pname, GLint *params);
	void glCopyColorTableSGI (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
	void glGetColorTableSGI (GLenum target, GLenum format, GLenum type, GLvoid *table);
	void glGetColorTableParameterfvSGI (GLenum target, GLenum pname, GLfloat *params);
	void glGetColorTableParameterivSGI (GLenum target, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, GLvoid *table) PFNGLCOLORTABLESGIPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLCOLORTABLEPARAMETERFVSGIPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLCOLORTABLEPARAMETERIVSGIPROC;
alias void function(GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width) PFNGLCOPYCOLORTABLESGIPROC;
alias void function(GLenum target, GLenum format, GLenum type, GLvoid *table) PFNGLGETCOLORTABLESGIPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETCOLORTABLEPARAMETERFVSGIPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETCOLORTABLEPARAMETERIVSGIPROC;

static const auto GL_SGIX_pixel_texture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPixelTexGenSGIX (GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode) PFNGLPIXELTEXGENSGIXPROC;

static const auto GL_SGIS_pixel_texture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPixelTexGenParameteriSGIS (GLenum pname, GLint param);
	void glPixelTexGenParameterivSGIS (GLenum pname, GLint *params);
	void glPixelTexGenParameterfSGIS (GLenum pname, GLfloat param);
	void glPixelTexGenParameterfvSGIS (GLenum pname, GLfloat *params);
	void glGetPixelTexGenParameterivSGIS (GLenum pname, GLint *params);
	void glGetPixelTexGenParameterfvSGIS (GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLint param) PFNGLPIXELTEXGENPARAMETERISGISPROC;
alias void function(GLenum pname, GLint *params) PFNGLPIXELTEXGENPARAMETERIVSGISPROC;
alias void function(GLenum pname, GLfloat param) PFNGLPIXELTEXGENPARAMETERFSGISPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLPIXELTEXGENPARAMETERFVSGISPROC;
alias void function(GLenum pname, GLint *params) PFNGLGETPIXELTEXGENPARAMETERIVSGISPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLGETPIXELTEXGENPARAMETERFVSGISPROC;

static const auto GL_SGIS_texture4D = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexImage4DSGIS (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLsizei size4d, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glTexSubImage4DSGIS (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint woffset, GLsizei width, GLsizei height, GLsizei depth, GLsizei size4d, GLenum format, GLenum type, GLvoid *pixels);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLsizei size4d, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXIMAGE4DSGISPROC;
alias void function(GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint woffset, GLsizei width, GLsizei height, GLsizei depth, GLsizei size4d, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXSUBIMAGE4DSGISPROC;

static const auto GL_SGI_texture_color_table = 1;

static const auto GL_EXT_cmyka = 1;

static const auto GL_EXT_texture_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLboolean glAreTexturesResidentEXT (GLsizei n, GLuint *textures, GLboolean *residences);
	void glBindTextureEXT (GLenum target, GLuint texture);
	void glDeleteTexturesEXT (GLsizei n, GLuint *textures);
	void glGenTexturesEXT (GLsizei n, GLuint *textures);
	GLboolean glIsTextureEXT (GLuint texture);
	void glPrioritizeTexturesEXT (GLsizei n, GLuint *textures, GLclampf *priorities);
} /* GL_GLEXT_PROTOTYPES */
alias GLboolean function(GLsizei n, GLuint *textures, GLboolean *residences) PFNGLARETEXTURESRESIDENTEXTPROC;
alias void function(GLenum target, GLuint texture) PFNGLBINDTEXTUREEXTPROC;
alias void function(GLsizei n, GLuint *textures) PFNGLDELETETEXTURESEXTPROC;
alias void function(GLsizei n, GLuint *textures) PFNGLGENTEXTURESEXTPROC;
alias GLboolean function(GLuint texture) PFNGLISTEXTUREEXTPROC;
alias void function(GLsizei n, GLuint *textures, GLclampf *priorities) PFNGLPRIORITIZETEXTURESEXTPROC;

static const auto GL_SGIS_detail_texture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDetailTexFuncSGIS (GLenum target, GLsizei n, GLfloat *points);
	void glGetDetailTexFuncSGIS (GLenum target, GLfloat *points);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei n, GLfloat *points) PFNGLDETAILTEXFUNCSGISPROC;
alias void function(GLenum target, GLfloat *points) PFNGLGETDETAILTEXFUNCSGISPROC;

static const auto GL_SGIS_sharpen_texture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glSharpenTexFuncSGIS (GLenum target, GLsizei n, GLfloat *points);
	void glGetSharpenTexFuncSGIS (GLenum target, GLfloat *points);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei n, GLfloat *points) PFNGLSHARPENTEXFUNCSGISPROC;
alias void function(GLenum target, GLfloat *points) PFNGLGETSHARPENTEXFUNCSGISPROC;

static const auto GL_EXT_packed_pixels = 1;

static const auto GL_SGIS_texture_lod = 1;

static const auto GL_SGIS_multisample = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glSampleMaskSGIS (GLclampf value, GLboolean invert);
	void glSamplePatternSGIS (GLenum pattern);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLclampf value, GLboolean invert) PFNGLSAMPLEMASKSGISPROC;
alias void function(GLenum pattern) PFNGLSAMPLEPATTERNSGISPROC;

static const auto GL_EXT_rescale_normal = 1;

static const auto GL_EXT_vertex_array = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glArrayElementEXT (GLint i);
	void glColorPointerEXT (GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
	void glDrawArraysEXT (GLenum mode, GLint first, GLsizei count);
	void glEdgeFlagPointerEXT (GLsizei stride, GLsizei count, GLboolean *pointer);
	void glGetPointervEXT (GLenum pname, GLvoid* *params);
	void glIndexPointerEXT (GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
	void glNormalPointerEXT (GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
	void glTexCoordPointerEXT (GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
	void glVertexPointerEXT (GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint i) PFNGLARRAYELEMENTEXTPROC;
alias void function(GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer) PFNGLCOLORPOINTEREXTPROC;
alias void function(GLenum mode, GLint first, GLsizei count) PFNGLDRAWARRAYSEXTPROC;
alias void function(GLsizei stride, GLsizei count, GLboolean *pointer) PFNGLEDGEFLAGPOINTEREXTPROC;
alias void function(GLenum pname, GLvoid* *params) PFNGLGETPOINTERVEXTPROC;
alias void function(GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer) PFNGLINDEXPOINTEREXTPROC;
alias void function(GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer) PFNGLNORMALPOINTEREXTPROC;
alias void function(GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer) PFNGLTEXCOORDPOINTEREXTPROC;
alias void function(GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer) PFNGLVERTEXPOINTEREXTPROC;

static const auto GL_EXT_misc_attribute = 1;

static const auto GL_SGIS_generate_mipmap = 1;

static const auto GL_SGIX_clipmap = 1;

static const auto GL_SGIX_shadow = 1;

static const auto GL_SGIS_texture_edge_clamp = 1;

static const auto GL_SGIS_texture_border_clamp = 1;

static const auto GL_EXT_blend_minmax = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendEquationEXT (GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode) PFNGLBLENDEQUATIONEXTPROC;

static const auto GL_EXT_blend_subtract = 1;

static const auto GL_EXT_blend_logic_op = 1;

static const auto GL_SGIX_interlace = 1;

static const auto GL_SGIX_pixel_tiles = 1;

static const auto GL_SGIX_texture_select = 1;

static const auto GL_SGIX_sprite = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glSpriteParameterfSGIX (GLenum pname, GLfloat param);
	void glSpriteParameterfvSGIX (GLenum pname, GLfloat *params);
	void glSpriteParameteriSGIX (GLenum pname, GLint param);
	void glSpriteParameterivSGIX (GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLfloat param) PFNGLSPRITEPARAMETERFSGIXPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLSPRITEPARAMETERFVSGIXPROC;
alias void function(GLenum pname, GLint param) PFNGLSPRITEPARAMETERISGIXPROC;
alias void function(GLenum pname, GLint *params) PFNGLSPRITEPARAMETERIVSGIXPROC;

static const auto GL_SGIX_texture_multi_buffer = 1;

static const auto GL_EXT_point_parameters = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPointParameterfEXT (GLenum pname, GLfloat param);
	void glPointParameterfvEXT (GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLfloat param) PFNGLPOINTPARAMETERFEXTPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLPOINTPARAMETERFVEXTPROC;

static const auto GL_SGIS_point_parameters = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPointParameterfSGIS (GLenum pname, GLfloat param);
	void glPointParameterfvSGIS (GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLfloat param) PFNGLPOINTPARAMETERFSGISPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLPOINTPARAMETERFVSGISPROC;

static const auto GL_SGIX_instruments = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLint glGetInstrumentsSGIX ();
	void glInstrumentsBufferSGIX (GLsizei size, GLint *buffer);
	GLint glPollInstrumentsSGIX (GLint *marker_p);
	void glReadInstrumentsSGIX (GLint marker);
	void glStartInstrumentsSGIX ();
	void glStopInstrumentsSGIX (GLint marker);
} /* GL_GLEXT_PROTOTYPES */
alias GLint function() PFNGLGETINSTRUMENTSSGIXPROC;
alias void function(GLsizei size, GLint *buffer) PFNGLINSTRUMENTSBUFFERSGIXPROC;
alias GLint function(GLint *marker_p) PFNGLPOLLINSTRUMENTSSGIXPROC;
alias void function(GLint marker) PFNGLREADINSTRUMENTSSGIXPROC;
alias void function() PFNGLSTARTINSTRUMENTSSGIXPROC;
alias void function(GLint marker) PFNGLSTOPINSTRUMENTSSGIXPROC;

static const auto GL_SGIX_texture_scale_bias = 1;

static const auto GL_SGIX_framezoom = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFrameZoomSGIX (GLint factor);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint factor) PFNGLFRAMEZOOMSGIXPROC;

static const auto GL_SGIX_tag_sample_buffer = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTagSampleBufferSGIX ();
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLTAGSAMPLEBUFFERSGIXPROC;

static const auto GL_SGIX_polynomial_ffd = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDeformationMap3dSGIX (GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, GLdouble w1, GLdouble w2, GLint wstride, GLint worder, GLdouble *points);
	void glDeformationMap3fSGIX (GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, GLfloat w1, GLfloat w2, GLint wstride, GLint worder, GLfloat *points);
	void glDeformSGIX (GLbitfield mask);
	void glLoadIdentityDeformationMapSGIX (GLbitfield mask);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, GLdouble w1, GLdouble w2, GLint wstride, GLint worder, GLdouble *points) PFNGLDEFORMATIONMAP3DSGIXPROC;
alias void function(GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, GLfloat w1, GLfloat w2, GLint wstride, GLint worder, GLfloat *points) PFNGLDEFORMATIONMAP3FSGIXPROC;
alias void function(GLbitfield mask) PFNGLDEFORMSGIXPROC;
alias void function(GLbitfield mask) PFNGLLOADIDENTITYDEFORMATIONMAPSGIXPROC;

static const auto GL_SGIX_reference_plane = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glReferencePlaneSGIX (GLdouble *equation);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLdouble *equation) PFNGLREFERENCEPLANESGIXPROC;

static const auto GL_SGIX_flush_raster = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFlushRasterSGIX ();
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLFLUSHRASTERSGIXPROC;

static const auto GL_SGIX_depth_texture = 1;

static const auto GL_SGIS_fog_function = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFogFuncSGIS (GLsizei n, GLfloat *points);
	void glGetFogFuncSGIS (GLfloat *points);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLfloat *points) PFNGLFOGFUNCSGISPROC;
alias void function(GLfloat *points) PFNGLGETFOGFUNCSGISPROC;

static const auto GL_SGIX_fog_offset = 1;

static const auto GL_HP_image_transform = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glImageTransformParameteriHP (GLenum target, GLenum pname, GLint param);
	void glImageTransformParameterfHP (GLenum target, GLenum pname, GLfloat param);
	void glImageTransformParameterivHP (GLenum target, GLenum pname, GLint *params);
	void glImageTransformParameterfvHP (GLenum target, GLenum pname, GLfloat *params);
	void glGetImageTransformParameterivHP (GLenum target, GLenum pname, GLint *params);
	void glGetImageTransformParameterfvHP (GLenum target, GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum pname, GLint param) PFNGLIMAGETRANSFORMPARAMETERIHPPROC;
alias void function(GLenum target, GLenum pname, GLfloat param) PFNGLIMAGETRANSFORMPARAMETERFHPPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLIMAGETRANSFORMPARAMETERIVHPPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLIMAGETRANSFORMPARAMETERFVHPPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETIMAGETRANSFORMPARAMETERIVHPPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETIMAGETRANSFORMPARAMETERFVHPPROC;

static const auto GL_HP_convolution_border_modes = 1;

static const auto GL_SGIX_texture_add_env = 1;

static const auto GL_EXT_color_subtable = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glColorSubTableEXT (GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, GLvoid *data);
	void glCopyColorSubTableEXT (GLenum target, GLsizei start, GLint x, GLint y, GLsizei width);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, GLvoid *data) PFNGLCOLORSUBTABLEEXTPROC;
alias void function(GLenum target, GLsizei start, GLint x, GLint y, GLsizei width) PFNGLCOPYCOLORSUBTABLEEXTPROC;

static const auto GL_PGI_vertex_hints = 1;

static const auto GL_PGI_misc_hints = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glHintPGI (GLenum target, GLint mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLint mode) PFNGLHINTPGIPROC;

static const auto GL_EXT_paletted_texture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glColorTableEXT (GLenum target, GLenum internalFormat, GLsizei width, GLenum format, GLenum type, GLvoid *table);
	void glGetColorTableEXT (GLenum target, GLenum format, GLenum type, GLvoid *data);
	void glGetColorTableParameterivEXT (GLenum target, GLenum pname, GLint *params);
	void glGetColorTableParameterfvEXT (GLenum target, GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum internalFormat, GLsizei width, GLenum format, GLenum type, GLvoid *table) PFNGLCOLORTABLEEXTPROC;
alias void function(GLenum target, GLenum format, GLenum type, GLvoid *data) PFNGLGETCOLORTABLEEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETCOLORTABLEPARAMETERIVEXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETCOLORTABLEPARAMETERFVEXTPROC;

static const auto GL_EXT_clip_volume_hint = 1;

static const auto GL_SGIX_list_priority = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetListParameterfvSGIX (GLuint list, GLenum pname, GLfloat *params);
	void glGetListParameterivSGIX (GLuint list, GLenum pname, GLint *params);
	void glListParameterfSGIX (GLuint list, GLenum pname, GLfloat param);
	void glListParameterfvSGIX (GLuint list, GLenum pname, GLfloat *params);
	void glListParameteriSGIX (GLuint list, GLenum pname, GLint param);
	void glListParameterivSGIX (GLuint list, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint list, GLenum pname, GLfloat *params) PFNGLGETLISTPARAMETERFVSGIXPROC;
alias void function(GLuint list, GLenum pname, GLint *params) PFNGLGETLISTPARAMETERIVSGIXPROC;
alias void function(GLuint list, GLenum pname, GLfloat param) PFNGLLISTPARAMETERFSGIXPROC;
alias void function(GLuint list, GLenum pname, GLfloat *params) PFNGLLISTPARAMETERFVSGIXPROC;
alias void function(GLuint list, GLenum pname, GLint param) PFNGLLISTPARAMETERISGIXPROC;
alias void function(GLuint list, GLenum pname, GLint *params) PFNGLLISTPARAMETERIVSGIXPROC;

static const auto GL_SGIX_ir_instrument1 = 1;

static const auto GL_SGIX_calligraphic_fragment = 1;

static const auto GL_SGIX_texture_lod_bias = 1;

static const auto GL_SGIX_shadow_ambient = 1;

static const auto GL_EXT_index_texture = 1;

static const auto GL_EXT_index_material = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glIndexMaterialEXT (GLenum face, GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum face, GLenum mode) PFNGLINDEXMATERIALEXTPROC;

static const auto GL_EXT_index_func = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glIndexFuncEXT (GLenum func, GLclampf _ref);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum func, GLclampf _ref) PFNGLINDEXFUNCEXTPROC;

static const auto GL_EXT_index_array_formats = 1;

static const auto GL_EXT_compiled_vertex_array = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glLockArraysEXT (GLint first, GLsizei count);
	void glUnlockArraysEXT ();
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint first, GLsizei count) PFNGLLOCKARRAYSEXTPROC;
alias void function() PFNGLUNLOCKARRAYSEXTPROC;

static const auto GL_EXT_cull_vertex = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCullParameterdvEXT (GLenum pname, GLdouble *params);
	void glCullParameterfvEXT (GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLdouble *params) PFNGLCULLPARAMETERDVEXTPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLCULLPARAMETERFVEXTPROC;

static const auto GL_SGIX_ycrcb = 1;

static const auto GL_SGIX_fragment_lighting = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFragmentColorMaterialSGIX (GLenum face, GLenum mode);
	void glFragmentLightfSGIX (GLenum light, GLenum pname, GLfloat param);
	void glFragmentLightfvSGIX (GLenum light, GLenum pname, GLfloat *params);
	void glFragmentLightiSGIX (GLenum light, GLenum pname, GLint param);
	void glFragmentLightivSGIX (GLenum light, GLenum pname, GLint *params);
	void glFragmentLightModelfSGIX (GLenum pname, GLfloat param);
	void glFragmentLightModelfvSGIX (GLenum pname, GLfloat *params);
	void glFragmentLightModeliSGIX (GLenum pname, GLint param);
	void glFragmentLightModelivSGIX (GLenum pname, GLint *params);
	void glFragmentMaterialfSGIX (GLenum face, GLenum pname, GLfloat param);
	void glFragmentMaterialfvSGIX (GLenum face, GLenum pname, GLfloat *params);
	void glFragmentMaterialiSGIX (GLenum face, GLenum pname, GLint param);
	void glFragmentMaterialivSGIX (GLenum face, GLenum pname, GLint *params);
	void glGetFragmentLightfvSGIX (GLenum light, GLenum pname, GLfloat *params);
	void glGetFragmentLightivSGIX (GLenum light, GLenum pname, GLint *params);
	void glGetFragmentMaterialfvSGIX (GLenum face, GLenum pname, GLfloat *params);
	void glGetFragmentMaterialivSGIX (GLenum face, GLenum pname, GLint *params);
	void glLightEnviSGIX (GLenum pname, GLint param);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum face, GLenum mode) PFNGLFRAGMENTCOLORMATERIALSGIXPROC;
alias void function(GLenum light, GLenum pname, GLfloat param) PFNGLFRAGMENTLIGHTFSGIXPROC;
alias void function(GLenum light, GLenum pname, GLfloat *params) PFNGLFRAGMENTLIGHTFVSGIXPROC;
alias void function(GLenum light, GLenum pname, GLint param) PFNGLFRAGMENTLIGHTISGIXPROC;
alias void function(GLenum light, GLenum pname, GLint *params) PFNGLFRAGMENTLIGHTIVSGIXPROC;
alias void function(GLenum pname, GLfloat param) PFNGLFRAGMENTLIGHTMODELFSGIXPROC;
alias void function(GLenum pname, GLfloat *params) PFNGLFRAGMENTLIGHTMODELFVSGIXPROC;
alias void function(GLenum pname, GLint param) PFNGLFRAGMENTLIGHTMODELISGIXPROC;
alias void function(GLenum pname, GLint *params) PFNGLFRAGMENTLIGHTMODELIVSGIXPROC;
alias void function(GLenum face, GLenum pname, GLfloat param) PFNGLFRAGMENTMATERIALFSGIXPROC;
alias void function(GLenum face, GLenum pname, GLfloat *params) PFNGLFRAGMENTMATERIALFVSGIXPROC;
alias void function(GLenum face, GLenum pname, GLint param) PFNGLFRAGMENTMATERIALISGIXPROC;
alias void function(GLenum face, GLenum pname, GLint *params) PFNGLFRAGMENTMATERIALIVSGIXPROC;
alias void function(GLenum light, GLenum pname, GLfloat *params) PFNGLGETFRAGMENTLIGHTFVSGIXPROC;
alias void function(GLenum light, GLenum pname, GLint *params) PFNGLGETFRAGMENTLIGHTIVSGIXPROC;
alias void function(GLenum face, GLenum pname, GLfloat *params) PFNGLGETFRAGMENTMATERIALFVSGIXPROC;
alias void function(GLenum face, GLenum pname, GLint *params) PFNGLGETFRAGMENTMATERIALIVSGIXPROC;
alias void function(GLenum pname, GLint param) PFNGLLIGHTENVISGIXPROC;

static const auto GL_IBM_rasterpos_clip = 1;

static const auto GL_HP_texture_lighting = 1;

static const auto GL_EXT_draw_range_elements = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawRangeElementsEXT (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices) PFNGLDRAWRANGEELEMENTSEXTPROC;

static const auto GL_WIN_phong_shading = 1;

static const auto GL_WIN_specular_fog = 1;

static const auto GL_EXT_light_texture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glApplyTextureEXT (GLenum mode);
	void glTextureLightEXT (GLenum pname);
	void glTextureMaterialEXT (GLenum face, GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode) PFNGLAPPLYTEXTUREEXTPROC;
alias void function(GLenum pname) PFNGLTEXTURELIGHTEXTPROC;
alias void function(GLenum face, GLenum mode) PFNGLTEXTUREMATERIALEXTPROC;

static const auto GL_SGIX_blend_alpha_minmax = 1;

static const auto GL_EXT_bgra = 1;

static const auto GL_SGIX_async = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glAsyncMarkerSGIX (GLuint marker);
	GLint glFinishAsyncSGIX (GLuint *markerp);
	GLint glPollAsyncSGIX (GLuint *markerp);
	GLuint glGenAsyncMarkersSGIX (GLsizei range);
	void glDeleteAsyncMarkersSGIX (GLuint marker, GLsizei range);
	GLboolean glIsAsyncMarkerSGIX (GLuint marker);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint marker) PFNGLASYNCMARKERSGIXPROC;
alias GLint function(GLuint *markerp) PFNGLFINISHASYNCSGIXPROC;
alias GLint function(GLuint *markerp) PFNGLPOLLASYNCSGIXPROC;
alias GLuint function(GLsizei range) PFNGLGENASYNCMARKERSSGIXPROC;
alias void function(GLuint marker, GLsizei range) PFNGLDELETEASYNCMARKERSSGIXPROC;
alias GLboolean function(GLuint marker) PFNGLISASYNCMARKERSGIXPROC;

static const auto GL_SGIX_async_pixel = 1;

static const auto GL_SGIX_async_histogram = 1;

static const auto GL_INTEL_parallel_arrays = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexPointervINTEL (GLint size, GLenum type, GLvoid* *pointer);
	void glNormalPointervINTEL (GLenum type, GLvoid* *pointer);
	void glColorPointervINTEL (GLint size, GLenum type, GLvoid* *pointer);
	void glTexCoordPointervINTEL (GLint size, GLenum type, GLvoid* *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint size, GLenum type, GLvoid* *pointer) PFNGLVERTEXPOINTERVINTELPROC;
alias void function(GLenum type, GLvoid* *pointer) PFNGLNORMALPOINTERVINTELPROC;
alias void function(GLint size, GLenum type, GLvoid* *pointer) PFNGLCOLORPOINTERVINTELPROC;
alias void function(GLint size, GLenum type, GLvoid* *pointer) PFNGLTEXCOORDPOINTERVINTELPROC;

static const auto GL_HP_occlusion_test = 1;

static const auto GL_EXT_pixel_transform = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPixelTransformParameteriEXT (GLenum target, GLenum pname, GLint param);
	void glPixelTransformParameterfEXT (GLenum target, GLenum pname, GLfloat param);
	void glPixelTransformParameterivEXT (GLenum target, GLenum pname, GLint *params);
	void glPixelTransformParameterfvEXT (GLenum target, GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum pname, GLint param) PFNGLPIXELTRANSFORMPARAMETERIEXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat param) PFNGLPIXELTRANSFORMPARAMETERFEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLPIXELTRANSFORMPARAMETERIVEXTPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLPIXELTRANSFORMPARAMETERFVEXTPROC;

static const auto GL_EXT_pixel_transform_color_table = 1;

static const auto GL_EXT_shared_texture_palette = 1;

static const auto GL_EXT_separate_specular_color = 1;

static const auto GL_EXT_secondary_color = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glSecondaryColor3bEXT (GLbyte red, GLbyte green, GLbyte blue);
	void glSecondaryColor3bvEXT (GLbyte *v);
	void glSecondaryColor3dEXT (GLdouble red, GLdouble green, GLdouble blue);
	void glSecondaryColor3dvEXT (GLdouble *v);
	void glSecondaryColor3fEXT (GLfloat red, GLfloat green, GLfloat blue);
	void glSecondaryColor3fvEXT (GLfloat *v);
	void glSecondaryColor3iEXT (GLint red, GLint green, GLint blue);
	void glSecondaryColor3ivEXT (GLint *v);
	void glSecondaryColor3sEXT (GLshort red, GLshort green, GLshort blue);
	void glSecondaryColor3svEXT (GLshort *v);
	void glSecondaryColor3ubEXT (GLubyte red, GLubyte green, GLubyte blue);
	void glSecondaryColor3ubvEXT (GLubyte *v);
	void glSecondaryColor3uiEXT (GLuint red, GLuint green, GLuint blue);
	void glSecondaryColor3uivEXT (GLuint *v);
	void glSecondaryColor3usEXT (GLushort red, GLushort green, GLushort blue);
	void glSecondaryColor3usvEXT (GLushort *v);
	void glSecondaryColorPointerEXT (GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLbyte red, GLbyte green, GLbyte blue) PFNGLSECONDARYCOLOR3BEXTPROC;
alias void function(GLbyte *v) PFNGLSECONDARYCOLOR3BVEXTPROC;
alias void function(GLdouble red, GLdouble green, GLdouble blue) PFNGLSECONDARYCOLOR3DEXTPROC;
alias void function(GLdouble *v) PFNGLSECONDARYCOLOR3DVEXTPROC;
alias void function(GLfloat red, GLfloat green, GLfloat blue) PFNGLSECONDARYCOLOR3FEXTPROC;
alias void function(GLfloat *v) PFNGLSECONDARYCOLOR3FVEXTPROC;
alias void function(GLint red, GLint green, GLint blue) PFNGLSECONDARYCOLOR3IEXTPROC;
alias void function(GLint *v) PFNGLSECONDARYCOLOR3IVEXTPROC;
alias void function(GLshort red, GLshort green, GLshort blue) PFNGLSECONDARYCOLOR3SEXTPROC;
alias void function(GLshort *v) PFNGLSECONDARYCOLOR3SVEXTPROC;
alias void function(GLubyte red, GLubyte green, GLubyte blue) PFNGLSECONDARYCOLOR3UBEXTPROC;
alias void function(GLubyte *v) PFNGLSECONDARYCOLOR3UBVEXTPROC;
alias void function(GLuint red, GLuint green, GLuint blue) PFNGLSECONDARYCOLOR3UIEXTPROC;
alias void function(GLuint *v) PFNGLSECONDARYCOLOR3UIVEXTPROC;
alias void function(GLushort red, GLushort green, GLushort blue) PFNGLSECONDARYCOLOR3USEXTPROC;
alias void function(GLushort *v) PFNGLSECONDARYCOLOR3USVEXTPROC;
alias void function(GLint size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLSECONDARYCOLORPOINTEREXTPROC;

static const auto GL_EXT_texture_perturb_normal = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTextureNormalEXT (GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode) PFNGLTEXTURENORMALEXTPROC;

static const auto GL_EXT_multi_draw_arrays = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glMultiDrawArraysEXT (GLenum mode, GLint *first, GLsizei *count, GLsizei primcount);
	void glMultiDrawElementsEXT (GLenum mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLint *first, GLsizei *count, GLsizei primcount) PFNGLMULTIDRAWARRAYSEXTPROC;
alias void function(GLenum mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount) PFNGLMULTIDRAWELEMENTSEXTPROC;

static const auto GL_EXT_fog_coord = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFogCoordfEXT (GLfloat coord);
	void glFogCoordfvEXT (GLfloat *coord);
	void glFogCoorddEXT (GLdouble coord);
	void glFogCoorddvEXT (GLdouble *coord);
	void glFogCoordPointerEXT (GLenum type, GLsizei stride, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLfloat coord) PFNGLFOGCOORDFEXTPROC;
alias void function(GLfloat *coord) PFNGLFOGCOORDFVEXTPROC;
alias void function(GLdouble coord) PFNGLFOGCOORDDEXTPROC;
alias void function(GLdouble *coord) PFNGLFOGCOORDDVEXTPROC;
alias void function(GLenum type, GLsizei stride, GLvoid *pointer) PFNGLFOGCOORDPOINTEREXTPROC;

static const auto GL_REND_screen_coordinates = 1;

static const auto GL_EXT_coordinate_frame = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTangent3bEXT (GLbyte tx, GLbyte ty, GLbyte tz);
	void glTangent3bvEXT (GLbyte *v);
	void glTangent3dEXT (GLdouble tx, GLdouble ty, GLdouble tz);
	void glTangent3dvEXT (GLdouble *v);
	void glTangent3fEXT (GLfloat tx, GLfloat ty, GLfloat tz);
	void glTangent3fvEXT (GLfloat *v);
	void glTangent3iEXT (GLint tx, GLint ty, GLint tz);
	void glTangent3ivEXT (GLint *v);
	void glTangent3sEXT (GLshort tx, GLshort ty, GLshort tz);
	void glTangent3svEXT (GLshort *v);
	void glBinormal3bEXT (GLbyte bx, GLbyte by, GLbyte bz);
	void glBinormal3bvEXT (GLbyte *v);
	void glBinormal3dEXT (GLdouble bx, GLdouble by, GLdouble bz);
	void glBinormal3dvEXT (GLdouble *v);
	void glBinormal3fEXT (GLfloat bx, GLfloat by, GLfloat bz);
	void glBinormal3fvEXT (GLfloat *v);
	void glBinormal3iEXT (GLint bx, GLint by, GLint bz);
	void glBinormal3ivEXT (GLint *v);
	void glBinormal3sEXT (GLshort bx, GLshort by, GLshort bz);
	void glBinormal3svEXT (GLshort *v);
	void glTangentPointerEXT (GLenum type, GLsizei stride, GLvoid *pointer);
	void glBinormalPointerEXT (GLenum type, GLsizei stride, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLbyte tx, GLbyte ty, GLbyte tz) PFNGLTANGENT3BEXTPROC;
alias void function(GLbyte *v) PFNGLTANGENT3BVEXTPROC;
alias void function(GLdouble tx, GLdouble ty, GLdouble tz) PFNGLTANGENT3DEXTPROC;
alias void function(GLdouble *v) PFNGLTANGENT3DVEXTPROC;
alias void function(GLfloat tx, GLfloat ty, GLfloat tz) PFNGLTANGENT3FEXTPROC;
alias void function(GLfloat *v) PFNGLTANGENT3FVEXTPROC;
alias void function(GLint tx, GLint ty, GLint tz) PFNGLTANGENT3IEXTPROC;
alias void function(GLint *v) PFNGLTANGENT3IVEXTPROC;
alias void function(GLshort tx, GLshort ty, GLshort tz) PFNGLTANGENT3SEXTPROC;
alias void function(GLshort *v) PFNGLTANGENT3SVEXTPROC;
alias void function(GLbyte bx, GLbyte by, GLbyte bz) PFNGLBINORMAL3BEXTPROC;
alias void function(GLbyte *v) PFNGLBINORMAL3BVEXTPROC;
alias void function(GLdouble bx, GLdouble by, GLdouble bz) PFNGLBINORMAL3DEXTPROC;
alias void function(GLdouble *v) PFNGLBINORMAL3DVEXTPROC;
alias void function(GLfloat bx, GLfloat by, GLfloat bz) PFNGLBINORMAL3FEXTPROC;
alias void function(GLfloat *v) PFNGLBINORMAL3FVEXTPROC;
alias void function(GLint bx, GLint by, GLint bz) PFNGLBINORMAL3IEXTPROC;
alias void function(GLint *v) PFNGLBINORMAL3IVEXTPROC;
alias void function(GLshort bx, GLshort by, GLshort bz) PFNGLBINORMAL3SEXTPROC;
alias void function(GLshort *v) PFNGLBINORMAL3SVEXTPROC;
alias void function(GLenum type, GLsizei stride, GLvoid *pointer) PFNGLTANGENTPOINTEREXTPROC;
alias void function(GLenum type, GLsizei stride, GLvoid *pointer) PFNGLBINORMALPOINTEREXTPROC;

static const auto GL_EXT_texture_env_combine = 1;

static const auto GL_APPLE_specular_vector = 1;

static const auto GL_APPLE_transform_hint = 1;

static const auto GL_SGIX_fog_scale = 1;

static const auto GL_SUNX_constant_data = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFinishTextureSUNX ();
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLFINISHTEXTURESUNXPROC;

static const auto GL_SUN_global_alpha = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGlobalAlphaFactorbSUN (GLbyte factor);
	void glGlobalAlphaFactorsSUN (GLshort factor);
	void glGlobalAlphaFactoriSUN (GLint factor);
	void glGlobalAlphaFactorfSUN (GLfloat factor);
	void glGlobalAlphaFactordSUN (GLdouble factor);
	void glGlobalAlphaFactorubSUN (GLubyte factor);
	void glGlobalAlphaFactorusSUN (GLushort factor);
	void glGlobalAlphaFactoruiSUN (GLuint factor);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLbyte factor) PFNGLGLOBALALPHAFACTORBSUNPROC;
alias void function(GLshort factor) PFNGLGLOBALALPHAFACTORSSUNPROC;
alias void function(GLint factor) PFNGLGLOBALALPHAFACTORISUNPROC;
alias void function(GLfloat factor) PFNGLGLOBALALPHAFACTORFSUNPROC;
alias void function(GLdouble factor) PFNGLGLOBALALPHAFACTORDSUNPROC;
alias void function(GLubyte factor) PFNGLGLOBALALPHAFACTORUBSUNPROC;
alias void function(GLushort factor) PFNGLGLOBALALPHAFACTORUSSUNPROC;
alias void function(GLuint factor) PFNGLGLOBALALPHAFACTORUISUNPROC;

static const auto GL_SUN_triangle_list = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glReplacementCodeuiSUN (GLuint code);
	void glReplacementCodeusSUN (GLushort code);
	void glReplacementCodeubSUN (GLubyte code);
	void glReplacementCodeuivSUN (GLuint *code);
	void glReplacementCodeusvSUN (GLushort *code);
	void glReplacementCodeubvSUN (GLubyte *code);
	void glReplacementCodePointerSUN (GLenum type, GLsizei stride, GLvoid* *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint code) PFNGLREPLACEMENTCODEUISUNPROC;
alias void function(GLushort code) PFNGLREPLACEMENTCODEUSSUNPROC;
alias void function(GLubyte code) PFNGLREPLACEMENTCODEUBSUNPROC;
alias void function(GLuint *code) PFNGLREPLACEMENTCODEUIVSUNPROC;
alias void function(GLushort *code) PFNGLREPLACEMENTCODEUSVSUNPROC;
alias void function(GLubyte *code) PFNGLREPLACEMENTCODEUBVSUNPROC;
alias void function(GLenum type, GLsizei stride, GLvoid* *pointer) PFNGLREPLACEMENTCODEPOINTERSUNPROC;

static const auto GL_SUN_vertex = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glColor4ubVertex2fSUN (GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y);
	void glColor4ubVertex2fvSUN (GLubyte *c, GLfloat *v);
	void glColor4ubVertex3fSUN (GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y, GLfloat z);
	void glColor4ubVertex3fvSUN (GLubyte *c, GLfloat *v);
	void glColor3fVertex3fSUN (GLfloat r, GLfloat g, GLfloat b, GLfloat x, GLfloat y, GLfloat z);
	void glColor3fVertex3fvSUN (GLfloat *c, GLfloat *v);
	void glNormal3fVertex3fSUN (GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glNormal3fVertex3fvSUN (GLfloat *n, GLfloat *v);
	void glColor4fNormal3fVertex3fSUN (GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glColor4fNormal3fVertex3fvSUN (GLfloat *c, GLfloat *n, GLfloat *v);
	void glTexCoord2fVertex3fSUN (GLfloat s, GLfloat t, GLfloat x, GLfloat y, GLfloat z);
	void glTexCoord2fVertex3fvSUN (GLfloat *tc, GLfloat *v);
	void glTexCoord4fVertex4fSUN (GLfloat s, GLfloat t, GLfloat p, GLfloat q, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glTexCoord4fVertex4fvSUN (GLfloat *tc, GLfloat *v);
	void glTexCoord2fColor4ubVertex3fSUN (GLfloat s, GLfloat t, GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y, GLfloat z);
	void glTexCoord2fColor4ubVertex3fvSUN (GLfloat *tc, GLubyte *c, GLfloat *v);
	void glTexCoord2fColor3fVertex3fSUN (GLfloat s, GLfloat t, GLfloat r, GLfloat g, GLfloat b, GLfloat x, GLfloat y, GLfloat z);
	void glTexCoord2fColor3fVertex3fvSUN (GLfloat *tc, GLfloat *c, GLfloat *v);
	void glTexCoord2fNormal3fVertex3fSUN (GLfloat s, GLfloat t, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glTexCoord2fNormal3fVertex3fvSUN (GLfloat *tc, GLfloat *n, GLfloat *v);
	void glTexCoord2fColor4fNormal3fVertex3fSUN (GLfloat s, GLfloat t, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glTexCoord2fColor4fNormal3fVertex3fvSUN (GLfloat *tc, GLfloat *c, GLfloat *n, GLfloat *v);
	void glTexCoord4fColor4fNormal3fVertex4fSUN (GLfloat s, GLfloat t, GLfloat p, GLfloat q, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glTexCoord4fColor4fNormal3fVertex4fvSUN (GLfloat *tc, GLfloat *c, GLfloat *n, GLfloat *v);
	void glReplacementCodeuiVertex3fSUN (GLuint rc, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiVertex3fvSUN (GLuint *rc, GLfloat *v);
	void glReplacementCodeuiColor4ubVertex3fSUN (GLuint rc, GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiColor4ubVertex3fvSUN (GLuint *rc, GLubyte *c, GLfloat *v);
	void glReplacementCodeuiColor3fVertex3fSUN (GLuint rc, GLfloat r, GLfloat g, GLfloat b, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiColor3fVertex3fvSUN (GLuint *rc, GLfloat *c, GLfloat *v);
	void glReplacementCodeuiNormal3fVertex3fSUN (GLuint rc, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiNormal3fVertex3fvSUN (GLuint *rc, GLfloat *n, GLfloat *v);
	void glReplacementCodeuiColor4fNormal3fVertex3fSUN (GLuint rc, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiColor4fNormal3fVertex3fvSUN (GLuint *rc, GLfloat *c, GLfloat *n, GLfloat *v);
	void glReplacementCodeuiTexCoord2fVertex3fSUN (GLuint rc, GLfloat s, GLfloat t, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiTexCoord2fVertex3fvSUN (GLuint *rc, GLfloat *tc, GLfloat *v);
	void glReplacementCodeuiTexCoord2fNormal3fVertex3fSUN (GLuint rc, GLfloat s, GLfloat t, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiTexCoord2fNormal3fVertex3fvSUN (GLuint *rc, GLfloat *tc, GLfloat *n, GLfloat *v);
	void glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fSUN (GLuint rc, GLfloat s, GLfloat t, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z);
	void glReplacementCodeuiTexCoord2fColor4fNormal3fVertex3fvSUN (GLuint *rc, GLfloat *tc, GLfloat *c, GLfloat *n, GLfloat *v);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y) PFNGLCOLOR4UBVERTEX2FSUNPROC;
alias void function(GLubyte *c, GLfloat *v) PFNGLCOLOR4UBVERTEX2FVSUNPROC;
alias void function(GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y, GLfloat z) PFNGLCOLOR4UBVERTEX3FSUNPROC;
alias void function(GLubyte *c, GLfloat *v) PFNGLCOLOR4UBVERTEX3FVSUNPROC;
alias void function(GLfloat r, GLfloat g, GLfloat b, GLfloat x, GLfloat y, GLfloat z) PFNGLCOLOR3FVERTEX3FSUNPROC;
alias void function(GLfloat *c, GLfloat *v) PFNGLCOLOR3FVERTEX3FVSUNPROC;
alias void function(GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLNORMAL3FVERTEX3FSUNPROC;
alias void function(GLfloat *n, GLfloat *v) PFNGLNORMAL3FVERTEX3FVSUNPROC;
alias void function(GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLCOLOR4FNORMAL3FVERTEX3FSUNPROC;
alias void function(GLfloat *c, GLfloat *n, GLfloat *v) PFNGLCOLOR4FNORMAL3FVERTEX3FVSUNPROC;
alias void function(GLfloat s, GLfloat t, GLfloat x, GLfloat y, GLfloat z) PFNGLTEXCOORD2FVERTEX3FSUNPROC;
alias void function(GLfloat *tc, GLfloat *v) PFNGLTEXCOORD2FVERTEX3FVSUNPROC;
alias void function(GLfloat s, GLfloat t, GLfloat p, GLfloat q, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLTEXCOORD4FVERTEX4FSUNPROC;
alias void function(GLfloat *tc, GLfloat *v) PFNGLTEXCOORD4FVERTEX4FVSUNPROC;
alias void function(GLfloat s, GLfloat t, GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y, GLfloat z) PFNGLTEXCOORD2FCOLOR4UBVERTEX3FSUNPROC;
alias void function(GLfloat *tc, GLubyte *c, GLfloat *v) PFNGLTEXCOORD2FCOLOR4UBVERTEX3FVSUNPROC;
alias void function(GLfloat s, GLfloat t, GLfloat r, GLfloat g, GLfloat b, GLfloat x, GLfloat y, GLfloat z) PFNGLTEXCOORD2FCOLOR3FVERTEX3FSUNPROC;
alias void function(GLfloat *tc, GLfloat *c, GLfloat *v) PFNGLTEXCOORD2FCOLOR3FVERTEX3FVSUNPROC;
alias void function(GLfloat s, GLfloat t, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLTEXCOORD2FNORMAL3FVERTEX3FSUNPROC;
alias void function(GLfloat *tc, GLfloat *n, GLfloat *v) PFNGLTEXCOORD2FNORMAL3FVERTEX3FVSUNPROC;
alias void function(GLfloat s, GLfloat t, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLTEXCOORD2FCOLOR4FNORMAL3FVERTEX3FSUNPROC;
alias void function(GLfloat *tc, GLfloat *c, GLfloat *n, GLfloat *v) PFNGLTEXCOORD2FCOLOR4FNORMAL3FVERTEX3FVSUNPROC;
alias void function(GLfloat s, GLfloat t, GLfloat p, GLfloat q, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLTEXCOORD4FCOLOR4FNORMAL3FVERTEX4FSUNPROC;
alias void function(GLfloat *tc, GLfloat *c, GLfloat *n, GLfloat *v) PFNGLTEXCOORD4FCOLOR4FNORMAL3FVERTEX4FVSUNPROC;
alias void function(GLuint rc, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUIVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLfloat *v) PFNGLREPLACEMENTCODEUIVERTEX3FVSUNPROC;
alias void function(GLuint rc, GLubyte r, GLubyte g, GLubyte b, GLubyte a, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUICOLOR4UBVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLubyte *c, GLfloat *v) PFNGLREPLACEMENTCODEUICOLOR4UBVERTEX3FVSUNPROC;
alias void function(GLuint rc, GLfloat r, GLfloat g, GLfloat b, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUICOLOR3FVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLfloat *c, GLfloat *v) PFNGLREPLACEMENTCODEUICOLOR3FVERTEX3FVSUNPROC;
alias void function(GLuint rc, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUINORMAL3FVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLfloat *n, GLfloat *v) PFNGLREPLACEMENTCODEUINORMAL3FVERTEX3FVSUNPROC;
alias void function(GLuint rc, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUICOLOR4FNORMAL3FVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLfloat *c, GLfloat *n, GLfloat *v) PFNGLREPLACEMENTCODEUICOLOR4FNORMAL3FVERTEX3FVSUNPROC;
alias void function(GLuint rc, GLfloat s, GLfloat t, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUITEXCOORD2FVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLfloat *tc, GLfloat *v) PFNGLREPLACEMENTCODEUITEXCOORD2FVERTEX3FVSUNPROC;
alias void function(GLuint rc, GLfloat s, GLfloat t, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUITEXCOORD2FNORMAL3FVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLfloat *tc, GLfloat *n, GLfloat *v) PFNGLREPLACEMENTCODEUITEXCOORD2FNORMAL3FVERTEX3FVSUNPROC;
alias void function(GLuint rc, GLfloat s, GLfloat t, GLfloat r, GLfloat g, GLfloat b, GLfloat a, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat x, GLfloat y, GLfloat z) PFNGLREPLACEMENTCODEUITEXCOORD2FCOLOR4FNORMAL3FVERTEX3FSUNPROC;
alias void function(GLuint *rc, GLfloat *tc, GLfloat *c, GLfloat *n, GLfloat *v) PFNGLREPLACEMENTCODEUITEXCOORD2FCOLOR4FNORMAL3FVERTEX3FVSUNPROC;

static const auto GL_EXT_blend_func_separate = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendFuncSeparateEXT (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha) PFNGLBLENDFUNCSEPARATEEXTPROC;

static const auto GL_INGR_blend_func_separate = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendFuncSeparateINGR (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha) PFNGLBLENDFUNCSEPARATEINGRPROC;

static const auto GL_INGR_color_clamp = 1;

static const auto GL_INGR_interlace_read = 1;

static const auto GL_EXT_stencil_wrap = 1;

static const auto GL_EXT_422_pixels = 1;

static const auto GL_NV_texgen_reflection = 1;

static const auto GL_SUN_convolution_border_modes = 1;

static const auto GL_EXT_texture_env_add = 1;

static const auto GL_EXT_texture_lod_bias = 1;

static const auto GL_EXT_texture_filter_anisotropic = 1;

static const auto GL_EXT_vertex_weighting = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexWeightfEXT (GLfloat weight);
	void glVertexWeightfvEXT (GLfloat *weight);
	void glVertexWeightPointerEXT (GLsizei size, GLenum type, GLsizei stride, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLfloat weight) PFNGLVERTEXWEIGHTFEXTPROC;
alias void function(GLfloat *weight) PFNGLVERTEXWEIGHTFVEXTPROC;
alias void function(GLsizei size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLVERTEXWEIGHTPOINTEREXTPROC;

static const auto GL_NV_light_max_exponent = 1;

static const auto GL_NV_vertex_array_range = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFlushVertexArrayRangeNV ();
	void glVertexArrayRangeNV (GLsizei length, GLvoid *pointer);
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLFLUSHVERTEXARRAYRANGENVPROC;
alias void function(GLsizei length, GLvoid *pointer) PFNGLVERTEXARRAYRANGENVPROC;

static const auto GL_NV_register_combiners = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCombinerParameterfvNV (GLenum pname, GLfloat *params);
	void glCombinerParameterfNV (GLenum pname, GLfloat param);
	void glCombinerParameterivNV (GLenum pname, GLint *params);
	void glCombinerParameteriNV (GLenum pname, GLint param);
	void glCombinerInputNV (GLenum stage, GLenum portion, GLenum variable, GLenum input, GLenum mapping, GLenum componentUsage);
	void glCombinerOutputNV (GLenum stage, GLenum portion, GLenum abOutput, GLenum cdOutput, GLenum sumOutput, GLenum scale, GLenum bias, GLboolean abDotProduct, GLboolean cdDotProduct, GLboolean muxSum);
	void glFinalCombinerInputNV (GLenum variable, GLenum input, GLenum mapping, GLenum componentUsage);
	void glGetCombinerInputParameterfvNV (GLenum stage, GLenum portion, GLenum variable, GLenum pname, GLfloat *params);
	void glGetCombinerInputParameterivNV (GLenum stage, GLenum portion, GLenum variable, GLenum pname, GLint *params);
	void glGetCombinerOutputParameterfvNV (GLenum stage, GLenum portion, GLenum pname, GLfloat *params);
	void glGetCombinerOutputParameterivNV (GLenum stage, GLenum portion, GLenum pname, GLint *params);
	void glGetFinalCombinerInputParameterfvNV (GLenum variable, GLenum pname, GLfloat *params);
	void glGetFinalCombinerInputParameterivNV (GLenum variable, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLfloat *params) PFNGLCOMBINERPARAMETERFVNVPROC;
alias void function(GLenum pname, GLfloat param) PFNGLCOMBINERPARAMETERFNVPROC;
alias void function(GLenum pname, GLint *params) PFNGLCOMBINERPARAMETERIVNVPROC;
alias void function(GLenum pname, GLint param) PFNGLCOMBINERPARAMETERINVPROC;
alias void function(GLenum stage, GLenum portion, GLenum variable, GLenum input, GLenum mapping, GLenum componentUsage) PFNGLCOMBINERINPUTNVPROC;
alias void function(GLenum stage, GLenum portion, GLenum abOutput, GLenum cdOutput, GLenum sumOutput, GLenum scale, GLenum bias, GLboolean abDotProduct, GLboolean cdDotProduct, GLboolean muxSum) PFNGLCOMBINEROUTPUTNVPROC;
alias void function(GLenum variable, GLenum input, GLenum mapping, GLenum componentUsage) PFNGLFINALCOMBINERINPUTNVPROC;
alias void function(GLenum stage, GLenum portion, GLenum variable, GLenum pname, GLfloat *params) PFNGLGETCOMBINERINPUTPARAMETERFVNVPROC;
alias void function(GLenum stage, GLenum portion, GLenum variable, GLenum pname, GLint *params) PFNGLGETCOMBINERINPUTPARAMETERIVNVPROC;
alias void function(GLenum stage, GLenum portion, GLenum pname, GLfloat *params) PFNGLGETCOMBINEROUTPUTPARAMETERFVNVPROC;
alias void function(GLenum stage, GLenum portion, GLenum pname, GLint *params) PFNGLGETCOMBINEROUTPUTPARAMETERIVNVPROC;
alias void function(GLenum variable, GLenum pname, GLfloat *params) PFNGLGETFINALCOMBINERINPUTPARAMETERFVNVPROC;
alias void function(GLenum variable, GLenum pname, GLint *params) PFNGLGETFINALCOMBINERINPUTPARAMETERIVNVPROC;

static const auto GL_NV_fog_distance = 1;

static const auto GL_NV_texgen_emboss = 1;

static const auto GL_NV_blend_square = 1;

static const auto GL_NV_texture_env_combine4 = 1;

static const auto GL_MESA_resize_buffers = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glResizeBuffersMESA ();
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLRESIZEBUFFERSMESAPROC;

static const auto GL_MESA_window_pos = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glWindowPos2dMESA (GLdouble x, GLdouble y);
	void glWindowPos2dvMESA (GLdouble *v);
	void glWindowPos2fMESA (GLfloat x, GLfloat y);
	void glWindowPos2fvMESA (GLfloat *v);
	void glWindowPos2iMESA (GLint x, GLint y);
	void glWindowPos2ivMESA (GLint *v);
	void glWindowPos2sMESA (GLshort x, GLshort y);
	void glWindowPos2svMESA (GLshort *v);
	void glWindowPos3dMESA (GLdouble x, GLdouble y, GLdouble z);
	void glWindowPos3dvMESA (GLdouble *v);
	void glWindowPos3fMESA (GLfloat x, GLfloat y, GLfloat z);
	void glWindowPos3fvMESA (GLfloat *v);
	void glWindowPos3iMESA (GLint x, GLint y, GLint z);
	void glWindowPos3ivMESA (GLint *v);
	void glWindowPos3sMESA (GLshort x, GLshort y, GLshort z);
	void glWindowPos3svMESA (GLshort *v);
	void glWindowPos4dMESA (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glWindowPos4dvMESA (GLdouble *v);
	void glWindowPos4fMESA (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glWindowPos4fvMESA (GLfloat *v);
	void glWindowPos4iMESA (GLint x, GLint y, GLint z, GLint w);
	void glWindowPos4ivMESA (GLint *v);
	void glWindowPos4sMESA (GLshort x, GLshort y, GLshort z, GLshort w);
	void glWindowPos4svMESA (GLshort *v);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLdouble x, GLdouble y) PFNGLWINDOWPOS2DMESAPROC;
alias void function(GLdouble *v) PFNGLWINDOWPOS2DVMESAPROC;
alias void function(GLfloat x, GLfloat y) PFNGLWINDOWPOS2FMESAPROC;
alias void function(GLfloat *v) PFNGLWINDOWPOS2FVMESAPROC;
alias void function(GLint x, GLint y) PFNGLWINDOWPOS2IMESAPROC;
alias void function(GLint *v) PFNGLWINDOWPOS2IVMESAPROC;
alias void function(GLshort x, GLshort y) PFNGLWINDOWPOS2SMESAPROC;
alias void function(GLshort *v) PFNGLWINDOWPOS2SVMESAPROC;
alias void function(GLdouble x, GLdouble y, GLdouble z) PFNGLWINDOWPOS3DMESAPROC;
alias void function(GLdouble *v) PFNGLWINDOWPOS3DVMESAPROC;
alias void function(GLfloat x, GLfloat y, GLfloat z) PFNGLWINDOWPOS3FMESAPROC;
alias void function(GLfloat *v) PFNGLWINDOWPOS3FVMESAPROC;
alias void function(GLint x, GLint y, GLint z) PFNGLWINDOWPOS3IMESAPROC;
alias void function(GLint *v) PFNGLWINDOWPOS3IVMESAPROC;
alias void function(GLshort x, GLshort y, GLshort z) PFNGLWINDOWPOS3SMESAPROC;
alias void function(GLshort *v) PFNGLWINDOWPOS3SVMESAPROC;
alias void function(GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLWINDOWPOS4DMESAPROC;
alias void function(GLdouble *v) PFNGLWINDOWPOS4DVMESAPROC;
alias void function(GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLWINDOWPOS4FMESAPROC;
alias void function(GLfloat *v) PFNGLWINDOWPOS4FVMESAPROC;
alias void function(GLint x, GLint y, GLint z, GLint w) PFNGLWINDOWPOS4IMESAPROC;
alias void function(GLint *v) PFNGLWINDOWPOS4IVMESAPROC;
alias void function(GLshort x, GLshort y, GLshort z, GLshort w) PFNGLWINDOWPOS4SMESAPROC;
alias void function(GLshort *v) PFNGLWINDOWPOS4SVMESAPROC;

static const auto GL_IBM_cull_vertex = 1;

static const auto GL_IBM_multimode_draw_arrays = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glMultiModeDrawArraysIBM (GLenum *mode, GLint *first, GLsizei *count, GLsizei primcount, GLint modestride);
	void glMultiModeDrawElementsIBM (GLenum *mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount, GLint modestride);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum *mode, GLint *first, GLsizei *count, GLsizei primcount, GLint modestride) PFNGLMULTIMODEDRAWARRAYSIBMPROC;
alias void function(GLenum *mode, GLsizei *count, GLenum type, GLvoid* *indices, GLsizei primcount, GLint modestride) PFNGLMULTIMODEDRAWELEMENTSIBMPROC;

static const auto GL_IBM_vertex_array_lists = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glColorPointerListIBM (GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride);
	void glSecondaryColorPointerListIBM (GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride);
	void glEdgeFlagPointerListIBM (GLint stride, GLboolean* *pointer, GLint ptrstride);
	void glFogCoordPointerListIBM (GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride);
	void glIndexPointerListIBM (GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride);
	void glNormalPointerListIBM (GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride);
	void glTexCoordPointerListIBM (GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride);
	void glVertexPointerListIBM (GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride) PFNGLCOLORPOINTERLISTIBMPROC;
alias void function(GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride) PFNGLSECONDARYCOLORPOINTERLISTIBMPROC;
alias void function(GLint stride, GLboolean* *pointer, GLint ptrstride) PFNGLEDGEFLAGPOINTERLISTIBMPROC;
alias void function(GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride) PFNGLFOGCOORDPOINTERLISTIBMPROC;
alias void function(GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride) PFNGLINDEXPOINTERLISTIBMPROC;
alias void function(GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride) PFNGLNORMALPOINTERLISTIBMPROC;
alias void function(GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride) PFNGLTEXCOORDPOINTERLISTIBMPROC;
alias void function(GLint size, GLenum type, GLint stride, GLvoid* *pointer, GLint ptrstride) PFNGLVERTEXPOINTERLISTIBMPROC;

static const auto GL_SGIX_subsample = 1;

static const auto GL_SGIX_ycrcba = 1;

static const auto GL_SGIX_ycrcb_subsample = 1;

static const auto GL_SGIX_depth_pass_instrument = 1;

static const auto GL_3DFX_texture_compression_FXT1 = 1;

static const auto GL_3DFX_multisample = 1;

static const auto GL_3DFX_tbuffer = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTbufferMask3DFX (GLuint mask);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint mask) PFNGLTBUFFERMASK3DFXPROC;

static const auto GL_EXT_multisample = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glSampleMaskEXT (GLclampf value, GLboolean invert);
	void glSamplePatternEXT (GLenum pattern);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLclampf value, GLboolean invert) PFNGLSAMPLEMASKEXTPROC;
alias void function(GLenum pattern) PFNGLSAMPLEPATTERNEXTPROC;

static const auto GL_SGIX_vertex_preclip = 1;

static const auto GL_SGIX_convolution_accuracy = 1;

static const auto GL_SGIX_resample = 1;

static const auto GL_SGIS_point_line_texgen = 1;

static const auto GL_SGIS_texture_color_mask = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTextureColorMaskSGIS (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha) PFNGLTEXTURECOLORMASKSGISPROC;

static const auto GL_SGIX_igloo_interface = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glIglooInterfaceSGIX (GLenum pname, GLvoid *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLvoid *params) PFNGLIGLOOINTERFACESGIXPROC;

static const auto GL_EXT_texture_env_dot3 = 1;

static const auto GL_ATI_texture_mirror_once = 1;

static const auto GL_NV_fence = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDeleteFencesNV (GLsizei n, GLuint *fences);
	void glGenFencesNV (GLsizei n, GLuint *fences);
	GLboolean glIsFenceNV (GLuint fence);
	GLboolean glTestFenceNV (GLuint fence);
	void glGetFenceivNV (GLuint fence, GLenum pname, GLint *params);
	void glFinishFenceNV (GLuint fence);
	void glSetFenceNV (GLuint fence, GLenum condition);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLuint *fences) PFNGLDELETEFENCESNVPROC;
alias void function(GLsizei n, GLuint *fences) PFNGLGENFENCESNVPROC;
alias GLboolean function(GLuint fence) PFNGLISFENCENVPROC;
alias GLboolean function(GLuint fence) PFNGLTESTFENCENVPROC;
alias void function(GLuint fence, GLenum pname, GLint *params) PFNGLGETFENCEIVNVPROC;
alias void function(GLuint fence) PFNGLFINISHFENCENVPROC;
alias void function(GLuint fence, GLenum condition) PFNGLSETFENCENVPROC;

static const auto GL_NV_evaluators = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glMapControlPointsNV (GLenum target, GLuint index, GLenum type, GLsizei ustride, GLsizei vstride, GLint uorder, GLint vorder, GLboolean packed, GLvoid *points);
	void glMapParameterivNV (GLenum target, GLenum pname, GLint *params);
	void glMapParameterfvNV (GLenum target, GLenum pname, GLfloat *params);
	void glGetMapControlPointsNV (GLenum target, GLuint index, GLenum type, GLsizei ustride, GLsizei vstride, GLboolean packed, GLvoid *points);
	void glGetMapParameterivNV (GLenum target, GLenum pname, GLint *params);
	void glGetMapParameterfvNV (GLenum target, GLenum pname, GLfloat *params);
	void glGetMapAttribParameterivNV (GLenum target, GLuint index, GLenum pname, GLint *params);
	void glGetMapAttribParameterfvNV (GLenum target, GLuint index, GLenum pname, GLfloat *params);
	void glEvalMapsNV (GLenum target, GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint index, GLenum type, GLsizei ustride, GLsizei vstride, GLint uorder, GLint vorder, GLboolean packed, GLvoid *points) PFNGLMAPCONTROLPOINTSNVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLMAPPARAMETERIVNVPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLMAPPARAMETERFVNVPROC;
alias void function(GLenum target, GLuint index, GLenum type, GLsizei ustride, GLsizei vstride, GLboolean packed, GLvoid *points) PFNGLGETMAPCONTROLPOINTSNVPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETMAPPARAMETERIVNVPROC;
alias void function(GLenum target, GLenum pname, GLfloat *params) PFNGLGETMAPPARAMETERFVNVPROC;
alias void function(GLenum target, GLuint index, GLenum pname, GLint *params) PFNGLGETMAPATTRIBPARAMETERIVNVPROC;
alias void function(GLenum target, GLuint index, GLenum pname, GLfloat *params) PFNGLGETMAPATTRIBPARAMETERFVNVPROC;
alias void function(GLenum target, GLenum mode) PFNGLEVALMAPSNVPROC;

static const auto GL_NV_packed_depth_stencil = 1;

static const auto GL_NV_register_combiners2 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCombinerStageParameterfvNV (GLenum stage, GLenum pname, GLfloat *params);
	void glGetCombinerStageParameterfvNV (GLenum stage, GLenum pname, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum stage, GLenum pname, GLfloat *params) PFNGLCOMBINERSTAGEPARAMETERFVNVPROC;
alias void function(GLenum stage, GLenum pname, GLfloat *params) PFNGLGETCOMBINERSTAGEPARAMETERFVNVPROC;

static const auto GL_NV_texture_compression_vtc = 1;

static const auto GL_NV_texture_rectangle = 1;

static const auto GL_NV_texture_shader = 1;

static const auto GL_NV_texture_shader2 = 1;

static const auto GL_NV_vertex_array_range2 = 1;

static const auto GL_NV_vertex_program = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLboolean glAreProgramsResidentNV (GLsizei n, GLuint *programs, GLboolean *residences);
	void glBindProgramNV (GLenum target, GLuint id);
	void glDeleteProgramsNV (GLsizei n, GLuint *programs);
	void glExecuteProgramNV (GLenum target, GLuint id, GLfloat *params);
	void glGenProgramsNV (GLsizei n, GLuint *programs);
	void glGetProgramParameterdvNV (GLenum target, GLuint index, GLenum pname, GLdouble *params);
	void glGetProgramParameterfvNV (GLenum target, GLuint index, GLenum pname, GLfloat *params);
	void glGetProgramivNV (GLuint id, GLenum pname, GLint *params);
	void glGetProgramStringNV (GLuint id, GLenum pname, GLubyte *program);
	void glGetTrackMatrixivNV (GLenum target, GLuint address, GLenum pname, GLint *params);
	void glGetVertexAttribdvNV (GLuint index, GLenum pname, GLdouble *params);
	void glGetVertexAttribfvNV (GLuint index, GLenum pname, GLfloat *params);
	void glGetVertexAttribivNV (GLuint index, GLenum pname, GLint *params);
	void glGetVertexAttribPointervNV (GLuint index, GLenum pname, GLvoid* *pointer);
	GLboolean glIsProgramNV (GLuint id);
	void glLoadProgramNV (GLenum target, GLuint id, GLsizei len, GLubyte *program);
	void glProgramParameter4dNV (GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glProgramParameter4dvNV (GLenum target, GLuint index, GLdouble *v);
	void glProgramParameter4fNV (GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glProgramParameter4fvNV (GLenum target, GLuint index, GLfloat *v);
	void glProgramParameters4dvNV (GLenum target, GLuint index, GLuint count, GLdouble *v);
	void glProgramParameters4fvNV (GLenum target, GLuint index, GLuint count, GLfloat *v);
	void glRequestResidentProgramsNV (GLsizei n, GLuint *programs);
	void glTrackMatrixNV (GLenum target, GLuint address, GLenum matrix, GLenum transform);
	void glVertexAttribPointerNV (GLuint index, GLint fsize, GLenum type, GLsizei stride, GLvoid *pointer);
	void glVertexAttrib1dNV (GLuint index, GLdouble x);
	void glVertexAttrib1dvNV (GLuint index, GLdouble *v);
	void glVertexAttrib1fNV (GLuint index, GLfloat x);
	void glVertexAttrib1fvNV (GLuint index, GLfloat *v);
	void glVertexAttrib1sNV (GLuint index, GLshort x);
	void glVertexAttrib1svNV (GLuint index, GLshort *v);
	void glVertexAttrib2dNV (GLuint index, GLdouble x, GLdouble y);
	void glVertexAttrib2dvNV (GLuint index, GLdouble *v);
	void glVertexAttrib2fNV (GLuint index, GLfloat x, GLfloat y);
	void glVertexAttrib2fvNV (GLuint index, GLfloat *v);
	void glVertexAttrib2sNV (GLuint index, GLshort x, GLshort y);
	void glVertexAttrib2svNV (GLuint index, GLshort *v);
	void glVertexAttrib3dNV (GLuint index, GLdouble x, GLdouble y, GLdouble z);
	void glVertexAttrib3dvNV (GLuint index, GLdouble *v);
	void glVertexAttrib3fNV (GLuint index, GLfloat x, GLfloat y, GLfloat z);
	void glVertexAttrib3fvNV (GLuint index, GLfloat *v);
	void glVertexAttrib3sNV (GLuint index, GLshort x, GLshort y, GLshort z);
	void glVertexAttrib3svNV (GLuint index, GLshort *v);
	void glVertexAttrib4dNV (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glVertexAttrib4dvNV (GLuint index, GLdouble *v);
	void glVertexAttrib4fNV (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glVertexAttrib4fvNV (GLuint index, GLfloat *v);
	void glVertexAttrib4sNV (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
	void glVertexAttrib4svNV (GLuint index, GLshort *v);
	void glVertexAttrib4ubNV (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
	void glVertexAttrib4ubvNV (GLuint index, GLubyte *v);
	void glVertexAttribs1dvNV (GLuint index, GLsizei count, GLdouble *v);
	void glVertexAttribs1fvNV (GLuint index, GLsizei count, GLfloat *v);
	void glVertexAttribs1svNV (GLuint index, GLsizei count, GLshort *v);
	void glVertexAttribs2dvNV (GLuint index, GLsizei count, GLdouble *v);
	void glVertexAttribs2fvNV (GLuint index, GLsizei count, GLfloat *v);
	void glVertexAttribs2svNV (GLuint index, GLsizei count, GLshort *v);
	void glVertexAttribs3dvNV (GLuint index, GLsizei count, GLdouble *v);
	void glVertexAttribs3fvNV (GLuint index, GLsizei count, GLfloat *v);
	void glVertexAttribs3svNV (GLuint index, GLsizei count, GLshort *v);
	void glVertexAttribs4dvNV (GLuint index, GLsizei count, GLdouble *v);
	void glVertexAttribs4fvNV (GLuint index, GLsizei count, GLfloat *v);
	void glVertexAttribs4svNV (GLuint index, GLsizei count, GLshort *v);
	void glVertexAttribs4ubvNV (GLuint index, GLsizei count, GLubyte *v);
} /* GL_GLEXT_PROTOTYPES */
alias GLboolean function(GLsizei n, GLuint *programs, GLboolean *residences) PFNGLAREPROGRAMSRESIDENTNVPROC;
alias void function(GLenum target, GLuint id) PFNGLBINDPROGRAMNVPROC;
alias void function(GLsizei n, GLuint *programs) PFNGLDELETEPROGRAMSNVPROC;
alias void function(GLenum target, GLuint id, GLfloat *params) PFNGLEXECUTEPROGRAMNVPROC;
alias void function(GLsizei n, GLuint *programs) PFNGLGENPROGRAMSNVPROC;
alias void function(GLenum target, GLuint index, GLenum pname, GLdouble *params) PFNGLGETPROGRAMPARAMETERDVNVPROC;
alias void function(GLenum target, GLuint index, GLenum pname, GLfloat *params) PFNGLGETPROGRAMPARAMETERFVNVPROC;
alias void function(GLuint id, GLenum pname, GLint *params) PFNGLGETPROGRAMIVNVPROC;
alias void function(GLuint id, GLenum pname, GLubyte *program) PFNGLGETPROGRAMSTRINGNVPROC;
alias void function(GLenum target, GLuint address, GLenum pname, GLint *params) PFNGLGETTRACKMATRIXIVNVPROC;
alias void function(GLuint index, GLenum pname, GLdouble *params) PFNGLGETVERTEXATTRIBDVNVPROC;
alias void function(GLuint index, GLenum pname, GLfloat *params) PFNGLGETVERTEXATTRIBFVNVPROC;
alias void function(GLuint index, GLenum pname, GLint *params) PFNGLGETVERTEXATTRIBIVNVPROC;
alias void function(GLuint index, GLenum pname, GLvoid* *pointer) PFNGLGETVERTEXATTRIBPOINTERVNVPROC;
alias GLboolean function(GLuint id) PFNGLISPROGRAMNVPROC;
alias void function(GLenum target, GLuint id, GLsizei len, GLubyte *program) PFNGLLOADPROGRAMNVPROC;
alias void function(GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLPROGRAMPARAMETER4DNVPROC;
alias void function(GLenum target, GLuint index, GLdouble *v) PFNGLPROGRAMPARAMETER4DVNVPROC;
alias void function(GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLPROGRAMPARAMETER4FNVPROC;
alias void function(GLenum target, GLuint index, GLfloat *v) PFNGLPROGRAMPARAMETER4FVNVPROC;
alias void function(GLenum target, GLuint index, GLuint count, GLdouble *v) PFNGLPROGRAMPARAMETERS4DVNVPROC;
alias void function(GLenum target, GLuint index, GLuint count, GLfloat *v) PFNGLPROGRAMPARAMETERS4FVNVPROC;
alias void function(GLsizei n, GLuint *programs) PFNGLREQUESTRESIDENTPROGRAMSNVPROC;
alias void function(GLenum target, GLuint address, GLenum matrix, GLenum transform) PFNGLTRACKMATRIXNVPROC;
alias void function(GLuint index, GLint fsize, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLVERTEXATTRIBPOINTERNVPROC;
alias void function(GLuint index, GLdouble x) PFNGLVERTEXATTRIB1DNVPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB1DVNVPROC;
alias void function(GLuint index, GLfloat x) PFNGLVERTEXATTRIB1FNVPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB1FVNVPROC;
alias void function(GLuint index, GLshort x) PFNGLVERTEXATTRIB1SNVPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB1SVNVPROC;
alias void function(GLuint index, GLdouble x, GLdouble y) PFNGLVERTEXATTRIB2DNVPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB2DVNVPROC;
alias void function(GLuint index, GLfloat x, GLfloat y) PFNGLVERTEXATTRIB2FNVPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB2FVNVPROC;
alias void function(GLuint index, GLshort x, GLshort y) PFNGLVERTEXATTRIB2SNVPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB2SVNVPROC;
alias void function(GLuint index, GLdouble x, GLdouble y, GLdouble z) PFNGLVERTEXATTRIB3DNVPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB3DVNVPROC;
alias void function(GLuint index, GLfloat x, GLfloat y, GLfloat z) PFNGLVERTEXATTRIB3FNVPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB3FVNVPROC;
alias void function(GLuint index, GLshort x, GLshort y, GLshort z) PFNGLVERTEXATTRIB3SNVPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB3SVNVPROC;
alias void function(GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLVERTEXATTRIB4DNVPROC;
alias void function(GLuint index, GLdouble *v) PFNGLVERTEXATTRIB4DVNVPROC;
alias void function(GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLVERTEXATTRIB4FNVPROC;
alias void function(GLuint index, GLfloat *v) PFNGLVERTEXATTRIB4FVNVPROC;
alias void function(GLuint index, GLshort x, GLshort y, GLshort z, GLshort w) PFNGLVERTEXATTRIB4SNVPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIB4SVNVPROC;
alias void function(GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w) PFNGLVERTEXATTRIB4UBNVPROC;
alias void function(GLuint index, GLubyte *v) PFNGLVERTEXATTRIB4UBVNVPROC;
alias void function(GLuint index, GLsizei count, GLdouble *v) PFNGLVERTEXATTRIBS1DVNVPROC;
alias void function(GLuint index, GLsizei count, GLfloat *v) PFNGLVERTEXATTRIBS1FVNVPROC;
alias void function(GLuint index, GLsizei count, GLshort *v) PFNGLVERTEXATTRIBS1SVNVPROC;
alias void function(GLuint index, GLsizei count, GLdouble *v) PFNGLVERTEXATTRIBS2DVNVPROC;
alias void function(GLuint index, GLsizei count, GLfloat *v) PFNGLVERTEXATTRIBS2FVNVPROC;
alias void function(GLuint index, GLsizei count, GLshort *v) PFNGLVERTEXATTRIBS2SVNVPROC;
alias void function(GLuint index, GLsizei count, GLdouble *v) PFNGLVERTEXATTRIBS3DVNVPROC;
alias void function(GLuint index, GLsizei count, GLfloat *v) PFNGLVERTEXATTRIBS3FVNVPROC;
alias void function(GLuint index, GLsizei count, GLshort *v) PFNGLVERTEXATTRIBS3SVNVPROC;
alias void function(GLuint index, GLsizei count, GLdouble *v) PFNGLVERTEXATTRIBS4DVNVPROC;
alias void function(GLuint index, GLsizei count, GLfloat *v) PFNGLVERTEXATTRIBS4FVNVPROC;
alias void function(GLuint index, GLsizei count, GLshort *v) PFNGLVERTEXATTRIBS4SVNVPROC;
alias void function(GLuint index, GLsizei count, GLubyte *v) PFNGLVERTEXATTRIBS4UBVNVPROC;

static const auto GL_SGIX_texture_coordinate_clamp = 1;

static const auto GL_SGIX_scalebias_hint = 1;

static const auto GL_OML_interlace = 1;

static const auto GL_OML_subsample = 1;

static const auto GL_OML_resample = 1;

static const auto GL_NV_copy_depth_to_color = 1;

static const auto GL_ATI_envmap_bumpmap = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexBumpParameterivATI (GLenum pname, GLint *param);
	void glTexBumpParameterfvATI (GLenum pname, GLfloat *param);
	void glGetTexBumpParameterivATI (GLenum pname, GLint *param);
	void glGetTexBumpParameterfvATI (GLenum pname, GLfloat *param);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLint *param) PFNGLTEXBUMPPARAMETERIVATIPROC;
alias void function(GLenum pname, GLfloat *param) PFNGLTEXBUMPPARAMETERFVATIPROC;
alias void function(GLenum pname, GLint *param) PFNGLGETTEXBUMPPARAMETERIVATIPROC;
alias void function(GLenum pname, GLfloat *param) PFNGLGETTEXBUMPPARAMETERFVATIPROC;

static const auto GL_ATI_fragment_shader = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLuint glGenFragmentShadersATI (GLuint range);
	void glBindFragmentShaderATI (GLuint id);
	void glDeleteFragmentShaderATI (GLuint id);
	void glBeginFragmentShaderATI ();
	void glEndFragmentShaderATI ();
	void glPassTexCoordATI (GLuint dst, GLuint coord, GLenum swizzle);
	void glSampleMapATI (GLuint dst, GLuint interp, GLenum swizzle);
	void glColorFragmentOp1ATI (GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod);
	void glColorFragmentOp2ATI (GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod);
	void glColorFragmentOp3ATI (GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod, GLuint arg3, GLuint arg3Rep, GLuint arg3Mod);
	void glAlphaFragmentOp1ATI (GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod);
	void glAlphaFragmentOp2ATI (GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod);
	void glAlphaFragmentOp3ATI (GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod, GLuint arg3, GLuint arg3Rep, GLuint arg3Mod);
	void glSetFragmentShaderConstantATI (GLuint dst, GLfloat *value);
} /* GL_GLEXT_PROTOTYPES */
alias GLuint function(GLuint range) PFNGLGENFRAGMENTSHADERSATIPROC;
alias void function(GLuint id) PFNGLBINDFRAGMENTSHADERATIPROC;
alias void function(GLuint id) PFNGLDELETEFRAGMENTSHADERATIPROC;
alias void function() PFNGLBEGINFRAGMENTSHADERATIPROC;
alias void function() PFNGLENDFRAGMENTSHADERATIPROC;
alias void function(GLuint dst, GLuint coord, GLenum swizzle) PFNGLPASSTEXCOORDATIPROC;
alias void function(GLuint dst, GLuint interp, GLenum swizzle) PFNGLSAMPLEMAPATIPROC;
alias void function(GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod) PFNGLCOLORFRAGMENTOP1ATIPROC;
alias void function(GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod) PFNGLCOLORFRAGMENTOP2ATIPROC;
alias void function(GLenum op, GLuint dst, GLuint dstMask, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod, GLuint arg3, GLuint arg3Rep, GLuint arg3Mod) PFNGLCOLORFRAGMENTOP3ATIPROC;
alias void function(GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod) PFNGLALPHAFRAGMENTOP1ATIPROC;
alias void function(GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod) PFNGLALPHAFRAGMENTOP2ATIPROC;
alias void function(GLenum op, GLuint dst, GLuint dstMod, GLuint arg1, GLuint arg1Rep, GLuint arg1Mod, GLuint arg2, GLuint arg2Rep, GLuint arg2Mod, GLuint arg3, GLuint arg3Rep, GLuint arg3Mod) PFNGLALPHAFRAGMENTOP3ATIPROC;
alias void function(GLuint dst, GLfloat *value) PFNGLSETFRAGMENTSHADERCONSTANTATIPROC;

static const auto GL_ATI_pn_triangles = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPNTrianglesiATI (GLenum pname, GLint param);
	void glPNTrianglesfATI (GLenum pname, GLfloat param);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLint param) PFNGLPNTRIANGLESIATIPROC;
alias void function(GLenum pname, GLfloat param) PFNGLPNTRIANGLESFATIPROC;

static const auto GL_ATI_vertex_array_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLuint glNewObjectBufferATI (GLsizei size, GLvoid *pointer, GLenum usage);
	GLboolean glIsObjectBufferATI (GLuint buffer);
	void glUpdateObjectBufferATI (GLuint buffer, GLuint offset, GLsizei size, GLvoid *pointer, GLenum preserve);
	void glGetObjectBufferfvATI (GLuint buffer, GLenum pname, GLfloat *params);
	void glGetObjectBufferivATI (GLuint buffer, GLenum pname, GLint *params);
	void glFreeObjectBufferATI (GLuint buffer);
	void glArrayObjectATI (GLenum array, GLint size, GLenum type, GLsizei stride, GLuint buffer, GLuint offset);
	void glGetArrayObjectfvATI (GLenum array, GLenum pname, GLfloat *params);
	void glGetArrayObjectivATI (GLenum array, GLenum pname, GLint *params);
	void glVariantArrayObjectATI (GLuint id, GLenum type, GLsizei stride, GLuint buffer, GLuint offset);
	void glGetVariantArrayObjectfvATI (GLuint id, GLenum pname, GLfloat *params);
	void glGetVariantArrayObjectivATI (GLuint id, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias GLuint function(GLsizei size, GLvoid *pointer, GLenum usage) PFNGLNEWOBJECTBUFFERATIPROC;
alias GLboolean function(GLuint buffer) PFNGLISOBJECTBUFFERATIPROC;
alias void function(GLuint buffer, GLuint offset, GLsizei size, GLvoid *pointer, GLenum preserve) PFNGLUPDATEOBJECTBUFFERATIPROC;
alias void function(GLuint buffer, GLenum pname, GLfloat *params) PFNGLGETOBJECTBUFFERFVATIPROC;
alias void function(GLuint buffer, GLenum pname, GLint *params) PFNGLGETOBJECTBUFFERIVATIPROC;
alias void function(GLuint buffer) PFNGLFREEOBJECTBUFFERATIPROC;
alias void function(GLenum array, GLint size, GLenum type, GLsizei stride, GLuint buffer, GLuint offset) PFNGLARRAYOBJECTATIPROC;
alias void function(GLenum array, GLenum pname, GLfloat *params) PFNGLGETARRAYOBJECTFVATIPROC;
alias void function(GLenum array, GLenum pname, GLint *params) PFNGLGETARRAYOBJECTIVATIPROC;
alias void function(GLuint id, GLenum type, GLsizei stride, GLuint buffer, GLuint offset) PFNGLVARIANTARRAYOBJECTATIPROC;
alias void function(GLuint id, GLenum pname, GLfloat *params) PFNGLGETVARIANTARRAYOBJECTFVATIPROC;
alias void function(GLuint id, GLenum pname, GLint *params) PFNGLGETVARIANTARRAYOBJECTIVATIPROC;

static const auto GL_EXT_vertex_shader = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBeginVertexShaderEXT ();
	void glEndVertexShaderEXT ();
	void glBindVertexShaderEXT (GLuint id);
	GLuint glGenVertexShadersEXT (GLuint range);
	void glDeleteVertexShaderEXT (GLuint id);
	void glShaderOp1EXT (GLenum op, GLuint res, GLuint arg1);
	void glShaderOp2EXT (GLenum op, GLuint res, GLuint arg1, GLuint arg2);
	void glShaderOp3EXT (GLenum op, GLuint res, GLuint arg1, GLuint arg2, GLuint arg3);
	void glSwizzleEXT (GLuint res, GLuint _in, GLenum outX, GLenum outY, GLenum outZ, GLenum outW);
	void glWriteMaskEXT (GLuint res, GLuint _in, GLenum outX, GLenum outY, GLenum outZ, GLenum outW);
	void glInsertComponentEXT (GLuint res, GLuint src, GLuint num);
	void glExtractComponentEXT (GLuint res, GLuint src, GLuint num);
	GLuint glGenSymbolsEXT (GLenum datatype, GLenum storagetype, GLenum range, GLuint components);
	void glSetInvariantEXT (GLuint id, GLenum type, GLvoid *addr);
	void glSetLocalConstantEXT (GLuint id, GLenum type, GLvoid *addr);
	void glVariantbvEXT (GLuint id, GLbyte *addr);
	void glVariantsvEXT (GLuint id, GLshort *addr);
	void glVariantivEXT (GLuint id, GLint *addr);
	void glVariantfvEXT (GLuint id, GLfloat *addr);
	void glVariantdvEXT (GLuint id, GLdouble *addr);
	void glVariantubvEXT (GLuint id, GLubyte *addr);
	void glVariantusvEXT (GLuint id, GLushort *addr);
	void glVariantuivEXT (GLuint id, GLuint *addr);
	void glVariantPointerEXT (GLuint id, GLenum type, GLuint stride, GLvoid *addr);
	void glEnableVariantClientStateEXT (GLuint id);
	void glDisableVariantClientStateEXT (GLuint id);
	GLuint glBindLightParameterEXT (GLenum light, GLenum value);
	GLuint glBindMaterialParameterEXT (GLenum face, GLenum value);
	GLuint glBindTexGenParameterEXT (GLenum unit, GLenum coord, GLenum value);
	GLuint glBindTextureUnitParameterEXT (GLenum unit, GLenum value);
	GLuint glBindParameterEXT (GLenum value);
	GLboolean glIsVariantEnabledEXT (GLuint id, GLenum cap);
	void glGetVariantBooleanvEXT (GLuint id, GLenum value, GLboolean *data);
	void glGetVariantIntegervEXT (GLuint id, GLenum value, GLint *data);
	void glGetVariantFloatvEXT (GLuint id, GLenum value, GLfloat *data);
	void glGetVariantPointervEXT (GLuint id, GLenum value, GLvoid* *data);
	void glGetInvariantBooleanvEXT (GLuint id, GLenum value, GLboolean *data);
	void glGetInvariantIntegervEXT (GLuint id, GLenum value, GLint *data);
	void glGetInvariantFloatvEXT (GLuint id, GLenum value, GLfloat *data);
	void glGetLocalConstantBooleanvEXT (GLuint id, GLenum value, GLboolean *data);
	void glGetLocalConstantIntegervEXT (GLuint id, GLenum value, GLint *data);
	void glGetLocalConstantFloatvEXT (GLuint id, GLenum value, GLfloat *data);
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLBEGINVERTEXSHADEREXTPROC;
alias void function() PFNGLENDVERTEXSHADEREXTPROC;
alias void function(GLuint id) PFNGLBINDVERTEXSHADEREXTPROC;
alias GLuint function(GLuint range) PFNGLGENVERTEXSHADERSEXTPROC;
alias void function(GLuint id) PFNGLDELETEVERTEXSHADEREXTPROC;
alias void function(GLenum op, GLuint res, GLuint arg1) PFNGLSHADEROP1EXTPROC;
alias void function(GLenum op, GLuint res, GLuint arg1, GLuint arg2) PFNGLSHADEROP2EXTPROC;
alias void function(GLenum op, GLuint res, GLuint arg1, GLuint arg2, GLuint arg3) PFNGLSHADEROP3EXTPROC;
alias void function(GLuint res, GLuint _in, GLenum outX, GLenum outY, GLenum outZ, GLenum outW) PFNGLSWIZZLEEXTPROC;
alias void function(GLuint res, GLuint _in, GLenum outX, GLenum outY, GLenum outZ, GLenum outW) PFNGLWRITEMASKEXTPROC;
alias void function(GLuint res, GLuint src, GLuint num) PFNGLINSERTCOMPONENTEXTPROC;
alias void function(GLuint res, GLuint src, GLuint num) PFNGLEXTRACTCOMPONENTEXTPROC;
alias GLuint function(GLenum datatype, GLenum storagetype, GLenum range, GLuint components) PFNGLGENSYMBOLSEXTPROC;
alias void function(GLuint id, GLenum type, GLvoid *addr) PFNGLSETINVARIANTEXTPROC;
alias void function(GLuint id, GLenum type, GLvoid *addr) PFNGLSETLOCALCONSTANTEXTPROC;
alias void function(GLuint id, GLbyte *addr) PFNGLVARIANTBVEXTPROC;
alias void function(GLuint id, GLshort *addr) PFNGLVARIANTSVEXTPROC;
alias void function(GLuint id, GLint *addr) PFNGLVARIANTIVEXTPROC;
alias void function(GLuint id, GLfloat *addr) PFNGLVARIANTFVEXTPROC;
alias void function(GLuint id, GLdouble *addr) PFNGLVARIANTDVEXTPROC;
alias void function(GLuint id, GLubyte *addr) PFNGLVARIANTUBVEXTPROC;
alias void function(GLuint id, GLushort *addr) PFNGLVARIANTUSVEXTPROC;
alias void function(GLuint id, GLuint *addr) PFNGLVARIANTUIVEXTPROC;
alias void function(GLuint id, GLenum type, GLuint stride, GLvoid *addr) PFNGLVARIANTPOINTEREXTPROC;
alias void function(GLuint id) PFNGLENABLEVARIANTCLIENTSTATEEXTPROC;
alias void function(GLuint id) PFNGLDISABLEVARIANTCLIENTSTATEEXTPROC;
alias GLuint function(GLenum light, GLenum value) PFNGLBINDLIGHTPARAMETEREXTPROC;
alias GLuint function(GLenum face, GLenum value) PFNGLBINDMATERIALPARAMETEREXTPROC;
alias GLuint function(GLenum unit, GLenum coord, GLenum value) PFNGLBINDTEXGENPARAMETEREXTPROC;
alias GLuint function(GLenum unit, GLenum value) PFNGLBINDTEXTUREUNITPARAMETEREXTPROC;
alias GLuint function(GLenum value) PFNGLBINDPARAMETEREXTPROC;
alias GLboolean function(GLuint id, GLenum cap) PFNGLISVARIANTENABLEDEXTPROC;
alias void function(GLuint id, GLenum value, GLboolean *data) PFNGLGETVARIANTBOOLEANVEXTPROC;
alias void function(GLuint id, GLenum value, GLint *data) PFNGLGETVARIANTINTEGERVEXTPROC;
alias void function(GLuint id, GLenum value, GLfloat *data) PFNGLGETVARIANTFLOATVEXTPROC;
alias void function(GLuint id, GLenum value, GLvoid* *data) PFNGLGETVARIANTPOINTERVEXTPROC;
alias void function(GLuint id, GLenum value, GLboolean *data) PFNGLGETINVARIANTBOOLEANVEXTPROC;
alias void function(GLuint id, GLenum value, GLint *data) PFNGLGETINVARIANTINTEGERVEXTPROC;
alias void function(GLuint id, GLenum value, GLfloat *data) PFNGLGETINVARIANTFLOATVEXTPROC;
alias void function(GLuint id, GLenum value, GLboolean *data) PFNGLGETLOCALCONSTANTBOOLEANVEXTPROC;
alias void function(GLuint id, GLenum value, GLint *data) PFNGLGETLOCALCONSTANTINTEGERVEXTPROC;
alias void function(GLuint id, GLenum value, GLfloat *data) PFNGLGETLOCALCONSTANTFLOATVEXTPROC;

static const auto GL_ATI_vertex_streams = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexStream1sATI (GLenum stream, GLshort x);
	void glVertexStream1svATI (GLenum stream, GLshort *coords);
	void glVertexStream1iATI (GLenum stream, GLint x);
	void glVertexStream1ivATI (GLenum stream, GLint *coords);
	void glVertexStream1fATI (GLenum stream, GLfloat x);
	void glVertexStream1fvATI (GLenum stream, GLfloat *coords);
	void glVertexStream1dATI (GLenum stream, GLdouble x);
	void glVertexStream1dvATI (GLenum stream, GLdouble *coords);
	void glVertexStream2sATI (GLenum stream, GLshort x, GLshort y);
	void glVertexStream2svATI (GLenum stream, GLshort *coords);
	void glVertexStream2iATI (GLenum stream, GLint x, GLint y);
	void glVertexStream2ivATI (GLenum stream, GLint *coords);
	void glVertexStream2fATI (GLenum stream, GLfloat x, GLfloat y);
	void glVertexStream2fvATI (GLenum stream, GLfloat *coords);
	void glVertexStream2dATI (GLenum stream, GLdouble x, GLdouble y);
	void glVertexStream2dvATI (GLenum stream, GLdouble *coords);
	void glVertexStream3sATI (GLenum stream, GLshort x, GLshort y, GLshort z);
	void glVertexStream3svATI (GLenum stream, GLshort *coords);
	void glVertexStream3iATI (GLenum stream, GLint x, GLint y, GLint z);
	void glVertexStream3ivATI (GLenum stream, GLint *coords);
	void glVertexStream3fATI (GLenum stream, GLfloat x, GLfloat y, GLfloat z);
	void glVertexStream3fvATI (GLenum stream, GLfloat *coords);
	void glVertexStream3dATI (GLenum stream, GLdouble x, GLdouble y, GLdouble z);
	void glVertexStream3dvATI (GLenum stream, GLdouble *coords);
	void glVertexStream4sATI (GLenum stream, GLshort x, GLshort y, GLshort z, GLshort w);
	void glVertexStream4svATI (GLenum stream, GLshort *coords);
	void glVertexStream4iATI (GLenum stream, GLint x, GLint y, GLint z, GLint w);
	void glVertexStream4ivATI (GLenum stream, GLint *coords);
	void glVertexStream4fATI (GLenum stream, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glVertexStream4fvATI (GLenum stream, GLfloat *coords);
	void glVertexStream4dATI (GLenum stream, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glVertexStream4dvATI (GLenum stream, GLdouble *coords);
	void glNormalStream3bATI (GLenum stream, GLbyte nx, GLbyte ny, GLbyte nz);
	void glNormalStream3bvATI (GLenum stream, GLbyte *coords);
	void glNormalStream3sATI (GLenum stream, GLshort nx, GLshort ny, GLshort nz);
	void glNormalStream3svATI (GLenum stream, GLshort *coords);
	void glNormalStream3iATI (GLenum stream, GLint nx, GLint ny, GLint nz);
	void glNormalStream3ivATI (GLenum stream, GLint *coords);
	void glNormalStream3fATI (GLenum stream, GLfloat nx, GLfloat ny, GLfloat nz);
	void glNormalStream3fvATI (GLenum stream, GLfloat *coords);
	void glNormalStream3dATI (GLenum stream, GLdouble nx, GLdouble ny, GLdouble nz);
	void glNormalStream3dvATI (GLenum stream, GLdouble *coords);
	void glClientActiveVertexStreamATI (GLenum stream);
	void glVertexBlendEnviATI (GLenum pname, GLint param);
	void glVertexBlendEnvfATI (GLenum pname, GLfloat param);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum stream, GLshort x) PFNGLVERTEXSTREAM1SATIPROC;
alias void function(GLenum stream, GLshort *coords) PFNGLVERTEXSTREAM1SVATIPROC;
alias void function(GLenum stream, GLint x) PFNGLVERTEXSTREAM1IATIPROC;
alias void function(GLenum stream, GLint *coords) PFNGLVERTEXSTREAM1IVATIPROC;
alias void function(GLenum stream, GLfloat x) PFNGLVERTEXSTREAM1FATIPROC;
alias void function(GLenum stream, GLfloat *coords) PFNGLVERTEXSTREAM1FVATIPROC;
alias void function(GLenum stream, GLdouble x) PFNGLVERTEXSTREAM1DATIPROC;
alias void function(GLenum stream, GLdouble *coords) PFNGLVERTEXSTREAM1DVATIPROC;
alias void function(GLenum stream, GLshort x, GLshort y) PFNGLVERTEXSTREAM2SATIPROC;
alias void function(GLenum stream, GLshort *coords) PFNGLVERTEXSTREAM2SVATIPROC;
alias void function(GLenum stream, GLint x, GLint y) PFNGLVERTEXSTREAM2IATIPROC;
alias void function(GLenum stream, GLint *coords) PFNGLVERTEXSTREAM2IVATIPROC;
alias void function(GLenum stream, GLfloat x, GLfloat y) PFNGLVERTEXSTREAM2FATIPROC;
alias void function(GLenum stream, GLfloat *coords) PFNGLVERTEXSTREAM2FVATIPROC;
alias void function(GLenum stream, GLdouble x, GLdouble y) PFNGLVERTEXSTREAM2DATIPROC;
alias void function(GLenum stream, GLdouble *coords) PFNGLVERTEXSTREAM2DVATIPROC;
alias void function(GLenum stream, GLshort x, GLshort y, GLshort z) PFNGLVERTEXSTREAM3SATIPROC;
alias void function(GLenum stream, GLshort *coords) PFNGLVERTEXSTREAM3SVATIPROC;
alias void function(GLenum stream, GLint x, GLint y, GLint z) PFNGLVERTEXSTREAM3IATIPROC;
alias void function(GLenum stream, GLint *coords) PFNGLVERTEXSTREAM3IVATIPROC;
alias void function(GLenum stream, GLfloat x, GLfloat y, GLfloat z) PFNGLVERTEXSTREAM3FATIPROC;
alias void function(GLenum stream, GLfloat *coords) PFNGLVERTEXSTREAM3FVATIPROC;
alias void function(GLenum stream, GLdouble x, GLdouble y, GLdouble z) PFNGLVERTEXSTREAM3DATIPROC;
alias void function(GLenum stream, GLdouble *coords) PFNGLVERTEXSTREAM3DVATIPROC;
alias void function(GLenum stream, GLshort x, GLshort y, GLshort z, GLshort w) PFNGLVERTEXSTREAM4SATIPROC;
alias void function(GLenum stream, GLshort *coords) PFNGLVERTEXSTREAM4SVATIPROC;
alias void function(GLenum stream, GLint x, GLint y, GLint z, GLint w) PFNGLVERTEXSTREAM4IATIPROC;
alias void function(GLenum stream, GLint *coords) PFNGLVERTEXSTREAM4IVATIPROC;
alias void function(GLenum stream, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLVERTEXSTREAM4FATIPROC;
alias void function(GLenum stream, GLfloat *coords) PFNGLVERTEXSTREAM4FVATIPROC;
alias void function(GLenum stream, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLVERTEXSTREAM4DATIPROC;
alias void function(GLenum stream, GLdouble *coords) PFNGLVERTEXSTREAM4DVATIPROC;
alias void function(GLenum stream, GLbyte nx, GLbyte ny, GLbyte nz) PFNGLNORMALSTREAM3BATIPROC;
alias void function(GLenum stream, GLbyte *coords) PFNGLNORMALSTREAM3BVATIPROC;
alias void function(GLenum stream, GLshort nx, GLshort ny, GLshort nz) PFNGLNORMALSTREAM3SATIPROC;
alias void function(GLenum stream, GLshort *coords) PFNGLNORMALSTREAM3SVATIPROC;
alias void function(GLenum stream, GLint nx, GLint ny, GLint nz) PFNGLNORMALSTREAM3IATIPROC;
alias void function(GLenum stream, GLint *coords) PFNGLNORMALSTREAM3IVATIPROC;
alias void function(GLenum stream, GLfloat nx, GLfloat ny, GLfloat nz) PFNGLNORMALSTREAM3FATIPROC;
alias void function(GLenum stream, GLfloat *coords) PFNGLNORMALSTREAM3FVATIPROC;
alias void function(GLenum stream, GLdouble nx, GLdouble ny, GLdouble nz) PFNGLNORMALSTREAM3DATIPROC;
alias void function(GLenum stream, GLdouble *coords) PFNGLNORMALSTREAM3DVATIPROC;
alias void function(GLenum stream) PFNGLCLIENTACTIVEVERTEXSTREAMATIPROC;
alias void function(GLenum pname, GLint param) PFNGLVERTEXBLENDENVIATIPROC;
alias void function(GLenum pname, GLfloat param) PFNGLVERTEXBLENDENVFATIPROC;

static const auto GL_ATI_element_array = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glElementPointerATI (GLenum type, GLvoid *pointer);
	void glDrawElementArrayATI (GLenum mode, GLsizei count);
	void glDrawRangeElementArrayATI (GLenum mode, GLuint start, GLuint end, GLsizei count);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum type, GLvoid *pointer) PFNGLELEMENTPOINTERATIPROC;
alias void function(GLenum mode, GLsizei count) PFNGLDRAWELEMENTARRAYATIPROC;
alias void function(GLenum mode, GLuint start, GLuint end, GLsizei count) PFNGLDRAWRANGEELEMENTARRAYATIPROC;

static const auto GL_SUN_mesh_array = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawMeshArraysSUN (GLenum mode, GLint first, GLsizei count, GLsizei width);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLint first, GLsizei count, GLsizei width) PFNGLDRAWMESHARRAYSSUNPROC;

static const auto GL_SUN_slice_accum = 1;

static const auto GL_NV_multisample_filter_hint = 1;

static const auto GL_NV_depth_clamp = 1;

static const auto GL_NV_occlusion_query = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGenOcclusionQueriesNV (GLsizei n, GLuint *ids);
	void glDeleteOcclusionQueriesNV (GLsizei n, GLuint *ids);
	GLboolean glIsOcclusionQueryNV (GLuint id);
	void glBeginOcclusionQueryNV (GLuint id);
	void glEndOcclusionQueryNV ();
	void glGetOcclusionQueryivNV (GLuint id, GLenum pname, GLint *params);
	void glGetOcclusionQueryuivNV (GLuint id, GLenum pname, GLuint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLuint *ids) PFNGLGENOCCLUSIONQUERIESNVPROC;
alias void function(GLsizei n, GLuint *ids) PFNGLDELETEOCCLUSIONQUERIESNVPROC;
alias GLboolean function(GLuint id) PFNGLISOCCLUSIONQUERYNVPROC;
alias void function(GLuint id) PFNGLBEGINOCCLUSIONQUERYNVPROC;
alias void function() PFNGLENDOCCLUSIONQUERYNVPROC;
alias void function(GLuint id, GLenum pname, GLint *params) PFNGLGETOCCLUSIONQUERYIVNVPROC;
alias void function(GLuint id, GLenum pname, GLuint *params) PFNGLGETOCCLUSIONQUERYUIVNVPROC;

static const auto GL_NV_point_sprite = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPointParameteriNV (GLenum pname, GLint param);
	void glPointParameterivNV (GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLint param) PFNGLPOINTPARAMETERINVPROC;
alias void function(GLenum pname, GLint *params) PFNGLPOINTPARAMETERIVNVPROC;

static const auto GL_NV_texture_shader3 = 1;

static const auto GL_NV_vertex_program1_1 = 1;

static const auto GL_EXT_shadow_funcs = 1;

static const auto GL_EXT_stencil_two_side = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glActiveStencilFaceEXT (GLenum face);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum face) PFNGLACTIVESTENCILFACEEXTPROC;

static const auto GL_ATI_text_fragment_shader = 1;

static const auto GL_APPLE_client_storage = 1;

static const auto GL_APPLE_element_array = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glElementPointerAPPLE (GLenum type, GLvoid *pointer);
	void glDrawElementArrayAPPLE (GLenum mode, GLint first, GLsizei count);
	void glDrawRangeElementArrayAPPLE (GLenum mode, GLuint start, GLuint end, GLint first, GLsizei count);
	void glMultiDrawElementArrayAPPLE (GLenum mode, GLint *first, GLsizei *count, GLsizei primcount);
	void glMultiDrawRangeElementArrayAPPLE (GLenum mode, GLuint start, GLuint end, GLint *first, GLsizei *count, GLsizei primcount);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum type, GLvoid *pointer) PFNGLELEMENTPOINTERAPPLEPROC;
alias void function(GLenum mode, GLint first, GLsizei count) PFNGLDRAWELEMENTARRAYAPPLEPROC;
alias void function(GLenum mode, GLuint start, GLuint end, GLint first, GLsizei count) PFNGLDRAWRANGEELEMENTARRAYAPPLEPROC;
alias void function(GLenum mode, GLint *first, GLsizei *count, GLsizei primcount) PFNGLMULTIDRAWELEMENTARRAYAPPLEPROC;
alias void function(GLenum mode, GLuint start, GLuint end, GLint *first, GLsizei *count, GLsizei primcount) PFNGLMULTIDRAWRANGEELEMENTARRAYAPPLEPROC;

static const auto GL_APPLE_fence = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGenFencesAPPLE (GLsizei n, GLuint *fences);
	void glDeleteFencesAPPLE (GLsizei n, GLuint *fences);
	void glSetFenceAPPLE (GLuint fence);
	GLboolean glIsFenceAPPLE (GLuint fence);
	GLboolean glTestFenceAPPLE (GLuint fence);
	void glFinishFenceAPPLE (GLuint fence);
	GLboolean glTestObjectAPPLE (GLenum object, GLuint name);
	void glFinishObjectAPPLE (GLenum object, GLint name);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLuint *fences) PFNGLGENFENCESAPPLEPROC;
alias void function(GLsizei n, GLuint *fences) PFNGLDELETEFENCESAPPLEPROC;
alias void function(GLuint fence) PFNGLSETFENCEAPPLEPROC;
alias GLboolean function(GLuint fence) PFNGLISFENCEAPPLEPROC;
alias GLboolean function(GLuint fence) PFNGLTESTFENCEAPPLEPROC;
alias void function(GLuint fence) PFNGLFINISHFENCEAPPLEPROC;
alias GLboolean function(GLenum object, GLuint name) PFNGLTESTOBJECTAPPLEPROC;
alias void function(GLenum object, GLint name) PFNGLFINISHOBJECTAPPLEPROC;

static const auto GL_APPLE_vertex_array_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBindVertexArrayAPPLE (GLuint array);
	void glDeleteVertexArraysAPPLE (GLsizei n, GLuint *arrays);
	void glGenVertexArraysAPPLE (GLsizei n, GLuint *arrays);
	GLboolean glIsVertexArrayAPPLE (GLuint array);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint array) PFNGLBINDVERTEXARRAYAPPLEPROC;
alias void function(GLsizei n, GLuint *arrays) PFNGLDELETEVERTEXARRAYSAPPLEPROC;
alias void function(GLsizei n, GLuint *arrays) PFNGLGENVERTEXARRAYSAPPLEPROC;
alias GLboolean function(GLuint array) PFNGLISVERTEXARRAYAPPLEPROC;

static const auto GL_APPLE_vertex_array_range = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexArrayRangeAPPLE (GLsizei length, GLvoid *pointer);
	void glFlushVertexArrayRangeAPPLE (GLsizei length, GLvoid *pointer);
	void glVertexArrayParameteriAPPLE (GLenum pname, GLint param);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei length, GLvoid *pointer) PFNGLVERTEXARRAYRANGEAPPLEPROC;
alias void function(GLsizei length, GLvoid *pointer) PFNGLFLUSHVERTEXARRAYRANGEAPPLEPROC;
alias void function(GLenum pname, GLint param) PFNGLVERTEXARRAYPARAMETERIAPPLEPROC;

static const auto GL_APPLE_ycbcr_422 = 1;

static const auto GL_S3_s3tc = 1;

static const auto GL_ATI_draw_buffers = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawBuffersATI (GLsizei n, GLenum *bufs);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei n, GLenum *bufs) PFNGLDRAWBUFFERSATIPROC;

static const auto GL_ATI_pixel_format_float = 1;
/* This is really a WGL extension, but defines some associated GL enums.
 * ATI does not export "GL_ATI_pixel_format_float" in the GL_EXTENSIONS string.
 */

static const auto GL_ATI_texture_env_combine3 = 1;

static const auto GL_ATI_texture_float = 1;

static const auto GL_NV_float_buffer = 1;

static const auto GL_NV_fragment_program = 1;
/* Some NV_fragment_program entry points are shared with ARB_vertex_program. */
version(GL_GLEXT_PROTOTYPES) {
	void glProgramNamedParameter4fNV (GLuint id, GLsizei len, GLubyte *name, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glProgramNamedParameter4dNV (GLuint id, GLsizei len, GLubyte *name, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glProgramNamedParameter4fvNV (GLuint id, GLsizei len, GLubyte *name, GLfloat *v);
	void glProgramNamedParameter4dvNV (GLuint id, GLsizei len, GLubyte *name, GLdouble *v);
	void glGetProgramNamedParameterfvNV (GLuint id, GLsizei len, GLubyte *name, GLfloat *params);
	void glGetProgramNamedParameterdvNV (GLuint id, GLsizei len, GLubyte *name, GLdouble *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint id, GLsizei len, GLubyte *name, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLPROGRAMNAMEDPARAMETER4FNVPROC;
alias void function(GLuint id, GLsizei len, GLubyte *name, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLPROGRAMNAMEDPARAMETER4DNVPROC;
alias void function(GLuint id, GLsizei len, GLubyte *name, GLfloat *v) PFNGLPROGRAMNAMEDPARAMETER4FVNVPROC;
alias void function(GLuint id, GLsizei len, GLubyte *name, GLdouble *v) PFNGLPROGRAMNAMEDPARAMETER4DVNVPROC;
alias void function(GLuint id, GLsizei len, GLubyte *name, GLfloat *params) PFNGLGETPROGRAMNAMEDPARAMETERFVNVPROC;
alias void function(GLuint id, GLsizei len, GLubyte *name, GLdouble *params) PFNGLGETPROGRAMNAMEDPARAMETERDVNVPROC;

static const auto GL_NV_half_float = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertex2hNV (GLhalfNV x, GLhalfNV y);
	void glVertex2hvNV (GLhalfNV *v);
	void glVertex3hNV (GLhalfNV x, GLhalfNV y, GLhalfNV z);
	void glVertex3hvNV (GLhalfNV *v);
	void glVertex4hNV (GLhalfNV x, GLhalfNV y, GLhalfNV z, GLhalfNV w);
	void glVertex4hvNV (GLhalfNV *v);
	void glNormal3hNV (GLhalfNV nx, GLhalfNV ny, GLhalfNV nz);
	void glNormal3hvNV (GLhalfNV *v);
	void glColor3hNV (GLhalfNV red, GLhalfNV green, GLhalfNV blue);
	void glColor3hvNV (GLhalfNV *v);
	void glColor4hNV (GLhalfNV red, GLhalfNV green, GLhalfNV blue, GLhalfNV alpha);
	void glColor4hvNV (GLhalfNV *v);
	void glTexCoord1hNV (GLhalfNV s);
	void glTexCoord1hvNV (GLhalfNV *v);
	void glTexCoord2hNV (GLhalfNV s, GLhalfNV t);
	void glTexCoord2hvNV (GLhalfNV *v);
	void glTexCoord3hNV (GLhalfNV s, GLhalfNV t, GLhalfNV r);
	void glTexCoord3hvNV (GLhalfNV *v);
	void glTexCoord4hNV (GLhalfNV s, GLhalfNV t, GLhalfNV r, GLhalfNV q);
	void glTexCoord4hvNV (GLhalfNV *v);
	void glMultiTexCoord1hNV (GLenum target, GLhalfNV s);
	void glMultiTexCoord1hvNV (GLenum target, GLhalfNV *v);
	void glMultiTexCoord2hNV (GLenum target, GLhalfNV s, GLhalfNV t);
	void glMultiTexCoord2hvNV (GLenum target, GLhalfNV *v);
	void glMultiTexCoord3hNV (GLenum target, GLhalfNV s, GLhalfNV t, GLhalfNV r);
	void glMultiTexCoord3hvNV (GLenum target, GLhalfNV *v);
	void glMultiTexCoord4hNV (GLenum target, GLhalfNV s, GLhalfNV t, GLhalfNV r, GLhalfNV q);
	void glMultiTexCoord4hvNV (GLenum target, GLhalfNV *v);
	void glFogCoordhNV (GLhalfNV fog);
	void glFogCoordhvNV (GLhalfNV *fog);
	void glSecondaryColor3hNV (GLhalfNV red, GLhalfNV green, GLhalfNV blue);
	void glSecondaryColor3hvNV (GLhalfNV *v);
	void glVertexWeighthNV (GLhalfNV weight);
	void glVertexWeighthvNV (GLhalfNV *weight);
	void glVertexAttrib1hNV (GLuint index, GLhalfNV x);
	void glVertexAttrib1hvNV (GLuint index, GLhalfNV *v);
	void glVertexAttrib2hNV (GLuint index, GLhalfNV x, GLhalfNV y);
	void glVertexAttrib2hvNV (GLuint index, GLhalfNV *v);
	void glVertexAttrib3hNV (GLuint index, GLhalfNV x, GLhalfNV y, GLhalfNV z);
	void glVertexAttrib3hvNV (GLuint index, GLhalfNV *v);
	void glVertexAttrib4hNV (GLuint index, GLhalfNV x, GLhalfNV y, GLhalfNV z, GLhalfNV w);
	void glVertexAttrib4hvNV (GLuint index, GLhalfNV *v);
	void glVertexAttribs1hvNV (GLuint index, GLsizei n, GLhalfNV *v);
	void glVertexAttribs2hvNV (GLuint index, GLsizei n, GLhalfNV *v);
	void glVertexAttribs3hvNV (GLuint index, GLsizei n, GLhalfNV *v);
	void glVertexAttribs4hvNV (GLuint index, GLsizei n, GLhalfNV *v);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLhalfNV x, GLhalfNV y) PFNGLVERTEX2HNVPROC;
alias void function(GLhalfNV *v) PFNGLVERTEX2HVNVPROC;
alias void function(GLhalfNV x, GLhalfNV y, GLhalfNV z) PFNGLVERTEX3HNVPROC;
alias void function(GLhalfNV *v) PFNGLVERTEX3HVNVPROC;
alias void function(GLhalfNV x, GLhalfNV y, GLhalfNV z, GLhalfNV w) PFNGLVERTEX4HNVPROC;
alias void function(GLhalfNV *v) PFNGLVERTEX4HVNVPROC;
alias void function(GLhalfNV nx, GLhalfNV ny, GLhalfNV nz) PFNGLNORMAL3HNVPROC;
alias void function(GLhalfNV *v) PFNGLNORMAL3HVNVPROC;
alias void function(GLhalfNV red, GLhalfNV green, GLhalfNV blue) PFNGLCOLOR3HNVPROC;
alias void function(GLhalfNV *v) PFNGLCOLOR3HVNVPROC;
alias void function(GLhalfNV red, GLhalfNV green, GLhalfNV blue, GLhalfNV alpha) PFNGLCOLOR4HNVPROC;
alias void function(GLhalfNV *v) PFNGLCOLOR4HVNVPROC;
alias void function(GLhalfNV s) PFNGLTEXCOORD1HNVPROC;
alias void function(GLhalfNV *v) PFNGLTEXCOORD1HVNVPROC;
alias void function(GLhalfNV s, GLhalfNV t) PFNGLTEXCOORD2HNVPROC;
alias void function(GLhalfNV *v) PFNGLTEXCOORD2HVNVPROC;
alias void function(GLhalfNV s, GLhalfNV t, GLhalfNV r) PFNGLTEXCOORD3HNVPROC;
alias void function(GLhalfNV *v) PFNGLTEXCOORD3HVNVPROC;
alias void function(GLhalfNV s, GLhalfNV t, GLhalfNV r, GLhalfNV q) PFNGLTEXCOORD4HNVPROC;
alias void function(GLhalfNV *v) PFNGLTEXCOORD4HVNVPROC;
alias void function(GLenum target, GLhalfNV s) PFNGLMULTITEXCOORD1HNVPROC;
alias void function(GLenum target, GLhalfNV *v) PFNGLMULTITEXCOORD1HVNVPROC;
alias void function(GLenum target, GLhalfNV s, GLhalfNV t) PFNGLMULTITEXCOORD2HNVPROC;
alias void function(GLenum target, GLhalfNV *v) PFNGLMULTITEXCOORD2HVNVPROC;
alias void function(GLenum target, GLhalfNV s, GLhalfNV t, GLhalfNV r) PFNGLMULTITEXCOORD3HNVPROC;
alias void function(GLenum target, GLhalfNV *v) PFNGLMULTITEXCOORD3HVNVPROC;
alias void function(GLenum target, GLhalfNV s, GLhalfNV t, GLhalfNV r, GLhalfNV q) PFNGLMULTITEXCOORD4HNVPROC;
alias void function(GLenum target, GLhalfNV *v) PFNGLMULTITEXCOORD4HVNVPROC;
alias void function(GLhalfNV fog) PFNGLFOGCOORDHNVPROC;
alias void function(GLhalfNV *fog) PFNGLFOGCOORDHVNVPROC;
alias void function(GLhalfNV red, GLhalfNV green, GLhalfNV blue) PFNGLSECONDARYCOLOR3HNVPROC;
alias void function(GLhalfNV *v) PFNGLSECONDARYCOLOR3HVNVPROC;
alias void function(GLhalfNV weight) PFNGLVERTEXWEIGHTHNVPROC;
alias void function(GLhalfNV *weight) PFNGLVERTEXWEIGHTHVNVPROC;
alias void function(GLuint index, GLhalfNV x) PFNGLVERTEXATTRIB1HNVPROC;
alias void function(GLuint index, GLhalfNV *v) PFNGLVERTEXATTRIB1HVNVPROC;
alias void function(GLuint index, GLhalfNV x, GLhalfNV y) PFNGLVERTEXATTRIB2HNVPROC;
alias void function(GLuint index, GLhalfNV *v) PFNGLVERTEXATTRIB2HVNVPROC;
alias void function(GLuint index, GLhalfNV x, GLhalfNV y, GLhalfNV z) PFNGLVERTEXATTRIB3HNVPROC;
alias void function(GLuint index, GLhalfNV *v) PFNGLVERTEXATTRIB3HVNVPROC;
alias void function(GLuint index, GLhalfNV x, GLhalfNV y, GLhalfNV z, GLhalfNV w) PFNGLVERTEXATTRIB4HNVPROC;
alias void function(GLuint index, GLhalfNV *v) PFNGLVERTEXATTRIB4HVNVPROC;
alias void function(GLuint index, GLsizei n, GLhalfNV *v) PFNGLVERTEXATTRIBS1HVNVPROC;
alias void function(GLuint index, GLsizei n, GLhalfNV *v) PFNGLVERTEXATTRIBS2HVNVPROC;
alias void function(GLuint index, GLsizei n, GLhalfNV *v) PFNGLVERTEXATTRIBS3HVNVPROC;
alias void function(GLuint index, GLsizei n, GLhalfNV *v) PFNGLVERTEXATTRIBS4HVNVPROC;

static const auto GL_NV_pixel_data_range = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPixelDataRangeNV (GLenum target, GLsizei length, GLvoid *pointer);
	void glFlushPixelDataRangeNV (GLenum target);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei length, GLvoid *pointer) PFNGLPIXELDATARANGENVPROC;
alias void function(GLenum target) PFNGLFLUSHPIXELDATARANGENVPROC;

static const auto GL_NV_primitive_restart = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPrimitiveRestartNV ();
	void glPrimitiveRestartIndexNV (GLuint index);
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLPRIMITIVERESTARTNVPROC;
alias void function(GLuint index) PFNGLPRIMITIVERESTARTINDEXNVPROC;

static const auto GL_NV_texture_expand_normal = 1;

static const auto GL_NV_vertex_program2 = 1;

static const auto GL_ATI_map_object_buffer = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLvoid* glMapObjectBufferATI (GLuint buffer);
	void glUnmapObjectBufferATI (GLuint buffer);
} /* GL_GLEXT_PROTOTYPES */
alias GLvoid* (PFNGLMAPOBJECTBUFFERATIPROC) (GLuint buffer);
alias void function(GLuint buffer) PFNGLUNMAPOBJECTBUFFERATIPROC;

static const auto GL_ATI_separate_stencil = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glStencilOpSeparateATI (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
	void glStencilFuncSeparateATI (GLenum frontfunc, GLenum backfunc, GLint _ref, GLuint mask);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass) PFNGLSTENCILOPSEPARATEATIPROC;
alias void function(GLenum frontfunc, GLenum backfunc, GLint _ref, GLuint mask) PFNGLSTENCILFUNCSEPARATEATIPROC;

static const auto GL_ATI_vertex_attrib_array_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexAttribArrayObjectATI (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLuint buffer, GLuint offset);
	void glGetVertexAttribArrayObjectfvATI (GLuint index, GLenum pname, GLfloat *params);
	void glGetVertexAttribArrayObjectivATI (GLuint index, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLuint buffer, GLuint offset) PFNGLVERTEXATTRIBARRAYOBJECTATIPROC;
alias void function(GLuint index, GLenum pname, GLfloat *params) PFNGLGETVERTEXATTRIBARRAYOBJECTFVATIPROC;
alias void function(GLuint index, GLenum pname, GLint *params) PFNGLGETVERTEXATTRIBARRAYOBJECTIVATIPROC;

static const auto GL_OES_read_format = 1;

static const auto GL_EXT_depth_bounds_test = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDepthBoundsEXT (GLclampd zmin, GLclampd zmax);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLclampd zmin, GLclampd zmax) PFNGLDEPTHBOUNDSEXTPROC;

static const auto GL_EXT_texture_mirror_clamp = 1;

static const auto GL_EXT_blend_equation_separate = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendEquationSeparateEXT (GLenum modeRGB, GLenum modeAlpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum modeRGB, GLenum modeAlpha) PFNGLBLENDEQUATIONSEPARATEEXTPROC;

static const auto GL_MESA_pack_invert = 1;

static const auto GL_MESA_ycbcr_texture = 1;

static const auto GL_EXT_pixel_buffer_object = 1;

static const auto GL_NV_fragment_program_option = 1;

static const auto GL_NV_fragment_program2 = 1;

static const auto GL_NV_vertex_program2_option = 1;

static const auto GL_NV_vertex_program3 = 1;

static const auto GL_EXT_framebuffer_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLboolean glIsRenderbufferEXT (GLuint renderbuffer);
	void glBindRenderbufferEXT (GLenum target, GLuint renderbuffer);
	void glDeleteRenderbuffersEXT (GLsizei n, GLuint *renderbuffers);
	void glGenRenderbuffersEXT (GLsizei n, GLuint *renderbuffers);
	void glRenderbufferStorageEXT (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
	void glGetRenderbufferParameterivEXT (GLenum target, GLenum pname, GLint *params);
	GLboolean glIsFramebufferEXT (GLuint framebuffer);
	void glBindFramebufferEXT (GLenum target, GLuint framebuffer);
	void glDeleteFramebuffersEXT (GLsizei n, GLuint *framebuffers);
	void glGenFramebuffersEXT (GLsizei n, GLuint *framebuffers);
	GLenum glCheckFramebufferStatusEXT (GLenum target);
	void glFramebufferTexture1DEXT (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
	void glFramebufferTexture2DEXT (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
	void glFramebufferTexture3DEXT (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset);
	void glFramebufferRenderbufferEXT (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
	void glGetFramebufferAttachmentParameterivEXT (GLenum target, GLenum attachment, GLenum pname, GLint *params);
	void glGenerateMipmapEXT (GLenum target);
} /* GL_GLEXT_PROTOTYPES */
alias GLboolean function(GLuint renderbuffer) PFNGLISRENDERBUFFEREXTPROC;
alias void function(GLenum target, GLuint renderbuffer) PFNGLBINDRENDERBUFFEREXTPROC;
alias void function(GLsizei n, GLuint *renderbuffers) PFNGLDELETERENDERBUFFERSEXTPROC;
alias void function(GLsizei n, GLuint *renderbuffers) PFNGLGENRENDERBUFFERSEXTPROC;
alias void function(GLenum target, GLenum internalformat, GLsizei width, GLsizei height) PFNGLRENDERBUFFERSTORAGEEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETRENDERBUFFERPARAMETERIVEXTPROC;
alias GLboolean function(GLuint framebuffer) PFNGLISFRAMEBUFFEREXTPROC;
alias void function(GLenum target, GLuint framebuffer) PFNGLBINDFRAMEBUFFEREXTPROC;
alias void function(GLsizei n, GLuint *framebuffers) PFNGLDELETEFRAMEBUFFERSEXTPROC;
alias void function(GLsizei n, GLuint *framebuffers) PFNGLGENFRAMEBUFFERSEXTPROC;
alias GLenum function(GLenum target) PFNGLCHECKFRAMEBUFFERSTATUSEXTPROC;
alias void function(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level) PFNGLFRAMEBUFFERTEXTURE1DEXTPROC;
alias void function(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level) PFNGLFRAMEBUFFERTEXTURE2DEXTPROC;
alias void function(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset) PFNGLFRAMEBUFFERTEXTURE3DEXTPROC;
alias void function(GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer) PFNGLFRAMEBUFFERRENDERBUFFEREXTPROC;
alias void function(GLenum target, GLenum attachment, GLenum pname, GLint *params) PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVEXTPROC;
alias void function(GLenum target) PFNGLGENERATEMIPMAPEXTPROC;

static const auto GL_GREMEDY_string_marker = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glStringMarkerGREMEDY (GLsizei len, GLvoid *string);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei len, GLvoid *string) PFNGLSTRINGMARKERGREMEDYPROC;

static const auto GL_EXT_packed_depth_stencil = 1;

static const auto GL_EXT_stencil_clear_tag = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glStencilClearTagEXT (GLsizei stencilTagBits, GLuint stencilClearTag);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLsizei stencilTagBits, GLuint stencilClearTag) PFNGLSTENCILCLEARTAGEXTPROC;

static const auto GL_EXT_texture_sRGB = 1;

static const auto GL_EXT_framebuffer_blit = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlitFramebufferEXT (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter) PFNGLBLITFRAMEBUFFEREXTPROC;

static const auto GL_EXT_framebuffer_multisample = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glRenderbufferStorageMultisampleEXT (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height) PFNGLRENDERBUFFERSTORAGEMULTISAMPLEEXTPROC;

static const auto GL_MESAX_texture_stack = 1;

static const auto GL_EXT_timer_query = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetQueryObjecti64vEXT (GLuint id, GLenum pname, GLint64EXT *params);
	void glGetQueryObjectui64vEXT (GLuint id, GLenum pname, GLuint64EXT *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint id, GLenum pname, GLint64EXT *params) PFNGLGETQUERYOBJECTI64VEXTPROC;
alias void function(GLuint id, GLenum pname, GLuint64EXT *params) PFNGLGETQUERYOBJECTUI64VEXTPROC;

static const auto GL_EXT_gpu_program_parameters = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProgramEnvParameters4fvEXT (GLenum target, GLuint index, GLsizei count, GLfloat *params);
	void glProgramLocalParameters4fvEXT (GLenum target, GLuint index, GLsizei count, GLfloat *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint index, GLsizei count, GLfloat *params) PFNGLPROGRAMENVPARAMETERS4FVEXTPROC;
alias void function(GLenum target, GLuint index, GLsizei count, GLfloat *params) PFNGLPROGRAMLOCALPARAMETERS4FVEXTPROC;

static const auto GL_APPLE_flush_buffer_range = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBufferParameteriAPPLE (GLenum target, GLenum pname, GLint param);
	void glFlushMappedBufferRangeAPPLE (GLenum target, GLintptr offset, GLsizeiptr size);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum pname, GLint param) PFNGLBUFFERPARAMETERIAPPLEPROC;
alias void function(GLenum target, GLintptr offset, GLsizeiptr size) PFNGLFLUSHMAPPEDBUFFERRANGEAPPLEPROC;

static const auto GL_NV_gpu_program4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProgramLocalParameterI4iNV (GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w);
	void glProgramLocalParameterI4ivNV (GLenum target, GLuint index, GLint *params);
	void glProgramLocalParametersI4ivNV (GLenum target, GLuint index, GLsizei count, GLint *params);
	void glProgramLocalParameterI4uiNV (GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
	void glProgramLocalParameterI4uivNV (GLenum target, GLuint index, GLuint *params);
	void glProgramLocalParametersI4uivNV (GLenum target, GLuint index, GLsizei count, GLuint *params);
	void glProgramEnvParameterI4iNV (GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w);
	void glProgramEnvParameterI4ivNV (GLenum target, GLuint index, GLint *params);
	void glProgramEnvParametersI4ivNV (GLenum target, GLuint index, GLsizei count, GLint *params);
	void glProgramEnvParameterI4uiNV (GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
	void glProgramEnvParameterI4uivNV (GLenum target, GLuint index, GLuint *params);
	void glProgramEnvParametersI4uivNV (GLenum target, GLuint index, GLsizei count, GLuint *params);
	void glGetProgramLocalParameterIivNV (GLenum target, GLuint index, GLint *params);
	void glGetProgramLocalParameterIuivNV (GLenum target, GLuint index, GLuint *params);
	void glGetProgramEnvParameterIivNV (GLenum target, GLuint index, GLint *params);
	void glGetProgramEnvParameterIuivNV (GLenum target, GLuint index, GLuint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w) PFNGLPROGRAMLOCALPARAMETERI4INVPROC;
alias void function(GLenum target, GLuint index, GLint *params) PFNGLPROGRAMLOCALPARAMETERI4IVNVPROC;
alias void function(GLenum target, GLuint index, GLsizei count, GLint *params) PFNGLPROGRAMLOCALPARAMETERSI4IVNVPROC;
alias void function(GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w) PFNGLPROGRAMLOCALPARAMETERI4UINVPROC;
alias void function(GLenum target, GLuint index, GLuint *params) PFNGLPROGRAMLOCALPARAMETERI4UIVNVPROC;
alias void function(GLenum target, GLuint index, GLsizei count, GLuint *params) PFNGLPROGRAMLOCALPARAMETERSI4UIVNVPROC;
alias void function(GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w) PFNGLPROGRAMENVPARAMETERI4INVPROC;
alias void function(GLenum target, GLuint index, GLint *params) PFNGLPROGRAMENVPARAMETERI4IVNVPROC;
alias void function(GLenum target, GLuint index, GLsizei count, GLint *params) PFNGLPROGRAMENVPARAMETERSI4IVNVPROC;
alias void function(GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w) PFNGLPROGRAMENVPARAMETERI4UINVPROC;
alias void function(GLenum target, GLuint index, GLuint *params) PFNGLPROGRAMENVPARAMETERI4UIVNVPROC;
alias void function(GLenum target, GLuint index, GLsizei count, GLuint *params) PFNGLPROGRAMENVPARAMETERSI4UIVNVPROC;
alias void function(GLenum target, GLuint index, GLint *params) PFNGLGETPROGRAMLOCALPARAMETERIIVNVPROC;
alias void function(GLenum target, GLuint index, GLuint *params) PFNGLGETPROGRAMLOCALPARAMETERIUIVNVPROC;
alias void function(GLenum target, GLuint index, GLint *params) PFNGLGETPROGRAMENVPARAMETERIIVNVPROC;
alias void function(GLenum target, GLuint index, GLuint *params) PFNGLGETPROGRAMENVPARAMETERIUIVNVPROC;

static const auto GL_NV_geometry_program4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProgramVertexLimitNV (GLenum target, GLint limit);
	void glFramebufferTextureEXT (GLenum target, GLenum attachment, GLuint texture, GLint level);
	void glFramebufferTextureLayerEXT (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer);
	void glFramebufferTextureFaceEXT (GLenum target, GLenum attachment, GLuint texture, GLint level, GLenum face);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLint limit) PFNGLPROGRAMVERTEXLIMITNVPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level) PFNGLFRAMEBUFFERTEXTUREEXTPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer) PFNGLFRAMEBUFFERTEXTURELAYEREXTPROC;
alias void function(GLenum target, GLenum attachment, GLuint texture, GLint level, GLenum face) PFNGLFRAMEBUFFERTEXTUREFACEEXTPROC;

static const auto GL_EXT_geometry_shader4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProgramParameteriEXT (GLuint program, GLenum pname, GLint value);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint program, GLenum pname, GLint value) PFNGLPROGRAMPARAMETERIEXTPROC;

static const auto GL_NV_vertex_program4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glVertexAttribI1iEXT (GLuint index, GLint x);
	void glVertexAttribI2iEXT (GLuint index, GLint x, GLint y);
	void glVertexAttribI3iEXT (GLuint index, GLint x, GLint y, GLint z);
	void glVertexAttribI4iEXT (GLuint index, GLint x, GLint y, GLint z, GLint w);
	void glVertexAttribI1uiEXT (GLuint index, GLuint x);
	void glVertexAttribI2uiEXT (GLuint index, GLuint x, GLuint y);
	void glVertexAttribI3uiEXT (GLuint index, GLuint x, GLuint y, GLuint z);
	void glVertexAttribI4uiEXT (GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
	void glVertexAttribI1ivEXT (GLuint index, GLint *v);
	void glVertexAttribI2ivEXT (GLuint index, GLint *v);
	void glVertexAttribI3ivEXT (GLuint index, GLint *v);
	void glVertexAttribI4ivEXT (GLuint index, GLint *v);
	void glVertexAttribI1uivEXT (GLuint index, GLuint *v);
	void glVertexAttribI2uivEXT (GLuint index, GLuint *v);
	void glVertexAttribI3uivEXT (GLuint index, GLuint *v);
	void glVertexAttribI4uivEXT (GLuint index, GLuint *v);
	void glVertexAttribI4bvEXT (GLuint index, GLbyte *v);
	void glVertexAttribI4svEXT (GLuint index, GLshort *v);
	void glVertexAttribI4ubvEXT (GLuint index, GLubyte *v);
	void glVertexAttribI4usvEXT (GLuint index, GLushort *v);
	void glVertexAttribIPointerEXT (GLuint index, GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
	void glGetVertexAttribIivEXT (GLuint index, GLenum pname, GLint *params);
	void glGetVertexAttribIuivEXT (GLuint index, GLenum pname, GLuint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint index, GLint x) PFNGLVERTEXATTRIBI1IEXTPROC;
alias void function(GLuint index, GLint x, GLint y) PFNGLVERTEXATTRIBI2IEXTPROC;
alias void function(GLuint index, GLint x, GLint y, GLint z) PFNGLVERTEXATTRIBI3IEXTPROC;
alias void function(GLuint index, GLint x, GLint y, GLint z, GLint w) PFNGLVERTEXATTRIBI4IEXTPROC;
alias void function(GLuint index, GLuint x) PFNGLVERTEXATTRIBI1UIEXTPROC;
alias void function(GLuint index, GLuint x, GLuint y) PFNGLVERTEXATTRIBI2UIEXTPROC;
alias void function(GLuint index, GLuint x, GLuint y, GLuint z) PFNGLVERTEXATTRIBI3UIEXTPROC;
alias void function(GLuint index, GLuint x, GLuint y, GLuint z, GLuint w) PFNGLVERTEXATTRIBI4UIEXTPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI1IVEXTPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI2IVEXTPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI3IVEXTPROC;
alias void function(GLuint index, GLint *v) PFNGLVERTEXATTRIBI4IVEXTPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI1UIVEXTPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI2UIVEXTPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI3UIVEXTPROC;
alias void function(GLuint index, GLuint *v) PFNGLVERTEXATTRIBI4UIVEXTPROC;
alias void function(GLuint index, GLbyte *v) PFNGLVERTEXATTRIBI4BVEXTPROC;
alias void function(GLuint index, GLshort *v) PFNGLVERTEXATTRIBI4SVEXTPROC;
alias void function(GLuint index, GLubyte *v) PFNGLVERTEXATTRIBI4UBVEXTPROC;
alias void function(GLuint index, GLushort *v) PFNGLVERTEXATTRIBI4USVEXTPROC;
alias void function(GLuint index, GLint size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLVERTEXATTRIBIPOINTEREXTPROC;
alias void function(GLuint index, GLenum pname, GLint *params) PFNGLGETVERTEXATTRIBIIVEXTPROC;
alias void function(GLuint index, GLenum pname, GLuint *params) PFNGLGETVERTEXATTRIBIUIVEXTPROC;

static const auto GL_EXT_gpu_shader4 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetUniformuivEXT (GLuint program, GLint location, GLuint *params);
	void glBindFragDataLocationEXT (GLuint program, GLuint color, GLchar *name);
	GLint glGetFragDataLocationEXT (GLuint program, GLchar *name);
	void glUniform1uiEXT (GLint location, GLuint v0);
	void glUniform2uiEXT (GLint location, GLuint v0, GLuint v1);
	void glUniform3uiEXT (GLint location, GLuint v0, GLuint v1, GLuint v2);
	void glUniform4uiEXT (GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
	void glUniform1uivEXT (GLint location, GLsizei count, GLuint *value);
	void glUniform2uivEXT (GLint location, GLsizei count, GLuint *value);
	void glUniform3uivEXT (GLint location, GLsizei count, GLuint *value);
	void glUniform4uivEXT (GLint location, GLsizei count, GLuint *value);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint program, GLint location, GLuint *params) PFNGLGETUNIFORMUIVEXTPROC;
alias void function(GLuint program, GLuint color, GLchar *name) PFNGLBINDFRAGDATALOCATIONEXTPROC;
alias GLint function(GLuint program, GLchar *name) PFNGLGETFRAGDATALOCATIONEXTPROC;
alias void function(GLint location, GLuint v0) PFNGLUNIFORM1UIEXTPROC;
alias void function(GLint location, GLuint v0, GLuint v1) PFNGLUNIFORM2UIEXTPROC;
alias void function(GLint location, GLuint v0, GLuint v1, GLuint v2) PFNGLUNIFORM3UIEXTPROC;
alias void function(GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3) PFNGLUNIFORM4UIEXTPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM1UIVEXTPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM2UIVEXTPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM3UIVEXTPROC;
alias void function(GLint location, GLsizei count, GLuint *value) PFNGLUNIFORM4UIVEXTPROC;

static const auto GL_EXT_draw_instanced = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDrawArraysInstancedEXT (GLenum mode, GLint start, GLsizei count, GLsizei primcount);
	void glDrawElementsInstancedEXT (GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode, GLint start, GLsizei count, GLsizei primcount) PFNGLDRAWARRAYSINSTANCEDEXTPROC;
alias void function(GLenum mode, GLsizei count, GLenum type, GLvoid *indices, GLsizei primcount) PFNGLDRAWELEMENTSINSTANCEDEXTPROC;

static const auto GL_EXT_packed_float = 1;

static const auto GL_EXT_texture_array = 1;

static const auto GL_EXT_texture_buffer_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexBufferEXT (GLenum target, GLenum internalformat, GLuint buffer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum internalformat, GLuint buffer) PFNGLTEXBUFFEREXTPROC;

static const auto GL_EXT_texture_compression_latc = 1;

static const auto GL_EXT_texture_compression_rgtc = 1;

static const auto GL_EXT_texture_shared_exponent = 1;

static const auto GL_NV_depth_buffer_float = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glDepthRangedNV (GLdouble zNear, GLdouble zFar);
	void glClearDepthdNV (GLdouble depth);
	void glDepthBoundsdNV (GLdouble zmin, GLdouble zmax);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLdouble zNear, GLdouble zFar) PFNGLDEPTHRANGEDNVPROC;
alias void function(GLdouble depth) PFNGLCLEARDEPTHDNVPROC;
alias void function(GLdouble zmin, GLdouble zmax) PFNGLDEPTHBOUNDSDNVPROC;

static const auto GL_NV_fragment_program4 = 1;

static const auto GL_NV_framebuffer_multisample_coverage = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glRenderbufferStorageMultisampleCoverageNV (GLenum target, GLsizei coverageSamples, GLsizei colorSamples, GLenum internalformat, GLsizei width, GLsizei height);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei coverageSamples, GLsizei colorSamples, GLenum internalformat, GLsizei width, GLsizei height) PFNGLRENDERBUFFERSTORAGEMULTISAMPLECOVERAGENVPROC;

static const auto GL_EXT_framebuffer_sRGB = 1;

static const auto GL_NV_geometry_shader4 = 1;

static const auto GL_NV_parameter_buffer_object = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProgramBufferParametersfvNV (GLenum target, GLuint buffer, GLuint index, GLsizei count, GLfloat *params);
	void glProgramBufferParametersIivNV (GLenum target, GLuint buffer, GLuint index, GLsizei count, GLint *params);
	void glProgramBufferParametersIuivNV (GLenum target, GLuint buffer, GLuint index, GLsizei count, GLuint *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint buffer, GLuint index, GLsizei count, GLfloat *params) PFNGLPROGRAMBUFFERPARAMETERSFVNVPROC;
alias void function(GLenum target, GLuint buffer, GLuint index, GLsizei count, GLint *params) PFNGLPROGRAMBUFFERPARAMETERSIIVNVPROC;
alias void function(GLenum target, GLuint buffer, GLuint index, GLsizei count, GLuint *params) PFNGLPROGRAMBUFFERPARAMETERSIUIVNVPROC;

static const auto GL_EXT_draw_buffers2 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glColorMaskIndexedEXT (GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a);
	void glGetBooleanIndexedvEXT (GLenum target, GLuint index, GLboolean *data);
	void glGetIntegerIndexedvEXT (GLenum target, GLuint index, GLint *data);
	void glEnableIndexedEXT (GLenum target, GLuint index);
	void glDisableIndexedEXT (GLenum target, GLuint index);
	GLboolean glIsEnabledIndexedEXT (GLenum target, GLuint index);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a) PFNGLCOLORMASKINDEXEDEXTPROC;
alias void function(GLenum target, GLuint index, GLboolean *data) PFNGLGETBOOLEANINDEXEDVEXTPROC;
alias void function(GLenum target, GLuint index, GLint *data) PFNGLGETINTEGERINDEXEDVEXTPROC;
alias void function(GLenum target, GLuint index) PFNGLENABLEINDEXEDEXTPROC;
alias void function(GLenum target, GLuint index) PFNGLDISABLEINDEXEDEXTPROC;
alias GLboolean function(GLenum target, GLuint index) PFNGLISENABLEDINDEXEDEXTPROC;

static const auto GL_NV_transform_feedback = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBeginTransformFeedbackNV (GLenum primitiveMode);
	void glEndTransformFeedbackNV ();
	void glTransformFeedbackAttribsNV (GLuint count, GLint *attribs, GLenum bufferMode);
	void glBindBufferRangeNV (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size);
	void glBindBufferOffsetNV (GLenum target, GLuint index, GLuint buffer, GLintptr offset);
	void glBindBufferBaseNV (GLenum target, GLuint index, GLuint buffer);
	void glTransformFeedbackVaryingsNV (GLuint program, GLsizei count, GLchar* *varyings, GLenum bufferMode);
	void glActiveVaryingNV (GLuint program, GLchar *name);
	GLint glGetVaryingLocationNV (GLuint program, GLchar *name);
	void glGetActiveVaryingNV (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name);
	void glGetTransformFeedbackVaryingNV (GLuint program, GLuint index, GLint *location);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum primitiveMode) PFNGLBEGINTRANSFORMFEEDBACKNVPROC;
alias void function() PFNGLENDTRANSFORMFEEDBACKNVPROC;
alias void function(GLuint count, GLint *attribs, GLenum bufferMode) PFNGLTRANSFORMFEEDBACKATTRIBSNVPROC;
alias void function(GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size) PFNGLBINDBUFFERRANGENVPROC;
alias void function(GLenum target, GLuint index, GLuint buffer, GLintptr offset) PFNGLBINDBUFFEROFFSETNVPROC;
alias void function(GLenum target, GLuint index, GLuint buffer) PFNGLBINDBUFFERBASENVPROC;
alias void function(GLuint program, GLsizei count, GLchar* *varyings, GLenum bufferMode) PFNGLTRANSFORMFEEDBACKVARYINGSNVPROC;
alias void function(GLuint program, GLchar *name) PFNGLACTIVEVARYINGNVPROC;
alias GLint function(GLuint program, GLchar *name) PFNGLGETVARYINGLOCATIONNVPROC;
alias void function(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name) PFNGLGETACTIVEVARYINGNVPROC;
alias void function(GLuint program, GLuint index, GLint *location) PFNGLGETTRANSFORMFEEDBACKVARYINGNVPROC;

static const auto GL_EXT_bindable_uniform = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glUniformBufferEXT (GLuint program, GLint location, GLuint buffer);
	GLint glGetUniformBufferSizeEXT (GLuint program, GLint location);
	GLintptr glGetUniformOffsetEXT (GLuint program, GLint location);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint program, GLint location, GLuint buffer) PFNGLUNIFORMBUFFEREXTPROC;
alias GLint function(GLuint program, GLint location) PFNGLGETUNIFORMBUFFERSIZEEXTPROC;
alias GLintptr function(GLuint program, GLint location) PFNGLGETUNIFORMOFFSETEXTPROC;

static const auto GL_EXT_texture_integer = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTexParameterIivEXT (GLenum target, GLenum pname, GLint *params);
	void glTexParameterIuivEXT (GLenum target, GLenum pname, GLuint *params);
	void glGetTexParameterIivEXT (GLenum target, GLenum pname, GLint *params);
	void glGetTexParameterIuivEXT (GLenum target, GLenum pname, GLuint *params);
	void glClearColorIiEXT (GLint red, GLint green, GLint blue, GLint alpha);
	void glClearColorIuiEXT (GLuint red, GLuint green, GLuint blue, GLuint alpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLTEXPARAMETERIIVEXTPROC;
alias void function(GLenum target, GLenum pname, GLuint *params) PFNGLTEXPARAMETERIUIVEXTPROC;
alias void function(GLenum target, GLenum pname, GLint *params) PFNGLGETTEXPARAMETERIIVEXTPROC;
alias void function(GLenum target, GLenum pname, GLuint *params) PFNGLGETTEXPARAMETERIUIVEXTPROC;
alias void function(GLint red, GLint green, GLint blue, GLint alpha) PFNGLCLEARCOLORIIEXTPROC;
alias void function(GLuint red, GLuint green, GLuint blue, GLuint alpha) PFNGLCLEARCOLORIUIEXTPROC;

static const auto GL_GREMEDY_frame_terminator = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glFrameTerminatorGREMEDY ();
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLFRAMETERMINATORGREMEDYPROC;

static const auto GL_NV_conditional_render = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBeginConditionalRenderNV (GLuint id, GLenum mode);
	void glEndConditionalRenderNV ();
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint id, GLenum mode) PFNGLBEGINCONDITIONALRENDERNVPROC;
alias void function() PFNGLENDCONDITIONALRENDERNVPROC;

static const auto GL_NV_present_video = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glPresentFrameKeyedNV (GLuint video_slot, GLuint64EXT minPresentTime, GLuint beginPresentTimeId, GLuint presentDurationId, GLenum type, GLenum target0, GLuint fill0, GLuint key0, GLenum target1, GLuint fill1, GLuint key1);
	void glPresentFrameDualFillNV (GLuint video_slot, GLuint64EXT minPresentTime, GLuint beginPresentTimeId, GLuint presentDurationId, GLenum type, GLenum target0, GLuint fill0, GLenum target1, GLuint fill1, GLenum target2, GLuint fill2, GLenum target3, GLuint fill3);
	void glGetVideoivNV (GLuint video_slot, GLenum pname, GLint *params);
	void glGetVideouivNV (GLuint video_slot, GLenum pname, GLuint *params);
	void glGetVideoi64vNV (GLuint video_slot, GLenum pname, GLint64EXT *params);
	void glGetVideoui64vNV (GLuint video_slot, GLenum pname, GLuint64EXT *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint video_slot, GLuint64EXT minPresentTime, GLuint beginPresentTimeId, GLuint presentDurationId, GLenum type, GLenum target0, GLuint fill0, GLuint key0, GLenum target1, GLuint fill1, GLuint key1) PFNGLPRESENTFRAMEKEYEDNVPROC;
alias void function(GLuint video_slot, GLuint64EXT minPresentTime, GLuint beginPresentTimeId, GLuint presentDurationId, GLenum type, GLenum target0, GLuint fill0, GLenum target1, GLuint fill1, GLenum target2, GLuint fill2, GLenum target3, GLuint fill3) PFNGLPRESENTFRAMEDUALFILLNVPROC;
alias void function(GLuint video_slot, GLenum pname, GLint *params) PFNGLGETVIDEOIVNVPROC;
alias void function(GLuint video_slot, GLenum pname, GLuint *params) PFNGLGETVIDEOUIVNVPROC;
alias void function(GLuint video_slot, GLenum pname, GLint64EXT *params) PFNGLGETVIDEOI64VNVPROC;
alias void function(GLuint video_slot, GLenum pname, GLuint64EXT *params) PFNGLGETVIDEOUI64VNVPROC;

static const auto GL_EXT_transform_feedback = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBeginTransformFeedbackEXT (GLenum primitiveMode);
	void glEndTransformFeedbackEXT ();
	void glBindBufferRangeEXT (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size);
	void glBindBufferOffsetEXT (GLenum target, GLuint index, GLuint buffer, GLintptr offset);
	void glBindBufferBaseEXT (GLenum target, GLuint index, GLuint buffer);
	void glTransformFeedbackVaryingsEXT (GLuint program, GLsizei count, GLchar* *varyings, GLenum bufferMode);
	void glGetTransformFeedbackVaryingEXT (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum primitiveMode) PFNGLBEGINTRANSFORMFEEDBACKEXTPROC;
alias void function() PFNGLENDTRANSFORMFEEDBACKEXTPROC;
alias void function(GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size) PFNGLBINDBUFFERRANGEEXTPROC;
alias void function(GLenum target, GLuint index, GLuint buffer, GLintptr offset) PFNGLBINDBUFFEROFFSETEXTPROC;
alias void function(GLenum target, GLuint index, GLuint buffer) PFNGLBINDBUFFERBASEEXTPROC;
alias void function(GLuint program, GLsizei count, GLchar* *varyings, GLenum bufferMode) PFNGLTRANSFORMFEEDBACKVARYINGSEXTPROC;
alias void function(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLsizei *size, GLenum *type, GLchar *name) PFNGLGETTRANSFORMFEEDBACKVARYINGEXTPROC;

static const auto GL_EXT_direct_state_access = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glClientAttribDefaultEXT (GLbitfield mask);
	void glPushClientAttribDefaultEXT (GLbitfield mask);
	void glMatrixLoadfEXT (GLenum mode, GLfloat *m);
	void glMatrixLoaddEXT (GLenum mode, GLdouble *m);
	void glMatrixMultfEXT (GLenum mode, GLfloat *m);
	void glMatrixMultdEXT (GLenum mode, GLdouble *m);
	void glMatrixLoadIdentityEXT (GLenum mode);
	void glMatrixRotatefEXT (GLenum mode, GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
	void glMatrixRotatedEXT (GLenum mode, GLdouble angle, GLdouble x, GLdouble y, GLdouble z);
	void glMatrixScalefEXT (GLenum mode, GLfloat x, GLfloat y, GLfloat z);
	void glMatrixScaledEXT (GLenum mode, GLdouble x, GLdouble y, GLdouble z);
	void glMatrixTranslatefEXT (GLenum mode, GLfloat x, GLfloat y, GLfloat z);
	void glMatrixTranslatedEXT (GLenum mode, GLdouble x, GLdouble y, GLdouble z);
	void glMatrixFrustumEXT (GLenum mode, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
	void glMatrixOrthoEXT (GLenum mode, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
	void glMatrixPopEXT (GLenum mode);
	void glMatrixPushEXT (GLenum mode);
	void glMatrixLoadTransposefEXT (GLenum mode, GLfloat *m);
	void glMatrixLoadTransposedEXT (GLenum mode, GLdouble *m);
	void glMatrixMultTransposefEXT (GLenum mode, GLfloat *m);
	void glMatrixMultTransposedEXT (GLenum mode, GLdouble *m);
	void glTextureParameterfEXT (GLuint texture, GLenum target, GLenum pname, GLfloat param);
	void glTextureParameterfvEXT (GLuint texture, GLenum target, GLenum pname, GLfloat *params);
	void glTextureParameteriEXT (GLuint texture, GLenum target, GLenum pname, GLint param);
	void glTextureParameterivEXT (GLuint texture, GLenum target, GLenum pname, GLint *params);
	void glTextureImage1DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glTextureImage2DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glTextureSubImage1DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels);
	void glTextureSubImage2DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
	void glCopyTextureImage1DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border);
	void glCopyTextureImage2DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
	void glCopyTextureSubImage1DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
	void glCopyTextureSubImage2DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
	void glGetTextureImageEXT (GLuint texture, GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
	void glGetTextureParameterfvEXT (GLuint texture, GLenum target, GLenum pname, GLfloat *params);
	void glGetTextureParameterivEXT (GLuint texture, GLenum target, GLenum pname, GLint *params);
	void glGetTextureLevelParameterfvEXT (GLuint texture, GLenum target, GLint level, GLenum pname, GLfloat *params);
	void glGetTextureLevelParameterivEXT (GLuint texture, GLenum target, GLint level, GLenum pname, GLint *params);
	void glTextureImage3DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glTextureSubImage3DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels);
	void glCopyTextureSubImage3DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
	void glMultiTexParameterfEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat param);
	void glMultiTexParameterfvEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat *params);
	void glMultiTexParameteriEXT (GLenum texunit, GLenum target, GLenum pname, GLint param);
	void glMultiTexParameterivEXT (GLenum texunit, GLenum target, GLenum pname, GLint *params);
	void glMultiTexImage1DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glMultiTexImage2DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glMultiTexSubImage1DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels);
	void glMultiTexSubImage2DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
	void glCopyMultiTexImage1DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border);
	void glCopyMultiTexImage2DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
	void glCopyMultiTexSubImage1DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
	void glCopyMultiTexSubImage2DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
	void glGetMultiTexImageEXT (GLenum texunit, GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
	void glGetMultiTexParameterfvEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat *params);
	void glGetMultiTexParameterivEXT (GLenum texunit, GLenum target, GLenum pname, GLint *params);
	void glGetMultiTexLevelParameterfvEXT (GLenum texunit, GLenum target, GLint level, GLenum pname, GLfloat *params);
	void glGetMultiTexLevelParameterivEXT (GLenum texunit, GLenum target, GLint level, GLenum pname, GLint *params);
	void glMultiTexImage3DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels);
	void glMultiTexSubImage3DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels);
	void glCopyMultiTexSubImage3DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
	void glBindMultiTextureEXT (GLenum texunit, GLenum target, GLuint texture);
	void glEnableClientStateIndexedEXT (GLenum array, GLuint index);
	void glDisableClientStateIndexedEXT (GLenum array, GLuint index);
	void glMultiTexCoordPointerEXT (GLenum texunit, GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
	void glMultiTexEnvfEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat param);
	void glMultiTexEnvfvEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat *params);
	void glMultiTexEnviEXT (GLenum texunit, GLenum target, GLenum pname, GLint param);
	void glMultiTexEnvivEXT (GLenum texunit, GLenum target, GLenum pname, GLint *params);
	void glMultiTexGendEXT (GLenum texunit, GLenum coord, GLenum pname, GLdouble param);
	void glMultiTexGendvEXT (GLenum texunit, GLenum coord, GLenum pname, GLdouble *params);
	void glMultiTexGenfEXT (GLenum texunit, GLenum coord, GLenum pname, GLfloat param);
	void glMultiTexGenfvEXT (GLenum texunit, GLenum coord, GLenum pname, GLfloat *params);
	void glMultiTexGeniEXT (GLenum texunit, GLenum coord, GLenum pname, GLint param);
	void glMultiTexGenivEXT (GLenum texunit, GLenum coord, GLenum pname, GLint *params);
	void glGetMultiTexEnvfvEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat *params);
	void glGetMultiTexEnvivEXT (GLenum texunit, GLenum target, GLenum pname, GLint *params);
	void glGetMultiTexGendvEXT (GLenum texunit, GLenum coord, GLenum pname, GLdouble *params);
	void glGetMultiTexGenfvEXT (GLenum texunit, GLenum coord, GLenum pname, GLfloat *params);
	void glGetMultiTexGenivEXT (GLenum texunit, GLenum coord, GLenum pname, GLint *params);
	void glGetFloatIndexedvEXT (GLenum target, GLuint index, GLfloat *data);
	void glGetDoubleIndexedvEXT (GLenum target, GLuint index, GLdouble *data);
	void glGetPointerIndexedvEXT (GLenum target, GLuint index, GLvoid* *data);
	void glCompressedTextureImage3DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *bits);
	void glCompressedTextureImage2DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *bits);
	void glCompressedTextureImage1DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *bits);
	void glCompressedTextureSubImage3DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *bits);
	void glCompressedTextureSubImage2DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *bits);
	void glCompressedTextureSubImage1DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *bits);
	void glGetCompressedTextureImageEXT (GLuint texture, GLenum target, GLint lod, GLvoid *img);
	void glCompressedMultiTexImage3DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *bits);
	void glCompressedMultiTexImage2DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *bits);
	void glCompressedMultiTexImage1DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *bits);
	void glCompressedMultiTexSubImage3DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *bits);
	void glCompressedMultiTexSubImage2DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *bits);
	void glCompressedMultiTexSubImage1DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *bits);
	void glGetCompressedMultiTexImageEXT (GLenum texunit, GLenum target, GLint lod, GLvoid *img);
	void glNamedProgramStringEXT (GLuint program, GLenum target, GLenum format, GLsizei len, GLvoid *string);
	void glNamedProgramLocalParameter4dEXT (GLuint program, GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
	void glNamedProgramLocalParameter4dvEXT (GLuint program, GLenum target, GLuint index, GLdouble *params);
	void glNamedProgramLocalParameter4fEXT (GLuint program, GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
	void glNamedProgramLocalParameter4fvEXT (GLuint program, GLenum target, GLuint index, GLfloat *params);
	void glGetNamedProgramLocalParameterdvEXT (GLuint program, GLenum target, GLuint index, GLdouble *params);
	void glGetNamedProgramLocalParameterfvEXT (GLuint program, GLenum target, GLuint index, GLfloat *params);
	void glGetNamedProgramivEXT (GLuint program, GLenum target, GLenum pname, GLint *params);
	void glGetNamedProgramStringEXT (GLuint program, GLenum target, GLenum pname, GLvoid *string);
	void glNamedProgramLocalParameters4fvEXT (GLuint program, GLenum target, GLuint index, GLsizei count, GLfloat *params);
	void glNamedProgramLocalParameterI4iEXT (GLuint program, GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w);
	void glNamedProgramLocalParameterI4ivEXT (GLuint program, GLenum target, GLuint index, GLint *params);
	void glNamedProgramLocalParametersI4ivEXT (GLuint program, GLenum target, GLuint index, GLsizei count, GLint *params);
	void glNamedProgramLocalParameterI4uiEXT (GLuint program, GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
	void glNamedProgramLocalParameterI4uivEXT (GLuint program, GLenum target, GLuint index, GLuint *params);
	void glNamedProgramLocalParametersI4uivEXT (GLuint program, GLenum target, GLuint index, GLsizei count, GLuint *params);
	void glGetNamedProgramLocalParameterIivEXT (GLuint program, GLenum target, GLuint index, GLint *params);
	void glGetNamedProgramLocalParameterIuivEXT (GLuint program, GLenum target, GLuint index, GLuint *params);
	void glTextureParameterIivEXT (GLuint texture, GLenum target, GLenum pname, GLint *params);
	void glTextureParameterIuivEXT (GLuint texture, GLenum target, GLenum pname, GLuint *params);
	void glGetTextureParameterIivEXT (GLuint texture, GLenum target, GLenum pname, GLint *params);
	void glGetTextureParameterIuivEXT (GLuint texture, GLenum target, GLenum pname, GLuint *params);
	void glMultiTexParameterIivEXT (GLenum texunit, GLenum target, GLenum pname, GLint *params);
	void glMultiTexParameterIuivEXT (GLenum texunit, GLenum target, GLenum pname, GLuint *params);
	void glGetMultiTexParameterIivEXT (GLenum texunit, GLenum target, GLenum pname, GLint *params);
	void glGetMultiTexParameterIuivEXT (GLenum texunit, GLenum target, GLenum pname, GLuint *params);
	void glProgramUniform1fEXT (GLuint program, GLint location, GLfloat v0);
	void glProgramUniform2fEXT (GLuint program, GLint location, GLfloat v0, GLfloat v1);
	void glProgramUniform3fEXT (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
	void glProgramUniform4fEXT (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
	void glProgramUniform1iEXT (GLuint program, GLint location, GLint v0);
	void glProgramUniform2iEXT (GLuint program, GLint location, GLint v0, GLint v1);
	void glProgramUniform3iEXT (GLuint program, GLint location, GLint v0, GLint v1, GLint v2);
	void glProgramUniform4iEXT (GLuint program, GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
	void glProgramUniform1fvEXT (GLuint program, GLint location, GLsizei count, GLfloat *value);
	void glProgramUniform2fvEXT (GLuint program, GLint location, GLsizei count, GLfloat *value);
	void glProgramUniform3fvEXT (GLuint program, GLint location, GLsizei count, GLfloat *value);
	void glProgramUniform4fvEXT (GLuint program, GLint location, GLsizei count, GLfloat *value);
	void glProgramUniform1ivEXT (GLuint program, GLint location, GLsizei count, GLint *value);
	void glProgramUniform2ivEXT (GLuint program, GLint location, GLsizei count, GLint *value);
	void glProgramUniform3ivEXT (GLuint program, GLint location, GLsizei count, GLint *value);
	void glProgramUniform4ivEXT (GLuint program, GLint location, GLsizei count, GLint *value);
	void glProgramUniformMatrix2fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix3fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix4fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix2x3fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix3x2fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix2x4fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix4x2fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix3x4fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniformMatrix4x3fvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value);
	void glProgramUniform1uiEXT (GLuint program, GLint location, GLuint v0);
	void glProgramUniform2uiEXT (GLuint program, GLint location, GLuint v0, GLuint v1);
	void glProgramUniform3uiEXT (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2);
	void glProgramUniform4uiEXT (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
	void glProgramUniform1uivEXT (GLuint program, GLint location, GLsizei count, GLuint *value);
	void glProgramUniform2uivEXT (GLuint program, GLint location, GLsizei count, GLuint *value);
	void glProgramUniform3uivEXT (GLuint program, GLint location, GLsizei count, GLuint *value);
	void glProgramUniform4uivEXT (GLuint program, GLint location, GLsizei count, GLuint *value);
	void glNamedBufferDataEXT (GLuint buffer, GLsizeiptr size, GLvoid *data, GLenum usage);
	void glNamedBufferSubDataEXT (GLuint buffer, GLintptr offset, GLsizeiptr size, GLvoid *data);
	GLvoid* glMapNamedBufferEXT (GLuint buffer, GLenum access);
	GLboolean glUnmapNamedBufferEXT (GLuint buffer);
	void glGetNamedBufferParameterivEXT (GLuint buffer, GLenum pname, GLint *params);
	void glGetNamedBufferPointervEXT (GLuint buffer, GLenum pname, GLvoid* *params);
	void glGetNamedBufferSubDataEXT (GLuint buffer, GLintptr offset, GLsizeiptr size, GLvoid *data);
	void glTextureBufferEXT (GLuint texture, GLenum target, GLenum internalformat, GLuint buffer);
	void glMultiTexBufferEXT (GLenum texunit, GLenum target, GLenum internalformat, GLuint buffer);
	void glNamedRenderbufferStorageEXT (GLuint renderbuffer, GLenum internalformat, GLsizei width, GLsizei height);
	void glGetNamedRenderbufferParameterivEXT (GLuint renderbuffer, GLenum pname, GLint *params);
	GLenum glCheckNamedFramebufferStatusEXT (GLuint framebuffer, GLenum target);
	void glNamedFramebufferTexture1DEXT (GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
	void glNamedFramebufferTexture2DEXT (GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
	void glNamedFramebufferTexture3DEXT (GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset);
	void glNamedFramebufferRenderbufferEXT (GLuint framebuffer, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
	void glGetNamedFramebufferAttachmentParameterivEXT (GLuint framebuffer, GLenum attachment, GLenum pname, GLint *params);
	void glGenerateTextureMipmapEXT (GLuint texture, GLenum target);
	void glGenerateMultiTexMipmapEXT (GLenum texunit, GLenum target);
	void glFramebufferDrawBufferEXT (GLuint framebuffer, GLenum mode);
	void glFramebufferDrawBuffersEXT (GLuint framebuffer, GLsizei n, GLenum *bufs);
	void glFramebufferReadBufferEXT (GLuint framebuffer, GLenum mode);
	void glGetFramebufferParameterivEXT (GLuint framebuffer, GLenum pname, GLint *params);
	void glNamedRenderbufferStorageMultisampleEXT (GLuint renderbuffer, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
	void glNamedRenderbufferStorageMultisampleCoverageEXT (GLuint renderbuffer, GLsizei coverageSamples, GLsizei colorSamples, GLenum internalformat, GLsizei width, GLsizei height);
	void glNamedFramebufferTextureEXT (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level);
	void glNamedFramebufferTextureLayerEXT (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level, GLint layer);
	void glNamedFramebufferTextureFaceEXT (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level, GLenum face);
	void glTextureRenderbufferEXT (GLuint texture, GLenum target, GLuint renderbuffer);
	void glMultiTexRenderbufferEXT (GLenum texunit, GLenum target, GLuint renderbuffer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLbitfield mask) PFNGLCLIENTATTRIBDEFAULTEXTPROC;
alias void function(GLbitfield mask) PFNGLPUSHCLIENTATTRIBDEFAULTEXTPROC;
alias void function(GLenum mode, GLfloat *m) PFNGLMATRIXLOADFEXTPROC;
alias void function(GLenum mode, GLdouble *m) PFNGLMATRIXLOADDEXTPROC;
alias void function(GLenum mode, GLfloat *m) PFNGLMATRIXMULTFEXTPROC;
alias void function(GLenum mode, GLdouble *m) PFNGLMATRIXMULTDEXTPROC;
alias void function(GLenum mode) PFNGLMATRIXLOADIDENTITYEXTPROC;
alias void function(GLenum mode, GLfloat angle, GLfloat x, GLfloat y, GLfloat z) PFNGLMATRIXROTATEFEXTPROC;
alias void function(GLenum mode, GLdouble angle, GLdouble x, GLdouble y, GLdouble z) PFNGLMATRIXROTATEDEXTPROC;
alias void function(GLenum mode, GLfloat x, GLfloat y, GLfloat z) PFNGLMATRIXSCALEFEXTPROC;
alias void function(GLenum mode, GLdouble x, GLdouble y, GLdouble z) PFNGLMATRIXSCALEDEXTPROC;
alias void function(GLenum mode, GLfloat x, GLfloat y, GLfloat z) PFNGLMATRIXTRANSLATEFEXTPROC;
alias void function(GLenum mode, GLdouble x, GLdouble y, GLdouble z) PFNGLMATRIXTRANSLATEDEXTPROC;
alias void function(GLenum mode, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar) PFNGLMATRIXFRUSTUMEXTPROC;
alias void function(GLenum mode, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar) PFNGLMATRIXORTHOEXTPROC;
alias void function(GLenum mode) PFNGLMATRIXPOPEXTPROC;
alias void function(GLenum mode) PFNGLMATRIXPUSHEXTPROC;
alias void function(GLenum mode, GLfloat *m) PFNGLMATRIXLOADTRANSPOSEFEXTPROC;
alias void function(GLenum mode, GLdouble *m) PFNGLMATRIXLOADTRANSPOSEDEXTPROC;
alias void function(GLenum mode, GLfloat *m) PFNGLMATRIXMULTTRANSPOSEFEXTPROC;
alias void function(GLenum mode, GLdouble *m) PFNGLMATRIXMULTTRANSPOSEDEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLfloat param) PFNGLTEXTUREPARAMETERFEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLfloat *params) PFNGLTEXTUREPARAMETERFVEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLint param) PFNGLTEXTUREPARAMETERIEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLint *params) PFNGLTEXTUREPARAMETERIVEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXTUREIMAGE1DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXTUREIMAGE2DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXTURESUBIMAGE1DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXTURESUBIMAGE2DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border) PFNGLCOPYTEXTUREIMAGE1DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border) PFNGLCOPYTEXTUREIMAGE2DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width) PFNGLCOPYTEXTURESUBIMAGE1DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYTEXTURESUBIMAGE2DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels) PFNGLGETTEXTUREIMAGEEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLfloat *params) PFNGLGETTEXTUREPARAMETERFVEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLint *params) PFNGLGETTEXTUREPARAMETERIVEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum pname, GLfloat *params) PFNGLGETTEXTURELEVELPARAMETERFVEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum pname, GLint *params) PFNGLGETTEXTURELEVELPARAMETERIVEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXTUREIMAGE3DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels) PFNGLTEXTURESUBIMAGE3DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYTEXTURESUBIMAGE3DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLfloat param) PFNGLMULTITEXPARAMETERFEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLfloat *params) PFNGLMULTITEXPARAMETERFVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint param) PFNGLMULTITEXPARAMETERIEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint *params) PFNGLMULTITEXPARAMETERIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLMULTITEXIMAGE1DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLMULTITEXIMAGE2DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels) PFNGLMULTITEXSUBIMAGE1DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels) PFNGLMULTITEXSUBIMAGE2DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border) PFNGLCOPYMULTITEXIMAGE1DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border) PFNGLCOPYMULTITEXIMAGE2DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width) PFNGLCOPYMULTITEXSUBIMAGE1DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYMULTITEXSUBIMAGE2DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels) PFNGLGETMULTITEXIMAGEEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLfloat *params) PFNGLGETMULTITEXPARAMETERFVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint *params) PFNGLGETMULTITEXPARAMETERIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum pname, GLfloat *params) PFNGLGETMULTITEXLEVELPARAMETERFVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum pname, GLint *params) PFNGLGETMULTITEXLEVELPARAMETERIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, GLvoid *pixels) PFNGLMULTITEXIMAGE3DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLvoid *pixels) PFNGLMULTITEXSUBIMAGE3DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) PFNGLCOPYMULTITEXSUBIMAGE3DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLuint texture) PFNGLBINDMULTITEXTUREEXTPROC;
alias void function(GLenum array, GLuint index) PFNGLENABLECLIENTSTATEINDEXEDEXTPROC;
alias void function(GLenum array, GLuint index) PFNGLDISABLECLIENTSTATEINDEXEDEXTPROC;
alias void function(GLenum texunit, GLint size, GLenum type, GLsizei stride, GLvoid *pointer) PFNGLMULTITEXCOORDPOINTEREXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLfloat param) PFNGLMULTITEXENVFEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLfloat *params) PFNGLMULTITEXENVFVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint param) PFNGLMULTITEXENVIEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint *params) PFNGLMULTITEXENVIVEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLdouble param) PFNGLMULTITEXGENDEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLdouble *params) PFNGLMULTITEXGENDVEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLfloat param) PFNGLMULTITEXGENFEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLfloat *params) PFNGLMULTITEXGENFVEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLint param) PFNGLMULTITEXGENIEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLint *params) PFNGLMULTITEXGENIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLfloat *params) PFNGLGETMULTITEXENVFVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint *params) PFNGLGETMULTITEXENVIVEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLdouble *params) PFNGLGETMULTITEXGENDVEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLfloat *params) PFNGLGETMULTITEXGENFVEXTPROC;
alias void function(GLenum texunit, GLenum coord, GLenum pname, GLint *params) PFNGLGETMULTITEXGENIVEXTPROC;
alias void function(GLenum target, GLuint index, GLfloat *data) PFNGLGETFLOATINDEXEDVEXTPROC;
alias void function(GLenum target, GLuint index, GLdouble *data) PFNGLGETDOUBLEINDEXEDVEXTPROC;
alias void function(GLenum target, GLuint index, GLvoid* *data) PFNGLGETPOINTERINDEXEDVEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDTEXTUREIMAGE3DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDTEXTUREIMAGE2DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDTEXTUREIMAGE1DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDTEXTURESUBIMAGE3DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDTEXTURESUBIMAGE2DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDTEXTURESUBIMAGE1DEXTPROC;
alias void function(GLuint texture, GLenum target, GLint lod, GLvoid *img) PFNGLGETCOMPRESSEDTEXTUREIMAGEEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDMULTITEXIMAGE3DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDMULTITEXIMAGE2DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDMULTITEXIMAGE1DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDMULTITEXSUBIMAGE3DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDMULTITEXSUBIMAGE2DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, GLvoid *bits) PFNGLCOMPRESSEDMULTITEXSUBIMAGE1DEXTPROC;
alias void function(GLenum texunit, GLenum target, GLint lod, GLvoid *img) PFNGLGETCOMPRESSEDMULTITEXIMAGEEXTPROC;
alias void function(GLuint program, GLenum target, GLenum format, GLsizei len, GLvoid *string) PFNGLNAMEDPROGRAMSTRINGEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) PFNGLNAMEDPROGRAMLOCALPARAMETER4DEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLdouble *params) PFNGLNAMEDPROGRAMLOCALPARAMETER4DVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) PFNGLNAMEDPROGRAMLOCALPARAMETER4FEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLfloat *params) PFNGLNAMEDPROGRAMLOCALPARAMETER4FVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLdouble *params) PFNGLGETNAMEDPROGRAMLOCALPARAMETERDVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLfloat *params) PFNGLGETNAMEDPROGRAMLOCALPARAMETERFVEXTPROC;
alias void function(GLuint program, GLenum target, GLenum pname, GLint *params) PFNGLGETNAMEDPROGRAMIVEXTPROC;
alias void function(GLuint program, GLenum target, GLenum pname, GLvoid *string) PFNGLGETNAMEDPROGRAMSTRINGEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLsizei count, GLfloat *params) PFNGLNAMEDPROGRAMLOCALPARAMETERS4FVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w) PFNGLNAMEDPROGRAMLOCALPARAMETERI4IEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLint *params) PFNGLNAMEDPROGRAMLOCALPARAMETERI4IVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLsizei count, GLint *params) PFNGLNAMEDPROGRAMLOCALPARAMETERSI4IVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w) PFNGLNAMEDPROGRAMLOCALPARAMETERI4UIEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLuint *params) PFNGLNAMEDPROGRAMLOCALPARAMETERI4UIVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLsizei count, GLuint *params) PFNGLNAMEDPROGRAMLOCALPARAMETERSI4UIVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLint *params) PFNGLGETNAMEDPROGRAMLOCALPARAMETERIIVEXTPROC;
alias void function(GLuint program, GLenum target, GLuint index, GLuint *params) PFNGLGETNAMEDPROGRAMLOCALPARAMETERIUIVEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLint *params) PFNGLTEXTUREPARAMETERIIVEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLuint *params) PFNGLTEXTUREPARAMETERIUIVEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLint *params) PFNGLGETTEXTUREPARAMETERIIVEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum pname, GLuint *params) PFNGLGETTEXTUREPARAMETERIUIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint *params) PFNGLMULTITEXPARAMETERIIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLuint *params) PFNGLMULTITEXPARAMETERIUIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLint *params) PFNGLGETMULTITEXPARAMETERIIVEXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum pname, GLuint *params) PFNGLGETMULTITEXPARAMETERIUIVEXTPROC;
alias void function(GLuint program, GLint location, GLfloat v0) PFNGLPROGRAMUNIFORM1FEXTPROC;
alias void function(GLuint program, GLint location, GLfloat v0, GLfloat v1) PFNGLPROGRAMUNIFORM2FEXTPROC;
alias void function(GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2) PFNGLPROGRAMUNIFORM3FEXTPROC;
alias void function(GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3) PFNGLPROGRAMUNIFORM4FEXTPROC;
alias void function(GLuint program, GLint location, GLint v0) PFNGLPROGRAMUNIFORM1IEXTPROC;
alias void function(GLuint program, GLint location, GLint v0, GLint v1) PFNGLPROGRAMUNIFORM2IEXTPROC;
alias void function(GLuint program, GLint location, GLint v0, GLint v1, GLint v2) PFNGLPROGRAMUNIFORM3IEXTPROC;
alias void function(GLuint program, GLint location, GLint v0, GLint v1, GLint v2, GLint v3) PFNGLPROGRAMUNIFORM4IEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLfloat *value) PFNGLPROGRAMUNIFORM1FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLfloat *value) PFNGLPROGRAMUNIFORM2FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLfloat *value) PFNGLPROGRAMUNIFORM3FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLfloat *value) PFNGLPROGRAMUNIFORM4FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLint *value) PFNGLPROGRAMUNIFORM1IVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLint *value) PFNGLPROGRAMUNIFORM2IVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLint *value) PFNGLPROGRAMUNIFORM3IVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLint *value) PFNGLPROGRAMUNIFORM4IVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX2FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX3FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX4FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX2X3FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX3X2FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX2X4FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX4X2FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX3X4FVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLboolean transpose, GLfloat *value) PFNGLPROGRAMUNIFORMMATRIX4X3FVEXTPROC;
alias void function(GLuint program, GLint location, GLuint v0) PFNGLPROGRAMUNIFORM1UIEXTPROC;
alias void function(GLuint program, GLint location, GLuint v0, GLuint v1) PFNGLPROGRAMUNIFORM2UIEXTPROC;
alias void function(GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2) PFNGLPROGRAMUNIFORM3UIEXTPROC;
alias void function(GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3) PFNGLPROGRAMUNIFORM4UIEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLuint *value) PFNGLPROGRAMUNIFORM1UIVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLuint *value) PFNGLPROGRAMUNIFORM2UIVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLuint *value) PFNGLPROGRAMUNIFORM3UIVEXTPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLuint *value) PFNGLPROGRAMUNIFORM4UIVEXTPROC;
alias void function(GLuint buffer, GLsizeiptr size, GLvoid *data, GLenum usage) PFNGLNAMEDBUFFERDATAEXTPROC;
alias void function(GLuint buffer, GLintptr offset, GLsizeiptr size, GLvoid *data) PFNGLNAMEDBUFFERSUBDATAEXTPROC;
alias GLvoid* (PFNGLMAPNAMEDBUFFEREXTPROC) (GLuint buffer, GLenum access);
alias GLboolean function(GLuint buffer) PFNGLUNMAPNAMEDBUFFEREXTPROC;
alias void function(GLuint buffer, GLenum pname, GLint *params) PFNGLGETNAMEDBUFFERPARAMETERIVEXTPROC;
alias void function(GLuint buffer, GLenum pname, GLvoid* *params) PFNGLGETNAMEDBUFFERPOINTERVEXTPROC;
alias void function(GLuint buffer, GLintptr offset, GLsizeiptr size, GLvoid *data) PFNGLGETNAMEDBUFFERSUBDATAEXTPROC;
alias void function(GLuint texture, GLenum target, GLenum internalformat, GLuint buffer) PFNGLTEXTUREBUFFEREXTPROC;
alias void function(GLenum texunit, GLenum target, GLenum internalformat, GLuint buffer) PFNGLMULTITEXBUFFEREXTPROC;
alias void function(GLuint renderbuffer, GLenum internalformat, GLsizei width, GLsizei height) PFNGLNAMEDRENDERBUFFERSTORAGEEXTPROC;
alias void function(GLuint renderbuffer, GLenum pname, GLint *params) PFNGLGETNAMEDRENDERBUFFERPARAMETERIVEXTPROC;
alias GLenum function(GLuint framebuffer, GLenum target) PFNGLCHECKNAMEDFRAMEBUFFERSTATUSEXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level) PFNGLNAMEDFRAMEBUFFERTEXTURE1DEXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level) PFNGLNAMEDFRAMEBUFFERTEXTURE2DEXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset) PFNGLNAMEDFRAMEBUFFERTEXTURE3DEXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer) PFNGLNAMEDFRAMEBUFFERRENDERBUFFEREXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLenum pname, GLint *params) PFNGLGETNAMEDFRAMEBUFFERATTACHMENTPARAMETERIVEXTPROC;
alias void function(GLuint texture, GLenum target) PFNGLGENERATETEXTUREMIPMAPEXTPROC;
alias void function(GLenum texunit, GLenum target) PFNGLGENERATEMULTITEXMIPMAPEXTPROC;
alias void function(GLuint framebuffer, GLenum mode) PFNGLFRAMEBUFFERDRAWBUFFEREXTPROC;
alias void function(GLuint framebuffer, GLsizei n, GLenum *bufs) PFNGLFRAMEBUFFERDRAWBUFFERSEXTPROC;
alias void function(GLuint framebuffer, GLenum mode) PFNGLFRAMEBUFFERREADBUFFEREXTPROC;
alias void function(GLuint framebuffer, GLenum pname, GLint *params) PFNGLGETFRAMEBUFFERPARAMETERIVEXTPROC;
alias void function(GLuint renderbuffer, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height) PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLEEXTPROC;
alias void function(GLuint renderbuffer, GLsizei coverageSamples, GLsizei colorSamples, GLenum internalformat, GLsizei width, GLsizei height) PFNGLNAMEDRENDERBUFFERSTORAGEMULTISAMPLECOVERAGEEXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLuint texture, GLint level) PFNGLNAMEDFRAMEBUFFERTEXTUREEXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLuint texture, GLint level, GLint layer) PFNGLNAMEDFRAMEBUFFERTEXTURELAYEREXTPROC;
alias void function(GLuint framebuffer, GLenum attachment, GLuint texture, GLint level, GLenum face) PFNGLNAMEDFRAMEBUFFERTEXTUREFACEEXTPROC;
alias void function(GLuint texture, GLenum target, GLuint renderbuffer) PFNGLTEXTURERENDERBUFFEREXTPROC;
alias void function(GLenum texunit, GLenum target, GLuint renderbuffer) PFNGLMULTITEXRENDERBUFFEREXTPROC;

static const auto GL_EXT_vertex_array_bgra = 1;

static const auto GL_EXT_texture_swizzle = 1;

static const auto GL_NV_explicit_multisample = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetMultisamplefvNV (GLenum pname, GLuint index, GLfloat *val);
	void glSampleMaskIndexedNV (GLuint index, GLbitfield mask);
	void glTexRenderbufferNV (GLenum target, GLuint renderbuffer);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLuint index, GLfloat *val) PFNGLGETMULTISAMPLEFVNVPROC;
alias void function(GLuint index, GLbitfield mask) PFNGLSAMPLEMASKINDEXEDNVPROC;
alias void function(GLenum target, GLuint renderbuffer) PFNGLTEXRENDERBUFFERNVPROC;

static const auto GL_NV_transform_feedback2 = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBindTransformFeedbackNV (GLenum target, GLuint id);
	void glDeleteTransformFeedbacksNV (GLsizei n, GLuint *ids);
	void glGenTransformFeedbacksNV (GLsizei n, GLuint *ids);
	GLboolean glIsTransformFeedbackNV (GLuint id);
	void glPauseTransformFeedbackNV ();
	void glResumeTransformFeedbackNV ();
	void glDrawTransformFeedbackNV (GLenum mode, GLuint id);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLuint id) PFNGLBINDTRANSFORMFEEDBACKNVPROC;
alias void function(GLsizei n, GLuint *ids) PFNGLDELETETRANSFORMFEEDBACKSNVPROC;
alias void function(GLsizei n, GLuint *ids) PFNGLGENTRANSFORMFEEDBACKSNVPROC;
alias GLboolean function(GLuint id) PFNGLISTRANSFORMFEEDBACKNVPROC;
alias void function() PFNGLPAUSETRANSFORMFEEDBACKNVPROC;
alias void function() PFNGLRESUMETRANSFORMFEEDBACKNVPROC;
alias void function(GLenum mode, GLuint id) PFNGLDRAWTRANSFORMFEEDBACKNVPROC;

static const auto GL_ATI_meminfo = 1;

static const auto GL_AMD_performance_monitor = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glGetPerfMonitorGroupsAMD (GLint *numGroups, GLsizei groupsSize, GLuint *groups);
	void glGetPerfMonitorCountersAMD (GLuint group, GLint *numCounters, GLint *maxActiveCounters, GLsizei counterSize, GLuint *counters);
	void glGetPerfMonitorGroupStringAMD (GLuint group, GLsizei bufSize, GLsizei *length, GLchar *groupString);
	void glGetPerfMonitorCounterStringAMD (GLuint group, GLuint counter, GLsizei bufSize, GLsizei *length, GLchar *counterString);
	void glGetPerfMonitorCounterInfoAMD (GLuint group, GLuint counter, GLenum pname, void *data);
	void glGenPerfMonitorsAMD (GLsizei n, GLuint *monitors);
	void glDeletePerfMonitorsAMD (GLsizei n, GLuint *monitors);
	void glSelectPerfMonitorCountersAMD (GLuint monitor, GLboolean enable, GLuint group, GLint numCounters, GLuint *counterList);
	void glBeginPerfMonitorAMD (GLuint monitor);
	void glEndPerfMonitorAMD (GLuint monitor);
	void glGetPerfMonitorCounterDataAMD (GLuint monitor, GLenum pname, GLsizei dataSize, GLuint *data, GLint *bytesWritten);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLint *numGroups, GLsizei groupsSize, GLuint *groups) PFNGLGETPERFMONITORGROUPSAMDPROC;
alias void function(GLuint group, GLint *numCounters, GLint *maxActiveCounters, GLsizei counterSize, GLuint *counters) PFNGLGETPERFMONITORCOUNTERSAMDPROC;
alias void function(GLuint group, GLsizei bufSize, GLsizei *length, GLchar *groupString) PFNGLGETPERFMONITORGROUPSTRINGAMDPROC;
alias void function(GLuint group, GLuint counter, GLsizei bufSize, GLsizei *length, GLchar *counterString) PFNGLGETPERFMONITORCOUNTERSTRINGAMDPROC;
alias void function(GLuint group, GLuint counter, GLenum pname, void *data) PFNGLGETPERFMONITORCOUNTERINFOAMDPROC;
alias void function(GLsizei n, GLuint *monitors) PFNGLGENPERFMONITORSAMDPROC;
alias void function(GLsizei n, GLuint *monitors) PFNGLDELETEPERFMONITORSAMDPROC;
alias void function(GLuint monitor, GLboolean enable, GLuint group, GLint numCounters, GLuint *counterList) PFNGLSELECTPERFMONITORCOUNTERSAMDPROC;
alias void function(GLuint monitor) PFNGLBEGINPERFMONITORAMDPROC;
alias void function(GLuint monitor) PFNGLENDPERFMONITORAMDPROC;
alias void function(GLuint monitor, GLenum pname, GLsizei dataSize, GLuint *data, GLint *bytesWritten) PFNGLGETPERFMONITORCOUNTERDATAAMDPROC;

static const auto GL_AMD_texture_texture4 = 1;

static const auto GL_AMD_vertex_shader_tesselator = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTessellationFactorAMD (GLfloat factor);
	void glTessellationModeAMD (GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLfloat factor) PFNGLTESSELLATIONFACTORAMDPROC;
alias void function(GLenum mode) PFNGLTESSELLATIONMODEAMDPROC;

static const auto GL_EXT_provoking_vertex = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glProvokingVertexEXT (GLenum mode);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum mode) PFNGLPROVOKINGVERTEXEXTPROC;

static const auto GL_EXT_texture_snorm = 1;

static const auto GL_AMD_draw_buffers_blend = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBlendFuncIndexedAMD (GLuint buf, GLenum src, GLenum dst);
	void glBlendFuncSeparateIndexedAMD (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
	void glBlendEquationIndexedAMD (GLuint buf, GLenum mode);
	void glBlendEquationSeparateIndexedAMD (GLuint buf, GLenum modeRGB, GLenum modeAlpha);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint buf, GLenum src, GLenum dst) PFNGLBLENDFUNCINDEXEDAMDPROC;
alias void function(GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha) PFNGLBLENDFUNCSEPARATEINDEXEDAMDPROC;
alias void function(GLuint buf, GLenum mode) PFNGLBLENDEQUATIONINDEXEDAMDPROC;
alias void function(GLuint buf, GLenum modeRGB, GLenum modeAlpha) PFNGLBLENDEQUATIONSEPARATEINDEXEDAMDPROC;

static const auto GL_APPLE_texture_range = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTextureRangeAPPLE (GLenum target, GLsizei length, GLvoid *pointer);
	void glGetTexParameterPointervAPPLE (GLenum target, GLenum pname, GLvoid* *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLsizei length, GLvoid *pointer) PFNGLTEXTURERANGEAPPLEPROC;
alias void function(GLenum target, GLenum pname, GLvoid* *params) PFNGLGETTEXPARAMETERPOINTERVAPPLEPROC;

static const auto GL_APPLE_float_pixels = 1;

static const auto GL_APPLE_vertex_program_evaluators = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glEnableVertexAttribAPPLE (GLuint index, GLenum pname);
	void glDisableVertexAttribAPPLE (GLuint index, GLenum pname);
	GLboolean glIsVertexAttribEnabledAPPLE (GLuint index, GLenum pname);
	void glMapVertexAttrib1dAPPLE (GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint stride, GLint order, GLdouble *points);
	void glMapVertexAttrib1fAPPLE (GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint stride, GLint order, GLfloat *points);
	void glMapVertexAttrib2dAPPLE (GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, GLdouble *points);
	void glMapVertexAttrib2fAPPLE (GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, GLfloat *points);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint index, GLenum pname) PFNGLENABLEVERTEXATTRIBAPPLEPROC;
alias void function(GLuint index, GLenum pname) PFNGLDISABLEVERTEXATTRIBAPPLEPROC;
alias GLboolean function(GLuint index, GLenum pname) PFNGLISVERTEXATTRIBENABLEDAPPLEPROC;
alias void function(GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint stride, GLint order, GLdouble *points) PFNGLMAPVERTEXATTRIB1DAPPLEPROC;
alias void function(GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint stride, GLint order, GLfloat *points) PFNGLMAPVERTEXATTRIB1FAPPLEPROC;
alias void function(GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, GLdouble *points) PFNGLMAPVERTEXATTRIB2DAPPLEPROC;
alias void function(GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, GLfloat *points) PFNGLMAPVERTEXATTRIB2FAPPLEPROC;

static const auto GL_APPLE_aux_depth_stencil = 1;

static const auto GL_APPLE_object_purgeable = 1;
version(GL_GLEXT_PROTOTYPES) {
	GLenum glObjectPurgeableAPPLE (GLenum objectType, GLuint name, GLenum option);
	GLenum glObjectUnpurgeableAPPLE (GLenum objectType, GLuint name, GLenum option);
	void glGetObjectParameterivAPPLE (GLenum objectType, GLuint name, GLenum pname, GLint *params);
} /* GL_GLEXT_PROTOTYPES */
alias GLenum function(GLenum objectType, GLuint name, GLenum option) PFNGLOBJECTPURGEABLEAPPLEPROC;
alias GLenum function(GLenum objectType, GLuint name, GLenum option) PFNGLOBJECTUNPURGEABLEAPPLEPROC;
alias void function(GLenum objectType, GLuint name, GLenum pname, GLint *params) PFNGLGETOBJECTPARAMETERIVAPPLEPROC;

static const auto GL_APPLE_row_bytes = 1;

static const auto GL_APPLE_rgb_422 = 1;

static const auto GL_NV_video_capture = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBeginVideoCaptureNV (GLuint video_capture_slot);
	void glBindVideoCaptureStreamBufferNV (GLuint video_capture_slot, GLuint stream, GLenum frame_region, GLintptrARB offset);
	void glBindVideoCaptureStreamTextureNV (GLuint video_capture_slot, GLuint stream, GLenum frame_region, GLenum target, GLuint texture);
	void glEndVideoCaptureNV (GLuint video_capture_slot);
	void glGetVideoCaptureivNV (GLuint video_capture_slot, GLenum pname, GLint *params);
	void glGetVideoCaptureStreamivNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLint *params);
	void glGetVideoCaptureStreamfvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLfloat *params);
	void glGetVideoCaptureStreamdvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLdouble *params);
	GLenum glVideoCaptureNV (GLuint video_capture_slot, GLuint *sequence_num, GLuint64EXT *capture_time);
	void glVideoCaptureStreamParameterivNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLint *params);
	void glVideoCaptureStreamParameterfvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLfloat *params);
	void glVideoCaptureStreamParameterdvNV (GLuint video_capture_slot, GLuint stream, GLenum pname, GLdouble *params);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint video_capture_slot) PFNGLBEGINVIDEOCAPTURENVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum frame_region, GLintptrARB offset) PFNGLBINDVIDEOCAPTURESTREAMBUFFERNVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum frame_region, GLenum target, GLuint texture) PFNGLBINDVIDEOCAPTURESTREAMTEXTURENVPROC;
alias void function(GLuint video_capture_slot) PFNGLENDVIDEOCAPTURENVPROC;
alias void function(GLuint video_capture_slot, GLenum pname, GLint *params) PFNGLGETVIDEOCAPTUREIVNVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum pname, GLint *params) PFNGLGETVIDEOCAPTURESTREAMIVNVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum pname, GLfloat *params) PFNGLGETVIDEOCAPTURESTREAMFVNVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum pname, GLdouble *params) PFNGLGETVIDEOCAPTURESTREAMDVNVPROC;
alias GLenum function(GLuint video_capture_slot, GLuint *sequence_num, GLuint64EXT *capture_time) PFNGLVIDEOCAPTURENVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum pname, GLint *params) PFNGLVIDEOCAPTURESTREAMPARAMETERIVNVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum pname, GLfloat *params) PFNGLVIDEOCAPTURESTREAMPARAMETERFVNVPROC;
alias void function(GLuint video_capture_slot, GLuint stream, GLenum pname, GLdouble *params) PFNGLVIDEOCAPTURESTREAMPARAMETERDVNVPROC;

static const auto GL_NV_copy_image = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glCopyImageSubDataNV (GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei width, GLsizei height, GLsizei depth);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei width, GLsizei height, GLsizei depth) PFNGLCOPYIMAGESUBDATANVPROC;

static const auto GL_EXT_separate_shader_objects = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glUseShaderProgramEXT (GLenum type, GLuint program);
	void glActiveProgramEXT (GLuint program);
	GLuint glCreateShaderProgramEXT (GLenum type, GLchar *string);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum type, GLuint program) PFNGLUSESHADERPROGRAMEXTPROC;
alias void function(GLuint program) PFNGLACTIVEPROGRAMEXTPROC;
alias GLuint function(GLenum type, GLchar *string) PFNGLCREATESHADERPROGRAMEXTPROC;

static const auto GL_NV_parameter_buffer_object2 = 1;

static const auto GL_NV_shader_buffer_load = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glMakeBufferResidentNV (GLenum target, GLenum access);
	void glMakeBufferNonResidentNV (GLenum target);
	GLboolean glIsBufferResidentNV (GLenum target);
	void glMakeNamedBufferResidentNV (GLuint buffer, GLenum access);
	void glMakeNamedBufferNonResidentNV (GLuint buffer);
	GLboolean glIsNamedBufferResidentNV (GLuint buffer);
	void glGetBufferParameterui64vNV (GLenum target, GLenum pname, GLuint64EXT *params);
	void glGetNamedBufferParameterui64vNV (GLuint buffer, GLenum pname, GLuint64EXT *params);
	void glGetIntegerui64vNV (GLenum value, GLuint64EXT *result);
	void glUniformui64NV (GLint location, GLuint64EXT value);
	void glUniformui64vNV (GLint location, GLsizei count, GLuint64EXT *value);
	void glGetUniformui64vNV (GLuint program, GLint location, GLuint64EXT *params);
	void glProgramUniformui64NV (GLuint program, GLint location, GLuint64EXT value);
	void glProgramUniformui64vNV (GLuint program, GLint location, GLsizei count, GLuint64EXT *value);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum target, GLenum access) PFNGLMAKEBUFFERRESIDENTNVPROC;
alias void function(GLenum target) PFNGLMAKEBUFFERNONRESIDENTNVPROC;
alias GLboolean function(GLenum target) PFNGLISBUFFERRESIDENTNVPROC;
alias void function(GLuint buffer, GLenum access) PFNGLMAKENAMEDBUFFERRESIDENTNVPROC;
alias void function(GLuint buffer) PFNGLMAKENAMEDBUFFERNONRESIDENTNVPROC;
alias GLboolean function(GLuint buffer) PFNGLISNAMEDBUFFERRESIDENTNVPROC;
alias void function(GLenum target, GLenum pname, GLuint64EXT *params) PFNGLGETBUFFERPARAMETERUI64VNVPROC;
alias void function(GLuint buffer, GLenum pname, GLuint64EXT *params) PFNGLGETNAMEDBUFFERPARAMETERUI64VNVPROC;
alias void function(GLenum value, GLuint64EXT *result) PFNGLGETINTEGERUI64VNVPROC;
alias void function(GLint location, GLuint64EXT value) PFNGLUNIFORMUI64NVPROC;
alias void function(GLint location, GLsizei count, GLuint64EXT *value) PFNGLUNIFORMUI64VNVPROC;
alias void function(GLuint program, GLint location, GLuint64EXT *params) PFNGLGETUNIFORMUI64VNVPROC;
alias void function(GLuint program, GLint location, GLuint64EXT value) PFNGLPROGRAMUNIFORMUI64NVPROC;
alias void function(GLuint program, GLint location, GLsizei count, GLuint64EXT *value) PFNGLPROGRAMUNIFORMUI64VNVPROC;

static const auto GL_NV_vertex_buffer_unified_memory = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glBufferAddressRangeNV (GLenum pname, GLuint index, GLuint64EXT address, GLsizeiptr length);
	void glVertexFormatNV (GLint size, GLenum type, GLsizei stride);
	void glNormalFormatNV (GLenum type, GLsizei stride);
	void glColorFormatNV (GLint size, GLenum type, GLsizei stride);
	void glIndexFormatNV (GLenum type, GLsizei stride);
	void glTexCoordFormatNV (GLint size, GLenum type, GLsizei stride);
	void glEdgeFlagFormatNV (GLsizei stride);
	void glSecondaryColorFormatNV (GLint size, GLenum type, GLsizei stride);
	void glFogCoordFormatNV (GLenum type, GLsizei stride);
	void glVertexAttribFormatNV (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride);
	void glVertexAttribIFormatNV (GLuint index, GLint size, GLenum type, GLsizei stride);
	void glGetIntegerui64i_vNV (GLenum value, GLuint index, GLuint64EXT *result);
} /* GL_GLEXT_PROTOTYPES */
alias void function(GLenum pname, GLuint index, GLuint64EXT address, GLsizeiptr length) PFNGLBUFFERADDRESSRANGENVPROC;
alias void function(GLint size, GLenum type, GLsizei stride) PFNGLVERTEXFORMATNVPROC;
alias void function(GLenum type, GLsizei stride) PFNGLNORMALFORMATNVPROC;
alias void function(GLint size, GLenum type, GLsizei stride) PFNGLCOLORFORMATNVPROC;
alias void function(GLenum type, GLsizei stride) PFNGLINDEXFORMATNVPROC;
alias void function(GLint size, GLenum type, GLsizei stride) PFNGLTEXCOORDFORMATNVPROC;
alias void function(GLsizei stride) PFNGLEDGEFLAGFORMATNVPROC;
alias void function(GLint size, GLenum type, GLsizei stride) PFNGLSECONDARYCOLORFORMATNVPROC;
alias void function(GLenum type, GLsizei stride) PFNGLFOGCOORDFORMATNVPROC;
alias void function(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride) PFNGLVERTEXATTRIBFORMATNVPROC;
alias void function(GLuint index, GLint size, GLenum type, GLsizei stride) PFNGLVERTEXATTRIBIFORMATNVPROC;
alias void function(GLenum value, GLuint index, GLuint64EXT *result) PFNGLGETINTEGERUI64I_VNVPROC;

static const auto GL_NV_texture_barrier = 1;
version(GL_GLEXT_PROTOTYPES) {
	void glTextureBarrierNV ();
} /* GL_GLEXT_PROTOTYPES */
alias void function() PFNGLTEXTUREBARRIERNVPROC;

static const auto GL_AMD_shader_stencil_export = 1;

static const auto GL_AMD_seamless_cubemap_per_texture = 1;

static const auto GL_AMD_conservative_depth = 1;
