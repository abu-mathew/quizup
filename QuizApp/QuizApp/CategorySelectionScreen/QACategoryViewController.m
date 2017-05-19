//
//  QACategoryViewController.m
//  QuizApp
//
//  Created by Deepu on 18/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QACategoryViewController.h"
#import "QACoredataManager.h"
#import "Categories.h"

#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import "Wheel.h"
#import "CenterPointer.h"
#import "OrderedDictionary.h"
#import "QAUtility.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

typedef enum rotationDirection{
    kClockwise,
    kAnticlockwise
} RotationDirection;
RotationDirection direction = kAnticlockwise;

@interface QACategoryViewController ()

@end

BackgroundTimer *backgroundTimer;
int startAngle = 0;
float adjustSectionAngle =0;
Wheel *theWheel;
NSMutableArray *colorBaseArray;
NSMutableArray *colorArray;
NSMutableArray *optionList;
NSMutableArray *iconList;
bool rotating = NO;
CGFloat wheelStartAngle = 0;
CGFloat angleRotated = 0;
NSTimeInterval rotationStartTime;

@implementation QACategoryViewController
@synthesize playerName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithPlayerName:(NSString*)name{
    if(self == [super init]){
        self.playerName = name;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    checkPointClearStatus = FALSE;
    self.navigationItem.hidesBackButton = YES;    
    [QAUtility hideRightButtonForNavigationController:self.navigationController hideOption:YES];
    //NSString *welcomeMessage = [NSString stringWithFormat:@"Welcome %@, Please select a category to continue",playerName];
    //[lblWelcomeMessage setText:welcomeMessage];
    colorBaseArray = [[NSMutableArray alloc]initWithObjects:
                      RGB(43,208,167),
                      RGB(43,208,206),
                      RGB(43,187,208),
                      RGB(43,164,208),
                      RGB(43,152,208),
                      RGB(48,140,225),
                      RGB(43,208,109),
                      RGB(43,208,144),
                      RGB(151,192,0),
                      nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(checkPointClearStatus){
        //This means the user completed a level;so remove the category that he just selected from the list and reload the wheel with the remaining categories
        NSString *selectedCatKey = [NSString stringWithFormat:@"%d",[selectedCategory.cat_id intValue]];
        
        [optionList removeAllObjects];
        [iconList removeAllObjects];
        [colorArray removeAllObjects];
        
        if([dicCategories valueForKey:selectedCatKey]){
            [dicCategories removeObjectForKey:selectedCatKey];
        }
    }
    else{
        //This means the user is coming to the category selection screen from the home page.
        QACoredataManager *coredataManager = [QACoredataManager sharedInstance];
        dicCategories                      = [coredataManager categories];
    }
    [self setUpBlowWheel];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Custom methods

-(void) setUpBlowWheel{
    
    if(theWheel){
        [theWheel removeFromSuperview];
    }
    
    [UIView setAnimationDelegate:self];
    

    int index = 0;
    NSArray *keys = [dicCategories allKeys];
    //options
    optionList = [NSMutableArray arrayWithCapacity:0];

    //icons
    iconList   = [NSMutableArray arrayWithCapacity:0];
    colorArray = [NSMutableArray arrayWithCapacity:0];
    
    if(keys.count > 0){
        for(id choiceObj in dicCategories){
            Categories *category = [dicCategories valueForKey:[keys objectAtIndex:index]];
            if(category){
                [optionList addObject:category.cat_name];
                [iconList addObject:category.cat_theme_image];
                [colorArray addObject:[colorBaseArray objectAtIndex:index]];
            }
            index++;
        }
    }
//    colorArray = [NSMutableArray arrayWithCapacity:0];
//    [colorArray addObject:RGB(43,208,167)];//43,208,167
//    [colorArray addObject:RGB(43,208,206)];//
//    [colorArray addObject:RGB(43,187,208)];//rgb
//    [colorArray addObject:RGB(43,164,208)];//
//    [colorArray addObject:RGB(43,152,208)];//
//    [colorArray addObject:RGB(48,140,225)];//
//    [colorArray addObject:RGB(43,208,109)];//
//    [colorArray addObject:RGB(43,208,144)];//b
//    [colorArray addObject:RGB(151,192,0)];
    
    
    theWheel = [[Wheel alloc]initWithFrame:CGRectMake(0, 0, 500, 500)];
    theWheel.colorList = colorArray;
    theWheel.optionList = optionList;
    theWheel.iconList = iconList;
    theWheel.center = CGPointMake(CGRectGetMidX(self.view.bounds), 380);
    float transformAngle = 360/[optionList count]/2;
    [theWheel setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-transformAngle))];    
    [self.view addSubview:theWheel];
    
    //Center Pointer
    CenterPointer *centerPointer = [[CenterPointer alloc]initWithFrame:CGRectMake(0, 100, 150, 150)];
    centerPointer.center = CGPointMake(CGRectGetMidX(self.view.bounds), 380);
    [self.view addSubview:centerPointer];
    
    transparentView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 400, 400)];
    transparentView.center = CGPointMake(CGRectGetMidX(self.view.bounds), 350);
    [self.view addSubview:transparentView];
    
//    backgroundTimer = [[BackgroundTimer alloc] init];
//    backgroundTimer.delegate = self;
//    NSOperationQueue *queue = [NSOperationQueue new];
//    [queue addOperation:backgroundTimer];
}


-(int) randomNumber{
    return arc4random()%8;
}

#pragma mark- 


#pragma mark- Button action

-(IBAction) homeButton_TouchUpInside:(id) sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark-


#pragma mark - Touch handling
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch   = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView:transparentView];
    if (currentTouchPoint.x > 0 && currentTouchPoint.y >0) {
        wheelStartAngle = atan2f(theWheel.transform.b, theWheel.transform.a);
        angleRotated = 0;
        rotationStartTime = event.timestamp;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch   = [touches anyObject];
    
    CGPoint pointA = [touch locationInView:self.view];
    CGPoint pointB = [touch previousLocationInView:self.view];
    
    direction = [self getRotationDirectionWithCenter:theWheel.center pointA:pointA pointB:pointB];
    
    CGPoint currentTouchPoint = [touch locationInView:transparentView];
    if (currentTouchPoint.x > 0 && currentTouchPoint.y >0) {
        CGPoint circleCenter = CGPointMake(CGRectGetMidX(transparentView.bounds), CGRectGetMidY(transparentView.bounds));
        CGPoint previousTouchPoint = [touch previousLocationInView:transparentView];
        CGFloat angleInRadians = atan2f(currentTouchPoint.y-circleCenter.y, currentTouchPoint.x-circleCenter.x)-atan2f(previousTouchPoint.y-circleCenter.y, previousTouchPoint.x-circleCenter.x);
        angleRotated += fabsf(angleInRadians);
        [self rotateToAngle:angleInRadians];
    }
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSTimeInterval timeElapsed = event.timestamp - rotationStartTime;
    float numberOfRevolutions = angleRotated/(2*M_PI);
    
    [self rotateWithVelocity:(numberOfRevolutions/timeElapsed) direction:direction];
}

#pragma mark - Handling Rotation
#pragma mark -

-(void)rotateToAngle:(CGFloat)angle
{
    if (!rotating) {
        CGFloat currentTransformAngle = atan2f(theWheel.transform.b, theWheel.transform.a);
        theWheel.transform = CGAffineTransformMakeRotation(currentTransformAngle + angle);
        //    [UIView commitAnimations];
    }
}

-(void)rotateWithVelocity:(float)velocity direction:(RotationDirection)direction
{
    if (!rotating) {
        rotating = YES;
        //int rotationAngle = 360.0 * velocity;
        float rotationAngle = 360*velocity*3;
        startAngle = rotationAngle;
        
        if (direction == kAnticlockwise) {
            rotationAngle *= -1;
        }
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 3;
        animation.delegate = self;
        [animation setValue:@"wheelRotation" forKey:@"id"];
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        //animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
        animation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(rotationAngle)];
        [theWheel.layer addAnimation:animation forKey:@"90rotation"];
        theWheel.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(rotationAngle));
        [UIView commitAnimations];
        
        [self.spinButton setEnabled:NO];
        
    }
}

-(void)triggerRotation:(NSNumber*)speed withPower:(NSNumber*)power{
    if (!rotating) {
        direction = kClockwise;
        rotating = YES;
        int rotationSpeed = [speed doubleValue] * 1000;
        //NSLog(@"Roation speed = %d", rotationSpeed);
        int rotationAngle = 360 + rotationSpeed;
        if([power intValue] > 0){
            rotationAngle = rotationAngle * [power intValue];
        }
        startAngle = rotationAngle;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 3;
        animation.delegate = self;
        [animation setValue:@"wheelRotation" forKey:@"id"];
        // animation.additive = YES;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        //animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
        animation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(rotationAngle)];
        [theWheel.layer addAnimation:animation forKey:@"90rotation"];
        theWheel.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(rotationAngle));
        [UIView commitAnimations];
        [self.spinButton setEnabled:NO];
    }
}
#pragma mark -


#pragma mark - Animations
#pragma mark -


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([[anim valueForKey:@"id"] isEqual:@"wheelRotation"]) {
        //adjust to center of section
        CGFloat currentTransformAngle = atan2f(theWheel.transform.b, theWheel.transform.a);
        CGFloat sAngle = currentTransformAngle * 180 / M_PI;
        startAngle = startAngle%360;
        if (direction == kAnticlockwise) {
            startAngle = sAngle;
            if (startAngle<0) {
                startAngle *= -1;
            }
        }
        int adjustSectionCount = startAngle/(360/[optionList count]);
        adjustSectionAngle = (360/[optionList count])*adjustSectionCount;
        float sectionCenter = 0;//adjustSectionAngle - (360/[optionList count]/2);
        if (direction == kClockwise) {
            sectionCenter = adjustSectionAngle - (360/[optionList count]/2);
        }
        else{
            adjustSectionAngle = (360/[optionList count])*(adjustSectionCount+1);
            sectionCenter = adjustSectionAngle + (360/[optionList count]/2);
        }
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 2;
        animation.delegate = self;
        [animation setValue:@"wheelRotationFinished" forKey:@"id"];
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        animation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(startAngle)];
        animation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(sectionCenter)];
        [theWheel.layer addAnimation:animation forKey:@"90rotation"];
        
        theWheel.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(sectionCenter));
        [UIView commitAnimations];
    }
    
    if([[anim valueForKey:@"id"] isEqual:@"wheelRotationFinished"]) {
        choosenCategoryCode = adjustSectionAngle/(360/[optionList count]);
        
        choosenCategoryCode = (int)[optionList count] - choosenCategoryCode;
        
        if (direction == kAnticlockwise) {
            choosenCategoryCode--;
        }
        //choosenCategoryCode++;
        
        if (choosenCategoryCode >= [optionList count]) {
            choosenCategoryCode = 0;
        }
        else if (choosenCategoryCode < 0){
            choosenCategoryCode = 0;
        }
        
        //[self.lblLuckyNo setText:[optionList objectAtIndex:choosenCategoryCode]];
        [self.spinButton setEnabled:YES];
        rotating = NO;
        backgroundTimer.lowPassResults = 0;
        angleRotated = 0;
        [self deleteRecordings];
        

        int index = 0;
        NSArray *keys = [dicCategories allKeys];
        if(keys.count > 0){
            for(id choiceObj in dicCategories){
                Categories *category = [dicCategories valueForKey:[keys objectAtIndex:index]];
                if(category){
                    if([category.cat_name isEqualToString:[optionList objectAtIndex:choosenCategoryCode]]){
                        selectedCategory = category;
                        break;
                    }
                }
                index++;
            }
        }
        
        //selectedCategory  = [dicCategories objectForKey:[NSString stringWithFormat:@"%d",choosenCategoryCode]];
        
        [lblSelectedCategory setText:[NSString stringWithFormat:@"%@, The Category that you just selected is---->%@",self.playerName,selectedCategory.cat_name]];
        [self performSelector:@selector(navigateToQuestionsView) withObject:nil afterDelay:2.0];
    }
}
#pragma mark -

-(void) navigateToQuestionsView{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onAnimationStop)];
    [UIView setAnimationTransition:(UIViewAnimationTransition) 110 forView:theWheel cache:NO];
    [UIView commitAnimations];
    
}

-(void)onAnimationStop{
    if(!questionsViewController){
        questionsViewController = [[QAQuestionsViewController alloc]initWithCategory:selectedCategory];
        questionsViewController.delegate                   = self;
    }
    else{
        questionsViewController.selectedCategory = selectedCategory;
    }
    [self.navigationController pushViewController:questionsViewController animated:YES];
}

-(void) deleteRecordings{
    
    NSError *error = nil;
    NSString *soundFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"MySound.caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    NSData *audioData = [NSData dataWithContentsOfFile:[soundFileURL path] options: 0 error:&error];
    
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[soundFileURL path] error:&error];
    }
    
}

-(RotationDirection)getRotationDirectionWithCenter:(CGPoint)center pointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    RotationDirection direction = kAnticlockwise;
    
    if (pointB.y > pointA.y && pointA.x <= center.x) {
        direction = kClockwise;
    }
    else if (pointB.y < pointA.y && pointA.x >= center.x) {
        direction = kClockwise;
    }
    else if (pointB.x > pointA.x && pointA.y >= center.y) {
        direction = kClockwise;
    }
    else if (pointB.x < pointA.x && pointA.y <= center.y) {
        direction = kClockwise;
    }
    return direction;
}

#pragma mark -

#pragma mark - Timer
#pragma mark -

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
}
#pragma mark -

#pragma mark - QAQuestionsViewController delegate method

-(void) userClearedCheckPoint{

    checkPointClearStatus = TRUE;
    
}

#pragma mark -
@end
