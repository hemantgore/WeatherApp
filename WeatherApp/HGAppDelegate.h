//
//  HGAppDelegate.h
//  WeatherApp
//
//  Created by Hemant on 5/8/14.
//  Copyright (c) 2014 Hemant. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;
@interface HGAppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
    BOOL wifiReachable;
    BOOL hostReachable;
    BOOL internetReachable;
    BOOL isInternetAvailable;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isInternetAvailable;
@end
