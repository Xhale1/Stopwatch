//
//  StopWatch.h
//  Stopwatch
//
//  Created by Reece Carolan on 9/3/14.
//
//

#import <Foundation/Foundation.h>


@interface StopWatch : NSObject
{
    uint64_t _start;
    uint64_t _stop;
    uint64_t _elapsed;
}

-(void) Start;
-(void) Stop;
-(void) StopWithContext:(NSString*) context;
-(double) seconds;
-(NSString*) description;
+(StopWatch*) stopWatch;
-(StopWatch*) init;
@end