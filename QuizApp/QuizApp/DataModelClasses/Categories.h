//
//  Categories.h
//  QuizApp
//
//  Created by Deepu on 19/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Categories : NSManagedObject

@property (nonatomic, retain) NSNumber * cat_id;
@property (nonatomic, retain) NSString * cat_name;
@property (nonatomic, retain) NSString * cat_theme_image;

@end
