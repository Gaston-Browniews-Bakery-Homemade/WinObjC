//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#ifndef __CGPATHINTERNAL_H
#define __CGPATHINTERNAL_H

#include "CFBridgeBase.h"
#include "CoreGraphics/CGContext.h"
#include "CoreGraphics/CGPath.h"
#include "D2DWrapper.h"

#include <COMIncludes.h>
#import <wrl/client.h>
#import <D2d1.h>
#include <COMIncludes_End.h>
#import "CFCPPBase.h"
#import <CoreFoundation/CoreFoundation.h>

const int kCGPathMaxPointCount = 3;

struct CGPathElementInternal : CGPathElement {
    // Internal representation of points used to simplify size calculations
    // CGPoint* points in CGPathElement should always point to this array
    CGPoint internalPoints[kCGPathMaxPointCount];

    // Constructor. Used to adjust array pointer after creation.
    CGPathElementInternal() : CGPathElement() {
        this->init();
    }
    // Copy Constructor. Used to adjust array pointer after copy.
    CGPathElementInternal(const CGPathElementInternal& copy) : CGPathElement(copy) {
        memcpy(this->internalPoints, copy.internalPoints, sizeof(internalPoints));
        this->init();
    }
    // Assignment operator. Used to adjust array pointer after assignment.
    CGPathElementInternal& operator=(const CGPathElementInternal& copy) {
        CGPathElement::operator=(copy);
        memcpy(this->internalPoints, copy.internalPoints, sizeof(internalPoints));
        this->init();
        return *this;
    }
    // This should be called when elements are created with alloc/memcpy
    void init() {
        this->points = internalPoints;
    }
};
typedef struct CGPathElementInternal CGPathElementInternal;

struct __CGPathImpl {
    Microsoft::WRL::ComPtr<ID2D1PathGeometry> pathGeometry{ nullptr };
    Microsoft::WRL::ComPtr<ID2D1GeometrySink> geometrySink{ nullptr };

    bool isFigureClosed;
    CGPoint currentPoint{ 0, 0 };
    CGPoint startingPoint{ 0, 0 };

    __CGPathImpl() : isFigureClosed(true) {
    }
};

struct __CGPath : CoreFoundation::CppBase<__CGPath, __CGPathImpl> {
    // A private helper function for re-opening a path geometry. CGPath does not
    // have a concept of an open and a closed path but D2D relies on it. A
    // path/sink cannot be read from while the path is open thus it must be
    // closed. However, a CGPath can be edited again after being read from so
    // we must open the path again. This cannot be done normally, so we must
    // create a new path with the old path information to edit.
    void preparePathForEditing() {
        if (!_impl.geometrySink) {
            // Re-open this geometry.
            Microsoft::WRL::ComPtr<ID2D1Factory> factory = _GetD2DFactoryInstance();

            // Create temp vars for new path/sink
            Microsoft::WRL::ComPtr<ID2D1PathGeometry> newPath;
            Microsoft::WRL::ComPtr<ID2D1GeometrySink> newSink;

            // Open a new path that the contents of the old path will be streamed
            // into. We cannot re-use the same path as it is now closed and cannot be opened again. We use the newPath variable because the
            // factory was returning the same pointer for some strange reason so this will force it to do otherwise.
            FAIL_FAST_IF_FAILED(factory->CreatePathGeometry(&newPath));
            FAIL_FAST_IF_FAILED(newPath->Open(&newSink));
            FAIL_FAST_IF_FAILED(_impl.pathGeometry->Stream(newSink.Get()));

            _impl.pathGeometry = newPath;
            _impl.geometrySink = newSink;

            // Without a new figure being created, it's by default closed
            _impl.isFigureClosed = true;
        }
    }

    void closePath() {
        if (_impl.geometrySink) {
            endFigure(D2D1_FIGURE_END_OPEN);
            _impl.geometrySink->Close();
            _impl.geometrySink = nullptr;
        }
    }

    void beginFigure() {
        if (_impl.isFigureClosed) {
            _impl.geometrySink->BeginFigure(D2D1::Point2F(_impl.currentPoint.x, _impl.currentPoint.y), D2D1_FIGURE_BEGIN_FILLED);
            _impl.isFigureClosed = false;
        }
    }

    void endFigure(D2D1_FIGURE_END figureStatus) {
        if (!_impl.isFigureClosed) {
            _impl.geometrySink->EndFigure(figureStatus);
            _impl.isFigureClosed = true;
        }
    }
};

#endif
