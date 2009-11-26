/*
 * glu.d
 *
 * This module contains bindings for opengl and was adapted from GLU.h
 *
 * Author: Dave Wilkinson
 *
 */

module binding.opengl.glu;

import binding.opengl.gl;

// The functions supported by opengl

extern (System) {
	extern(C) struct GLUnurbs;
	extern(C) struct GLUquadric;
	extern(C) struct GLUtesselator;

	/****           Backwards compatibility for old tesselator           ****/

	void  gluBeginPolygon(GLUtesselator *tess);
	void  gluNextContour(GLUtesselator *tess, GLenum type);
	void  gluEndPolygon(GLUtesselator *tess);

	GLubyte * gluErrorString(GLenum errCode);
	 //wchar_t*  gluErrorUnicodeStringEXT (
	 //   GLenum   errCode);
	GLubyte * gluGetString(GLenum name);
	void  gluOrtho2D(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top);
	void  gluPerspective(GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar);
	void  gluPickMatrix(GLdouble x, GLdouble y, GLdouble width, GLdouble height, GLint *viewport);
	void  gluLookAt(GLdouble eyex, GLdouble eyey, GLdouble eyez, GLdouble centerx, GLdouble centery, GLdouble centerz, GLdouble upx, GLdouble upy, GLdouble upz);
	int  gluProject(GLdouble objx, GLdouble objy, GLdouble objz, GLdouble *modelMatrix, GLdouble *projMatrix, GLint *viewport, GLdouble *winx, GLdouble *winy, GLdouble *winz);
	int  gluUnProject(GLdouble winx, GLdouble winy, GLdouble winz, GLdouble *modelMatrix, GLdouble *projMatrix, GLint *viewport, GLdouble *objx, GLdouble *objy, GLdouble *objz);

	int  gluScaleImage(GLenum format, GLint widthin, GLint heightin, GLenum typein, void *datain, GLint widthout, GLint heightout, GLenum typeout, void *dataout);

	int  gluBuild1DMipmaps(GLenum target, GLint components, GLint width, GLenum format, GLenum type, void *data);
	int  gluBuild2DMipmaps(GLenum target, GLint components, GLint width, GLint height, GLenum format, GLenum type, void *data);
}

extern (System):

/* backwards compatibility: */



/* backwards compatibility: */
alias GLUnurbs GLUnurbsObj;
alias GLUquadric GLUquadricObj;
alias GLUtesselator GLUtesselatorObj;
alias GLUtesselator GLUtriangulatorObj;



GLUquadric * gluNewQuadric();
void  gluDeleteQuadric(GLUquadric *state);

void  gluQuadricNormals(GLUquadric *quadObject, GLenum normals);

void  gluQuadricTexture(GLUquadric *quadObject, GLboolean textureCoords);

void  gluQuadricOrientation(GLUquadric *quadObject, GLenum orientation);

void  gluQuadricDrawStyle(GLUquadric *quadObject, GLenum drawStyle);

void  gluCylinder(GLUquadric *qobj, GLdouble baseRadius, GLdouble topRadius, GLdouble height, GLint slices, GLint stacks);

void  gluDisk(GLUquadric *qobj, GLdouble innerRadius, GLdouble outerRadius, GLint slices, GLint loops);

void  gluPartialDisk(GLUquadric *qobj, GLdouble innerRadius, GLdouble outerRadius, GLint slices, GLint loops, GLdouble startAngle, GLdouble sweepAngle);

void  gluSphere(GLUquadric *qobj, GLdouble radius, GLint slices, GLint stacks);

void  gluQuadricCallback(GLUquadric *qobj, GLenum which, void function()fn);

GLUtesselator * gluNewTess();

void  gluDeleteTess(GLUtesselator *tess);

void  gluTessBeginPolygon(GLUtesselator *tess, void *polygon_data);

void  gluTessBeginContour(GLUtesselator *tess);

void  gluTessVertex(GLUtesselator *tess, GLdouble *coords, void *data);

void  gluTessEndContour(GLUtesselator *tess);

void  gluTessEndPolygon(GLUtesselator *tess);

void  gluTessProperty(GLUtesselator *tess, GLenum which, GLdouble value);

void  gluTessNormal(GLUtesselator *tess, GLdouble x, GLdouble y, GLdouble z);

void  gluTessCallback(GLUtesselator *tess, GLenum which, void function()fn);

void  gluGetTessProperty(GLUtesselator *tess, GLenum which, GLdouble *value);

GLUnurbs * gluNewNurbsRenderer();

void  gluDeleteNurbsRenderer(GLUnurbs *nobj);

void  gluBeginSurface(GLUnurbs *nobj);

void  gluBeginCurve(GLUnurbs *nobj);

void  gluEndCurve(GLUnurbs *nobj);

void  gluEndSurface(GLUnurbs *nobj);

void  gluBeginTrim(GLUnurbs *nobj);

void  gluEndTrim(GLUnurbs *nobj);

void  gluPwlCurve(GLUnurbs *nobj, GLint count, GLfloat *array, GLint stride, GLenum type);

void  gluNurbsCurve(GLUnurbs *nobj, GLint nknots, GLfloat *knot, GLint stride, GLfloat *ctlarray, GLint order, GLenum type);

void  gluNurbsSurface(GLUnurbs *nobj, GLint sknot_count, float *sknot, GLint tknot_count, GLfloat *tknot, GLint s_stride, GLint t_stride, GLfloat *ctlarray, GLint sorder, GLint torder, GLenum type);

void  gluLoadSamplingMatrices(GLUnurbs *nobj, GLfloat *modelMatrix, GLfloat *projMatrix, GLint *viewport);

void  gluNurbsProperty(GLUnurbs *nobj, GLenum property, GLfloat value);

void  gluGetNurbsProperty(GLUnurbs *nobj, GLenum property, GLfloat *value);

void  gluNurbsCallback(GLUnurbs *nobj, GLenum which, void  function()fn);


/****           Callback function prototypes    ****/

/* gluQuadricCallback */
alias void  function(GLenum )GLUquadricErrorProc;

/* gluTessCallback */
alias void  function(GLenum )GLUtessBeginProc;
alias void  function(GLboolean )GLUtessEdgeFlagProc;
alias void  function(void *)GLUtessVertexProc;
alias void  function()GLUtessEndProc;
alias void  function(GLenum )GLUtessErrorProc;
alias void  function(GLdouble *, void **, GLfloat *, void **)GLUtessCombineProc;
alias void  function(GLenum , void *)GLUtessBeginDataProc;
alias void  function(GLboolean , void *)GLUtessEdgeFlagDataProc;
alias void  function(void *, void *)GLUtessVertexDataProc;
alias void  function(void *)GLUtessEndDataProc;
alias void  function(GLenum , void *)GLUtessErrorDataProc;
alias void  function(GLdouble *, void **, GLfloat *, void **, void *)GLUtessCombineDataProc;

/* gluNurbsCallback */
alias void  function(GLenum )GLUnurbsErrorProc;


/****           Generic ants               ****/

/* Version */
const GLU_VERSION_1_1 = 1;

const GLU_VERSION_1_2 = 1;
/* Errors: (return value 0 = no error) */
const GLU_INVALID_ENUM = 100900;
const GLU_INVALID_VALUE = 100901;
const GLU_OUT_OF_MEMORY = 100902;

const GLU_INCOMPATIBLE_GL_VERSION = 100903;
/* StringName */
const GLU_VERSION = 100800;

const GLU_EXTENSIONS = 100801;
/* Boolean */
alias GL_TRUE GLU_TRUE;

alias GL_FALSE GLU_FALSE;

/****           Quadric ants               ****/

/* QuadricNormal */
const GLU_SMOOTH = 100000;
const GLU_FLAT = 100001;

const GLU_NONE = 100002;
/* QuadricDrawStyle */
const GLU_POINT = 100010;
const GLU_LINE = 100011;
const GLU_FILL = 100012;

const GLU_SILHOUETTE = 100013;
/* QuadricOrientation */
const GLU_OUTSIDE = 100020;

const GLU_INSIDE = 100021;
/* Callback types: */
/*      GLU_ERROR               100103 */


/****           Tesselation ants           ****/


const GLU_TESS_MAX_COORD = 1.0e150;
/* TessProperty */
const GLU_TESS_WINDING_RULE = 100140;
const GLU_TESS_BOUNDARY_ONLY = 100141;

const GLU_TESS_TOLERANCE = 100142;
/* TessWinding */
const GLU_TESS_WINDING_ODD = 100130;
const GLU_TESS_WINDING_NONZERO = 100131;
const GLU_TESS_WINDING_POSITIVE = 100132;
const GLU_TESS_WINDING_NEGATIVE = 100133;

const GLU_TESS_WINDING_ABS_GEQ_TWO = 100134;
/* TessCallback */
const GLU_TESS_BEGIN = 100100;
const GLU_TESS_VERTEX = 100101;
const GLU_TESS_END = 100102;
const GLU_TESS_ERROR = 100103;
const GLU_TESS_EDGE_FLAG = 100104;

const GLU_TESS_COMBINE = 100105;



const GLU_TESS_BEGIN_DATA = 100106;

const GLU_TESS_VERTEX_DATA = 100107;
const GLU_TESS_END_DATA = 100108;

const GLU_TESS_ERROR_DATA = 100109;

const GLU_TESS_EDGE_FLAG_DATA = 100110;

const GLU_TESS_COMBINE_DATA = 100111;




/* TessError */
const GLU_TESS_ERROR1 = 100151;
const GLU_TESS_ERROR2 = 100152;
const GLU_TESS_ERROR3 = 100153;
const GLU_TESS_ERROR4 = 100154;
const GLU_TESS_ERROR5 = 100155;
const GLU_TESS_ERROR6 = 100156;
const GLU_TESS_ERROR7 = 100157;

const GLU_TESS_ERROR8 = 100158;
alias GLU_TESS_ERROR1 GLU_TESS_MISSING_BEGIN_POLYGON;
alias GLU_TESS_ERROR2 GLU_TESS_MISSING_BEGIN_CONTOUR;
alias GLU_TESS_ERROR3 GLU_TESS_MISSING_END_POLYGON;
alias GLU_TESS_ERROR4 GLU_TESS_MISSING_END_CONTOUR;
alias GLU_TESS_ERROR5 GLU_TESS_COORD_TOO_LARGE;

alias GLU_TESS_ERROR6 GLU_TESS_NEED_COMBINE_;
/****           NURBS ants                 ****/

/* NurbsProperty */
const GLU_AUTO_LOAD_MATRIX = 100200;
const GLU_CULLING = 100201;
const GLU_SAMPLING_TOLERANCE = 100203;
const GLU_DISPLAY_MODE = 100204;
const GLU_PARAMETRIC_TOLERANCE = 100202;
const GLU_SAMPLING_METHOD = 100205;
const GLU_U_STEP = 100206;

const GLU_V_STEP = 100207;
/* NurbsSampling */
const GLU_PATH_LENGTH = 100215;
const GLU_PARAMETRIC_ERROR = 100216;

const GLU_DOMAIN_DISTANCE = 100217;

/* NurbsTrim */
const GLU_MAP1_TRIM_2 = 100210;

const GLU_MAP1_TRIM_3 = 100211;
/* NurbsDisplay */
/*      GLU_FILL                100012 */
const GLU_OUTLINE_POLYGON = 100240;

const GLU_OUTLINE_PATCH = 100241;
/* NurbsCallback */
/*      GLU_ERROR               100103 */

/* NurbsErrors */
const GLU_NURBS_ERROR1 = 100251;
const GLU_NURBS_ERROR2 = 100252;
const GLU_NURBS_ERROR3 = 100253;
const GLU_NURBS_ERROR4 = 100254;
const GLU_NURBS_ERROR5 = 100255;
const GLU_NURBS_ERROR6 = 100256;
const GLU_NURBS_ERROR7 = 100257;
const GLU_NURBS_ERROR8 = 100258;
const GLU_NURBS_ERROR9 = 100259;
const GLU_NURBS_ERROR10 = 100260;
const GLU_NURBS_ERROR11 = 100261;
const GLU_NURBS_ERROR12 = 100262;
const GLU_NURBS_ERROR13 = 100263;
const GLU_NURBS_ERROR14 = 100264;
const GLU_NURBS_ERROR15 = 100265;
const GLU_NURBS_ERROR16 = 100266;
const GLU_NURBS_ERROR17 = 100267;
const GLU_NURBS_ERROR18 = 100268;
const GLU_NURBS_ERROR19 = 100269;
const GLU_NURBS_ERROR20 = 100270;
const GLU_NURBS_ERROR21 = 100271;
const GLU_NURBS_ERROR22 = 100272;
const GLU_NURBS_ERROR23 = 100273;
const GLU_NURBS_ERROR24 = 100274;
const GLU_NURBS_ERROR25 = 100275;
const GLU_NURBS_ERROR26 = 100276;
const GLU_NURBS_ERROR27 = 100277;
const GLU_NURBS_ERROR28 = 100278;
const GLU_NURBS_ERROR29 = 100279;
const GLU_NURBS_ERROR30 = 100280;
const GLU_NURBS_ERROR31 = 100281;
const GLU_NURBS_ERROR32 = 100282;
const GLU_NURBS_ERROR33 = 100283;
const GLU_NURBS_ERROR34 = 100284;
const GLU_NURBS_ERROR35 = 100285;
const GLU_NURBS_ERROR36 = 100286;

const GLU_NURBS_ERROR37 = 100287;

/* Contours types -- obsolete! */
const GLU_CW = 100120;
const GLU_CCW = 100121;
const GLU_INTERIOR = 100122;
const GLU_EXTERIOR = 100123;

const GLU_UNKNOWN = 100124;
/* Names without "TESS_" prefix */
alias GLU_TESS_BEGIN GLU_BEGIN;
alias GLU_TESS_VERTEX GLU_VERTEX;
alias GLU_TESS_END GLU_END;
alias GLU_TESS_ERROR GLU_ERROR;

alias GLU_TESS_EDGE_FLAG GLU_EDGE_FLAG;

