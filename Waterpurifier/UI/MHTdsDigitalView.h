//
//  MHTdsDigitalView.h
//  MiHome
//
//  Created by wayne on 15/6/25.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHTdsDigitalView : UIView

@property (nonatomic, assign) NSUInteger tdsValue;
@property (nonatomic, retain) UIColor* zeroColor;   //数字0的颜色
@property (nonatomic, retain) UIColor* nonzeroColor;//非0数字的颜色
@property (nonatomic, copy) void (^detailHandler)();

- (void)switchFromDescription:(NSAttributedString *)fromDesc toDescription:(NSAttributedString *)toDesc;

@end
