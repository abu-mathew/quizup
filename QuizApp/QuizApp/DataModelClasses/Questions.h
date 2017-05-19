//
//  Questions.h
//  QuizApp
//
//  Created by Deepu on 24/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Questions : NSManagedObject

@property (nonatomic, retain) NSNumber * category_id;
@property (nonatomic, retain) NSNumber * complexity;
@property (nonatomic, retain) NSNumber * is_active;
@property (nonatomic, retain) NSNumber * qestion_id;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * optionA;
@property (nonatomic, retain) NSString * optionB;
@property (nonatomic, retain) NSString * optionC;
@property (nonatomic, retain) NSString * optionD;
@property (nonatomic, retain) NSString * rightOption;

@end
