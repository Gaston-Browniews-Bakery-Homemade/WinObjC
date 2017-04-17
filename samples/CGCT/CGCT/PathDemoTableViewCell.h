#import <UIKit/UIKit.h>
#import "DemoTableViewCell.h"

@interface PathDemoTableViewCell : DemoTableViewCell
- (void)drawDemoIntoContext:(CGContextRef)context withFrame:(CGRect)bounds view:(UIView*)view;
@end
