//
//  QAQuestionCustomCell.h
//  QuizApp
//
//  Created by Deepu on 21/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAQuestionCustomCell : UITableViewCell{
    IBOutlet UILabel *lblOption;
    IBOutlet UILabel *lblOptionNumber;
}
@property(nonatomic,strong) IBOutlet UILabel *lblOption;
@property(nonatomic,strong) IBOutlet UILabel *lblOptionNumber;
@end
