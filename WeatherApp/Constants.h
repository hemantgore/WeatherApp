//
//  Constants.h
//  WeatherApp
//
//  Created by Hemant on 5/8/14.
//  Copyright (c) 2014 Hemant. All rights reserved.
//

//Search API
#define kAPI_URL_SEARCH_NAME @"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&mode=json&cnt=14&units=metric&type=accurate&APPID=2a09ec052ffd4b94872a99a1c05e4ee4"
#define  kAPI_URL_SEARCH_LOCATION @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=10&mode=json&cnt=14&units=metric&APPID=2a09ec052ffd4b94872a99a1c05e4ee4"

#import <Foundation/Foundation.h>

@interface Constants : NSObject

@end
