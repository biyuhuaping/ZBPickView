//
//  ZBPickView.m
//  ZBPickView
//
//  Created by zhoubo on 17/12/20.
//  Copyright (c) 2017年 zhoubo. All rights reserved.
//

#import "ZBPickView.h"

#define ZBToobarHeight 40   //toobar的高
#define ZBPickHeight 216    //pick的高
#define ZBPickBgAlpha 0.35  //pick黑色背景的透明度

#define kScreenWidth     CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight    CGRectGetHeight([UIScreen mainScreen].bounds)

@interface ZBPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (copy, nonatomic) NSString *plistName;
@property (strong, nonatomic) NSArray *plistArray;

@property (assign, nonatomic) BOOL isLevelArray;
@property (assign, nonatomic) BOOL isLevelString;
@property (assign, nonatomic) BOOL isLevelDic;

@property (strong, nonatomic) NSDictionary *levelTwoDic;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (assign, nonatomic) NSDate *defaulDate;
@property (assign, nonatomic) NSInteger pickeviewHeight;

@property (strong, nonatomic) NSMutableArray *componentArray;
@property (strong, nonatomic) NSMutableArray *dicKeyArray;

@property (copy, nonatomic) NSMutableArray *state;
@property (copy, nonatomic) NSMutableArray *city;
@property (copy, nonatomic) NSString *resultString;

@property (strong, nonatomic) UIView *backgroundView;

@end


@implementation ZBPickView

- (NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

- (NSArray *)componentArray{
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpToolBar];
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, ZBPickHeight + ZBToobarHeight);
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissPickView)];
        [self.backgroundView addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, ZBPickHeight + ZBToobarHeight);
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissPickView)];
        [self.backgroundView addGestureRecognizer:tap];
    }
    return self;
}


- (instancetype)initPickViewWithPlistName:(NSString *)plistName{
    self = [super init];
    if (self) {
        _plistName = plistName;
        self.plistArray = [self getPlistArrayByplistName:plistName];
        [self setUpPickView];
    }
    return self;
}

- (instancetype)initPickViewWithArray:(NSArray *)array{
    self = [super init];
    if (self) {
        self.plistArray = array;
        [self setArrayClass:array];
        [self setUpPickView];
        
        //寻找当前年、月，让pickerView滚动到指定位置。
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *yyyy = [self getFomatTime:@"yyyy"];
        NSString *MM = [self getFomatTime:@"MM"];
        
        NSInteger row0 = 0;
        NSInteger row1 = 0;
        for (int i = 0; i < [array[0] count]; i ++) {
            if ([array[0][i] isEqualToString:yyyy]) {
                row0 = i;
                break;
            }
        }
        for (int i = 0; i < [array[2] count]; i ++) {
            if ([array[2][i] isEqualToString:MM]) {
                row1 = i;
                break;
            }
        }
        
        [self.pickerView selectRow:row0 inComponent:0 animated:YES];
        [self pickerView:self.pickerView didSelectRow:row0 inComponent:0];
        
        [self.pickerView selectRow:row1 inComponent:2 animated:YES];
        [self pickerView:self.pickerView didSelectRow:row1 inComponent:2];
    }
    return self;
}

- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode{
    self = [super init];
    if (self) {
        _defaulDate = defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
    }
    return self;
}


- (NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array = [[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

- (void)setArrayClass:(NSArray *)array{
    _dicKeyArray = [[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray = YES;
            _isLevelString = NO;
            _isLevelDic = NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]) {
            _isLevelString = YES;
            _isLevelArray = NO;
            _isLevelDic = NO;
        }else if ([levelTwo isKindOfClass:[NSDictionary class]]) {
            _isLevelDic = YES;
            _isLevelString = NO;
            _isLevelArray = NO;
            _levelTwoDic = levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

- (void)setUpPickView{
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.backgroundColor = [UIColor whiteColor];
    _pickerView = pickView;
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.frame = CGRectMake(0, ZBToobarHeight, kScreenWidth, CGRectGetHeight(pickView.frame));
    _pickeviewHeight = CGRectGetHeight(pickView.frame);
    [self addSubview:pickView];
}

- (void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor = [UIColor whiteColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker = datePicker;
    datePicker.frame = CGRectMake(0, ZBToobarHeight, kScreenWidth, CGRectGetHeight(datePicker.frame));
    _pickeviewHeight = CGRectGetHeight(datePicker.frame);
    [self addSubview:datePicker];
}

- (void)setUpToolBar{
    UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(dissmissPickView)];
    UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_queren"] landscapeImagePhone:[UIImage imageNamed:@"icon_queren"] style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_queren"] style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
//    right.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ZBToobarHeight)];
    _toolbar.items = @[lefttem, centerSpace, right];
    _toolbar.frame = CGRectMake(0, 0, kScreenWidth, ZBToobarHeight);

    [self addSubview:_toolbar];
}

#pragma mark - piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSInteger component = 0;
    if (_isLevelArray) {
        component = _plistArray.count;
    } else if (_isLevelString){
        component = 1;
    }else if(_isLevelDic){
        component = [_levelTwoDic allKeys].count*2;
    }
    return component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *rowArray = [[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray = _plistArray[component];
    }else if (_isLevelString){
        rowArray = _plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic = _plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2 == 1) {
                    rowArray = dicValue;
                }else{
                    rowArray = _plistArray;
                }
            }
        }
    }
    return rowArray.count;
}

#pragma mark - UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle = nil;
    if (_isLevelArray) {
        rowTitle = _plistArray[component][row];
    }else if (_isLevelString){
        rowTitle = _plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic = _plistArray[pIndex];
        if(component%2 == 0) {
            rowTitle = _dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]] && component%2 == 1){
                NSArray *bb = aa;
                if (bb.count > row) {
                    rowTitle = aa[row];
                }
            }
        }
    }
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_isLevelDic && component%2 == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString = _plistArray[row];
        
    }else if (_isLevelArray){
        _resultString = @"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i = 0; i < _plistArray.count; i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString = [NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString = [NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        if (component == 0) {
            _state = _dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic = _plistArray[cIndex];
            NSArray *dicValueArray = [dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city = dicValueArray[row];
            }
        }
    }
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [UIView animateWithDuration:0.25 animations:^(void){
        self.frame = CGRectMake(0, kScreenHeight - CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:ZBPickBgAlpha];
    }];
}

//取消
- (void)dissmissPickView {
    [UIView animateWithDuration:0.25 animations:^(void){
        self.frame = CGRectMake(0, kScreenHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL isCompleted){
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

//确定
- (void)doneClick {
    if (_pickerView) {
        if (_resultString) {
            
        }else{
            if (_isLevelString) {
                _resultString = [NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString = @"";
                for (int i = 0; i<_plistArray.count;i++) {
                    _resultString = [NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                if (_state == nil) {
                    _state = _dicKeyArray[0][0];
//                    NSDictionary *dicValueDic = _plistArray[0];
//                    _city = [dicValueDic allValues][0][0];
                }
                if (_city == nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic = _plistArray[cIndex];
                    _city = [dicValueDic allValues][0][0];
                }
                _resultString = [NSString stringWithFormat:@"%@/%@",_state,_city];
//                _resultString = [NSString stringWithFormat:@"%@",_city];
            }
        }
    }else if (_datePicker) {
//        _resultString = [NSString stringWithFormat:@"%@",_datePicker.date];
        //时间戳的值
        _resultString = [NSString stringWithFormat:@"%ld", (long)[_datePicker.date timeIntervalSince1970]];
    }
    if (self.block) {
        self.block(_resultString);
    }
    [self dissmissPickView];
}


//设置toobar的文字颜色
- (void)setTintColor:(UIColor *)color{
    _toolbar.tintColor = color;
}

//设置toobar的背景颜色
- (void)setToolbarTintColor:(UIColor *)color{
    _toolbar.barTintColor = color;
}

//指定格式，获取当前日期
- (NSString *)getFomatTime:(NSString*)formator{
    NSDate *date = [NSDate date];//先转成时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateStyle:NSDateFormatterFullStyle];//设置天的时间格式
    //    [formatter setTimeStyle:NSDateFormatterFullStyle];//设置时的时间格式
    [formatter setDateFormat:formator];
    NSString *stringTime = [formatter stringFromDate:date];
    return stringTime;
}

- (void)dealloc{
    //NSLog(@"销毁了");
}

@end




