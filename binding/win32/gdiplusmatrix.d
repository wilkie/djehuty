/*
 * gdiplusmatrix.d
 *
 * This module implements GdiPlusMatrix.h for D. The original
 * copyright info is given below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.gdiplusmatrix;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;
import binding.win32.wingdi;
import binding.win32.guiddef;
import binding.win32.gdiplusbase;
import binding.win32.gdiplustypes;
import binding.win32.gdiplusenums;
import binding.win32.gdipluspixelformats;
import binding.win32.gdiplusgpstubs;
import binding.win32.gdiplusmetaheader;
import binding.win32.gdipluspixelformats;
import binding.win32.gdipluscolor;
import binding.win32.gdipluscolormatrix;
import binding.win32.gdiplusflat;

/**************************************************************************\
*
* Copyright (c) 1998-2001, Microsoft Corp.  All Rights Reserved.
*
* Module Name:
*
*   GdiplusMatrix.h
*
* Abstract:
*
*   GDI+ Matrix class
*
\**************************************************************************/

extern(System):

class Matrix : GdiplusBase {

    this() {
        GpMatrix *matrix = null;

        lastResult = GdipCreateMatrix(&matrix);

        SetNativeMatrix(matrix);
    }

    this(in REAL m11, in REAL m12, in REAL m21, in REAL m22, in REAL dx, in REAL dy) {
        GpMatrix *matrix = null;

        lastResult = GdipCreateMatrix2(m11, m12, m21, m22,
                                                      dx, dy, &matrix);

        SetNativeMatrix(matrix);
    }

    this(in RectF rect, in PointF* dstplg) {
        GpMatrix *matrix = null;

        lastResult = GdipCreateMatrix3(&rect,
                           dstplg,
                           &matrix);

        SetNativeMatrix(matrix);
    }

    this(in Rect rect, in Point* dstplg) {
        GpMatrix *matrix = null;

        lastResult = GdipCreateMatrix3I(&rect,
                                        dstplg,
                                        &matrix);

        SetNativeMatrix(matrix);
    }

    ~this() {
        GdipDeleteMatrix(nativeMatrix);
    }

    Matrix Clone() {
        GpMatrix *cloneMatrix = null;

        SetStatus(GdipCloneMatrix(nativeMatrix,
                                  &cloneMatrix));

        if (lastResult != Status.Ok)
            return null;

        return new Matrix(cloneMatrix);
    }

    alias Clone dup;

    Status GetElements(REAL *m) {
        return SetStatus(GdipGetMatrixElements(nativeMatrix, m));
    }

    Status SetElements(in REAL m11, in REAL m12, in REAL m21, in REAL m22, in REAL dx, in REAL dy) {
        return SetStatus(GdipSetMatrixElements(nativeMatrix,
                            m11, m12, m21, m22, dx, dy));
    }

    REAL OffsetX() {
        REAL[6] elements;

        if (GetElements(&elements[0]) == Status.Ok)
            return elements[4];
        else
            return 0.0f;
    }

    REAL OffsetY() {
       REAL[6] elements;

       if (GetElements(&elements[0]) == Status.Ok)
           return elements[5];
       else
           return 0.0f;
    }

    Status Reset() {
        // set identity matrix elements
        return SetStatus(GdipSetMatrixElements(nativeMatrix,
                                             1.0, 0.0, 0.0, 1.0, 0.0, 0.0));
    }

    Status Multiply(in Matrix matrix,
                    in MatrixOrder order = MatrixOrder.MatrixOrderPrepend)
    {
        return SetStatus(GdipMultiplyMatrix(nativeMatrix,
                                          matrix.nativeMatrix,
                                          order));
    }

    Status Translate(in REAL offsetX,
                     in REAL offsetY,
                     in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipTranslateMatrix(nativeMatrix, offsetX,
                                                         offsetY, order));
    }

    Status Scale(in REAL scaleX,
                 in REAL scaleY,
                 in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipScaleMatrix(nativeMatrix, scaleX,
                                                     scaleY, order));
    }

    Status Rotate(in REAL angle,
                  in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipRotateMatrix(nativeMatrix, angle,
                                                      order));
    }

    Status RotateAt(in REAL angle,
                    in PointF center,
                    in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        if(order == MatrixOrder.MatrixOrderPrepend) {
            SetStatus(GdipTranslateMatrix(nativeMatrix, center.X,
                                                      center.Y, order));
            SetStatus(GdipRotateMatrix(nativeMatrix, angle,
                                                   order));
            return SetStatus(GdipTranslateMatrix(nativeMatrix,
                                                             -center.X,
                                                             -center.Y,
                                                             order));
        }
        else {
            SetStatus(GdipTranslateMatrix(nativeMatrix,
                                                      - center.X,
                                                      - center.Y,
                                                      order));
            SetStatus(GdipRotateMatrix(nativeMatrix, angle,
                                                   order));
            return SetStatus(GdipTranslateMatrix(nativeMatrix,
                                                             center.X,
                                                             center.Y,
                                                             order));
        }
    }

    Status Shear(in REAL shearX,
                 in REAL shearY,
                 in MatrixOrder order = MatrixOrder.MatrixOrderPrepend) {
        return SetStatus(GdipShearMatrix(nativeMatrix, shearX,
                                                     shearY, order));
    }

    Status Invert() {
        return SetStatus(GdipInvertMatrix(nativeMatrix));
    }

    // float version
    Status TransformPoints(ref PointF* pts,
                           in INT count = 1) {
        return SetStatus(GdipTransformMatrixPoints(nativeMatrix,
                                                               pts, count));
    }

    Status TransformPoints(ref Point* pts,
                           in INT count = 1) {
        return SetStatus(GdipTransformMatrixPointsI(nativeMatrix,
                                                                pts,
                                                                count));
    }

    Status TransformVectors(ref PointF* pts,
                            in INT count = 1) {
        return SetStatus(GdipVectorTransformMatrixPoints(
                                        nativeMatrix, pts, count));
    }

    Status TransformVectors(ref Point* pts,
                            in INT count = 1) {
       return SetStatus(GdipVectorTransformMatrixPointsI(
                                        nativeMatrix,
                                        pts,
                                        count));
    }

    BOOL IsInvertible() {
        BOOL result = FALSE;

        SetStatus(GdipIsMatrixInvertible(nativeMatrix, &result));

        return result;
    }

    BOOL IsIdentity() {
       BOOL result = FALSE;

       SetStatus(GdipIsMatrixIdentity(nativeMatrix, &result));

       return result;
    }

    BOOL Equals(in Matrix *matrix) {
       BOOL result = FALSE;

       SetStatus(GdipIsMatrixEqual(nativeMatrix,
                                               matrix.nativeMatrix,
                                               &result));

       return result;
    }

    Status GetLastStatus() {
        Status lastStatus = lastResult;
        lastResult = Status.Ok;

        return lastStatus;
    }

protected:
    this(GpMatrix *nativeMatrix) {
        lastResult = Status.Ok;
        SetNativeMatrix(nativeMatrix);
    }

    VOID SetNativeMatrix(GpMatrix *nativeMatrix) {
        this.nativeMatrix = nativeMatrix;
    }

    Status SetStatus(Status status) {
        if (status != Status.Ok)
            return (lastResult = status);
        else
            return status;
    }

    package GpMatrix* nativeMatrix;
	package Status lastResult;
}