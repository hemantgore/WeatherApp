//
//  WeatherCondition.h
//  WeatherApp
//
//  Created by Hemant on 5/8/14.
//  Copyright (c) 2014 Hemant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherCondition : NSObject
    
@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *day;
@property(nonatomic, strong) NSString *minTemp;
@property(nonatomic, strong) NSString *maxTemp;
@property(nonatomic, strong) NSString *weatherDescription;
@end
