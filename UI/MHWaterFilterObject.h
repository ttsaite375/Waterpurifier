//
//  MHWaterFilterObject.h
//  MiHome
//
//  Created by wayne on 15/7/6.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHWaterFilterObject : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, assign) NSInteger usedTime;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, assign) NSInteger usedFlow;
@property (nonatomic, assign) NSInteger totalFlow;
@property (nonatomic, assign) CGFloat lifePercentage; //剩余寿命（百分比）

@end
