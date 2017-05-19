//
//  QALeaderboard.m
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QAUtility.h"
#import "QALeaderboard.h"
#import "QALeaderboardCustomCell.h"
#import "QACoredataManager.h"
#import "Player.h"

@interface QALeaderboard (){
    NSMutableArray *contents;
}
@end

@implementation QALeaderboard

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
    [tblViewLeaderboard setBackgroundView:nil];
    [tblViewLeaderboard setBackgroundColor:[UIColor clearColor]];
    
    QACoredataManager *dataManager = [QACoredataManager sharedInstance];
    board          = [dataManager leaderboard];
    
    [QAUtility hideRightButtonForNavigationController:self.navigationController hideOption:YES];
    self.title = @"Leaderboard";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Tableview delegates & datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;//return [board count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellIdentifier = @"leaderboardcell";
    QALeaderboardCustomCell *cell = (QALeaderboardCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"QALeaderboardCustomCell" owner:self options:nil];
        for (id item in nibObjects) {
            if ([item isKindOfClass:[QALeaderboardCustomCell class]]) {
                cell = (QALeaderboardCustomCell *)item;
                break;
            }
        }
        cell = [cell initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

#pragma mark-

@end
