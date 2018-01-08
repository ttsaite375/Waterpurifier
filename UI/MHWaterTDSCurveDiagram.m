//
//  MHWaterTDSCurveDiagram.m
//  MiHome
//
//  Created by wayne on 15/7/2.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHWaterTDSCurveDiagram.h"
#import "MHWaterpurifierDefine.h"

@implementation MHWaterTDSDrawObject

- (id)copyWithZone:(NSZone *)zone
{
    MHWaterTDSDrawObject* copyObject = [MHWaterTDSDrawObject allocWithZone:zone];
    copyObject.inTDS = self.inTDS;
    copyObject.outTDS = self.outTDS;
    copyObject.maxInTDS = self.maxInTDS;
    copyObject.maxOutTDS = self.maxOutTDS;
    copyObject.isPurifying = self.isPurifying;
    copyObject.time = [self.time copy];
    return copyObject;
}

@end

@implementation MHWaterTDSCurveDiagram
{
    NSArray* _drawObjects;
    NSMutableArray* _pointsOnInputTDSCurve;     //自来水曲线上的点
    NSMutableArray* _pointsOnOutputTDSCurve;    //纯净水曲线上的点
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _pointsOnInputTDSCurve = [NSMutableArray new];
        _pointsOnOutputTDSCurve = [NSMutableArray new];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 绘制TDS曲线
    [self drawPurifyTdsCurve:ctx inRect:rect];
    
    // 是否正在净水
    if (_record.state == MHWaterPurifyRecordStatePurifying) {
        // 绘制净水实时进度
        [self drawPurifyingProgress:ctx];
    }
    
    // 绘制最近TDS
    [self drawLatestTDSValue:ctx inRect:rect];
    
    // 绘制净水时间
    [self drawTimeIntervalInRect:rect];
}

- (void)drawPurifyTdsCurve:(CGContextRef)ctx inRect:(CGRect)rect
{
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    // 自来水曲线  zcm 修改 米二代没有这条曲线
    if(!self.isWaterPurifyLX5) {
        CGContextSetLineWidth(ctx, 1.0f);
        CGContextSetStrokeColorWithColor(ctx, [MHColorUtils colorWithRGB:0x70889e alpha:0.5].CGColor);
        UIBezierPath* inputCurve = [self quadraticBezierPathWithPoints:_pointsOnInputTDSCurve];
        CGContextAddPath(ctx, inputCurve.CGPath);
        CGContextStrokePath(ctx);
    }
    
    // 纯净水曲线
    CGContextSetLineWidth(ctx, 4.0f);
    CGContextSetStrokeColorWithColor(ctx, [MHColorUtils colorWithRGB:0x00caed].CGColor);
    UIBezierPath* outputCurve = [self quadraticBezierPathWithPoints:_pointsOnOutputTDSCurve];
    CGContextAddPath(ctx, outputCurve.CGPath);
    CGContextStrokePath(ctx);
    
    // Draw gradient
    CGPoint lastPoint = [[_pointsOnOutputTDSCurve lastObject] CGPointValue];
    CGPoint firstPoint = [[_pointsOnOutputTDSCurve firstObject] CGPointValue];
    __block CGPoint maxPoint = CGPointZero;
    [_pointsOnOutputTDSCurve enumerateObjectsUsingBlock:^(id anyObj, NSUInteger idx, BOOL *stop) {
        CGPoint anyPoint = [anyObj CGPointValue];
        if (anyPoint.y > maxPoint.y) {
            maxPoint = anyPoint;
        }
        //zcm修改
        
        
    }];
    [outputCurve addLineToPoint:CGPointMake(lastPoint.x, 0)];
    [outputCurve addLineToPoint:CGPointMake(firstPoint.x, 0)];
    [outputCurve closePath];
    CGContextAddPath(ctx, outputCurve.CGPath);
    CGContextClip(ctx);
    
    NSArray* colors = @[(__bridge id)[MHColorUtils colorWithRGB:0xbbf6ff].CGColor, (__bridge id)self.backgroundColor.CGColor];
    CGFloat locations[] = {0, 1};
    CGGradientRef outputGra = CGGradientCreateWithColors(cs, (__bridge CFArrayRef)colors, locations);
    CGContextDrawLinearGradient(ctx, outputGra, CGPointMake(maxPoint.x, maxPoint.y), CGPointMake(maxPoint.x, 0), 0);
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(cs);
}

- (void)drawPurifyingProgress:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    CGPoint lastPoint = [[_pointsOnOutputTDSCurve lastObject] CGPointValue];
    CGMutablePathRef liveLine = CGPathCreateMutable();
    CGPathMoveToPoint(liveLine, NULL, lastPoint.x, lastPoint.y);
    CGPathAddLineToPoint(liveLine, NULL, lastPoint.x, 0);
    CGContextAddPath(ctx, liveLine);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [MHColorUtils colorWithRGB:0xc6c6c6].CGColor);
    CGContextStrokePath(ctx);
    CGPathRelease(liveLine);
    
    // 绘制圆圈
    CGFloat radius = 10.0;
    CGRect circleRect = CGRectMake(lastPoint.x - radius, lastPoint.y - radius, radius * 2.0, radius * 2.0);
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddEllipseInRect(circle, NULL, circleRect);
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetStrokeColorWithColor(ctx, [MHColorUtils colorWithRGB:0x00caed].CGColor);
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextAddPath(ctx, circle);
    CGContextStrokePath(ctx);
    CGContextAddPath(ctx, circle);
    CGContextFillPath(ctx);
    CGPathRelease(circle);
    
    CGContextRestoreGState(ctx);
}

- (void)drawLatestTDSValue:(CGContextRef)ctx inRect:(CGRect)rect
{
    CGContextSaveGState(ctx);
    
    
    NSLog(@"12345");
    
    MHWaterTDSDrawObject* lastDrawObject = [_drawObjects lastObject];
    
    CGPoint lastInputPoint = [[_pointsOnInputTDSCurve lastObject] CGPointValue];
    CGPoint lastOutputPoint = [[_pointsOnOutputTDSCurve lastObject] CGPointValue];
    
    NSDictionary* inputAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:11.f],
                                NSForegroundColorAttributeName : [MHColorUtils colorWithRGB:0x7a98b3 alpha:0.9]};
    NSDictionary* outputAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:11.f],
                                 NSForegroundColorAttributeName : [MHColorUtils colorWithRGB:0x00caed]};
    //没有数据时，不显示这两个字段～。
    NSString* inputTDSString = @"";
    NSString* outputTDSString = @"";
    if ((int)lastDrawObject.inTDS == 0 && (int)lastDrawObject.outTDS == 0) {
        inputTDSString = @"";
        outputTDSString = @"";
    }else{
//        inputTDSString = [NSString stringWithFormat:WaterpurifierString(@"tap.water.tds", @"自来水水质\n%d TDS"), (int)lastDrawObject.inTDS];
//        outputTDSString = [NSString stringWithFormat:WaterpurifierString(@"purified.water.tds", @"纯水水质\n%d TDS"), (int)lastDrawObject.outTDS];
        
//        NSNumber *minOutTDS = [_drawObjects valueForKeyPath:@"self.outTDS.@min.intValue"];
        
        //zcm 修改 因为TDS值不稳定，我们只选非0最小值显示
        
        inputTDSString = [NSString stringWithFormat:WaterpurifierString(@"tap.water.tds", @"自来水水质\n%d TDS"), (int)_record.inTDS];
        
        NSArray<NSNumber *> *outTDSArray = [_drawObjects valueForKeyPath:@"self.outTDS"];
        
        __block NSNumber *minOutTDS = [NSNumber numberWithInt:65535];
        
        [outTDSArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.intValue <= minOutTDS.intValue  && obj.intValue != 0) {
                minOutTDS = obj;
            }
        }];
        
        outputTDSString = [NSString stringWithFormat:WaterpurifierString(@"purified.water.tds", @"纯水水质\n%d TDS"),minOutTDS.intValue];
    }
    
    //zcm add 取消米二代标题
    if(self.isWaterPurifyLX5) {
        inputTDSString = @"";
    }
    
    //字符显示在曲线上面
    BOOL upperOutputString = (CGRectGetMaxY(rect) - lastOutputPoint.y) < CGRectGetHeight(rect) / 5;
    CGFloat stringOffsetY = upperOutputString ? - 30 : 30;
    CGFloat stringOffsetX = 10;
    
    CGSize inputSize = [inputTDSString sizeWithAttributes:inputAttr];
    CGSize outputSize = [outputTDSString sizeWithAttributes:outputAttr];
    
    CGFloat inputPointX = CGRectGetMaxX(rect) - inputSize.width - stringOffsetX;
    CGFloat inputPointY = self.bounds.size.height - lastInputPoint.y - inputSize.height - stringOffsetY;
    
    CGFloat outputPointX = CGRectGetMaxX(rect) - outputSize.width - stringOffsetX;
    CGFloat outputPointY = self.bounds.size.height - lastOutputPoint.y - outputSize.height - stringOffsetY;
    
    [inputTDSString drawAtPoint:CGPointMake(inputPointX,inputPointY) withAttributes:inputAttr];
    [outputTDSString drawAtPoint:CGPointMake(outputPointX,outputPointY) withAttributes:outputAttr];
    
    CGContextRestoreGState(ctx);
}

- (void)drawTimeIntervalInRect:(CGRect)rect
{
    NSDate* startTime = ((MHWaterTDSDrawObject *)[_drawObjects firstObject]).time;
    NSDate* endTime = ((MHWaterTDSDrawObject *)[_drawObjects lastObject]).time;
    NSDictionary* timeAttr = @{NSFontAttributeName : [UIFont fontWithName:@"DINOffc-CondMedi" size:14.f],
                               NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:0.5]};
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm:ss";
    NSString* startTimeStr = [formatter stringFromDate:startTime];
    CGSize startTimeSize = [startTimeStr sizeWithAttributes:timeAttr];
    [startTimeStr drawAtPoint:CGPointMake(10.0, CGRectGetMaxY(rect)-startTimeSize.height-7.0) withAttributes:timeAttr];
    
    NSString* endTimeStr = [formatter stringFromDate:endTime];
    CGSize endTimeSize = [endTimeStr sizeWithAttributes:timeAttr];
    [endTimeStr drawAtPoint:CGPointMake(CGRectGetMaxX(rect)-endTimeSize.width-10.0, CGRectGetMaxY(rect)-endTimeSize.height-7.0) withAttributes:timeAttr];
}

//- (void)setDrawObjects:(NSArray *)drawObjects
- (void)setRecord:(MHDataWaterPurifyRecord *)record
{
    _record = record;
    
    [self parseRecordToCurvePoints:record];
    [self setNeedsDisplay];
}

- (void)animationCurveFadeIn
{
    // animation
    UIView* maskView = [UIView new];
    maskView.backgroundColor = [MHColorUtils colorWithRGB:0xf7f7f7];
    maskView.frame = self.bounds;
    [self addSubview:maskView];
    [UIView animateWithDuration:1.5 animations:^{
        maskView.frame = CGRectOffset(maskView.frame, CGRectGetWidth(maskView.frame), 0);
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];
}

- (void)parseRecordToCurvePoints:(MHDataWaterPurifyRecord *)record
{
    _drawObjects = [self drawObjectsForRecord:record];
    
    [_pointsOnInputTDSCurve removeAllObjects];
    [_pointsOnOutputTDSCurve removeAllObjects];
    
    XM_WS(ws);
    NSArray* onScreenDrawObjects = nil;
    CGFloat unitx = 0;
    if (record.state == MHWaterPurifyRecordStatePurifying) { //净水ing
        //在屏幕宽度的一半上展示10个点
        unitx = CGRectGetWidth(self.bounds) / 2 / (10-1);
        //最多后10个drawObjects能够onScreen
        if ([_drawObjects count] > 10) {
            onScreenDrawObjects = [_drawObjects subarrayWithRange:NSMakeRange([_drawObjects count]-10, 10)];
        } else {
            onScreenDrawObjects = _drawObjects;
        }
    }
    else if (record.state == MHWaterPurifyRecordStateIdle) { //净水已结束
        // n个点把x轴分成n-1段
        unitx = CGRectGetWidth(self.bounds) / ([_drawObjects count] - 1);
        // 所有的drawObjects都onScreen
        onScreenDrawObjects = _drawObjects;
    }
    
    [onScreenDrawObjects enumerateObjectsUsingBlock:^(MHWaterTDSDrawObject* object, NSUInteger idx, BOOL *stop) {
        XM_SS(ss, ws);
        CGPoint point = CGPointZero;
        point.x = idx * unitx;
        point.y = [self inputPointYForTDSDrawObject:object];
        [ss->_pointsOnInputTDSCurve addObject:[NSValue valueWithCGPoint:point]];
        point.y = [self outputPointYForTDSDrawObject:object];
        [ss->_pointsOnOutputTDSCurve addObject:[NSValue valueWithCGPoint:point]];
    }];
}

- (NSArray *)drawObjectsForRecord:(MHDataWaterPurifyRecord *)record
{
    NSInteger maxInTDS = 0;
    NSInteger maxOutTDS = 0;
    NSMutableArray* tdsDrawObjects = [NSMutableArray array];
    
    for (id outTDS in record.outTDSList) {
        MHWaterTDSDrawObject* object = [MHWaterTDSDrawObject new];
        object.inTDS = record.inTDS + arc4random() % (int)floor(record.inTDS / 10.0); //在inTDS的10%范围内随机
        object.outTDS = [outTDS integerValue];
        object.time = record.time;
        [tdsDrawObjects addObject:object];
        
        if (object.inTDS > maxInTDS) {
            maxInTDS = object.inTDS;
        }
        if (object.outTDS > maxOutTDS) {
            maxOutTDS = object.outTDS;
        }
    }
    
    [tdsDrawObjects enumerateObjectsUsingBlock:^(MHWaterTDSDrawObject* obj, NSUInteger idx, BOOL *stop) {
        obj.maxInTDS = maxInTDS+1;
        obj.maxOutTDS = maxOutTDS+1;
    }];
    // 为了方便绘制，只有一个drawObject时，复制一个
    if ([tdsDrawObjects count] == 1) {
        MHWaterTDSDrawObject* drawObject = [tdsDrawObjects objectAtIndex:0];
        [tdsDrawObjects addObject:[drawObject copy]];
    }
    
    // set time
    MHWaterTDSDrawObject* firstObject = [tdsDrawObjects firstObject];
    firstObject.time = record.time;
    MHWaterTDSDrawObject* lastObject = [tdsDrawObjects lastObject];
    lastObject.time = [NSDate dateWithTimeIntervalSince1970:[record.time timeIntervalSince1970] + record.costTime];
    
    return tdsDrawObjects;
}

- (CGFloat)inputPointYForTDSDrawObject:(MHWaterTDSDrawObject *)object
{
    return CGRectGetHeight(self.bounds)*0.5 + //base 0.5 x height
           CGRectGetHeight(self.bounds)*0.2*object.inTDS/object.maxInTDS; //range 0.2 x height
}

- (CGFloat)outputPointYForTDSDrawObject:(MHWaterTDSDrawObject *)object
{
    
    //zcm修改 maxOutTDS小于200， 提升至20
    CGFloat maxValue = object.maxOutTDS < 200 ? 300 : object.maxOutTDS;
    
    return CGRectGetHeight(self.bounds)*0.1 + //base 0.1 x height
           CGRectGetHeight(self.bounds)*0.4 *object.outTDS/maxValue; //range 0.4 x height
}

// 二次贝塞尔曲线拟合
- (UIBezierPath *)quadraticBezierPathWithPoints:(NSArray *)points
{
    __block UIBezierPath *bPath = [UIBezierPath bezierPath];
    [points enumerateObjectsUsingBlock:^(id pointObj, NSUInteger idx, BOOL *stop) {
        CGPoint point = [pointObj CGPointValue];
        if (idx == 0) {
            [bPath moveToPoint:point];
        } else if (idx == [points count] - 1) {
            [bPath addLineToPoint:point];
        } else {
            CGPoint prevPoint = [[points objectAtIndex:idx - 1] CGPointValue];
            CGPoint nextPoint = [[points objectAtIndex:idx + 1] CGPointValue];
            CGPoint startPoint = oneThirdPointBetweenPoints(point, prevPoint);
            CGPoint endPoint = oneThirdPointBetweenPoints(point, nextPoint);
            [bPath addLineToPoint:startPoint];
            [bPath addQuadCurveToPoint:endPoint controlPoint:point];
        }
    }];
    
    return bPath;
}

CGPoint oneThirdPointBetweenPoints(CGPoint point1, CGPoint point2)
{
    return CGPointMake(point1.x + (point2.x - point1.x) / 3.0,
                       point1.y + (point2.y - point1.y) / 3.0);
}

// 折线
- (UIBezierPath *)polygonalBezierPathWithPoints:(NSArray *)points
{
    __block UIBezierPath *bPath = [UIBezierPath bezierPath];
    [points enumerateObjectsUsingBlock:^(id pointObj, NSUInteger idx, BOOL *stop) {
        CGPoint point = [pointObj CGPointValue];
        if (idx == 0) {
            [bPath moveToPoint:point];
        } else {
            [bPath addLineToPoint:point];
        }
    }];
    return bPath;
}

@end
