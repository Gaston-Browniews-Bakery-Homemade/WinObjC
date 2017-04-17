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
    bool needsToDraw;
};

- (void)updateCurrentDemo:(DemoTableViewCell*)newDemo {
    needsToDraw = true;
    demoToDraw = newDemo;
}

- (void)drawRect:(CGRect)pos {
    if (needsToDraw) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [demoToDraw drawDemoIntoContext:context withFrame:self.frame view:self];
    }
}

@end
