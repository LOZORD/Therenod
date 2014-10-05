//
//  MainViewController.m
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation MainViewController

uint8_t mode = POINTER_MODE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.HIDServ = [OpenSpatialBluetooth sharedBluetoothServ];
    self.HIDServ.delegate = self;
    xPos = 0.0f;
    yPos = 0.0f;
    [super viewDidLoad];
}

-(void) startLoop
{
    [self.HIDServ setMode:mode forDeviceNamed:self.lastNodPeripheral.name];
    if(mode == POINTER_MODE)
    {
        mode = THREE_D_MODE;
    }
    else
    {
        mode = POINTER_MODE;
    }
    [self performSelector:@selector(startLoop) withObject:nil afterDelay:5];
}

-(ButtonEvent *)buttonEventFired: (ButtonEvent *) buttonEvent
{
    NSLog(@"This is the value of button event type from %@", [buttonEvent.peripheral name]);
    switch([buttonEvent getButtonEventType])
    {
        case TOUCH0_DOWN:
            NSLog(@"Touch 0 Down");
            break;
        case TOUCH0_UP:
            NSLog(@"Touch 0 Up");
            break;
        case TOUCH1_DOWN:
            NSLog(@"Touch 1 Down");
            break;
        case TOUCH1_UP:
            NSLog(@"Touch 1 Up");
            break;
        case TOUCH2_DOWN:
            NSLog(@"Touch 2 Down");
            break;
        case TOUCH2_UP:
            NSLog(@"Touch 2 Up");
            break;
        case TACTILE0_DOWN:
            NSLog(@"Tactile 0 Down");
            break;
        case TACTILE0_UP:
            NSLog(@"Tactile 0 Up");
            break;
        case TACTILE1_DOWN:
            NSLog(@"Tactile 1 Down");
            break;
        case TACTILE1_UP:
            NSLog(@"Tactile 1 Up");
            break;
    }
    
    return nil;
}
//- (float) HumanUnitToTGUnit:(float)hup {
//    return 265.075 * exp(0.0120 * hup);
//}
-(PointerEvent *)pointerEventFired: (PointerEvent *) pointerEvent
{
    
    NSLog(@"This is the x value of the pointer event from %@", [pointerEvent.peripheral name]);
    NSLog(@"%hd", [pointerEvent getXValue]);
    
    
    NSLog(@"This is the y value of the pointer event from %@", [pointerEvent.peripheral name]);
    NSLog(@"%hd", [pointerEvent getYValue]);
    
    //yPos += [self NodUnitToHumanUnit:[pointerEvent getYValue]];
    yPos += [pointerEvent getYValue];
    if (yPos > 150) {
        yPos = 150;
    }
    else if (yPos < 0) {
        yPos = 0;
    }
    xPos += [pointerEvent getXValue];
    if (xPos > 150) {
        xPos = 150;
    }
    else if(xPos < 0){
        xPos = 0;
    }
    
    float tguPitch  = [self HumanPitchToTGPitch:[self _NodUnitToHumanUnit:xPos]];
    float tguVolume = [self HumanVolumeToTGVolume:[self _NodUnitToHumanUnit:yPos]];
    
    [self playSoundWithPitch:tguPitch withVolume:tguVolume];
    
    
    return nil;
}

//LEO' CONVERTERS
- (float) _NodUnitToHumanUnit:(short int)ndu
{
    return ndu/1.50;
}

- (float) HumanPitchToTGPitch:(float)hup
{
    return ((hup)/100) * 660 +220;
}

- (float) HumanVolumeToTGVolume:(float)hup
{
    return (hup/11.0) * 100.0;
}

- (void) didConnectToNod: (CBPeripheral*) peripheral
{
    NSLog(@"here");
    self.lastNodPeripheral = peripheral;

}

- (IBAction)subscribeEvents:(UIButton *)sender
{
    [self.HIDServ subscribeToButtonEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToGestureEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToPointerEvents:self.lastNodPeripheral.name];
    [self.HIDServ subscribeToRotationEvents:self.lastNodPeripheral.name];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"trans1"])
    {
        MainViewController *OrigMvc = self;
        ViewController * vc =(ViewController*)[segue destinationViewController];
    }
}
- (void) playSoundWithPitch:(float)p withVolume:(float)v {
    //[self stopSound]; //otherwise it break :'(
    should_play = YES;
    if (should_play)
    {
        static TGSineWaveToneGenerator * tgs = nil;

        //if we have't initialized the tg yet, create it
        if (tgs == nil)
        {
            tgs = [[TGSineWaveToneGenerator alloc] initWithFrequency:p amplitude:v];
        }
        //otherwise, update the values
        else
        {
            tgs->frequency = p;
            tgs->amplitude = v;
        }
        
        [tgs play];
    }
    else
    {
        [self stopSound];
    }
}
- (void) stopSound {
    [tgs stop];
}
- (IBAction)beginTherenod:(id)sender {
    should_play = true;
    xPos = yPos = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _button.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     }
                     completion:NULL];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _button.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }
                     completion:NULL];
}

@end
