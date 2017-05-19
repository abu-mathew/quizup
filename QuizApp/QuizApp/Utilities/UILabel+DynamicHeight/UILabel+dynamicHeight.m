//
//  UILabel+dynamicHeight.m
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "UILabel+dynamicHeight.h"
#import "QAConstants.h"

@implementation UILabel (dynamicHeight)

-(float)resizeToFit{
    float height         = [self expectedHeight];
    CGRect newFrame      = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setNumberOfLines:0];
        [self setLineBreakMode:NSLineBreakByCharWrapping];
        
        UIFont *font = [UIFont systemFontOfSize:17.0];
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              font, NSFontAttributeName,
                                              nil];
        CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,9999);
        CGRect expectedLabelRect = [[self text] boundingRectWithSize:maximumLabelSize
                                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                          attributes:attributesDictionary
                                                             context:nil];
        CGSize *expectedLabelSize = &expectedLabelRect.size;
        
        return expectedLabelSize->height;
    }
    else{
        [self setNumberOfLines:0];
        [self setLineBreakMode:UILineBreakModeWordWrap];
        
        CGSize maximumLabelSize  = CGSizeMake(self.frame.size.width,9999);
        CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:[self lineBreakMode]];
        return expectedLabelSize.height;
    }
}

@end
