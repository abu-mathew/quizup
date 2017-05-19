//
//  BackgroundTimer.m
//  BlowWheel
//
//  Created by Manu Prasad on 19/02/14.
//  Copyright (c) 2014 Infosys. All rights reserved.
//

#import "BackgroundTimer.h"

@interface BackgroundTimer(){
    
}
@end

AVAudioRecorder *recorder;
double blowPeak;

@implementation BackgroundTimer
@synthesize _done;
@synthesize delegate;
@synthesize lowPassResults;

-(void) main
{
    blowPeak       = 0;
    lowPassResults = 0;
    
    if ([self isCancelled])
    {
        return;
    }

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];

    NSString *soundFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"MySound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    NSError *error = nil;
    
    
    NSData *audioData = [NSData dataWithContentsOfFile:[soundFileURL path] options: 0 error:&error];
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[soundFileURL path] error:&error];
    }

    error = nil;
    recorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    recorder.delegate = self;
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    }
    else
    {
        [recorder prepareToRecord];
  		recorder.meteringEnabled = YES;
        
        BOOL audioHWAvailable = audioSession.inputAvailable;
        if (! audioHWAvailable) {
            UIAlertView *cantRecordAlert =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: @"Audio input hardware not available"
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [cantRecordAlert show];
            return;
        }
  		[recorder record];
    }
    
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.003
                                                      target:self
                                                    selector:@selector(timerCallBack)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //keep the runloop going as long as needed
    while (!_done && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                              beforeDate:[NSDate distantFuture]]);
    
}

-(void) timerCallBack{

    [recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (ALPHA * [recorder peakPowerForChannel:0]));

    peakPowerForChannel = peakPowerForChannel*1.25;
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
	if (lowPassResults > 0.50)
    {
        if (blowPeak < lowPassResults)
        {
            blowPeak = lowPassResults;
        }
        else
        {
            if([delegate respondsToSelector:@selector(triggerRotation:withPower:)]){
                [delegate triggerRotation:[NSNumber numberWithDouble:blowPeak] withPower:[NSNumber numberWithInt:peakPowerForChannel]];
            }
            blowPeak = 0;
        }
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Recording finished succesfully");    
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

@end
