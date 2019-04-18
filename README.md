# ZBPickView
封装好的PickView，使用时只需要引用，添加几句代码就可以搞定，极其简单、方便！


封装好的PickView，使用时只需要引用，添加几句代码就可以搞定，极其简单、方便！
## 1. 导入头文件：
#import "ZBPickView.h"


## 2. 添加代码：
```
//选择年月日
- (IBAction)buttonAction2:(id)sender {
    ZBPickView *pickView = [[ZBPickView alloc]initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate];
    pickView.block = ^(NSString *string) {
        self.label.text = [self getFomatTime:string formator:@"yyyy-MM-dd"];
    };
    [pickView show];
}
```
或使用自定义数据：
```
//自定义数据
- (IBAction)buttonAction1:(id)sender {
    NSArray *array = @[@[@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030"],@[@"-"],@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"]];
    ZBPickView *pickView = [[ZBPickView alloc]initPickViewWithArray:array];
    pickView.block = ^(NSString *string) {
        self.label.text = string;
    };
    [pickView show];
}
```

## 3. 展示效果：<br/>
![ZBPickView.gif](https://img-blog.csdnimg.cn/20190418113941833.gif)

就这么简单就完成了。

<br><br><br>
简书：https://www.jianshu.com/p/83b0d71df698 <br>
CSDN：https://blog.csdn.net/biyuhuaping/article/details/89375438
