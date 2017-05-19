//
//  QAQuestionCustomCell.m
//  QuizApp
//
//  Created by Deepu on 21/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QAQuestionCustomCell.h"

@interface QAQuestionCustomCell ()

@end

@implementation QAQuestionCustomCell
@synthesize lblOption;
@synthesize lblOptionNumber;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
    }
    return self;
}

@end
