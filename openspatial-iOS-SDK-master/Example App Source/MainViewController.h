//
//  MainViewController.h
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenSpatialBluetooth.h"
#import "TGSineWaveToneGenerator.h"

@interface MainViewController : UIViewController <OpenSpatialBluetoothDelegate>{

    @public
        float xPos;
        float yPos;
    BOOL should_play;
TGSineWaveToneGenerator * tgs;
}
@property OpenSpatialBluetooth *HIDServ;
@property CBPeripheral *lastNodPeripheral;

-(void) startLoop;

@end
