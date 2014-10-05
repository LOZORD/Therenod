//
//  ViewController.m
//  Therenod
//
//  Created by Leo Rudberg on 10/4/14.
//  Copyright (c) 2014 LeoAndRitvik. All rights reserved.
//

#import "ViewController.h"
//#import "TGSineWaveToneGenerator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [switched addTarget:self
                      action:@selector(btnSwitched:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnSwitched:(id)sender {
//    if(switched.on){
//        NSLog(@"SWITCH IS ON");
//        pitch = pitch_slider.value;
//        volume = volume_slider.value;
//        [self playSoundWithPitch:pitch withVolume:volume];
//    }else{
//        NSLog(@"SWITCH IS OFF");
//        [self stopSound];
//    }

    should_play = switched.on;
    [self playSoundWithPitch:pitch withVolume:volume];
}

- (void) playSoundWithPitch:(float)p withVolume:(float)v {
    [self stopSound]; //otherwise it break :'(

    if (should_play)
    {
        tg = [[TGSineWaveToneGenerator alloc] initWithFrequency:p amplitude:v];

        [tg play];
    }
    else
    {
        [self stopSound];
    }
}

- (void) stopSound {
    [tg stop];
}
- (IBAction)pitch_slider:(id)sender {
    NSLog(@"YOLOSWAG--p");
    pitch = pitch_slider.value;
    [self playSoundWithPitch:pitch withVolume:volume];
}

- (IBAction)volume_slider:(id)sender {
    NSLog(@"YOLOSWAG--v");
    volume = volume_slider.value;
    [self playSoundWithPitch:pitch withVolume:volume];
}


@end
