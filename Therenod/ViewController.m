//
//  ViewController.m
//  Therenod
//
//  Created by Leo Rudberg on 10/4/14.
//  Copyright (c) 2014 LeoAndRitvik. All rights reserved.
//

#import "ViewController.h"

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
    }else{
        NSLog(@"SWITCH IS OFF");
    }
}

//- (void) playSound {
//    [[SinePlayer sp ] alloc init]
//}

@end
