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

    TGSineWaveToneGenerator * tgs;
    
    @public
        short int xPos;
        short int yPos;
        int xSum;
        int ySum;
        int pitchIndex;
        BOOL should_play;
        BOOL take_update;
}
@property OpenSpatialBluetooth *HIDServ;
@property CBPeripheral *lastNodPeripheral;
@property int numEvents;

-(void) startLoop;
-(void) initDISCRETE_NOTES;

@end
