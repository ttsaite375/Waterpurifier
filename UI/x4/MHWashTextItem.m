//
//  MHWashTextItem.m
//  MiHome
//
//  Created by liushilou on 2017/4/25.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHWashTextItem.h"
#import "YMScreenAdapter.h"

@implementation MHWashTextItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
        UIView *tabview = [[UIView alloc] init];
        tabview.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [self addSubview:tabview];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _textLabel.font = [UIFont systemFontOfSize:[YMScreenAdapter sizeBy750:30.0]];
        [self addSubview:_textLabel];
        
        [tabview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).with.offset([YMScreenAdapter sizeBy1080:20]);
            make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy1080:14], [YMScreenAdapter sizeBy1080:14]));
        }];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tabview.mas_right).with.offset(15);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}



@end
