//
//  InsetUILabel.m
//  RetailExecution
//
//  Created by Martin Steiner on 7/25/12.
//  Copyright (c) 2012 SAP Labs. All rights reserved.
//

#import "InsetUILabel.h"

@implementation InsetUILabel

@synthesize insets;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.insets = UIEdgeInsetsMake(-100, 2, -100, 2);
    }
    return self;
}

- (void) drawTextInRect:(CGRect)rect
{   
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

-(CGSize) sizeThatFits:(CGSize)size {
    CGSize preferredSize = [super sizeThatFits:size];
    return CGSizeMake(preferredSize.width + self.insets.left + self.insets.right, preferredSize.height + self.insets.bottom + self.insets.top);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
