//
//  Wheel.m
//  Test_Rotation
//
//  Created by Manu Prasad on 21/11/13.
//  Copyright (c) 2013 Manu Prasad. All rights reserved.
//

#import "Wheel.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation Wheel

@synthesize colorList;
@synthesize optionList;
@synthesize iconList;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Original Wheel
    CGFloat wheelRadius = self.bounds.size.width/2 - 10;
    CGPoint wheelCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    int divisions = [optionList count];
    float divisionAngle = 360/divisions;
    float startAngle = 0;
    float endAngle = divisionAngle;
    
    for (int i=0; i<divisions; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:wheelCenter];
        //Draw Arc
        if (i==divisions-1) {
            [path addArcWithCenter:wheelCenter radius:wheelRadius startAngle:(DEGREES_TO_RADIANS(startAngle)) endAngle:(DEGREES_TO_RADIANS(360)) clockwise:YES];
        }
        else
        {
        [path addArcWithCenter:wheelCenter radius:wheelRadius startAngle:(DEGREES_TO_RADIANS(startAngle)) endAngle:(DEGREES_TO_RADIANS(endAngle)) clockwise:YES];
        }
        
        [path closePath];
        //Fill
        [((UIColor*)[colorList objectAtIndex:i]) setFill];
        [path fill];
        //Stroke
        [[UIColor whiteColor] setStroke];
        [path setLineWidth:5];
        [path stroke];
        
        //Text
//        UILabel *optionText         = [[UILabel alloc]initWithFrame:CGRectMake(wheelCenter.x, wheelCenter.y, wheelRadius-60, 20)];
//        optionText.text             = [optionList objectAtIndex:i];
//        UIFont *helveticaNueue      = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
//        optionText.font             = helveticaNueue;
//        
//        optionText.textAlignment = NSTextAlignmentRight;
//        optionText.layer.position = wheelCenter;
//        optionText.layer.anchorPoint = CGPointMake(0, .5);
//        optionText.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS((startAngle + divisionAngle/2)));
//        [self addSubview:optionText];
        
        //Icon
        UIImage *img = [UIImage imageNamed:[iconList objectAtIndex:i]];
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        
//        CGPoint iconPosition = CGPointMake(wheelCenter.x + (wheelRadius-30) * cosf(DEGREES_TO_RADIANS((startAngle + divisionAngle/2))),wheelCenter.y + (wheelRadius-30) * sinf(DEGREES_TO_RADIANS((startAngle + divisionAngle/2))));
        
        CGPoint iconPosition = CGPointMake(wheelCenter.x + (wheelRadius-100) * cosf(DEGREES_TO_RADIANS((startAngle + divisionAngle/2))),wheelCenter.y + (wheelRadius-100) * sinf(DEGREES_TO_RADIANS((startAngle + divisionAngle/2))));
         icon.layer.position = iconPosition;
        icon.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS((startAngle + divisionAngle/2)));
        [icon setImage:img];
        [self addSubview:icon];
        
        startAngle = endAngle;
        endAngle += divisionAngle;
    }

}

@end
