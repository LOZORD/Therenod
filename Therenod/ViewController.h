//
//  ViewController.h
//  Therenod
//
//  Created by Leo Rudberg on 10/4/14.
//  Copyright (c) 2014 LeoAndRitvik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGSineWaveToneGenerator.h"


@interface ViewController : UIViewController{
    __weak IBOutlet UISwitch *switched;
    __weak IBOutlet UISlider *pitch_slider;
    __weak IBOutlet UISlider *volume_slider;

    //global tone generator object
    TGSineWaveToneGenerator * tg;

    float pitch;
    float volume;
    BOOL should_play;

    //(IBAction)pitch_slider
}
@end

