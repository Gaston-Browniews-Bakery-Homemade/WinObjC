//
//  PathDemoTableViewCell.m
//  CGCT
//
//  Created by Henry Fox on 12/04/2017.
//  Copyright © 2017 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "PathDemoTableViewCell.h"

@implementation PathDemoTableViewCell

- (void)drawDemoIntoContext:(CGContextRef)context withFrame:(CGRect)bounds view:(UIView*)view {
    view.backgroundColor = [UIColor colorWithRed:.1 green:.3 blue:1 alpha:1];

    CGContextSaveGState(context);

    CGMutablePathRef light = CGPathCreateMutable();
    CGPathMoveToPoint(light, NULL, bounds.size.width * .9, bounds.size.height * .1);
    CGPathAddLineToPoint(light, NULL, 0, 0);
    CGPathAddLineToPoint(light, NULL, 0, bounds.size.height);
    CGPathAddLineToPoint(light, NULL, bounds.size.width * .9, bounds.size.height * .81);

    CGContextSetRGBFillColor(context, .7, .7, 1, .5);
    CGContextAddPath(context, light);
    CGContextDrawPath(context, kCGPathFill);

    CGMutablePathRef windowTR = CGPathCreateMutable();

    CGPoint windowsCorners[] = { CGPointMake(bounds.size.width * .9, bounds.size.height * .1),
                                 CGPointMake(bounds.size.width * .9, bounds.size.height * .45),
                                 CGPointMake(bounds.size.width * .6, bounds.size.height * .45),
                                 CGPointMake(bounds.size.width * .6, bounds.size.height * .2),
                                 CGPointMake(bounds.size.width * .9, bounds.size.height * .1) };

    CGPathAddLines(windowTR, NULL, windowsCorners, 4);

    CGAffineTransform windowTransform = CGAffineTransformIdentity;
    windowTransform = CGAffineTransformScale(windowTransform, 1, -1);
    windowTransform = CGAffineTransformTranslate(windowTransform, 0, -.91 * bounds.size.height);

    CGPathRef windowBR = CGPathCreateCopyByTransformingPath(windowTR, &windowTransform);

    windowTransform = CGAffineTransformTranslate(windowTransform, -bounds.size.width * .05, bounds.size.height * .136);
    windowTransform = CGAffineTransformScale(windowTransform, .7, .7);

    CGPathRef windowBL = CGPathCreateCopyByTransformingPath(windowBR, &windowTransform);

    windowTransform = CGAffineTransformTranslate(windowTransform, 0, .908 * bounds.size.height);
    windowTransform = CGAffineTransformScale(windowTransform, 1, -1);

    CGPathRef windowTL = CGPathCreateCopyByTransformingPath(windowBR, &windowTransform);

    CGContextSetRGBFillColor(context, 1, 1, 1, 1);

    CGContextAddPath(context, windowTL);
    CGContextAddPath(context, windowTR);
    CGContextAddPath(context, windowBL);
    CGContextAddPath(context, windowBR);
    CGContextSetShadow(context, CGSizeMake(10.f, 10.f), 1.0);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);

    // draw tear shaped curve coming out of window. Create using paths.

    CGMutablePathRef tear = CGPathCreateMutable();
    CGPathMoveToPoint(tear, NULL, .5 * bounds.size.width, .6 * bounds.size.height);
    CGPathAddQuadCurveToPoint(tear,
                              NULL,
                              .4 * bounds.size.width,
                              .7 * bounds.size.height,
                              .45 * bounds.size.width,
                              .8 * bounds.size.height);
    CGPathAddArc(
        tear, NULL, .5 * bounds.size.width, .8 * bounds.size.height, .05 * bounds.size.width, M_PI, 3 * M_PI / 2, true); // add circle
    CGPathAddQuadCurveToPoint(tear, NULL, .4 * bounds.size.width, .7 * bounds.size.height, .5 * bounds.size.width, .6 * bounds.size.height);
    CGPathCloseSubpath(tear);

    CGRect tearCircle = CGRectMake(bounds.size.width * .5, bounds.size.height * .8, bounds.size.width * .03, bounds.size.height * .03);
    CGPathAddEllipseInRect(tear, NULL, tearCircle);

    CGRect test = CGRectMake(bounds.size.width * .445, bounds.size.height * .795, bounds.size.width * .005, bounds.size.height * .005);
    CGPathAddRect(tear, NULL, test);

    CGContextAddPath(context, tear);
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextDrawPath(context, kCGPathFillStroke);

    // CGPathaddEllipseInRect(); // Add circle in middle of tear x3 or 4
    // copy it with a vertical flip and change the fill mode.
    // CGPathSetFillMode??;

    // draw some dashed lines coming out as well
    // CGFloat dashes[] = {
    //
    //}
    // CGContextSetDashPattern
    //
    //	// draw a curved ribbon or two and fill with gradient
    //	CGMutablePathRef ribbon = CGPathCreateMutable();
}

@end
