//
//  QALaunchViewController.m
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QALaunchViewController.h"
#import "QACategoryViewController.h"
#import "QACoredataManager.h"

@interface QALaunchViewController ()

@end

@implementation QALaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Button action
-(IBAction) go_TouchUpInside:(id)sender{
    if(txtFieldPlayerName.text.length <= 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name to continue" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else{
        QACoredataManager *coredataManager = [QACoredataManager sharedInstance];
        int numPlayers                     = [coredataManager numberOfFinishedPlayers];
        if(numPlayers >= 3){
            [coredataManager unmarkAllQuestions];
        }
        
        [coredataManager savePlayerInfo:txtFieldPlayerName.text];
    }
    QACategoryViewController *categoryViewController = [[QACategoryViewController alloc]initWithPlayerName:txtFieldPlayerName.text];
    [self.navigationController pushViewController:categoryViewController animated:YES];
}
#pragma mark-

@end
