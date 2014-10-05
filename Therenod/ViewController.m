//
//  ViewController.m
//  Therenod
//
//  Created by Leo Rudberg on 10/4/14.
//  Copyright (c) 2014 LeoAndRitvik. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
//#import "TGSineWaveToneGenerator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *pitchSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UISwitch *toggle;

@end

@implementation ViewController

//To reset the user defaults!
//NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [switched addTarget:self
                      action:@selector(btnSwitched:) forControlEvents:UIControlEventValueChanged];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"pitch"]!=nil)
        [self.pitchSlider setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"pitch"]];
    else
        [self.volumeSlider setValue:0.0f];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"volume"]!=nil)
        [self.volumeSlider setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"volume"]];
    else
        [self.volumeSlider setValue:0.0f];
    
    [self.toggle setSelected:[[NSUserDefaults standardUserDefaults] boolForKey:@"toggle"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnSwitched:(id)sender {
    BOOL togglePhase;
    if (switched.on) {
        togglePhase = YES;
    }
    else{
        togglePhase = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:togglePhase forKey:@"toggle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    should_play = switched.on;
    [self playSoundWithPitch:pitch withVolume:volume];

}
-(IBAction) switchValueChanged{
    if (!switched.on) {
        [self playSoundWithPitch:pitch withVolume:volume];
    }
    else{
        [self stopSound];
    }
}
-(IBAction) toggleButtonPressed{
    if (switched.on) {
        [switched setOn:NO animated:YES];
    }
    else{
        [switched setOn:YES animated:YES];
    }
}
- (void) playSoundWithPitch:(float)p withVolume:(float)v {
    //[self stopSound]; //otherwise it break :'(

    if (should_play)
    {
        static TGSineWaveToneGenerator * tg = nil;
        tgs = tg;
        //if we have't initialized the tg yet, create it
        if (tg == nil)
        {
            tg = [[TGSineWaveToneGenerator alloc] initWithFrequency:p amplitude:v];
        }
        //otherwise, update the values
        else
        {
            tg->frequency = p;
            tg->amplitude = v;
        }

        [tg play];
    }
    else
    {
        [self stopSound];
    }
}

- (void) stopSound {
    [tgs stop];
}
- (IBAction)pitch_slider:(id)sender {
    pitch = pitch_slider.value;
    [[NSUserDefaults standardUserDefaults] setFloat:pitch forKey:@"pitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"\n\n%f\n", pitch);
    [self playSoundWithPitch:pitch withVolume:volume];
    
}

- (IBAction)volume_slider:(id)sender {
    volume = volume_slider.value;
    [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:@"volume"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self playSoundWithPitch:pitch withVolume:volume];
    NSLog(@"\n\n%f\n", volume);
}

- (float) HumanUnitToTGUnit:(float)hup {
    return 265.075 * exp(0.0120 * hup);
}

@end
