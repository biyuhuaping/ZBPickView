//
//  ZBPickView.h
//  ZBPickView
//
//  Created by zhoubo on 17/12/20.
//  Copyright (c) 2017年 zhoubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZBPickViewBlock) (NSString *string);

@interface ZBPickView : UIView

@property (copy, nonatomic) ZBPickViewBlock block;

/**
 *  通过plistName添加一个pickView
 *  @param plistName plist文件的名字
 *  @return 带有toolbar的pickview
 */
- (instancetype)initPickViewWithPlistName:(NSString *)plistName;

/**
 *  通过plistName添加一个pickView
 *  @param array 需要显示的数组
 *  @return 带有toolbar的pickview
 */
- (instancetype)initPickViewWithArray:(NSArray *)array;

/**
 通过时间创建一个DatePicker

 @param defaulDate 默认选中时间
 @param datePickerMode 默认mode
 @return 带有toolbar的datePicker
 */
- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode;


//显示本控件
- (void)show;




//设置toobar的文字颜色
- (void)setTintColor:(UIColor *)color;

// 设置toobar的背景颜色
- (void)setToolbarTintColor:(UIColor *)color;

@end
