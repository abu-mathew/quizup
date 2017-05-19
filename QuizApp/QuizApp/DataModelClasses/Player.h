//
//  Player.h
//  QuizApp
//
//  Created by Deepu on 19/03/14.
//  Copyright (c) 2014 Deepu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * player_id;
@property (nonatomic, retain) NSString * player_image;
@property (nonatomic, retain) NSString * player_name;
@property (nonatomic, retain) NSNumber * player_point;
@property (nonatomic, retain) NSNumber * time_to_finish;

@end
