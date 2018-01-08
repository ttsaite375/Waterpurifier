//
//  MHTdsDigitalView.m
//  MiHome
//
//  Created by wayne on 15/6/25.
//  Copyright (c) 2015年 小米移动软件. All rights reserved.
//

#import "MHTdsDigitalView.h"
//#import "Masonry.h"
#import "MHSerialAnimation.h"

@implementation MHTdsDigitalView
{
    UILabel* _tdsDigital;
    UILabel* _tdsMark;
    UILabel* _description0;
    UILabel* _description1;
    UIButton* _detailBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tdsValue = NSUIntegerMax;
        [self buildSubviews];
        [self buildConstraints];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)buildSubviews
{
    UIFont *digitalFont = [UIFont fontWithName:@"DINOffc-CondMedi" size:125.0];
    _tdsDigital = [UILabel new];
    _tdsDigital.font = digitalFont;
    _tdsDigital.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_tdsDigital];
    
    UIFont *markFont = [UIFont fontWithName:@"DINOffc-CondMedi" size:16.0];
    _tdsMark = [UILabel new];
    _tdsMark.font = markFont;
    _tdsMark.text = @"TDS";
    _tdsMark.textColor = [MHColorUtils colorWithRGB:0x00caed];
    [self addSubview:_tdsMark];
    
    _description0 = [UILabel new];
    _description0.font = [UIFont systemFontOfSize:15.0];
    _description0.textColor = [MHColorUtils colorWithRGB:0x00caed];
    _description0.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_description0];
    
    _description1 = [UILabel new];
    _description1.font = [UIFont systemFontOfSize:15.0];
    _description1.textColor = [MHColorUtils colorWithRGB:0x00caed];
    _description1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_description1];
    
    _detailBtn = [UIButton new];
    [_detailBtn addTarget:self action:@selector(detailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_detailBtn];
}

- (void)buildConstraints
{
    XM_WS(weakself);
    [_tdsDigital mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.center.equalTo(weakself);
    }];
    [_tdsMark mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.baseline.equalTo(strongself->_tdsDigital.mas_baseline);
        make.left.equalTo(strongself->_tdsDigital.mas_right);
    }];
    
    [_description0 mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.top.equalTo(strongself->_tdsDigital.mas_baseline).offset(10.0);
        make.centerX.equalTo(strongself->_tdsDigital);
//        make.left.equalTo(strongself->_tdsDigital);
//        make.right.equalTo(strongself->_tdsDigital);
    }];
    [_description1 mas_makeConstraints:^(MASConstraintMaker *make) {
        XM_SS(strongself, weakself);
        make.center.equalTo(strongself->_description0);
        make.size.equalTo(strongself->_description0);
    }];
    
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
}

- (void)detailBtnClicked:(id)sender
{
    if (self.detailHandler) {
        self.detailHandler();
    }
}

- (NSAttributedString *)attributedStringForTdsValue:(NSUInteger)tdsValue
{
    if (tdsValue >= 1000) {
        return nil;
    }
    NSString* tdsString = [NSString stringWithFormat:@"%03d", (int)tdsValue];
    NSMutableAttributedString* mutableAString = [[NSMutableAttributedString alloc] initWithString:tdsString];
    
    UIFont *digitalFont = [UIFont fontWithName:@"DINOffc-CondMedi" size:125.0];
    NSDictionary* zeroAttributes = @{NSFontAttributeName : digitalFont, NSForegroundColorAttributeName : self.zeroColor};
    NSDictionary* nonzeroAttributes = @{NSFontAttributeName : digitalFont, NSForegroundColorAttributeName : self.nonzeroColor};
    BOOL nonzeroExist = NO;
    for (NSUInteger i=0; i < [tdsString length]; i++) {
        unichar ch = [tdsString characterAtIndex:i];
        if (ch != '0' || nonzeroExist) { //非'0'或者已经出现过非'0'的字符
            [mutableAString addAttributes:nonzeroAttributes range:NSMakeRange(i, 1)];
            nonzeroExist = YES;
        } else { //填充用的'0'字符
            [mutableAString addAttributes:zeroAttributes range:NSMakeRange(i, 1)];
        }
    }
    return [[NSAttributedString alloc] initWithAttributedString:mutableAString];
}

- (void)setTdsValue:(NSUInteger)tdsValue
{
    NSAttributedString* attributedString = [self attributedStringForTdsValue:tdsValue];
    _tdsDigital.attributedText = attributedString;
    CGSize digitalSize = [attributedString size];
    [_tdsDigital mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ceil(digitalSize.width), ceil(digitalSize.height)));
    }];
    _tdsMark.textColor = self.nonzeroColor;
    
    _tdsValue = tdsValue;
}

//实现近大远小的立体效果先定义两个方法：
CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}


- (void)switchFromDescription:(NSAttributedString *)fromDesc toDescription:(NSAttributedString *)toDesc
{
    CGFloat angle = 0;
    CGFloat tz = 10;
    CGFloat disZ = 150;
    
    XM_WS(ws);
    [MHSerialAnimation addAnimationWithDuration:1.0 preAnimation:^{
        XM_SS(ss, ws);
        CATransform3D move = CATransform3DMakeTranslation(0, 0, tz);
        CATransform3D back = CATransform3DMakeTranslation(0, 0, -tz);
        
        CATransform3D rotate0 = CATransform3DMakeRotation(-angle, 1, 0, 0);
        CATransform3D rotate1 = CATransform3DMakeRotation(M_PI_2-angle, 1, 0, 0);
        
        CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
        CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
        
        ss->_description0.layer.transform = CATransform3DPerspect(mat0, CGPointZero, disZ);
        ss->_description1.layer.transform = CATransform3DPerspect(mat1, CGPointZero, disZ);
        ss->_description0.attributedText = fromDesc;
        ss->_description1.attributedText = toDesc;
    } animations:^{
        XM_SS(ss, ws);
        CGFloat angle = M_PI_2;
        CATransform3D move = CATransform3DMakeTranslation(0, 0, tz);
        CATransform3D back = CATransform3DMakeTranslation(0, 0, -tz);
        
        CATransform3D rotate0 = CATransform3DMakeRotation(-angle, 1, 0, 0);
        CATransform3D rotate1 = CATransform3DMakeRotation(M_PI_2-angle, 1, 0, 0);
        
        CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
        CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
        
        ss->_description0.layer.transform = CATransform3DPerspect(mat0, CGPointZero, disZ);
        ss->_description1.layer.transform = CATransform3DPerspect(mat1, CGPointZero, disZ);
    } completion:^{
        XM_SS(ss, ws);
        ss->_description0.text = nil;
    }];
}

@end
