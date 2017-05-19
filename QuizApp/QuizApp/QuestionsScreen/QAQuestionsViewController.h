//
//  QAQuestionsViewController.h
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "QAResultViewController.h"

@class Categories;
@class Questions;
@class QASpinnerView;
@class OrderedDictionary;
@class MutableOrderedDictionary;
@class QuestionChoices;
@class QAProgressView;
@class AMProgressView;
@class QAQuestionsViewController;

@protocol QAQuestionsViewControllerDelegate <NSObject>

-(void) userClearedCheckPoint;

@end

@interface QAQuestionsViewController : UIViewController<RadioButtonDelegate,QAResultViewControllerDelegate>{

    Categories *selectedCategory;
    Questions *selectedQuestion;
    //QuestionChoices *selectedChoice;
    NSString *selectedChoice;
    
    QAProgressView *progressView;
    //MutableOrderedDictionary *dicChoices;
    NSMutableArray *arrChoices;
    
    int complexityLevel;
    int timeToFinish;
    int timeTakenForSingleQuestion;
    
    int points;
    int selectedOptionIndex;
    IBOutlet UIButton *btnLockTheChoice;
    IBOutlet UITableView *tblViewQuestions;
    IBOutlet UIView *viewResult;
    IBOutlet UIView *viewQuestion;
    IBOutlet UILabel *lblCategory;
    IBOutlet UIImageView *imgViewCategory;
    BOOL done;
    
    id<QAQuestionsViewControllerDelegate> delegate;
    BOOL fromResult;
}

- (id)initWithCategory:(Categories*) category;

@property (weak, nonatomic) IBOutlet QASpinnerView *spinnerView;
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UITableView *tblViewQuestions;
@property (strong, nonatomic) IBOutlet UIView *viewQuestion;
@property(nonatomic,assign) BOOL done;
@property (nonatomic, weak) AMProgressView *pv1;

@property(nonatomic,strong) id<QAQuestionsViewControllerDelegate> delegate;
@property(nonatomic,strong) Categories *selectedCategory;

@end
