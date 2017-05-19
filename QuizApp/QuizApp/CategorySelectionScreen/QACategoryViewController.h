//
//  QACategoryViewController.h
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundTimer.h"
#import "QAQuestionsViewController.h"

@class Categories;
@class MutableOrderedDictionary;

@interface QACategoryViewController : UIViewController<BackgroundTimerDelegate,QAQuestionsViewControllerDelegate>{
    NSString *playerName;
    IBOutlet UILabel *lblWelcomeMessage;
    IBOutlet UILabel *lblSelectedCategory;
    Categories *selectedCategory;
    MutableOrderedDictionary *dicCategories;
    
    
    BOOL checkPointClearStatus;
    //BlowWheel variables
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    double lowPassResults;
    UIView *transparentView;
    int choosenCategoryCode;
    QAQuestionsViewController *questionsViewController;
}

@property(nonatomic,strong) NSString *playerName;

@property (weak, nonatomic) IBOutlet UILabel *lblLuckyNo;
@property (weak, nonatomic) IBOutlet UIButton *spinButton;

-(id) initWithPlayerName:(NSString*)name;
- (void)levelTimerCallback:(NSTimer *)timer;
@end
