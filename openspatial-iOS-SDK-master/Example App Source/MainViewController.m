//
//  MainViewController.m
//  Example App
//
//  Created by Neel Bhoopalam on 6/9/14.
//  Copyright (c) 2014 Nod Labs. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "Timer.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property Timer *time;
@property NSArray * DISCRETE_NOTES;
#define CHUNK_SIZE 3
@end

@implementation MainViewController
//@synthesize DISCRETE_NOTES;

uint8_t mode = POINTER_MODE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [self initDISCRETE_NOTES];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void) initDISCRETE_NOTES
{
    self.DISCRETE_NOTES = @[
        @(110.00),
        @(116.54f),
        @(123.47f),
        @(130.81f),
        @(138.59f),
        @(146.83f),
        @(155.56f),
        @(164.81f),
        @(174.61f),
        @(185.0f),
        @(196.0f),
        @(207.65f),
        @(220.0f),
        @(233.08f),
        @(246.94f),
        @(261.63f),
        @(277.18f),
        @(293.66f),
        @(311.13f),
        @(329.63f),
        @(349.23f),
        @(369.99f),
        @(392.0f),
        @(415.3f),
        @(440.0f),
        @(466.16f),
        @(493.88f),
        @(523.25f),
        @(554.37f),
        @(587.33f),
        @(622.25f),
        @(659.26f),
        @(698.46f),
        @(739.99f),
        @(783.99f),
        @(830.61f),
        @(880.0f),
        @(932.33f),
        @(987.77f),
        @(1046.5f),
        @(1108.73f),
        @(1174.66f),
        @(1244.51f),
        @(1318.51f),
        @(1396.91f),
        @(1479.98f),
        @(1568.00f),
        @(1661.20f),
        @(1760.00f)
    ];
}

- (void)viewDidLoad
{
    
    self.HIDServ = [OpenSpatialBluetooth sharedBluetoothServ];
    self.HIDServ.delegate = self;
    xPos = 0.0f;
    yPos = 0.0f;
    xSum = 0;
    ySum = 0;
    pitchIndex = 0;
    self.time = [[Timer alloc] init];
    
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
    int myNumEvents = self.numEvents;
    
    NSLog(@"This is the x value of the pointer event from %@", [pointerEvent.peripheral name]);
    NSLog(@"%hd", [pointerEvent getXValue]);
    
    
    NSLog(@"This is the y value of the pointer event from %@", [pointerEvent.peripheral name]);
    NSLog(@"%hd", [pointerEvent getYValue]);
    
    //yPos += [self NodUnitToHumanUnit:[pointerEvent getYValue]];
    
    
    //we just want -1 or 1 updates
    yPos += ([pointerEvent getYValue]);
    xPos += ([pointerEvent getXValue]);
    
    xSum += [self unitize:xPos];
    ySum += [self unitize:yPos];
    
    
    
    //if we've summed CHUNK_SIZE change vectors, send it for an update
    //this is done for smoothing reasons
    if (myNumEvents % CHUNK_SIZE == 0)
    {
        //int adjX = xSum / CHUNK_SIZE;
        //int adjY = ySum / CHUNK_SIZE;
        
        if (xSum + pitchIndex < 0 || xSum + pitchIndex > [self.DISCRETE_NOTES count])
        {
            //do nothing
        }
        else
        {
            pitchIndex += xSum;
        }
        
        int newPitch = [self.DISCRETE_NOTES objectAtIndex:pitchIndex];
        
        float tguPitch  = [self HumanPitchToTGPitch:[self _NodUnitToHumanUnit:newPitch]];
        float tguVolume = [self HumanVolumeToTGVolume:[self _NodUnitToHumanUnit:100]];
        
        [self playSoundWithPitch:tguPitch withVolume:100.0];
        
        //then reset the sums
        xSum = ySum = 0;
    }
    
    //we want to start with an intial sound
    //increment last (0 % 4 == 0)
    self.numEvents++;
    
    return nil;
}

- (int) unitize:(int) num
{
    if (num > 0)
    {
        return 1;
    }
    else if (num < 0)
    {
        return -1;
    }
    else
    {
        return 0;
    }
}

//LEO' CONVERTERS
//nod = nod distance unit
//huX = human unit (pitch|volume)
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
    NSLog(@"---------////////----------------Number of events:%d",self.numEvents);
}
- (void) stopSound {
    [tgs stop];
}
- (IBAction)beginTherenod:(id)sender {
    should_play = true;
    take_update = true;
    xPos = yPos = 0;
    [self.time startTimer];
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
