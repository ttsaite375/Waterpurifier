//
//  MHFilterLifetimeView.h
//  MiHome
//
//  Created by wayne on 15/7/7.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHWaterFilterObject.h"

@interface MHFilterLifetimeView : UIView

@property (nonatomic, retain) MHWaterFilterObject* filterObject;
@property (nonatomic, assign) NSInteger index;

@end
