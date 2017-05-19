//
//  QAHomeScreenViewController.m
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QAHomeScreenViewController.h"
#import "QALeaderboard.h"
#import "QALaunchViewController.h"
#import "QAUtility.h"

@interface QAHomeScreenViewController (){
    
}

-(void) quitQuiz_TouchUpInside;

@end

@implementation QAHomeScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(initializeSpinner:) userInfo:nil repeats:YES];
    [self addQuitQuizButton];
    [QAUtility hideRightButtonForNavigationController:self.navigationController hideOption:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Button action
-(IBAction) leaderboard_TouchUpInside:(id)sender{
    QALeaderboard *leaderboard = [[QALeaderboard alloc]init];
    [self.navigationController pushViewController:leaderboard animated:YES];
}

-(IBAction) launchQuiz_TouchUpInside:(id)sender{
    QALaunchViewController *launchViewController = [[QALaunchViewController alloc]init];
    [self.navigationController pushViewController:launchViewController animated:YES];
}

-(void) quitQuiz_TouchUpInside{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- 

#pragma mark- Custom methods
-(void) addQuitQuizButton{
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quitButton.tag       = 100;
    [quitButton addTarget:self
                  action:@selector(quitQuiz_TouchUpInside)
        forControlEvents:UIControlEventTouchDown];
    
    [quitButton setBackgroundImage:[UIImage imageNamed:@"home_icon.png"]
                         forState:UIControlStateNormal];
    
    quitButton.frame = CGRectMake(975, 21, 30, 30);
    [self.navigationController.view addSubview:quitButton];
}

#pragma mark- 

@end
