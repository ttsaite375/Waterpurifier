//
//  MHWashDetailViewController.m
//  MiHome
//
//  Created by liushilou on 2017/4/20.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHWashDetailViewController.h"
#import "YMScreenAdapter.h"
#import "MHWashTextItem.h"

@interface MHWashDetailViewController ()

@end

@implementation MHWashDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.detailTitle;
    self.view.backgroundColor = [MHColorUtils colorWithRGB:0xF8F8F8];
    self.isTabBarHidden = YES;
    //self.isNavBarTranslucent = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildSubviews {

    NSMutableArray *textItems = [NSMutableArray new];
    
    for (NSString *text in self.detail) {
        MHWashTextItem *textItem = [[MHWashTextItem alloc] init];
        textItem.textLabel.text = text;
        [self.view addSubview:textItem];
        
        [textItems addObject:textItem];
    }
    
    for (NSInteger i = 0; i < textItems.count; i++) {
        MHWashTextItem *textItem = [textItems objectAtIndex:i];
        if (i == 0) {
            [textItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(25);
                make.right.equalTo(self.view).with.offset(-25);
                make.top.equalTo(self.view).with.offset(80);
            }];
        }else{
            MHWashTextItem *bTextItem = [textItems objectAtIndex:i-1];
            [textItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(25);
                make.right.equalTo(self.view).with.offset(-25);
                make.top.equalTo(bTextItem.mas_bottom).with.offset(15);
            }];
        }
    }
    
}

@end
