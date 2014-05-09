//
//  HGAppDelegate.m
//  WeatherApp
//
//  Created by Hemant on 5/8/14.
//  Copyright (c) 2014 Hemant. All rights reserved.
//

#import "HGAppDelegate.h"
#import "HGSearchViewController.h"
#import "Reachability.h"
@implementation HGAppDelegate
@synthesize isInternetAvailable=isInternetAvailable;

#pragma mark - Reachability Check
-(void)checkReachability
{
    internetReach = [Reachability reachabilityForInternetConnection];
    
	[self updateInterfaceWithReachability: internetReach];
    [internetReach startNotifier];
    
    wifiReach =[Reachability reachabilityForLocalWiFi] ;
    
	[self updateInterfaceWithReachability: wifiReach];
    [wifiReach startNotifier];
    
    hostReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
    
    [self updateInterfaceWithReachability: hostReach];
    [hostReach startNotifier];
    
}
- (void)updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    if(curReach==wifiReach)
    {
        if(netStatus==NotReachable)
        {
            wifiReachable =NO;
        }
        else
        {
            wifiReachable =YES;
        }
    }else if(curReach==hostReach)
    {
        if(netStatus==NotReachable)
        {
            hostReachable =NO;
        }else{
            hostReachable=YES;
        }
    }
    else if(curReach==internetReach)
    {
        if(netStatus==NotReachable)
        {
            internetReachable =NO;
        }else
        {
            internetReachable =YES;
        }
    }
    
    if(hostReachable)
    {
        if(internetReachable || wifiReachable ||hostReachable )
        {
            isInternetAvailable = YES;
        }
        else
        {
            isInternetAvailable = NO;
        }
    }
    else
    {
        isInternetAvailable = NO;
    }
    NSLog(@"isInternetAvailable::%d",isInternetAvailable);
}
- (void)reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    
    @try {
        [curReach isKindOfClass:[Reachability class]];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:%@", [exception debugDescription]);
    }
    @finally {
        //
    }
    
    [self updateInterfaceWithReachability:curReach];
    
}
#pragma mark - App Delegates
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    HGSearchViewController *searchViewController = [[HGSearchViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:searchViewController];
    //REgister observer for Reachability change
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    [self performSelector:@selector(checkReachability) withObject:nil afterDelay:0.5];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
