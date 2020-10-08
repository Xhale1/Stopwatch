//
//  InfoController.m
//  WatchStop
//
//  Created by Reece Carolan on 12/20/16.
//  Copyright © 2016 Reece Carolan. All rights reserved.
//

#import "InfoController.h"

@interface InfoController ()

@end

@implementation InfoController

-(void)viewWillAppear:(BOOL)animated
{
    [self updateSkin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)blueSkin:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Blue" forKey:@"skinColor"];
    [self updateSkin];
}

-(IBAction)greenSkin:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Green" forKey:@"skinColor"];
    [self updateSkin];
}

-(IBAction)pinkSkin:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Pink" forKey:@"skinColor"];
    [self updateSkin];
}

-(void)updateSkin
{
    NSString *skinColor = [[NSUserDefaults standardUserDefaults] stringForKey:@"skinColor"];
    Background.image = [UIImage imageNamed:[NSString stringWithFormat:@"Background_%@", skinColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
