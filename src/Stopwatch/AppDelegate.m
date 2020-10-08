//
//  AppDelegate.m
//  Stopwatch
//
//  Created by Reece Carolan on 8/28/14.
//
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (UIStoryboard *)grabStoryboard {
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone_3.5" bundle:nil];
         NSLog(@"Device has a 3.5inch Display.");
    } else if (height == 568) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
         NSLog(@"Device has a 4inch Display.");
    } else{
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
         NSLog(@"Device is an iPad");
    }
    
    return storyboard;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    UIStoryboard *storyboard = [self grabStoryboard];
    
    // show the storyboard
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[[NSUserDefaults standardUserDefaults] setObject:Time forKey:@"TheTime"];
    [[NSUserDefaults standardUserDefaults] setObject:methodStart forKey:@"TheTime"];
    [[NSUserDefaults standardUserDefaults] setBool:Running forKey:@"Running"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
