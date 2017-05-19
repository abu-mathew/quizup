//
//  CenterPointer.m
//  Test_Rotation
//
//  Created by Manu Prasad on 25/11/13.
//  Copyright (c) 2013 Manu Prasad. All rights reserved.
//

#import "CenterPointer.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation CenterPointer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat wheelRadius = self.bounds.size.width-20;
    CGPoint wheelCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,rect.size.width, CGRectGetMidY(self.bounds));
    CGPathAddLineToPoint(path, NULL,rect.size.width-60,CGRectGetMidY(self.bounds)-8);
    CGPathAddLineToPoint(path, NULL,rect.size.width-60,CGRectGetMidY(self.bounds)+8);
    CGPathAddLineToPoint(path, NULL,rect.size.width,CGRectGetMidY(self.bounds));
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    
    CGContextSetFillColorWithColor(context, RGB(242,203,47).CGColor);
//    CGContextSetShadowWithColor(context, CGSizeMake(0, 3), 2.0, RGB(242,203,47).CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 3), 2.0, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, wheelCenter.x,wheelCenter.y);
    CGContextAddEllipseInRect(context, CGRectInset(rect, 50, 50));
    CGContextSetFillColorWithColor(context, RGB(234,166,39).CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(0, 3), 2.0, RGB(234,166,39).CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 3), 2.0, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    
    CGPathRelease(path);
    
}


@end
