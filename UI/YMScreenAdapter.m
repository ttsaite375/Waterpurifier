//
//  YMScreenAdapter.m
//  MiHome
//
//  Created by liushilou on 16/8/1.
//  Copyright © 2016年 小米移动软件. All rights reserved.
//

#import "YMScreenAdapter.h"

@implementation YMScreenAdapter

+ (CGFloat)sizeBy1080:(CGFloat)size
{
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    
//    return ((width*scale)/1080/scale)*size;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat value = round((width * size)/1080);
    return value;
}

+ (CGFloat)sizeBy750:(CGFloat)size
{
   // CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat value = round((width * size)/750);
    return value;
}

+ (CGFloat)fontsizeBy750:(CGFloat)size
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat value = (width * size)/750;
    if (width == 320) {
        value = value * 1.2;
    }
    
    return round(value);
}



@end
