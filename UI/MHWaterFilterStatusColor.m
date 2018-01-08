//
//  MHWaterFilterStatusColor.m
//  MiHome
//
//  Created by liushilou on 16/8/2.
//  Copyright © 2016年 小米移动软件. All rights reserved.
//

#import "MHWaterFilterStatusColor.h"

@implementation MHWaterFilterStatusColor

+ (UIColor *)statusColor:(MHWaterFilterObject *)obj
{
    //lsl修改 修改到期、快到期颜色
    UIColor *color = nil;
    NSInteger days = (NSInteger)((obj.totalTime * obj.lifePercentage)/24);
    NSLog(@"zz days:%ld",days);
    
    if (obj.totalTime > 0) {
        if (days > 0 && days <=15) {
            color = [MHColorUtils colorWithRGB:0xffff9800];
        }else if (days <= 0){
            color = [MHColorUtils colorWithRGB:0xffff4500];
        }else{
            color = [MHColorUtils colorWithRGB:0xff00caed];
        }
        
    }else{
        color = [UIColor grayColor];
    }

    return color;
}

@end
