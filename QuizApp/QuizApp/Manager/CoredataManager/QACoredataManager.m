//
//  QACoredataManager.m
//  QuizApp
//
//  Created by Deepu on 19/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import "QACoredataManager.h"
#import "QAAppDelegate.h"
#import "Categories.h"
#import "QuestionChoices.h"
#import "OrderedDictionary.h"
#import "PlayerQuestionAnswers.h"

static QACoredataManager *_sharedInstance = nil;

@implementation QACoredataManager

@synthesize fetchedResultsController;

+(QACoredataManager *) sharedInstance {
	
    if(!_sharedInstance) {
		_sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

-(MutableOrderedDictionary*) categories{

    MutableOrderedDictionary *dicCategories       = nil;
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];

    NSError *error   = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(objects.count == 0){
        return dicCategories;
    }
    else{
        dicCategories = [[MutableOrderedDictionary alloc]init];
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *categoryId;
            if([obj isKindOfClass:[Categories class]]){
                Categories *categoryObj = (Categories*)obj;
                categoryId              = [NSString stringWithFormat:@"%d",[categoryObj.cat_id intValue]];
                [dicCategories setObject:categoryObj forKey:categoryId];
            }
        }];
    }
    return dicCategories;
}

-(MutableOrderedDictionary*) questionForCategory:(NSString*)categoryId withComplexity:(NSString*)questionComplexity{
    
    MutableOrderedDictionary *dicQuestion         = nil;
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *categoryPredicate   = [NSPredicate predicateWithFormat:@"(category_id = %@)",categoryId];
    NSPredicate *complexityPredicate = [NSPredicate predicateWithFormat:@"(complexity = %@)",questionComplexity];
    NSPredicate *isActivePredicate   = [NSPredicate predicateWithFormat:@"(is_active = %@)",[NSNumber numberWithInt:0]];
    
    NSArray *arrPredicate            = [NSArray arrayWithObjects:categoryPredicate, complexityPredicate,isActivePredicate, nil];
    NSPredicate *compoundPredicate   = [NSCompoundPredicate andPredicateWithSubpredicates:arrPredicate];
    [fetchRequest setPredicate:compoundPredicate];
     //NSManagedObject *matches = nil;
    
    NSError *error   = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(objects.count == 0){
        return dicQuestion;
    }
    else{
        dicQuestion = [[MutableOrderedDictionary alloc]init];
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *questionId;
            if([obj isKindOfClass:[Questions class]]){
                Questions *questionObj = (Questions*)obj;
                questionId              = [NSString stringWithFormat:@"%d",[questionObj.qestion_id intValue]];
                [dicQuestion setObject:questionObj forKey:questionId];
            }
        }];
    }
    return dicQuestion;
}

-(BOOL) savePlayerInfo:(NSString*)playerName{
    
    BOOL saveStatus = FALSE;
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSError *error = nil;
    NSManagedObject *newPlayer = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Player"
                                    inManagedObjectContext:managedObjectContext];
    
    [newPlayer setValue:playerName forKey:@"player_name"];
    int numPlayers = [self numberOfPlayers];
    numPlayers++;
    [newPlayer setValue:[NSNumber numberWithInt:numPlayers] forKey:@"player_id"];
    appdelegate.currentPlayerId = numPlayers;
    
    saveStatus = [managedObjectContext save:&error];
    return saveStatus;
}

-(BOOL) saveLevelInfo:(Player*)playerObj questionInfo:(Questions*) questionObj{
   
    BOOL saveStatus = FALSE;
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSError *error             = nil;
    
    NSFetchRequest *request    = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"PlayerQuestionAnswers" inManagedObjectContext:managedObjectContext]];
    
    NSPredicate *userPredicate   = [NSPredicate predicateWithFormat:@"(player_id = %@)",[NSNumber numberWithInt:appdelegate.currentPlayerId]];
    [request setPredicate:userPredicate];
        
    NSArray *objects = [managedObjectContext executeFetchRequest:request
                                                           error:&error];

    
    if(objects.count == 0){
        //There is no record for the user so create a new record.
        
        NSManagedObject *newPlayer = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"PlayerQuestionAnswers"
                                      inManagedObjectContext:managedObjectContext];
        
        [newPlayer setValue:playerObj.player_name       forKey:@"player_name"];
        [newPlayer setValue:playerObj.player_id         forKey:@"player_id"];
        [newPlayer setValue:playerObj.player_point      forKey:@"point"];
        [newPlayer setValue:playerObj.time_to_finish    forKey:@"time_to_finish"];
        [newPlayer setValue:questionObj.qestion_id      forKey:@"question_id"];
        [newPlayer setValue:questionObj.category_id     forKey:@"cat_id"];
        
        saveStatus = [managedObjectContext save:&error];
        
    }
    
    else{
        //There are records available for the user,so update the record.
        
        PlayerQuestionAnswers *playerQuestionAnswers = [objects objectAtIndex:0];
        
        [playerQuestionAnswers setValue:playerObj.player_name       forKey:@"player_name"];
        [playerQuestionAnswers setValue:playerObj.player_id         forKey:@"player_id"];
        [playerQuestionAnswers setValue:playerObj.player_point      forKey:@"point"];
        [playerQuestionAnswers setValue:playerObj.time_to_finish    forKey:@"time_to_finish"];
        [playerQuestionAnswers setValue:questionObj.qestion_id      forKey:@"question_id"];
        [playerQuestionAnswers setValue:questionObj.category_id     forKey:@"cat_id"];
        
        saveStatus = [managedObjectContext save:&error];
    }
    

    return saveStatus;
    
}

-(BOOL) markQuestionAsAttempted:(Questions*) question{

    BOOL saveStatus = FALSE;
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSError *error                                = nil;
    NSFetchRequest *request                       = [[NSFetchRequest alloc] init];
    
    NSPredicate *categoryPredicate   = [NSPredicate predicateWithFormat:@"(category_id = %@)",question.category_id];
    NSPredicate *questionPredicate   = [NSPredicate predicateWithFormat:@"(qestion_id = %@)",question.qestion_id];
    NSArray *arrPredicate            = [NSArray arrayWithObjects:categoryPredicate, questionPredicate, nil];
    NSPredicate *compoundPredicate   = [NSCompoundPredicate andPredicateWithSubpredicates:arrPredicate];
    [request setPredicate:compoundPredicate];
    
    
    [request setEntity:[NSEntityDescription entityForName:@"Questions" inManagedObjectContext:managedObjectContext]];
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
    if(objects.count > 0){
        Questions *question = [objects objectAtIndex:0];
        [question setValue:[NSNumber numberWithInt:1] forKey:@"is_active"];
        saveStatus = [managedObjectContext save:&error];
    }
    return saveStatus;
}

-(void) unmarkAllQuestions{
    
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSError *error                                = nil;

    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];

    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(objects.count > 0){
        
        for(Questions *questionObj in objects){
            [questionObj setValue:[NSNumber numberWithInt:0] forKey:@"is_active"];
        }
        [managedObjectContext save:&error];
    }
}

-(int) numberOfPlayers{
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor              = [NSSortDescriptor sortDescriptorWithKey:@"player_id" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error   = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return (int)[objects count];
}

-(int) numberOfFinishedPlayers{
    
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"PlayerQuestionAnswers" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor              = [NSSortDescriptor sortDescriptorWithKey:@"player_id" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error   = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return (int)[objects count];
    
}

-(Player*) player{

    Player *currentPlayer = nil;
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];

    NSPredicate *userPredicate   = [NSPredicate predicateWithFormat:@"(player_id = %@)",[NSNumber numberWithInt:appdelegate.currentPlayerId]];
    [fetchRequest setPredicate:userPredicate];
    
//    NSSortDescriptor *sortDescriptor              = [NSSortDescriptor sortDescriptorWithKey:@"player_id" ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error   = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(objects.count == 0){
        return currentPlayer;
    }
    else{
        currentPlayer = [objects objectAtIndex:[objects count]-1];
    }
    return currentPlayer;
}


-(NSMutableArray*) leaderboard{
    
    NSMutableArray *board = nil;
    
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor              = [NSSortDescriptor sortDescriptorWithKey:@"time_to_finish" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSPredicate *rankPredicate   = [NSPredicate predicateWithFormat:@"(player_point = %@)",[NSNumber numberWithInt:1000]];
    [fetchRequest setPredicate:rankPredicate];
    
    NSError *error   = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(objects.count == 0){
        return board = [objects mutableCopy];
    }
    return board;
}

-(MutableOrderedDictionary*) choicesForQuestion:(NSString*) questionId inCategory:(NSString*)categoryId {
    
    
    MutableOrderedDictionary *dicChoices          = nil;
    QAAppDelegate *appdelegate                    = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext  = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription        = [NSEntityDescription entityForName:@"QuestionChoices" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest                  = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *categoryPredicate   = [NSPredicate predicateWithFormat:@"(cat_id = %@)",categoryId];
    NSPredicate *questionPredicate   = [NSPredicate predicateWithFormat:@"(question_id = %@)",questionId];
    NSArray *arrPredicate            = [NSArray arrayWithObjects:categoryPredicate, questionPredicate, nil];
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:arrPredicate];
    [fetchRequest setPredicate:compoundPredicate];
    
    NSError *error   = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(objects.count == 0){
        return dicChoices;
    }
    else{
        dicChoices = [[MutableOrderedDictionary alloc]init];
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *choiceId;
            if([obj isKindOfClass:[QuestionChoices class]]){
                QuestionChoices *choicesObj = (QuestionChoices*)obj;
                choiceId                    = [NSString stringWithFormat:@"%d",[choicesObj.choice_id intValue]];
                //[dicChoices setValue:choicesObj forKey:choiceId];
                [dicChoices setObject:choicesObj forKey:choiceId];
            }
        }];
    }
    return dicChoices;
}

@end
