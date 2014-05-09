//
//  HGSearchViewController.h
//  WeatherApp
//
//  Created by Hemant on 5/8/14.
//  Copyright (c) 2014 Hemant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    
}
@property (nonatomic, strong) UITableView *weatherTableView;
@property (nonatomic, strong) NSMutableArray *allCityWeatherReport;
@property (nonatomic, strong) NSMutableArray *weatherReport;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UISearchBar *citySearchBar;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableArray *cityNames;
@end
