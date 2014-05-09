//
//  HGSearchViewController.m
//  WeatherApp
//
//  Created by Hemant on 5/8/14.
//  Copyright (c) 2014 Hemant. All rights reserved.
//

#import "HGSearchViewController.h"
#import "Constants.h"
#import "WeatherCondition.h"
#import "HGAppDelegate.h"
@interface HGSearchViewController ()

@end

@implementation HGSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd/MM/yyyy"];
        self.weatherReport=[[NSMutableArray alloc] init];
        self.cityNames=[[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    float topOffSet=0.0;
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
                topOffSet=22.0;
    }
	//TableView
    _weatherTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44.0+topOffSet, self.view.bounds.size.width, self.view.bounds.size.height-(44.0+topOffSet))];
    [_weatherTableView setDataSource:self];
    [_weatherTableView setDelegate:self];
    [_weatherTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_weatherTableView];
    
    //Search Bar
    _citySearchBar = [[UISearchBar alloc] init];
    [_citySearchBar setPlaceholder:@"Search City1,City2 etc"];
    [_citySearchBar setFrame:CGRectMake(0, topOffSet, self.view.bounds.size.width, 44.0)];
	[_citySearchBar setDelegate:self];
	[_citySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//	_weatherTableView.tableHeaderView = citySearchBar;
    [self.view addSubview:_citySearchBar];
    
    //Spinner view
    self.spinner=[[UIActivityIndicatorView alloc]init];
    [self.spinner setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, (CGRectGetHeight(self.view.bounds)/2))];
    [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner setHidesWhenStopped:YES];
    [self.view addSubview:self.spinner];
    [self.spinner stopAnimating];
    
}

#pragma mark - UITableView data source and delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==0?44.0:50.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.weatherReport count]?[self.weatherReport count]:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [self.weatherReport count]?[[self.weatherReport objectAtIndex:section] count]:1;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     WeatherCondition *condition=[self.weatherReport count]?[[self.weatherReport objectAtIndex:section] objectAtIndex:0]:nil;
    return condition!=nil?[NSString stringWithFormat:@"Forcast for %@",condition.cityName]:@"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
        cell.selectionStyle=UITableViewCellSeparatorStyleNone;
	}
    WeatherCondition *condition=[self.weatherReport count]?[[self.weatherReport objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]:nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    if([self.weatherReport count])
    cell.textLabel.text = (condition!=nil && [condition.date length])?[NSString stringWithFormat:@"Min:%@°/Max:%@° for %@",condition.minTemp,condition.maxTemp,condition.date]:@"Weather forcast not available.";
    else
        cell.textLabel.text =@"";
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
        
   

	return cell;
}
#pragma mark - Scroll Delegate to hide Keyboard
//Hide leyboard when user start scrolling table view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     if(_citySearchBar.isFirstResponder)[_citySearchBar resignFirstResponder];
}
#pragma mark - SearchBar Delegates
//Start searching weather forecast for entered cities.
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    HGAppDelegate *appDel=(HGAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(!appDel.isInternetAvailable)
    {
        [self showAlert:@"Internet connection appears to be offline, try later."];
        return;
    }
    if(searchBar.text && [searchBar.text length]>2){
       
        self.cityNames =[NSMutableArray arrayWithArray:[searchBar.text componentsSeparatedByString:@","] ];
        if([self.cityNames count]){
            if(self.weatherReport)[self.weatherReport removeAllObjects];
            [self.weatherTableView setScrollEnabled:NO];
            [self searchWeatherForCity:[self.cityNames objectAtIndex:0]];
        }
        if(searchBar.isFirstResponder)[searchBar resignFirstResponder];
    }else{
        [self.weatherTableView setScrollEnabled:YES];
        NSLog(@"Need more characters");
        [self showAlert:@"Please enter more characters."];
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
#pragma mark - Orientation Delegates
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
//Allow both Landscape and Portrait orientaitons
- (BOOL)shouldAutorotate{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
//Update UI with respect to current orientation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //Manage Orientation
    _citySearchBar.frame=CGRectMake(0.f, 22.0f, self.view.bounds.size.width, 44.f);
    _weatherTableView.frame = CGRectMake(0.f, 66.0f,self.view.bounds.size.width , self.view.bounds.size.height-66.0);
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight ||
		[[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft){
                  [self.spinner setCenter:CGPointMake(CGRectGetHeight(self.view.bounds)/2, (CGRectGetWidth(self.view.bounds)/2))];
    }else{
                [self.spinner setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, (CGRectGetHeight(self.view.bounds)/2))];
    }
    [_weatherTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Query Openwheathermap API with City name
- (void)searchWeatherForCity:(NSString*)name
{
    
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    NSString *url=[NSString stringWithFormat:kAPI_URL_SEARCH_NAME,name];
    NSURL *searchURL=[NSURL URLWithString:url];
    NSURLRequest *searchReq=[NSURLRequest requestWithURL:searchURL];
   [NSURLConnection sendAsynchronousRequest:searchReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       if(!connectionError)
       {
           [self.weatherTableView setScrollEnabled:YES];
           [self.spinner stopAnimating];
           if(data){
               NSError* error;
               NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //NSLog(@"jsonDict::%@",jsonDict);
               NSMutableArray *weatherReportTemp=[[NSMutableArray alloc]init];
               //Check for error and Success Code
               if(!error && [[jsonDict objectForKey:@"cod"] integerValue]==200)
               {
                  
                   NSString *cityName=[[jsonDict objectForKey:@"city"] objectForKey:@"name"];
                   
                   NSArray *weatherRecords=[[NSArray alloc]initWithArray:[jsonDict objectForKey:@"list"]];
                   for (NSDictionary *dict in weatherRecords) {
                       if([dict isKindOfClass:[NSDictionary class]])
                       {
                           WeatherCondition *condition=[[WeatherCondition alloc]init];
                           condition.cityName=cityName;
                           NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"dt"] doubleValue]];
                           condition.date=[self.dateFormatter stringFromDate:date];
                           condition.minTemp=[NSString stringWithFormat:@"%.0f",[[[dict objectForKey:@"temp"] objectForKey:@"min"] floatValue]];
                           condition.maxTemp=[NSString stringWithFormat:@"%.0f",[[[dict objectForKey:@"temp"] objectForKey:@"max"] floatValue]];
                           condition.weatherDescription=[[[dict objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"];
                           [weatherReportTemp addObject:condition];
                       }
                   }
                   //
                   
                   if([weatherReportTemp count])
                   [self.weatherReport addObject:weatherReportTemp];
                   
//                   [self.allCityWeatherReport addObject:weatherReportTemp];
                   [self.weatherTableView reloadData];
                   if([self.cityNames count])
                   {
                       [self.cityNames removeObjectAtIndex:0];
                       if([self.cityNames count])
                       {
                           [self searchWeatherForCity:[self.cityNames objectAtIndex:0]];
                       }
                   }
               }else if([[jsonDict objectForKey:@"cod"] integerValue]==404)//forcast for city Not Found
               {
                   [self.weatherTableView setScrollEnabled:YES];

                   WeatherCondition *condition=[[WeatherCondition alloc]init];
                   
                   if([self.cityNames count])
                   {
                       condition.cityName=[NSString stringWithFormat:@"%@ not found",[self.cityNames objectAtIndex:0]];
                       condition.minTemp=@"0";
                       condition.maxTemp=@"0";
                       condition.date=@"";
                       NSMutableArray *weatherReportTemp=[[NSMutableArray alloc]init];
                       [self.cityNames removeObjectAtIndex:0];
                       [weatherReportTemp addObject:condition];
                       if([weatherReportTemp count])
                           [self.weatherReport addObject:weatherReportTemp];
                       
                       if([self.cityNames count])
                       {
                           [self searchWeatherForCity:[self.cityNames objectAtIndex:0]];
                       }
                   }
                   [self.weatherTableView reloadData];
                   
                   NSLog(@"City not found");
               }else{
                   [self.weatherTableView setScrollEnabled:YES];
                    NSLog(@"Parsing error");
                   [self showAlert:@"Somthing going wrong, try agian."];
               }
           }else{
               [self.weatherTableView setScrollEnabled:YES];
               //No data from req.
               NSLog(@"No data from Req.");
               [self showAlert:@"Somthing going wrong, try agian."];
               
           }
       }else{
           [self.weatherTableView setScrollEnabled:YES];
           [self.spinner stopAnimating];
           NSLog(@"connection response error%@",connectionError);
           [self showAlert:[connectionError localizedDescription]];
       }
   }];
}
//To various alert messages
- (void)showAlert:(NSString*)message
{
    UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlert show];
}
@end
