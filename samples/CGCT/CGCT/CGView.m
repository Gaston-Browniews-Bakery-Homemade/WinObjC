//
//  CGView.m
//  CGCT
//
//  Created by Henry Fox on 13/04/2017.
//  Copyright © 2017 Microsoft. All rights reserved.
//

#import "CGView.h"

@implementation CGView {
    DemoTableViewCell* demoToDraw;
};

- (void)updateCurrentDemo:(DemoTableViewCell*)newDemo {
    demoToDraw = newDemo;
}

- (void)drawRect:(CGRect)pos {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [demoToDraw drawDemoIntoContext:context withFrame:self.frame view:self];
}

@end
