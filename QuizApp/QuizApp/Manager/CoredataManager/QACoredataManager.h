//
//  QACoredataManager.h
//  QuizApp
//
//  Created by Deepu on 19/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Questions.h"

@class OrderedDictionary;
@class MutableOrderedDictionary;

@interface QACoredataManager : NSObject<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    //NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+(QACoredataManager *) sharedInstance;
-(MutableOrderedDictionary*) categories;
-(MutableOrderedDictionary*) questionForCategory:(NSString*)categoryId withComplexity:(NSString*)questionComplexity;
-(MutableOrderedDictionary*) choicesForQuestion:(NSString*) questionId inCategory:(NSString*)categoryId;
-(BOOL) savePlayerInfo:(NSString*)playerName;
-(Player*) player;
-(BOOL) saveLevelInfo:(Player*)playerObj questionInfo:(Questions*) questionObj;
-(int) numberOfPlayers;
-(BOOL) markQuestionAsAttempted:(Questions*) question;
-(void) unmarkAllQuestions;
-(NSMutableArray*) leaderboard;
-(int) numberOfFinishedPlayers;

@end
