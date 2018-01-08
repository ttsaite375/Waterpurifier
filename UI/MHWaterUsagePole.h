//
//  MHWaterUsagePole.h
//  MiHome
//
//  Created by wayne on 15/6/30.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHDataWaterPurifyRecord.h"

@interface MHWaterUsageObject : NSObject

@property (nonatomic, assign) NSInteger inWaterVolume;
@property (nonatomic, assign) NSInteger outWaterVolume;
//@property (nonatomic, assign) NSInteger maxInVolumn; //本次用水统计中最大体积，用来调整统计柱状图的显示比例

@property (nonatomic, assign) NSInteger maxVolumn; //zcm 修改：柱状图的最大高度的极限
@property (nonatomic, copy) NSString* label;
@property (nonatomic, copy) NSString* selectedLabel;
@property (nonatomic, retain) NSDate* time;
@property (nonatomic, assign) MHWaterPurifyRecordType type; //记录类型
@property (nonatomic, retain) MHDataWaterPurifyRecord* record; //净水记录

@end

@interface MHWaterUsagePole : UIView

@property (nonatomic, copy) void(^selectedHandler)(MHWaterUsageObject *);
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) MHWaterUsageObject* usage; //统计数据

//zcm 暴露进水量bar，米二代将隐藏
@property (nonatomic, strong) UIView *inWaterUsageBar;

@end
