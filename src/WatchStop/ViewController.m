//
//  ViewController.m
//  WatchStop
//
//  Created by Reece Carolan on 5/3/16.
//  Copyright © 2016 Reece Carolan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self updateSkin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRunning"];
    
    
    //array = [NSMutableArray arrayWithObject:@"Laps"];
    lapTotal = [NSMutableArray array];
    lapPrev = [NSMutableArray array];
    
    
    tblView.dataSource=self;
    tblView.delegate=self;
    //tblView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [tblView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [tblView reloadData];
    //[self.view addSubview:tblView];
    
    
    [unitSelector addTarget:self action:@selector(changeUnits:) forControlEvents:UIControlEventValueChanged];
    
    NSInteger unitIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"unitIndex"];
    [unitSelector setSelectedSegmentIndex:unitIndex];
    
    
    [lapSelector addTarget:self action:@selector(updateLaps:) forControlEvents:UIControlEventValueChanged];
    
    NSInteger lapIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"lapIndex"];
    [lapSelector setSelectedSegmentIndex:lapIndex];
    /*
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [unitSelector setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    */
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];


}

-(void)updateSkin
{
    NSString *skinColor = [[NSUserDefaults standardUserDefaults] stringForKey:@"skinColor"];
    BarLeft.image = [UIImage imageNamed:[NSString stringWithFormat:@"Bar_%@", skinColor]];
    BarRight.image = [UIImage imageNamed:[NSString stringWithFormat:@"Bar_%@", skinColor]];
    
    Background.image = [UIImage imageNamed:[NSString stringWithFormat:@"Background_%@", skinColor]];
}

-(IBAction)StartStop:(id)sender
{
    BOOL isRunning = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunning"];
    
    if (isRunning) {
        [self Stop];
    } else {
        [self Start];
    }
}

-(IBAction)ResetLap:(id)sender
{
    BOOL isRunning = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunning"];
    
    if (isRunning) {
        [self AddLap];
    } else {
        [self Reset];
    }
}

- (void)changeUnits:(UISegmentedControl*)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"unitIndex"];
    
    [self UpdateLaelsForSeconds:exTime];
}

-(void)Start{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRunning"];
    
    if ([SecondsLabel.text isEqualToString:@"0"]) {
        methodStart = [NSDate date];
        prevTime = 0;
    } else {
        methodStart = [[NSDate date] dateByAddingTimeInterval:-1*exTime];
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001
                                            target:self
                                          selector:@selector(Calculate)
                                          userInfo:nil
                                           repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //StartLapImg.image = [UIImage imageNamed:@"LapButton.png"];
    //StopResetImg.image = [UIImage imageNamed:@"StopButton.png"];
    
    [StartStopButton setTitle:@"STOP" forState:UIControlStateNormal];
    [ResetLapButton setTitle:@"LAP" forState:UIControlStateNormal];
}

-(void)AddLap{
    float time = [self getCurrentTime];
    
    float seconds = fmodf(time, 60);
    int minutes = ((int)time / 60) % 60;
    int hours = time / 3600;
    
    [lapTotal insertObject:[NSString stringWithFormat:@"Lap %lu: %02i:%02i:%05.2f", (unsigned long)[lapTotal count], hours, minutes, seconds] atIndex:0];
    
    time = [self getCurrentTime] - prevTime;
    seconds = fmodf(time, 60);
    minutes = ((int)time / 60) % 60;
    hours = time / 3600;
    
    [lapPrev insertObject:[NSString stringWithFormat:@"Lap %lu: %02i:%02i:%05.2f", (unsigned long)[lapPrev count], hours, minutes, seconds] atIndex:0];
    
    [tblView reloadData];
    
    prevTime = [self getCurrentTime];
}

-(void)updateLaps:(UISegmentedControl*)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"lapIndex"];
    [tblView reloadData];
}

-(void)Stop{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRunning"];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
        
        [self UpdateLaelsForSeconds:[self getCurrentTime]];
        
        //StartLapImg.image = [UIImage imageNamed:@"StartButton.png"];
        //StopResetImg.image = [UIImage imageNamed:@"ResetButton.png"];
        
        [StartStopButton setTitle:@"START" forState:UIControlStateNormal];
        [ResetLapButton setTitle:@"RESET" forState:UIControlStateNormal];
    }
}

-(void)Reset{
    SecondsLabel.text = @"0";
    TimeLabel.text = @"00:00:00";
    
    lapTotal = [NSMutableArray array];
    lapPrev = [NSMutableArray array];
    [tblView reloadData];
}

-(void)Calculate{
    [self UpdateLaelsForSeconds:[self getCurrentTime]];
}

-(void)UpdateLaelsForSeconds:(float)time{
    NSInteger unitIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"unitIndex"];
    
    if (unitIndex == 0) {
        SecondsLabel.text = [NSString stringWithFormat:@"%f", time / 0.02];
    } else if (unitIndex == 1){
        SecondsLabel.text = [NSString stringWithFormat:@"%f", time];
    } else if (unitIndex == 2){
        SecondsLabel.text = [NSString stringWithFormat:@"%f", time / 60];
    } else if (unitIndex == 3){
        SecondsLabel.text = [NSString stringWithFormat:@"%f", time / 3600];
    }
    
    int seconds = (int)time % 60;
    int minutes = ((int)time / 60) % 60;
    int hours = time / 3600;
    
    TimeLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

-(float)getCurrentTime{
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    exTime = executionTime;
    
    return executionTime;
}









- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lapTotal count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Reloading table");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*if (indexPath.row == 0) {
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Lap %li: %@", (long)indexPath.row, [array objectAtIndex:indexPath.row]];
    }*/

    NSInteger lapIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"lapIndex"];
    if (lapIndex == 0) {
        cell.textLabel.text = [lapTotal objectAtIndex:indexPath.row];
    } else{
        cell.textLabel.text = [lapPrev objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
    //[string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5,6)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange([cell.textLabel.text length] - 3,3)];
    cell.textLabel.attributedText = string;
    
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:19];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //cell.textLabel.alpha = 0.8;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Your custom operation
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
