//
//  Settings.m
//  WatchStop
//
//  Created by Reece Carolan on 10/18/14.
//
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

-(IBAction)Gold:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ButtonColor"];
    [Back setBackgroundImage:[UIImage imageNamed:@"GoldButton.png"] forState:UIControlStateNormal];
}

-(IBAction)Silver:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"ButtonColor"];
    [Back setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
}

-(IBAction)BlueButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"ButtonColor"];
    [Back setBackgroundImage:[UIImage imageNamed:@"BlueButton.png"] forState:UIControlStateNormal];
}

-(IBAction)Gray:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"BGColor"];
    BG.image = [UIImage imageNamed:@"BG.png"];
}

-(IBAction)Linen:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"BGColor"];
    BG.image = [UIImage imageNamed:@"GrayBG.png"];
}

-(IBAction)GoldBG:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"BGColor"];
    BG.image = [UIImage imageNamed:@"GoldBG.png"];
}

-(IBAction)Blue:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"BGColor"];
    BG.image = [UIImage imageNamed:@"BlueBG.png"];
}

-(IBAction)Metal:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"BGColor"];
    BG.image = [UIImage imageNamed:@"MetalBG.png"];
}

-(IBAction)Green:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"BGColor"];
    BG.image = [UIImage imageNamed:@"GreenBG3.png"];
}

-(IBAction)increments:(id)sender
{
    if (!increments.on) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Increments"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Increments"];
    }
}

-(IBAction)Back:(id)sender{
    if (!increments.on) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Increments"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Increments"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    BOOL ShowIncrements = [[NSUserDefaults standardUserDefaults] boolForKey:@"Increments"];
    if (ShowIncrements == NO) {
        increments.on = NO;
    }
    
    NSInteger option = [[NSUserDefaults standardUserDefaults] integerForKey:@"ButtonColor"];
    if (option == 2) {
        [Back setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
    } else if (option == 3){
        [Back setBackgroundImage:[UIImage imageNamed:@"BlueButton.png"] forState:UIControlStateNormal];
    } else {
        [Back setBackgroundImage:[UIImage imageNamed:@"GoldButton.png"] forState:UIControlStateNormal];
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
