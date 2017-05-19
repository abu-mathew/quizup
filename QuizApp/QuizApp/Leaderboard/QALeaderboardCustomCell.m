//
//  QALeaderboardCustomCell.m
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QALeaderboardCustomCell.h"

@interface QALeaderboardCustomCell ()

@end

@implementation QALeaderboardCustomCell
@synthesize lblPlayerName;
@synthesize lblPoint;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
    }
    return self;
}

@end
