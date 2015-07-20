//
//  MZViewController.h
//  MZDayPicker
//
//  Created by Michał Zaborowski on 21.04.2013.
//  Copyright (c) 2013 whitecode Michał Zaborowski. All rights reserved.
//

#import "MZViewController.h"


@interface MZViewController () <MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,assign)NSInteger monthInt;
@property (nonatomic ,assign)NSInteger currentMonth;
@property (nonatomic,assign)NSInteger yearInt;
@property (nonatomic ,assign)NSInteger currentYear;
@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableData = [@[] mutableCopy];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
    
    /*
     *  You can set month, year using:
     *  self.dayPicker.month = 9;
     *  self.dayPicker.year = 2013;
     *  [self.dayPicker setActiveDaysFrom:1 toDay:30];
     *  [self.dayPicker setCurrentDay:15 animated:NO];
     *
     *  or set up date range:
     */
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"dd"];
    [monthFormatter setDateFormat:@"MM"];
    [yearFormatter setDateFormat:@"yyyy"];
    NSString *dayStr = [dayFormatter stringFromDate:date];
    NSString *monthStr = [monthFormatter stringFromDate:date];
    NSString *firstLetter = [monthStr substringToIndex:1];
    NSString *yearStr = [yearFormatter stringFromDate:date];
    if([firstLetter isEqualToString:@"0"])
    {
        monthStr = [monthStr substringFromIndex:1];
    }
    _currentMonth = [monthStr integerValue];
    _monthInt = [monthStr integerValue];
    _currentYear = [yearStr integerValue];
    _yearInt = [yearStr integerValue];
    
    [self.dayPicker setStartDate:[NSDate dateFromDay:[dayStr integerValue] month:_currentMonth year:_currentYear] endDate:[NSDate dateFromDay:5 month:10 year:2020]];
    
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:[dayStr integerValue] month:_currentMonth year:_currentYear] animated:NO];
    
    self.tableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height, self.tableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.frame.size.height);
    self.tableView.hidden = YES;
    
    

    
}

- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Did select day %@",day.day);
    NSDate *date = day.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthStr = [dateFormatter stringFromDate:date];
    NSString *firstLetter = [monthStr substringToIndex:1];
    if([firstLetter isEqualToString:@"0"])
    {
        monthStr = [monthStr substringFromIndex:1];
    }
    _monthInt = [monthStr integerValue];
    NSLog(@"montInt:%ld",(long)_monthInt);
    [self.tableData addObject:day];
    [self.tableView reloadData];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    NSLog(@"Will select day %@",day.day);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    MZDay *day = self.tableData[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",day.day];
    cell.detailTextLabel.text = day.name;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDayPicker:nil];
    [super viewDidUnload];
}

- (IBAction)nestMonth:(id)sender
{
    if(_monthInt ==12)
    {
        _yearInt++;
        _monthInt = 0;
    }
    _monthInt++;
//    [self.dayPicker setStartDate:[NSDate dateFromDay:11 month:7 year:2015] endDate:[NSDate dateFromDay:5 month:10 year:2015]];
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:1 month:_monthInt year:_yearInt] animated:NO];
}

- (IBAction)preMonth:(id)sender {
    if(_monthInt == _currentMonth)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"之前的日期不可预订" delegate:self
    cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
