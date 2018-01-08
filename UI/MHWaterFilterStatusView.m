//
//  MHWaterFilterStatusView.m
//  MiHome
//
//  Created by wayne on 15/6/29.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterFilterStatusView.h"
#import "MHWaterFilterStatusCell.h"
#import "MHWaterpurifierDefine.h"
#import "MHFilterTipsview.h"


#define kDefaultCellId @"defaultCellId"
#define kStatusCellId @"statusCellId"

@interface MHWaterFilterStatusView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) MHFilterTipsview *filterTipsview;

@property (nonatomic,assign) NSInteger reloadNumber;

@end

@implementation MHWaterFilterStatusView
{
    UITableView* _filterStatus;
    
    
//    NSMutableArray * _filterObjects;
    /*zcm 修改：声明数组元素Class*/
    NSMutableArray<MHWaterFilterObject *>* _filterObjects;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reloadNumber = 0;
        [self buildSubviews];
        
        [self reloadFilterStatus:NO];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"MHWaterFilterStatusView dealloc");
    self.filterTipsview = nil;
}


- (void)buildSubviews
{
    _filterStatus = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _filterStatus.backgroundColor = [UIColor clearColor];
    _filterStatus.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    _filterStatus.scrollEnabled = NO;
    _filterStatus.dataSource = self;
    _filterStatus.delegate = self;
    [_filterStatus registerClass:[MHWaterFilterStatusCell class] forCellReuseIdentifier:kStatusCellId];
    [_filterStatus registerClass:[UITableViewCell class] forCellReuseIdentifier:kDefaultCellId];
    [self addSubview:_filterStatus];
    
    [_filterStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (CGSize)intrinsicContentSize
{
    
//    return CGSizeMake(CGRectGetWidth(_filterStatus.frame), 68.0*4+30.0);
    
    //zcm 修改：米二代 ContentSize减少两个滤芯的大小。
    int filterNum = [self.device.model isEqualToString:DeviceModelWaterPuriLX5] ? 2 : 4;
    
    return CGSizeMake(CGRectGetWidth(_filterStatus.frame), 68.0*filterNum+30.0);
}

- (void)reloadFilterStatus:(BOOL)deviceOnline
{
    
    if (_filterObjects == nil) {
        _filterObjects = [NSMutableArray new];
    }
    [_filterObjects removeAllObjects];
    
//    MHWaterFilterObject* object1 = [MHWaterFilterObject new];
//    
//    object1.index = 1;
//    object1.name = WaterpurifierString(@"filter.pp.cotton", @"PP棉滤芯");
//    object1.desc = WaterpurifierString(@"filter.pp.cotton.desc", @"对自来水进行第一级过滤，滤除泥沙、铁锈、纤维等肉眼可见物。前置预处理，滤除相对粒径较大的杂质与颗粒，保护反渗透滤芯，避免反渗透膜污堵。");
//    object1.usedTime = self.device.oneUsedTime;
//    object1.totalTime = self.device.oneTotalTime;
//    object1.usedFlow = self.device.oneUsedFlow;
//    object1.totalFlow = self.device.oneTotalFlow;
//    object1.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.oneUsedTime
//                                                              totalTime:self.device.oneTotalTime
//                                                               usedFlow:self.device.oneUsedFlow
//                                                              totalFlow:self.device.oneTotalFlow];
//    [_filterObjects addObject:object1];
    
//    MHWaterFilterObject* object2 = [MHWaterFilterObject new];
//    
//    object2.index = 2;
//    object2.name = WaterpurifierString(@"filter.front.gac", @"前置活性炭滤芯");
//    object2.desc = WaterpurifierString(@"filter.front.gac.desc", @"对自来水进行第二级过滤，吸附水中的异色、异味、余氯及部分有机物。前置预处理，吸附余氯等物质，保护反渗透滤芯，防止反渗透膜氧化损坏。");
//    object2.usedTime = self.device.twoUsedTime;
//    object2.totalTime = self.device.twoTotalTime;
//    object2.usedFlow = self.device.twoUsedFlow;
//    object2.totalFlow = self.device.twoTotalFlow;
//    object2.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.twoUsedTime
//                                                              totalTime:self.device.twoTotalTime
//                                                               usedFlow:self.device.twoUsedFlow
//                                                              totalFlow:self.device.twoTotalFlow];
//     [_filterObjects addObject:object2];
    
    
    //zcm 米二代标志
    BOOL isWaterPuriLX5 = [self.device.model isEqualToString:DeviceModelWaterPuriLX5];
    
    //zcm 米二代 1号滤芯
    MHWaterFilterObject* object1 = [MHWaterFilterObject new];
    
    if(isWaterPuriLX5) {
        object1.index = 1;
        object1.name = WaterpurifierString(@"filter_3_in_1", @"3合1复合滤芯");
        object1.desc = WaterpurifierString(@"filter_3_in_1_desc", @"前置炭棒过滤I精选韩国进口炭棒，吸附更均匀，更有效吸附余氯、异味及部分有机物；折叠PP滤芯I精选优质折叠PP滤材，过滤面积更大，孔径均匀，纳污量大，利用率更高，使用寿命长一倍，有效滤除泥沙、铁锈等大颗粒杂质；后置炭棒过滤I精选韩国进口炭棒，过滤精度高，吸附能力强，进一步改善口感。");
        object1.usedTime = self.device.oneUsedTime;
        object1.totalTime = self.device.oneTotalTime;
        object1.usedFlow = self.device.oneUsedFlow;
        object1.totalFlow = self.device.oneTotalFlow;
        object1.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.oneUsedTime
                                                                  totalTime:self.device.oneTotalTime
                                                                   usedFlow:self.device.oneUsedFlow
                                                                  totalFlow:self.device.oneTotalFlow];
    }else { //zcm 米一代 1号滤芯
        object1.index = 1;
        object1.name = WaterpurifierString(@"filter.pp.cotton", @"PP棉滤芯");
        object1.desc = WaterpurifierString(@"filter.pp.cotton.desc", @"对自来水进行第一级过滤，滤除泥沙、铁锈、纤维等肉眼可见物。前置预处理，滤除相对粒径较大的杂质与颗粒，保护反渗透滤芯，避免反渗透膜污堵。");
        object1.usedTime = self.device.oneUsedTime;
        object1.totalTime = self.device.oneTotalTime;
        object1.usedFlow = self.device.oneUsedFlow;
        object1.totalFlow = self.device.oneTotalFlow;
        object1.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.oneUsedTime
                                                                  totalTime:self.device.oneTotalTime
                                                                   usedFlow:self.device.oneUsedFlow
                                                                  totalFlow:self.device.oneTotalFlow];
    }
    
    [_filterObjects addObject:object1];
    
    /*zcm 米二代 2号滤芯*/
    MHWaterFilterObject* object2 = [MHWaterFilterObject new];
    
    if(isWaterPuriLX5) {
        object2.index = 2;
        object2.name = WaterpurifierString(@"filter.ro", @"RO反渗透滤芯");
        object2.desc = WaterpurifierString(@"filter_ro_2_desc", @"对自来水进行第二级过滤，滤除水中的重金属、细菌、水垢、有机物等杂质。理论过滤精度可达0.0001微米，其使用寿命和去除效果受当地水质、用户使用习惯及前两级滤芯的处理能力的影响。");
        object2.usedTime = self.device.twoUsedTime;
        object2.totalTime = self.device.twoTotalTime;
        object2.usedFlow = self.device.twoUsedFlow;
        object2.totalFlow = self.device.twoTotalFlow;
        object2.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.twoUsedTime
                                                                  totalTime:self.device.twoTotalTime
                                                                   usedFlow:self.device.twoUsedFlow
                                                                  totalFlow:self.device.twoTotalFlow];
    }else { /*zcm 米一代2号滤芯*/
        object2.index = 2;
        object2.name = WaterpurifierString(@"filter.front.gac", @"前置活性炭滤芯");
        object2.desc = WaterpurifierString(@"filter.front.gac.desc", @"对自来水进行第二级过滤，吸附水中的异色、异味、余氯及部分有机物。前置预处理，吸附余氯等物质，保护反渗透滤芯，防止反渗透膜氧化损坏。");
        object2.usedTime = self.device.twoUsedTime;
        object2.totalTime = self.device.twoTotalTime;
        object2.usedFlow = self.device.twoUsedFlow;
        object2.totalFlow = self.device.twoTotalFlow;
        object2.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.twoUsedTime
                                                                  totalTime:self.device.twoTotalTime
                                                                   usedFlow:self.device.twoUsedFlow
                                                                  totalFlow:self.device.twoTotalFlow];
    }
    
    [_filterObjects addObject:object2];
    
    
//    MHWaterFilterObject* object3 = [MHWaterFilterObject new];
//    object3.index = 3;
//    object3.name = WaterpurifierString(@"filter.ro", @"RO反渗透滤芯");
//    object3.desc = WaterpurifierString(@"filter.ro.desc", @"对自来水进行第三级过滤，滤除水中的重金属、细菌、水垢、有机物等杂质。理论过滤精度可达0.0001微米，其使用寿命和去除效果受当地水质、用户使用习惯及前两级滤芯的处理能力的影响。");
//    object3.usedTime = self.device.threeUsedTime;
//    object3.totalTime = self.device.threeTotalTime;
//    object3.usedFlow = self.device.threeUsedFlow;
//    object3.totalFlow = self.device.threeTotalFlow;
//    object3.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.threeUsedTime
//                                                              totalTime:self.device.threeTotalTime
//                                                               usedFlow:self.device.threeUsedFlow
//                                                              totalFlow:self.device.threeTotalFlow];
//    [_filterObjects addObject:object3];
//    
//
//    MHWaterFilterObject* object4 = [MHWaterFilterObject new];
//    object4.index = 4;
//    object4.name = WaterpurifierString(@"filter.back.gac", @"后置活性炭滤芯");
//    object4.desc = WaterpurifierString(@"filter.back.gac.desc", @"对反渗透滤芯生产的纯水进行深度净化，吸附异味，改善口感。纯水的后置处理滤芯，寿命到期后不更换可能会影响口感，甚至滋生细菌。");
//    object4.usedTime = self.device.fourUsedTime;
//    object4.totalTime = self.device.fourTotalTime;
//    object4.usedFlow = self.device.fourUsedFlow;
//    object4.totalFlow = self.device.fourTotalFlow;
//    object4.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.fourUsedTime
//                                                              totalTime:self.device.fourTotalTime
//                                                               usedFlow:self.device.fourUsedFlow
//                                                              totalFlow:self.device.fourTotalFlow];
//    [_filterObjects addObject:object4];
    
    
    if(!isWaterPuriLX5) {
        /*zcm 米一代 4号滤芯*/
        MHWaterFilterObject* object3 = [MHWaterFilterObject new];
        object3.index = 3;
        object3.name = WaterpurifierString(@"filter.ro", @"RO反渗透滤芯");
        object3.desc = WaterpurifierString(@"filter.ro.desc", @"对自来水进行第三级过滤，滤除水中的重金属、细菌、水垢、有机物等杂质。理论过滤精度可达0.0001微米，其使用寿命和去除效果受当地水质、用户使用习惯及前两级滤芯的处理能力的影响。");
        object3.usedTime = self.device.threeUsedTime;
        object3.totalTime = self.device.threeTotalTime;
        object3.usedFlow = self.device.threeUsedFlow;
        object3.totalFlow = self.device.threeTotalFlow;
        object3.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.threeUsedTime
                                                                  totalTime:self.device.threeTotalTime
                                                                   usedFlow:self.device.threeUsedFlow
                                                                  totalFlow:self.device.threeTotalFlow];
        [_filterObjects addObject:object3];
        
        
        /*zcm 米一代 4号滤芯*/
        MHWaterFilterObject* object4 = [MHWaterFilterObject new];
        object4.index = 4;
        object4.name = WaterpurifierString(@"filter.back.gac", @"后置活性炭滤芯");
        object4.desc = WaterpurifierString(@"filter.back.gac.desc", @"对反渗透滤芯生产的纯水进行深度净化，吸附异味，改善口感。纯水的后置处理滤芯，寿命到期后不更换可能会影响口感，甚至滋生细菌。");
        object4.usedTime = self.device.fourUsedTime;
        object4.totalTime = self.device.fourTotalTime;
        object4.usedFlow = self.device.fourUsedFlow;
        object4.totalFlow = self.device.fourTotalFlow;
        object4.lifePercentage = [self.device filterLifePercentWithUsedTime:self.device.fourUsedTime
                                                                  totalTime:self.device.fourTotalTime
                                                                   usedFlow:self.device.fourUsedFlow
                                                                  totalFlow:self.device.fourTotalFlow];
        [_filterObjects addObject:object4];
    }
    
    
    
    
    //lsl修改
    //首次加载显示，因为init时，执行了一遍reloadFilterStatus,所以1
    if (_reloadNumber == 1) {
        if (!self.filterTipsview && deviceOnline) {    //设备在线才弹出提示
            
            NSMutableArray *tipsArray = [NSMutableArray new];
            
//            NSInteger days1 = (NSInteger)((object1.totalTime * object1.lifePercentage)/24);
//            if (days1 <= 30) {
//                [tipsArray addObject:object1];
//            }
//            
//            NSInteger days2 = (NSInteger)((object2.totalTime * object2.lifePercentage)/24);
//            if (days2 <= 30) {
//                [tipsArray addObject:object2];
//            }
//            
//            /*zcm 二代没有3 号和 4号滤芯*/
//            if(!isWaterPuriLX5) {
//                NSInteger days3 = (NSInteger)((object3.totalTime * object3.lifePercentage)/24);
//                if (days3 <= 30) {
//                    [tipsArray addObject:object3];
//                }
//                
//                NSInteger days4 = (NSInteger)((object4.totalTime * object4.lifePercentage)/24);
//                if (days4 <= 30) {
//                    [tipsArray addObject:object4];
//                }
//            }
            
            //zcm 修改：遍历滤芯数组，适应米二代滤芯数量。
            [_filterObjects enumerateObjectsUsingBlock:^(MHWaterFilterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger days = (NSInteger)((obj.totalTime * obj.lifePercentage)/24);
                if(days <= 15) {
                    [tipsArray addObject:obj];
                }
            }];
            
            
            if (tipsArray.count >0) {
                self.filterTipsview = [[MHFilterTipsview alloc] initWithFrame:[UIScreen mainScreen].bounds];
                
                [self.filterTipsview showWidthData:tipsArray];
            }

        }
    }
    
        //lsl修改
        //避免相同数据重新渲染加载（主要是为了避免到期、即将到期图片闪烁问题）(原来写的代码有问题(每次更新数据都创建view～。。)～不大改了。。)
        if (_reloadNumber > 1) {
            //粗略这么判断吧，因为剩余时间以天为单位，没这么快变化的
            __block BOOL update = YES;
            
//            MHWaterFilterObject *obj1 = [_filterObjects objectAtIndex:0];
//            if(self.device.oneUsedTime == obj1.usedTime){
//                update = NO;
//            }
//    
//            MHWaterFilterObject *obj2 = [_filterObjects objectAtIndex:1];
//            if(self.device.twoUsedTime == obj2.usedTime){
//                update = NO;
//            }
//    
//            //zcm 二代没有3 号和 4号滤芯
//            if(![self.device.model isEqualToString:DeviceModelWaterPurifier2]){
//                MHWaterFilterObject *obj3 = [_filterObjects objectAtIndex:2];
//                if(self.device.threeUsedTime == obj3.usedTime){
//                    update = NO;
//                }
//                
//                MHWaterFilterObject *obj4 = [_filterObjects objectAtIndex:3];
//                if(self.device.fourUsedTime == obj4.usedTime){
//                    update = NO;
//                }
//            }
            
            //zcm 修改：遍历滤芯数组，适应米二代滤芯数量
            [_filterObjects enumerateObjectsUsingBlock:^(MHWaterFilterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                update = self.device.oneUsedTime == obj.usedTime ?  NO : update;
                
            }];

            if (!update) {
                return;
            }
        }
    
    if (_reloadNumber <= 1) {
        _reloadNumber += 1;
    }

    [_filterStatus reloadData];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 5;
    
    //zcm 添加：米二代只有两根滤芯
    if([self.device.model isEqualToString:DeviceModelWaterPuriLX5]) {
        return 3;
    }else{
       return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellId forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.textLabel.text = WaterpurifierString(@"filter.status", @"滤芯状态");
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        MHWaterFilterStatusCell* cell = [tableView dequeueReusableCellWithIdentifier:kStatusCellId forIndexPath:indexPath];
        if (indexPath.row-1 < [_filterObjects count]) {
            cell.reloadNumber = _reloadNumber;
            [cell configureWithDataObject:[_filterObjects objectAtIndex:indexPath.row-1]];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 30.f;
    } else {
        return 68.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
//    if (indexPath.row == 0) {
//        // do nothing
//    } else {
//        if (self.filterSelectedHandler) {
//            self.filterSelectedHandler([_filterObjects objectAtIndex:indexPath.row-1]);
//        }
//    }
    
    //zcm 修改
    if(indexPath.row > 0 && self.filterSelectedHandler) {
        self.filterSelectedHandler([_filterObjects objectAtIndex:indexPath.row-1]);
    }
}

@end
