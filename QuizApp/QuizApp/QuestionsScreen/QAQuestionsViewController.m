//
//  QAQuestionsViewController.m
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QAQuestionsViewController.h"
#import "QAConstants.h"
#import "Categories.h"
#import "Questions.h"
#import "QASpinnerView.h"
#import "QuestionChoices.h"
#import "QACoredataManager.h"
#import "OrderedDictionary.h"
#import "QAQuestionCustomCell.h"
#import "AMProgressView.h"
#import "QAUtility.h"
#import "Player.h"
#import "QAResultViewController.h"

#define QUESTION @"Who invented atom bomb?"

#define QUESTION_DEFAULT_FRAME CGRectMake(27, 148, 904, 0)

@interface QAQuestionsViewController (){

    NSTimer *countDownTimer;
    int questionsAnswered;
}

-(void)createQuestionsAndAnswers;
//-(void)initializeSpinner:(NSTimer *)timer;

@end

float increment;
int oldCheckPoint;

@implementation QAQuestionsViewController
@synthesize lblTimer;
@synthesize lblMessage;
@synthesize done;
@synthesize tblViewQuestions;
@synthesize viewQuestion;
@synthesize delegate;
@synthesize selectedCategory;

- (id)initWithCategory:(Categories*) category{
    if (self == [super init]) {
        // Custom initialization
        self.selectedCategory = category;
        
        questionsAnswered = 0;
        oldCheckPoint     = 0;
        points            = 0;
        timeToFinish      = 0;
        timeTakenForSingleQuestion = 0;
        
        [self getPlayerInfo];
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(fromResult){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    increment = 0;
    timeTakenForSingleQuestion = 0;
    [btnLockTheChoice setEnabled:TRUE];
    
    [self.tblViewQuestions setBackgroundView:nil];
    [self.tblViewQuestions setBackgroundColor:[UIColor clearColor]];
    
    [QAUtility hideRightButtonForNavigationController:self.navigationController hideOption:YES];
    [self addProgressView];
    self.navigationItem.hidesBackButton = YES;
    [btnLockTheChoice setHidden:TRUE];
    //Initially the complexity will be 1; and as the player attempts the question in each category this number will increment.
    
    [self getComplexity];
    selectedChoice  = nil;
    
    //[lblTimer setText:[NSString stringWithFormat:@"%d",timeToFinish]];
    [self getTheQuestion];
    [self getTheChoices];
    [self createQuestionsAndAnswers];
    
    [lblCategory setText:selectedCategory.cat_name];
    [imgViewCategory setImage:[UIImage imageNamed:selectedCategory.cat_theme_image]];

    //    [[self spinnerView] setImage:nil];
    [self.view bringSubviewToFront:viewResult];
    [tblViewQuestions reloadData];
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

#pragma mark- Custom methods
-(void) addProgressView{
    
    
    for(id subView in self.viewQuestion.subviews){
//        if([subView isKindOfClass:[UILabel class]]){
//            [(UILabel *)subView removeFromSuperview];
//        }
        [subView removeFromSuperview];
    }

    AMProgressView *pv5 = [[AMProgressView alloc] initWithFrame:CGRectMake(0, 2, 1024, 43)
                                              andGradientColors:[NSArray arrayWithObjects:[UIColor blackColor], nil]
                                               andOutsideBorder:NO
                                                    andVertical:NO];
    // Configure
    pv5.emptyPartAlpha = 1.0f;
    // Display
    [self.viewQuestion addSubview:pv5];
    
    self.pv1  = pv5;
    increment = 0;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue:) userInfo:nil repeats:YES];
}

- (void)changeValue:(NSTimer*)sender {
    
    NSLog(@"timer running");
    NSTimer *senderTimer = (NSTimer*)sender;
    countDownTimer       = senderTimer;
    
    timeTakenForSingleQuestion++;
    increment         = timeTakenForSingleQuestion-sender.timeInterval;
    self.pv1.progress = increment/30;

    if(increment/30 >= 1.00){
        timeToFinish += timeTakenForSingleQuestion;
        [sender invalidate];
        [btnLockTheChoice setEnabled:FALSE];
    }
    
}


//- (void)initializeSpinner:(NSTimer *)timer
//{
//    countDownTimer = timer;
//    static float prog = 0.0;
//    prog += 0.035;
//    timeToFinish --;
//    if(prog >= 1.0) {
//        prog         = 0.0;
//        [timer invalidate];
//        [lblMessage setText:@"Sorry; you have taken more time"];
//    }
//    [lblTimer setText:[NSString stringWithFormat:@"%d",timeToFinish]];
//    [[self spinnerView] setProgress:prog animated:YES];
//}

-(Player*) getPlayerInfo{
    
    QACoredataManager *coredataManager = [QACoredataManager sharedInstance];

    Player *currentPlayer = [coredataManager player];
    currentPlayer.player_point   = [NSNumber numberWithInt:points];
    currentPlayer.time_to_finish = [NSNumber numberWithInt:timeToFinish];

    return currentPlayer;
    
}

-(void) getTheQuestion{
    
    selectedQuestion = nil;
    
    QACoredataManager *coredataManager      = [QACoredataManager sharedInstance];
    [self getComplexity];
    MutableOrderedDictionary *dicQuestion   = [coredataManager questionForCategory:[NSString stringWithFormat:@"%d",[selectedCategory.cat_id intValue]] withComplexity:[NSString stringWithFormat:@"%d",complexityLevel]];
    
    if([dicQuestion count] > 0){
        NSArray *keys = [dicQuestion allKeys];
        if(keys.count > 0){
            selectedQuestion = [dicQuestion objectForKey:[keys objectAtIndex:0]];
        }
    }
}

-(void) getTheChoices{

    if(arrChoices){
        [arrChoices removeAllObjects];
        arrChoices = nil;
    }
    arrChoices = [[NSMutableArray alloc]init];
    if(selectedQuestion){
        [arrChoices addObject:selectedQuestion.optionA];
        [arrChoices addObject:selectedQuestion.optionB];
        [arrChoices addObject:selectedQuestion.optionC];
        [arrChoices addObject:selectedQuestion.optionD];
    }

//    QACoredataManager *coredataManager      = [QACoredataManager sharedInstance];
//    MutableOrderedDictionary *dicOfChoices  = [coredataManager choicesForQuestion:[NSString stringWithFormat:@"%d",[selectedQuestion.qestion_id intValue]] inCategory:[NSString stringWithFormat:@"%d",[selectedCategory.cat_id intValue]]];
//    
//    if([dicOfChoices count] > 0){
//        dicChoices = dicOfChoices;
//    }
}

-(void) showHideResultView:(BOOL)flag{
    CGRect viewFrame = viewResult.frame;
    
    if(flag){
        //Show the view
        viewFrame.origin.y += 724;
    }
    else{
        //Hide the view
        viewFrame.origin.y -= 724;
    }
    [UIView animateWithDuration:1.0
                          delay:0.1
                        options: UIViewAnimationOptionCurveLinear
                     animations:^
     {
         CGRect newFrame = viewFrame;
         viewResult.frame = newFrame;
     }
                     completion:^(BOOL finished)
     {
     }];
}

-(void) createQuestionsAndAnswers{
    
    UILabel *lblDynamicSize  = [self getDynamicSizedLabelWithString:selectedQuestion.question forWidth:893 forPoint:CGPointMake(40, 5)];
    CGRect questionViewFrame = lblDynamicSize.frame;
    
    questionViewFrame.size.height += 10;
    [self.viewQuestion addSubview:lblDynamicSize];
    self.viewQuestion.frame  = questionViewFrame;
    
//    CGRect tblFrame          = tblViewQuestions.frame;
//    CGFloat tblViewYpos     = lblDynamicSize.frame.size.height+ lblDynamicSize.frame.origin.y+10;
//    tblFrame.origin.y       = tblViewYpos;
//    self.tblViewQuestions.frame  = tblFrame;
}

-(NSString*) optionNumberForIndex:(int) index{
    NSString *optionNum = @"";
    switch (index) {
        case 0:
            optionNum =  @"a";
            break;
        case 1:
            optionNum =  @"b";
            break;
        case 2:
            optionNum =  @"c";
            break;
        case 3:
            optionNum =  @"d";
            break;            
        default:
            break;
    }
    return optionNum;
}

-(UILabel*) getDynamicSizedLabelWithString:(NSString*)labelText forWidth:(CGFloat)lblWidth forPoint:(CGPoint)point
{
    //Create Label
    UIFont *helveticaNueue   = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0f];
    //UIFont *futura = [UIFont fontWithName:@"Futura" size:17];
    UILabel *label      = [[UILabel alloc] init];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:helveticaNueue];
    label.text          = labelText;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    //Set frame according to string

    CGSize size         = [label.text sizeWithFont:helveticaNueue
                                 constrainedToSize:CGSizeMake(lblWidth, MAXFLOAT)
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    [label setFrame:CGRectMake(point.x , point.y , size.width , size.height)];
    //Add Label in current view
    //[self.view addSubview:label];

    return label;
}

-(int) currentCheckPoint{

    int chkPoint;
    if(questionsAnswered == 1){
        chkPoint = 1;
    }
    else if (questionsAnswered > 1 && questionsAnswered < 4){
        chkPoint = 2;
    }
    else if (questionsAnswered > 3 && questionsAnswered < 7){
        chkPoint = 3;
    }
    else {
        chkPoint = 4;
    }
    return chkPoint;
}

-(void) getComplexity{
    complexityLevel  = arc4random()%4;
    if(complexityLevel == 0){
        complexityLevel = 1;
    }
    NSLog(@"complexity--->%d",complexityLevel);
    NSLog(@"Time to finish--->%d",timeToFinish);
}

-(void) saveTheLevelInfo{
    
    Player *currentPlayer        = [self getPlayerInfo];
    currentPlayer.player_point   = [NSNumber numberWithInt:points];
    currentPlayer.time_to_finish = [NSNumber numberWithInt:timeToFinish];
}

#pragma mark-

#pragma mark- Button action
-(IBAction) lockAnswer_TouchUpInside:(id)sender{

    [btnLockTheChoice setEnabled:FALSE];
    [countDownTimer invalidate];
    //if([selectedChoice.is_right_choice intValue] == 0){
    if(![[self optionNumberForIndex:selectedOptionIndex-1] isEqualToString:selectedQuestion.rightOption]){
        [self showHideResultView:NO];
        QAResultViewController *resultViewController = [[QAResultViewController alloc]initWithStatus:@"wrong" andPoint:[NSString stringWithFormat:@"%d",points] andActionStatus:@"Quit the game"];
        resultViewController.delegate = self;
        [self.navigationController pushViewController:resultViewController animated:YES];
    }
    else{
        questionsAnswered++;
        points += 100;
        
        if(points == 1000){
        //Game finished and the player can redeem the gift..
            
            QAResultViewController *resultViewController = [[QAResultViewController alloc]initWithStatus:@"Quiz Completed" andPoint:[NSString stringWithFormat:@"%d",1000] andActionStatus:@"Quit the game"];
            resultViewController.delegate = self;
            [self.navigationController pushViewController:resultViewController animated:YES];
        }
        
        
        //int newCheckPoint = [self currentCheckPoint];
        //if(newCheckPoint  == oldCheckPoint){

        if(questionsAnswered == 1 || questionsAnswered == 3 || questionsAnswered == 6){

            //This means the user just cleared a checkpoint,so reset the complexity and go back to select a new category
            //oldCheckPoint = newCheckPoint;

            QACoredataManager *dataManager = [QACoredataManager sharedInstance];

            [dataManager saveLevelInfo:[self getPlayerInfo] questionInfo:selectedQuestion];
            [dataManager markQuestionAsAttempted:selectedQuestion];
            
            [self getComplexity];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"You have succesfully completed this level.Please select a different category to continue to the next level." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }
        else{
            //In this case the checkpoint stays same;so increase the complexity of the questions
//            complexityLevel++;
//           
//            [self getTheQuestion];
//            [self getTheChoices];
//            [self createQuestionsAndAnswers];
            
            QAResultViewController *resultViewController = [[QAResultViewController alloc]initWithStatus:@"Correct" andPoint:[NSString stringWithFormat:@"%d",points] andActionStatus:@"next"];
            resultViewController.delegate = self;            
            [self.navigationController pushViewController:resultViewController animated:YES];
        }

        return;
    }
    
}

-(IBAction) homeButton_TouchUpInside:(id) sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if([delegate respondsToSelector:@selector(userClearedCheckPoint)]){
            [delegate userClearedCheckPoint];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark-

//#pragma mark- RadioButton delegate
//-(void) selectedOption:(int) optionButtonTag{
//
//    [btnLockTheChoice setHidden:FALSE];
//    selectedChoice = [dicChoices valueForKey:[NSString stringWithFormat:@"%d",optionButtonTag]];
//    
//}
//#pragma mark-


#pragma mark- Tableview delegates & datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [dicChoices count];
    return [arrChoices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"quizcell";
    QAQuestionCustomCell *cell = (QAQuestionCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        NSArray *nibObjects = [[NSBundle mainBundle]loadNibNamed:@"QAQuestionCustomCell" owner:self options:nil];
        for (id item in nibObjects) {
            if ([item isKindOfClass:[QAQuestionCustomCell class]]) {
                cell = (QAQuestionCustomCell *)item;
                break;
            }
        }

        //cell = [cell initWithStyle:(UITableViewCellStyle)UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
//        NSArray *keys = [dicChoices allKeys];
//        NSString *dicKey = [keys objectAtIndex:indexPath.row];
//        QuestionChoices *questionChoice = [dicChoices objectForKey:dicKey];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
//        [cell.lblOption setText:questionChoice.choice];
        [cell.lblOption setText:[arrChoices objectAtIndex:indexPath.row]];
        [cell.lblOptionNumber setText:[self optionNumberForIndex:(int)indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [btnLockTheChoice setHidden:FALSE];
    selectedOptionIndex = (int)indexPath.row+1;
}

#pragma mark-

#pragma mark- resultview delegate

-(void) goToHomeScreen{
    fromResult = TRUE;
}

#pragma mark-
@end
