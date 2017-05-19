//
//  QAUtility.m
//  QuizApp
//
//  Created by Deepu on 21/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QAUtility.h"

@implementation QAUtility

+(void) hideRightButtonForNavigationController:(UINavigationController*)navController hideOption:(BOOL) option{
    //self.navigationController.view
    for(id subview in [navController.view subviews]){
        if([subview isKindOfClass:[UIButton class]]){
            UIButton *barButton = (UIButton*)subview;
            if(barButton.tag == 100){
                [barButton setHidden:option];
            }
        }
    }
}

@end
