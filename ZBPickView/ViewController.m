//
//  ViewController.m
//  ZBPickView
//
//  Created by 周博 on 2019/4/18.
//  Copyright © 2019 周博. All rights reserved.
//

#import "ViewController.h"
#import "ZBPickView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//自定义数据
- (IBAction)buttonAction1:(id)sender {
    NSArray *array = @[@[@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030"],@[@"-"],@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"]];
    ZBPickView *pickView = [[ZBPickView alloc]initPickViewWithArray:array];
    pickView.block = ^(NSString *string) {
        self.label.text = string;
    };
    [pickView show];
}

//选择年月日
- (IBAction)buttonAction2:(id)sender {
    ZBPickView *pickView = [[ZBPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate];
    pickView.block = ^(NSString *string) {
        self.label.text = [self getFomatTime:string formator:@"yyyy-MM-dd"];
    };
    [pickView show];
}

#pragma mark -
//根据时间戳获取指定格式的时间
- (NSString *)getFomatTime:(NSString *)timeInterval formator:(NSString*)formator{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]];//先转成时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateStyle:NSDateFormatterFullStyle];//设置天的时间格式
    //    [formatter setTimeStyle:NSDateFormatterFullStyle];//设置时的时间格式
    [formatter setDateFormat:formator];
    NSString *stringTime = [formatter stringFromDate:date];
    return stringTime;
}

@end
