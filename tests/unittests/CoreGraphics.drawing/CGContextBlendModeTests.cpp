//******************************************************************************
//
// Copyright (c) Microsoft. All rights reserved.
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

#include "DrawingTest.h"
#include <Starboard/SmartTypes.h>
#include <CoreText/CoreText.h>

struct CGNamedBlendMode {
    const char* name;
    CGBlendMode blendMode;
};

CGNamedBlendMode porterDuffBlendModes[] =
    { { "kCGBlendModeMultiply", kCGBlendModeMultiply },     { "kCGBlendModeScreen", kCGBlendModeScreen },
      { "kCGBlendModeDarken", kCGBlendModeDarken },         { "kCGBlendModeLighten", kCGBlendModeLighten },
      { "kCGBlendModeColorBurn", kCGBlendModeColorBurn },   { "kCGBlendModeColorDodge", kCGBlendModeColorDodge },
      { "kCGBlendModeOverlay", kCGBlendModeOverlay },       { "kCGBlendModeSoftLight", kCGBlendModeSoftLight },
      { "kCGBlendModeHardLight", kCGBlendModeHardLight },   { "kCGBlendModeDifference", kCGBlendModeDifference },
      { "kCGBlendModeExclusion", kCGBlendModeExclusion },   { "kCGBlendModeHue", kCGBlendModeHue },
      { "kCGBlendModeSaturation", kCGBlendModeSaturation }, { "kCGBlendModeColor", kCGBlendModeColor },
      { "kCGBlendModeLuminosity", kCGBlendModeLuminosity } };

CGNamedBlendMode blendOperators[] = { { "kCGBlendModeClear", kCGBlendModeClear } };

CGNamedBlendMode compositionModes[] = {
    { "kCGBlendModeNormal", kCGBlendModeNormal },
    { "kCGBlendModeDestinationOver", kCGBlendModeDestinationOver },
    { "kCGBlendModeSourceIn", kCGBlendModeSourceIn },
    { "kCGBlendModeDestinationIn", kCGBlendModeDestinationIn },
    { "kCGBlendModeSourceOut", kCGBlendModeSourceOut },
    { "kCGBlendModeDestinationOut", kCGBlendModeDestinationOut },
    { "kCGBlendModeSourceAtop", kCGBlendModeSourceAtop },
    { "kCGBlendModeDestinationAtop", kCGBlendModeDestinationAtop },
    { "kCGBlendModeXOR", kCGBlendModeXOR },
    { "kCGBlendModePlusLighter", kCGBlendModePlusLighter },
    { "kCGBlendModeCopy", kCGBlendModeCopy },
    { "kCGBlendModePlusDarker", kCGBlendModePlusDarker },
};

CGFloat alphas[] = { 0.5f, 1.f };

class CGContextBlendMode : public WhiteBackgroundTest<>, public ::testing::WithParamInterface<::testing::tuple<CGFloat, CGNamedBlendMode>> {
    CFStringRef CreateOutputFilename() {
        const char* blendModeName = ::testing::get<1>(GetParam()).name;
        CGFloat alpha = ::testing::get<0>(GetParam());
        return CFStringCreateWithFormat(nullptr, nullptr, CFSTR("TestImage.CGContext.Blending_%s.A%1.01f.png"), blendModeName, alpha);
    }
};

TEST_P(CGContextBlendMode, OverlappedEllipses) {
    CGContextRef context = GetDrawingContext();
    CGRect bounds = GetDrawingBounds();
    CGBlendMode blendMode = ::testing::get<1>(GetParam()).blendMode;
    CGFloat alpha = ::testing::get<0>(GetParam());

    bounds = CGRectInset(bounds, 16.f, 16.f);

    CGPoint firstEllipseCenter{ bounds.origin.x + bounds.size.width / 3.f, bounds.origin.y + bounds.size.height / 2.f };
    CGPoint secondEllipseCenter{ firstEllipseCenter.x + (bounds.size.width / 3.f), firstEllipseCenter.y };

    CGContextSetRGBFillColor(context, .25, .71, .95, alpha);
    CGContextFillEllipseInRect(context, _CGRectCenteredOnPoint({ bounds.size.height, bounds.size.height }, firstEllipseCenter));

    CGContextSetBlendMode(context, blendMode);

    CGContextSetRGBFillColor(context, .95, .25, .66, alpha);
    CGContextFillEllipseInRect(context, _CGRectCenteredOnPoint({ bounds.size.height, bounds.size.height }, secondEllipseCenter));
}

INSTANTIATE_TEST_CASE_P(DISABLED_CompositionModes,
                        CGContextBlendMode,
                        ::testing::Combine(::testing::ValuesIn(alphas), ::testing::ValuesIn(compositionModes)));

INSTANTIATE_TEST_CASE_P(DISABLED_PorterDuffModes,
                        CGContextBlendMode,
                        ::testing::Combine(::testing::ValuesIn(alphas), ::testing::ValuesIn(porterDuffBlendModes)));

INSTANTIATE_TEST_CASE_P(DISABLED_OperatorBlendModes,
                        CGContextBlendMode,
                        ::testing::Combine(::testing::ValuesIn(alphas), ::testing::ValuesIn(blendOperators)));

class CGContextTextAA : public WhiteBackgroundTest<>, public ::testing::WithParamInterface<::testing::tuple<int, int, int, int, CGPoint>> {
    CFStringRef CreateOutputFilename() {
        int useAA = ::testing::get<0>(GetParam());
        int useSmoothing = ::testing::get<1>(GetParam());
        int useSubpixel = ::testing::get<2>(GetParam());
        int useQuantization = ::testing::get<3>(GetParam());
        CGPoint origin = ::testing::get<4>(GetParam());
        return CFStringCreateWithFormat(nullptr, nullptr, CFSTR("TextAA_%d_%d_%d_%d_%f.png"), useAA ? 1 : 0, useSmoothing ? 1 : 0, useSubpixel ? 1 : 0, useQuantization ? 1 : 0, origin.x);
    }
};

static std::vector<CGGlyph> __CreateGlyphs() {
    UniChar chars[4] = { 'T', 'E', 'S', 'T' };
    std::vector<CGGlyph> glyphs(4);
    woc::unique_cf<CTFontRef> ctfont{ CTFontCreateWithName(CFSTR("Arial"), 144, nullptr) };
    CTFontGetGlyphsForCharacters(ctfont.get(), chars, glyphs.data(), 4);
    return glyphs;
}

static void __SetFontForContext(CGContextRef context) {
    woc::unique_cf<CGFontRef> font{ CGFontCreateWithFontName(CFSTR("Arial")) };
    CGContextSetFont(context, font.get());
    CGContextSetFontSize(context, 144);
}

static void __SetContextToggles(CGContextRef context, int useAA, int useSmoothing, int useSubpixel, int useQuantization) {
    //General AA
    if (useAA != 2) {
        CGContextSetAllowsAntialiasing(context, useAA == 1);
        CGContextSetShouldAntialias(context, useAA == 1);
    }

    //Smoothing
    if (useSmoothing != 2) {
        CGContextSetAllowsFontSmoothing(context, useSmoothing == 1);
        CGContextSetShouldSmoothFonts(context, useSmoothing == 1);
    }

    //SubPixel
    if (useSubpixel != 2) {
        CGContextSetAllowsFontSubpixelPositioning(context, useSubpixel == 1);
        CGContextSetShouldSubpixelPositionFonts(context, useSubpixel == 1);
    }

    //Quantization
    if (useQuantization != 2) {
        CGContextSetAllowsFontSubpixelQuantization(context, useQuantization == 1);
        CGContextSetShouldSubpixelQuantizeFonts(context, useQuantization == 1);
    }
}

TEST_P(CGContextTextAA, ContextAntialiasToggles) {
    CGContextRef context = GetDrawingContext();
    CGRect bounds = GetDrawingBounds();

    int useAA = ::testing::get<0>(GetParam());
    int useSmoothing = ::testing::get<1>(GetParam());
    int useSubpixel = ::testing::get<2>(GetParam());
    int useQuantization = ::testing::get<3>(GetParam());
    CGPoint origin = ::testing::get<4>(GetParam());
    //__SetContextToggles(context, useAA, useSmoothing, useSubpixel, useQuantization);

    std::vector<CGGlyph> glyphs{ __CreateGlyphs() };
    __SetFontForContext(context);
    CGContextSetTextPosition(context, origin.x, origin.y);
    CGContextShowGlyphs(context, glyphs.data(), glyphs.size());
}

int toggles[] = { 0, 1 };
CGPoint points[] = { {0, 0}, {.25, .25}, {.5, .5}, {.75, .75 } };

INSTANTIATE_TEST_CASE_P(TextRenderModes,
    CGContextTextAA,
    ::testing::Combine(::testing::ValuesIn(toggles), ::testing::ValuesIn(toggles), ::testing::ValuesIn(toggles), ::testing::ValuesIn(toggles), ::testing::ValuesIn(points)));