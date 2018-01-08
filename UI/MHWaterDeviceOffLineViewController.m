//
//  MHWaterDeviceOffLineViewController.m
//  MiHome
//
//  Created by liushilou on 16/11/7.
//  Copyright © 2016年 小米移动软件. All rights reserved.
//

#import "MHWaterDeviceOffLineViewController.h"
#import "MHWaterpurifierDefine.h"
#import "YMScreenAdapter.h"
#import "MHNotificationCenter.h"

@interface MHWaterDeviceOffLineViewController ()

@end

@implementation MHWaterDeviceOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = WaterpurifierString(@"um_string_title_device_offline", @"离线帮助");
    self.view.backgroundColor = [MHColorUtils colorWithRGB:0xF8F8F8];
    self.isTabBarHidden = YES;
//    self.isNavBarTranslucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)buildSubviews
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    if (@available(iOS 11.0, *)){
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UILabel *titleLabel1 = [self titleLabel];
    titleLabel1.text = WaterpurifierString(@"um_string_device_offline_sub_title", @"出现“设备离线”提示怎么办？");
    [scrollView addSubview:titleLabel1];
    
    UILabel *detailLabel1 = [self detailLabel];
    detailLabel1.text = WaterpurifierString(@"um_string_device_offline_desc", @"当出现“设备离线”提示时，可能因为当前网络环境较差或设备断电导致。\n请按以下步骤检查自己的操作：\n1、设备有接通电源且设备未被他人占用；\n2、路由器可正常使用并正确输入WiFi密码；\n3、尝试进行设备重置操作。");
    [scrollView addSubview:detailLabel1];
    
    UILabel *titleLabel2 = [self titleLabel];
    titleLabel2.text = WaterpurifierString(@"um_string_reset_title", @"如何进行“设备重置”？");
    [scrollView addSubview:titleLabel2];
    
    UILabel *detailLabel2 = [self detailLabel];
    detailLabel2.text = WaterpurifierString(@"um_string_reset_desc", @"重置设备请同时按下“选择”和“复位”键3秒，听到“嘀嘀嘀”提示音后，指示灯变为橙色快闪，设备重置成功。");
    [scrollView addSubview:detailLabel2];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage imageNamed:@"waterpurifier_resetDevice"];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    [imageview setClipsToBounds:YES];
    [scrollView addSubview:imageview];
    
    UILabel *detailLabel3 = [self detailLabel];
    detailLabel3.text = WaterpurifierString(@"um_string_reset_end", @"检查完毕后，请尝试返回设备列表刷新设备状态。");
    [scrollView addSubview:detailLabel3];
    
    
//    CGFloat btnheight = [YMScreenAdapter sizeBy1080:130];
//    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    refreshButton.layer.borderColor = [UIColor grayColor].CGColor;
//    refreshButton.layer.borderWidth = 1;
//    refreshButton.layer.cornerRadius = btnheight/2;
//    [refreshButton setTitle:WaterpurifierString(@"um_string_button_refresh_device_and_exit", @"刷新并返回设备列表") forState:UIControlStateNormal];
//    [refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:[YMScreenAdapter sizeBy1080:44]]];
//    [scrollView addSubview:refreshButton];
//    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(20);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    [detailLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel1.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel1.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    [detailLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel2.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel2.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo([YMScreenAdapter sizeBy1080:620]);
    }];
    [detailLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageview.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.bottom.equalTo(scrollView).with.offset(-20);
    }];
//    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(detailLabel3.mas_bottom).with.offset(20);
//        make.left.equalTo(self.view).with.offset(15);
//        make.right.equalTo(self.view).with.offset(-15);
//        make.bottom.equalTo(scrollView).with.offset(-20);
//        make.height.mas_equalTo(btnheight);
//    }];
    
}
    

- (UILabel *)titleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:[YMScreenAdapter sizeBy1080:50]];
    
    return titleLabel;
}

- (UILabel *)detailLabel
{
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:[YMScreenAdapter sizeBy1080:44]];
    
    return label;
}

- (void)refreshAction
{
// 似乎没刷新。。算了，不这样做了
//    [[MHNotificationCenter sharedInstance] postNotificationName:@"kMHNotificationOfPullDownRefreshDeviceList" infoObject:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


@end
