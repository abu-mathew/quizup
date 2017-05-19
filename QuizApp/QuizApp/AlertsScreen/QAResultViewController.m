//
//  QAResultViewController.m
//  QuizApp
//
//  Created by Deepu on 25/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QAResultViewController.h"
#import "QAHomeScreenViewController.h"

@interface QAResultViewController ()

@end

@implementation QAResultViewController
@synthesize statusLabel;
@synthesize pointsLabel;
@synthesize actionButton;


@synthesize statusText;
@synthesize pointsText;
@synthesize actionText;

@synthesize delegate;

- (id)initWithStatus:(NSString*)status andPoint:(NSString*)points andActionStatus:(NSString*)actionStatus
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.statusText = status;
        self.pointsText = points;
        self.actionText = actionStatus;
    }
    return self;
}

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
    
    self.navigationItem.hidesBackButton = YES;        
    [self.statusLabel setText:statusText];
    [self.pointsLabel setText:pointsText];
    [self.actionButton setTitle:actionText forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionButton_TouchUpInside:(id)sender{
    UIButton *btnAction = (UIButton*)sender;
    if([btnAction.titleLabel.text isEqualToString:@"next"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([btnAction.titleLabel.text isEqualToString:@"Quit the game"]){
        //QAHomeScreenViewController *homeScreenViewController = [self.navigationController.viewControllers objectAtIndex:0];
        //[self.navigationController popToViewController:homeScreenViewController animated:YES];
        if([delegate respondsToSelector:@selector(goToHomeScreen)]){
            [delegate goToHomeScreen];
        }
        [self.navigationController popViewControllerAnimated:YES];        
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(IBAction) homeButton_TouchUpInside:(id)sender{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    if([delegate respondsToSelector:@selector(goToHomeScreen)]){
        [delegate goToHomeScreen];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
