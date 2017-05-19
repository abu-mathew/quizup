//
//  PlayerQuestionAnswers.h
//  QuizApp
//
//  Created by Deepu on 19/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayerQuestionAnswers : NSManagedObject

@property (nonatomic, retain) NSNumber * cat_id;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * is_right_choice;
@property (nonatomic, retain) NSNumber * player_id;
@property (nonatomic, retain) NSNumber * question_id;
@property (nonatomic, retain) NSNumber * time_to_finish;
@property (nonatomic, retain) NSString * player_name;

@end
