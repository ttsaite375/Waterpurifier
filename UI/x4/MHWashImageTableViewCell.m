//
//  MHWashImageTableViewCell.m
//  MiHome
//
//  Created by liushilou on 2017/4/20.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHWashImageTableViewCell.h"
#import "YMScreenAdapter.h"
#import "MHWaterpurifierDefine.h"

@implementation MHWashImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.font = [UIFont systemFontOfSize:[YMScreenAdapter sizeBy750:30.0]];
        self.tipLabel.textColor = [MHColorUtils colorWithRGB:0xffff9800];
        [self.contentView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset([YMScreenAdapter sizeBy1080:70]);
            make.left.equalTo(self.contentView).with.offset(15);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        [imageview setImage:[UIImage imageNamed:@"waterpurifier_wash"]];
        [self.contentView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLabel.mas_bottom).with.offset([YMScreenAdapter sizeBy1080:50]);
            make.size.mas_equalTo(CGSizeMake([YMScreenAdapter sizeBy1080:881], [YMScreenAdapter sizeBy1080:788]));
            make.centerX.equalTo(self.contentView);
        }];
        

    }
    return self;
}


@end
