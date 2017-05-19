//
//  QALeaderboardCustomCell.h
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QALeaderboardCustomCell : UITableViewCell{
    IBOutlet UILabel *lblPlayerName;
    IBOutlet UILabel *lblPoint;
}

@property(nonatomic,strong) IBOutlet UILabel *lblPlayerName;
@property(nonatomic,strong) IBOutlet UILabel *lblPoint;

@end
