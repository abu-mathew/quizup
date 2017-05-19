//
//  QuestionChoices.h
//  QuizApp
//
//  Created by Deepu on 19/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QuestionChoices : NSManagedObject

@property (nonatomic, retain) NSNumber * cat_id;
@property (nonatomic, retain) NSString * choice;
@property (nonatomic, retain) NSNumber * choice_id;
@property (nonatomic, retain) NSNumber * is_right_choice;
@property (nonatomic, retain) NSNumber * question_id;

@end
