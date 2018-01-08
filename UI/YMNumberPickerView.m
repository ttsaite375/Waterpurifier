//
//  YMNumberPickerView.m
//  MiHome
//
//  Created by ChengMinZhang on 2017/11/14.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHDataPickerView.h"
#import "YMNumberPickerView.h"
#import "YMScreenAdapter.h"
#import "MHWaterpurifierDefine.h"

@interface YMNumberPickerView()
<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) NSInteger selectValue;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YMNumberPickerView

- (instancetype)init
{
    self = [super init];
    if(self) {
        
        _minValue = 0;
        _maxValue = 0;
        _interval = 0;
        _selectValue = 0;
        _defaultValue = 0;
        
        self.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.0 alpha:0.5];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:[YMScreenAdapter fontsizeBy750:24]];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        
        UIView *segmentLine = [[UIView alloc] init];
        segmentLine.backgroundColor = [UIColor grayColor];
        segmentLine.alpha = 0.3;
        
        UIButton *cancleButton = [[UIButton alloc] init];
        [cancleButton.titleLabel setFont:[UIFont systemFontOfSize:[YMScreenAdapter fontsizeBy750:30]]];
        [cancleButton setTitle:WaterpurifierString(@"mydevice.orange.cancle", @"取消") forState:UIControlStateNormal];
        [cancleButton setTitleColor:[[UIColor alloc] initWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        UIButton *sureButton = [[UIButton alloc] init];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:[YMScreenAdapter fontsizeBy750:30]]];
        [sureButton setTitle:WaterpurifierString(@"mydevice.orange.sure", @"确定") forState:UIControlStateNormal];
        [sureButton setTitleColor:[[UIColor alloc] initWithRed:88.0/255.0 green:193.0/255.0 blue:232.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        UIView *selectView = [[UIView alloc] init];
        selectView.userInteractionEnabled = NO;
        [selectView setAlpha:0.3];
        [selectView setBackgroundColor:[UIColor clearColor]];
        selectView.layer.borderWidth = 0.5;
        selectView.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        UIView *(^initTipView)(UIColor *headColor,NSString *tip) = ^UIView *(UIColor *headColor,NSString *tip)
        {
            UIView *tipView = [[UIView alloc] init];
            
            UIView *headView = [[UIView alloc] init];
            headView.backgroundColor = headColor;
            headView.layer.cornerRadius = [YMScreenAdapter sizeBy750:10] / 2;
            headView.layer.masksToBounds = YES;
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.textColor = [UIColor grayColor];
            tipLabel.alpha = 0.5;
            tipLabel.font = [UIFont systemFontOfSize:[YMScreenAdapter fontsizeBy750:18]];
            tipLabel.text = tip;
            
            [tipView addSubview:headView];
            [tipView addSubview:tipLabel];
            
            [headView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tipView);
                make.height.mas_equalTo([YMScreenAdapter sizeBy750:10]);
                make.width.mas_equalTo([YMScreenAdapter sizeBy750:10]);
                make.left.equalTo(tipView);
            }];
            
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tipView);
                make.left.equalTo(headView.mas_right).with.offset([YMScreenAdapter sizeBy750:20]);
                make.right.equalTo(tipView);
            }];
            
            return tipView;
        };
        
        NSString *tip1 = WaterpurifierString(@"waterpurifier.purity.height", @"0-50 纯度高");
        NSString *tip2 = WaterpurifierString(@"waterpurifier.purity.good", @"50-100 纯度较高");
        NSString *tip3 = WaterpurifierString(@"waterpurifier.purity.normal", @"100-300 纯度正常");
        
        UIView *tipView1 = initTipView([[UIColor alloc] initWithRed:108.0/255.0 green:212.0/255.0 blue:255.0/255.0 alpha:1],tip1);
        UIView *tipView2 = initTipView([[UIColor alloc] initWithRed:88.0/255.0 green:193.0/255.0 blue:232.0/255.0 alpha:1],tip2);
        UIView *tipView3 = initTipView([[UIColor alloc] initWithRed:89.0/255.0 green:174.0/255.0 blue:209.0/255.0 alpha:1],tip3);
        
        [self addSubview:backgroundView];
        [self addSubview:_contentView];
        [_contentView addSubview:tipView1];
        [_contentView addSubview:tipView2];
        [_contentView addSubview:tipView3];
        [_contentView addSubview:_pickerView];
        [_contentView addSubview:_titleLabel];
        [_contentView addSubview:cancleButton];
        [_contentView addSubview:sureButton];
        [_contentView addSubview:segmentLine];
        [_contentView addSubview:selectView];
        
        XM_WS(ws);
        
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(ws);
            make.bottom.equalTo(ws.pickerView.mas_top);
        }];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(ws);
            make.height.mas_equalTo([YMScreenAdapter sizeBy750:550]);
        }];
        
        
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(ws.contentView);
            make.top.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:150]);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.contentView.mas_centerX);
            make.centerY.equalTo(cancleButton.mas_centerY);
            make.left.equalTo(cancleButton.mas_right);
            make.right.equalTo(sureButton.mas_left);
        }];
        
        [segmentLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ws.contentView);
            make.top.equalTo(ws.contentView.mas_top).with.offset([YMScreenAdapter sizeBy750:85]);
            make.height.mas_equalTo(0.5);
        }];
        
        [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:8]);
            make.left.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:8]);
            make.height.mas_equalTo([YMScreenAdapter sizeBy750:60]);
            make.width.mas_equalTo([YMScreenAdapter sizeBy750:130]);
        }];
        
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:8]);
            make.right.equalTo(ws.contentView).with.offset(-[YMScreenAdapter sizeBy750:8]);
            make.height.mas_equalTo([YMScreenAdapter sizeBy750:60]);
            make.width.mas_equalTo([YMScreenAdapter sizeBy750:100]);
        }];
        
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.pickerView).with.offset(- 2);
            make.right.equalTo(ws.pickerView).with.offset(2);
            make.center.equalTo(ws.pickerView);
            make.height.mas_equalTo([YMScreenAdapter sizeBy750:80]);
        }];
        
        [tipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:100]);
            make.left.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:30]);
            make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy750:200], [YMScreenAdapter sizeBy750:40]));
        }];
        
        [tipView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:100]);
            make.centerX.equalTo(ws.contentView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy750:200], [YMScreenAdapter sizeBy750:40]));
        }];
        
        [tipView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).with.offset([YMScreenAdapter sizeBy750:100]);
            make.right.equalTo(ws.contentView).with.offset(- [YMScreenAdapter sizeBy750:30]);
            make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy750:200], [YMScreenAdapter sizeBy750:40]));
        }];
        
        UITapGestureRecognizer *tapBK = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
        
        [backgroundView addGestureRecognizer:tapBK];
        
        [cancleButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.interval == 0) {
        return 1;
    }
    NSInteger totalRows = round((self.maxValue - self.minValue) / self.interval) + 1;
    
    return totalRows < 0 ? 0 : totalRows;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 42;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * label;
    
    if(view) {
        label = (UILabel *)view;
    }else {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:[YMScreenAdapter fontsizeBy750:36]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
    }
    
    label.text = @(row * self.interval + self.minValue).stringValue;
    
    label.tag = row;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectValue = row * self.interval + self.minValue;
}

#pragma mark - 动作
- (void)sure
{
    if(self.didPickNumber) {
        
        if(self.selectValue >= self.minValue && self.selectValue <= self.maxValue) {
            self.didPickNumber(self.selectValue);
        }else {
            self.didPickNumber(self.minValue);
        }
        
        [self hide];
    }
}

- (void)tapBackground:(UITapGestureRecognizer *)sender
{
    CGPoint tapPoint = [sender locationInView:sender.view];
    
    if(!CGRectContainsPoint(self.contentView.frame, tapPoint)) {
        
        [self hide];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)hide
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self setFrame:CGRectMake(0,
                                  [UIScreen mainScreen].bounds.size.height,
                                  [UIScreen mainScreen].bounds.size.width,
                                  [UIScreen mainScreen].bounds.size.height)];
        
    } completion:^(BOOL finished) {
        
        self.pickerView.delegate = nil;
        
        self.pickerView.dataSource = nil;
        
        [self removeFromSuperview];
    }];
}



- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self setFrame:CGRectMake(0,
                              [UIScreen mainScreen].bounds.size.height,
                              [UIScreen mainScreen].bounds.size.width,
                              [UIScreen mainScreen].bounds.size.height)];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [self setFrame:[UIScreen mainScreen].bounds];
    } completion:^(BOOL finished) {
        
        self.pickerView.delegate = self;
        
        self.pickerView.dataSource = self;
        
        [self.pickerView reloadAllComponents];
        
        NSInteger selectRow = self.interval ? (self.defaultValue - self.minValue)/self.interval : 0;
        
        [self.pickerView selectRow:selectRow inComponent:0 animated:YES];
    }];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}


@end

