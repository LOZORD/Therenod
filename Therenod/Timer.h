//
//  Timer.h
//  Therenod
//
//  Created by Ritvik Upadhyaya on 22/11/14.
//  Copyright (c) 2014 LeoAndRitvik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject {
    NSDate *start;
    NSDate *end;
}

- (void) startTimer;
- (void) stopTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;

@end