//
//  ViewController.m
//  Stopwatch
//
//  Created by Reece Carolan on 8/28/14.
//
//

#import "ViewController.h"
#import "StopWatch.h"

@interface ViewController ()

@end

@implementation ViewController

-(IBAction)lap:(id)sender
{
    lapList.text = [NSString stringWithFormat:@"Lap %i    %03i: %02i: %02i: %02i: %02i: %02i \n%@", lapNum, [hh.text intValue], [mm.text intValue], [ss.text intValue], [ms.text intValue], [ex.text intValue], [ns.text intValue], lapList.text];
    lapNum++;
    //lapNum = 1;
    Box.hidden = NO;
}

-(void)convert:(id)sender
{
    converted.text = [NSString stringWithFormat:@"%@", Time];
    converted.hidden = NO;
    Screen.hidden = NO;
}

-(void)counter
{
    NSLog(@"Hello2");
    int HH = [hh.text intValue];
    int MM = [mm.text intValue];
    int SS = [ss.text intValue];
    int MS = [ms.text intValue];
    int EX = [ex.text intValue];
    ex.text = [NSString stringWithFormat:@"%i", EX+1];
    if (EX >= 9) {
        ms.text = [NSString stringWithFormat:@"%i", MS+1];
        ex.text = [NSString stringWithFormat:@"0"];
    }
    if (MS >= 99) {
        ss.text = [NSString stringWithFormat:@"%i", SS+1];
        ms.text = [NSString stringWithFormat:@"00"];
    }
    if (SS >= 59) {
        mm.text = [NSString stringWithFormat:@"%i", MM+1];
        ss.text = [NSString stringWithFormat:@"00"];
    }
    if (MM >= 59) {
        hh.text = [NSString stringWithFormat:@"%i", HH+1];
        mm.text = [NSString stringWithFormat:@"00"];
    }
}

-(void)Calculate
{
    methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    Time = [NSString stringWithFormat:@"%f", executionTime];
    NSRange range = [Time rangeOfString:@"."];
    ns.text = [NSString stringWithFormat:@"%c%c", [Time characterAtIndex:5+range.location], [Time characterAtIndex:6+range.location]];
    ex.text = [NSString stringWithFormat:@"%c%c:", [Time characterAtIndex:3+range.location], [Time characterAtIndex:4+range.location]];
    ms.text = [NSString stringWithFormat:@"%c%c:", [Time characterAtIndex:3-2+range.location], [Time characterAtIndex:4-2+range.location]];
    ss.text = [NSString stringWithFormat:@"%02i:", [Time intValue]%60];
    mm.text = [NSString stringWithFormat:@"%02i:", ([Time intValue]/60)%60];
    hh.text = [NSString stringWithFormat:@"%03i:", ([Time intValue]/3600)%24];
}

-(IBAction)start:(id)sender
{
    NSLog(@"Hello1");
    [self Stop];
    ns.text = [NSString stringWithFormat:@"00"];
    ex.text = [NSString stringWithFormat:@"00:"];
    ms.text = [NSString stringWithFormat:@"00:"];
    ss.text = [NSString stringWithFormat:@"00:"];
    mm.text = [NSString stringWithFormat:@"00:"];
    hh.text = [NSString stringWithFormat:@"000:"];
    dos = 0;
    lapList.text = @"";
    convertToSeconds.hidden = YES;
    converted.hidden = YES;
    Screen.hidden = YES;
    Box.hidden = YES;
    Reset=NO;
    //methodStart = [NSDate date];
    
        //[stopWatch StopWithContext:[NSString stringWithFormat:@"Created %d Records",100]];
    
}

-(void)Stop
{
    if (time) {
        NSLog(@"Hello3");
    [time invalidate];
    time = nil;
    methodFinish = [NSDate date];
    executionTime1 = [methodFinish timeIntervalSinceDate:methodStart];
    
    [stopReset setTitle:@"Start" forState:UIControlStateNormal];
    convertToSeconds.hidden = NO;
    Running = NO;
    Reset = YES;
        
        [[NSUserDefaults standardUserDefaults] setBool:Running forKey:@"Running"];
    Time = [NSString stringWithFormat:@"%f", executionTime1];
    NSRange range = [Time rangeOfString:@"."];
    
    //NSLog(@"executionTime = %f", executionTime1);     *Debugging*
    ns.text = [NSString stringWithFormat:@"%c%c", [Time characterAtIndex:5+range.location], [Time characterAtIndex:6+range.location]];
    //NSLog(@"executionTime = %f", executionTime1);     *Debugging*
    ex.text = [NSString stringWithFormat:@"%c%c:", [Time characterAtIndex:3+range.location], [Time characterAtIndex:4+range.location]];
    ms.text = [NSString stringWithFormat:@"%c%c:", [Time characterAtIndex:3-2+range.location], [Time characterAtIndex:4-2+range.location]];
    ss.text = [NSString stringWithFormat:@"%02i:", [Time intValue]%60];
    mm.text = [NSString stringWithFormat:@"%02i:", ([Time intValue]/60)%60];
    hh.text = [NSString stringWithFormat:@"%03i:", ([Time intValue]/3600)%24];
    }
}

-(IBAction)stopReset:(id)sender
{
    NSLog(@"Hello4");
    NSString *state_ = [sender currentTitle];
    if ([state_ isEqualToString:@"Stop"]) {
        [self Stop];
        NSLog(@"Hello5");
    }
    if ([state_ isEqualToString:@"Start"]) {
        NSLog(@"Hello6");
        if (Running == NO) {
            NSLog(@"Hello7");
            methodStart = [[NSDate date] dateByAddingTimeInterval:-executionTime1];
            if (Reset == NO) {
                NSLog(@"Hello8");
                NSLog(@"HUHUHUH");
                //NSLog(@"Reset is NO");     *Debugging*
                methodStart = [NSDate date];
            }
            converted.hidden = YES;
            Screen.hidden = YES;
            [stopReset setTitle:@"Stop" forState:UIControlStateNormal];
            time = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                    target:self
                                                  selector:@selector(Calculate)
                                                  userInfo:nil
                                                   repeats:YES];
            Running = YES;
        }
    }
}

- (void)viewDidLoad
{
    NSString *t = [[NSUserDefaults standardUserDefaults] objectForKey:@"TheTime"];
    NSLog(@"t is %@", t);
    [super viewDidLoad];
    NSInteger option = [[NSUserDefaults standardUserDefaults] integerForKey:@"ButtonColor"];
    if (option == 2) {
        [stopReset setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [convertToSeconds setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [reset setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [lap setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
        [settings setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
    } else if (option == 3){
        [stopReset setBackgroundImage:[UIImage imageNamed:@"BlueButton.png"] forState:UIControlStateNormal];
        [convertToSeconds setBackgroundImage:[UIImage imageNamed:@"BlueButton.png"] forState:UIControlStateNormal];
        [reset setBackgroundImage:[UIImage imageNamed:@"BlueButton.png"] forState:UIControlStateNormal];
        [lap setBackgroundImage:[UIImage imageNamed:@"BlueButton.png"] forState:UIControlStateNormal];
        [settings setBackgroundImage:[UIImage imageNamed:@"BlueButton.png"] forState:UIControlStateNormal];
    } else {
        [stopReset setBackgroundImage:[UIImage imageNamed:@"GoldButton.png"] forState:UIControlStateNormal];
        [convertToSeconds setBackgroundImage:[UIImage imageNamed:@"GoldButton.png"] forState:UIControlStateNormal];
        [reset setBackgroundImage:[UIImage imageNamed:@"GoldButton.png"] forState:UIControlStateNormal];
        [lap setBackgroundImage:[UIImage imageNamed:@"GoldButton.png"] forState:UIControlStateNormal];
        [settings setBackgroundImage:[UIImage imageNamed:@"GoldButton.png"] forState:UIControlStateNormal];
    }
    
    NSInteger BGColor = [[NSUserDefaults standardUserDefaults] integerForKey:@"BGColor"];
    if (BGColor == 2) {
        BG.image = [UIImage imageNamed:@"GrayBG.png"];
    } else if (BGColor == 3) {
        BG.image = [UIImage imageNamed:@"GoldBG.png"];
    } else if (BGColor == 4) {
        BG.image = [UIImage imageNamed:@"BlueBG.png"];
    } else if (BGColor == 5) {
        BG.image = [UIImage imageNamed:@"MetalBG.png"];
    } else if (BGColor == 6) {
        BG.image = [UIImage imageNamed:@"GreenBG3.png"];
    }else {
        BG.image = [UIImage imageNamed:@"BG.png"];
    }
    
    BOOL ShowIncrements = [[NSUserDefaults standardUserDefaults] boolForKey:@"Increments"];
    if (ShowIncrements == NO) {
        a.hidden = YES;
        b.hidden = YES;
        c.hidden = YES;
        d.hidden = YES;
        e.hidden = YES;
        f.hidden = YES;
    } else{
        mm.textColor = [UIColor whiteColor];
        ms.textColor = [UIColor blueColor];
        ns.textColor = [UIColor whiteColor];
        a.hidden = NO;
        b.hidden = NO;
        c.hidden = NO;
        d.hidden = NO;
        e.hidden = NO;
        f.hidden = NO;
    }
    
    BOOL isRunning = [[NSUserDefaults standardUserDefaults] boolForKey:@"Running"];
    if (isRunning == YES) {
         methodStart = [[NSUserDefaults standardUserDefaults] objectForKey:@"TheTime"];
        time = [NSTimer scheduledTimerWithTimeInterval:0.001
                                                target:self
                                              selector:@selector(Calculate)
                                              userInfo:nil
                                               repeats:YES];
        Running = YES;
        [stopReset setTitle:@"Stop" forState:UIControlStateNormal];
    }
    
    dos = 0;
    Box.hidden = YES;
    lapNum = 1;
    Running = NO;
    Reset = NO;
    convertToSeconds.hidden = YES;
    converted.hidden = YES;
    Screen.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (Running == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:methodStart forKey:@"TheTime"];
        [[NSUserDefaults standardUserDefaults] setBool:Running forKey:@"Running"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
