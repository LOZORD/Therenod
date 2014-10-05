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
    if(switched.on){
        NSLog(@"SWITCH IS ON");
        float pitch = pitch_slider.value;
        float volume = volume_slider.value;
        [self playSoundWithPitch:pitch withVolume:volume];
    }else{
        NSLog(@"SWITCH IS OFF");
        [self stopSound];
    }
}

- (void) playSoundWithPitch:(float)p withVolume:(float)v {
    tg = [[TGSineWaveToneGenerator alloc] initWithFrequency:p amplitude:v];

    [tg play];
}

- (void) stopSound {
    [tg stop];
}




@end
