//
//  YMNumberPickerView.h
//  MiHome
//
//  Created by ChengMinZhang on 2017/11/14.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMNumberPickerView : UIView

@property (nonatomic, assign) NSInteger minValue;       //最小值
@property (nonatomic, assign) NSInteger maxValue;       //最大值
@property (nonatomic, assign) NSInteger interval;       //间隔值
@property (nonatomic, assign) NSInteger defaultValue;   //默认值

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void(^didPickNumber)(NSInteger value);

- (void)show;

@end
