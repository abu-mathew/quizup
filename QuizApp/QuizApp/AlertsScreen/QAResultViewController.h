//
//  QAResultViewController.h
//  QuizApp
//
//  Created by Deepu on 25/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QAResultViewController;

@protocol QAResultViewControllerDelegate <NSObject>

-(void) goToHomeScreen;

@end


@interface QAResultViewController : UIViewController{
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *pointsLabel;
    IBOutlet UIButton *actionButton;
    id<QAResultViewControllerDelegate> delegate;
}

@property(nonatomic,retain)IBOutlet UILabel *statusLabel;
@property(nonatomic,retain)IBOutlet UILabel *pointsLabel;
@property(nonatomic,retain)IBOutlet UIButton *actionButton;

@property(nonatomic,retain)NSString *statusText;
@property(nonatomic,retain)NSString *pointsText;
@property(nonatomic,retain)NSString *actionText;

@property(nonatomic,strong) id<QAResultViewControllerDelegate> delegate;

- (id)initWithStatus:(NSString*)status andPoint:(NSString*)points andActionStatus:(NSString*)actionStatus;

@end
