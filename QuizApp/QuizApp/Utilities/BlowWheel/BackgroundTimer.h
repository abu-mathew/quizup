//
//  BackgroundTimer.h
//  BlowWheel
//
//  Created by Manu Prasad on 19/02/14.
//  Copyright (c) 2014 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
//Audio
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@class BackgroundTimer;
@protocol BackgroundTimerDelegate <NSObject>

-(void)triggerRotation:(NSNumber*)speed;
-(void)triggerRotation:(NSNumber*)speed withPower:(NSNumber*)power;

@end

@interface BackgroundTimer : NSOperation<AVAudioRecorderDelegate>{
    BOOL _done;
    id<BackgroundTimerDelegate> delegate;    
}

@property(nonatomic,assign) BOOL _done;
@property(nonatomic,strong) id<BackgroundTimerDelegate> delegate;
@property(nonatomic,assign) double lowPassResults;

@end
