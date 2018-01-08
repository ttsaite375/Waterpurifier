//
//  MHWashViewController.m
//  MiHome
//
//  Created by liushilou on 2017/4/20.
//  Copyright © 2017年 小米移动软件. All rights reserved.
//

#import "MHWashViewController.h"
#import "MHWaterpurifierDefine.h"
#import "YMScreenAdapter.h"
#import "MHWashImageTableViewCell.h"
#import "MHWashDetailViewController.h"

#define ImageTipCell @"ImageTipCell"
#define TextTipCell @"TextTipCell"

@interface MHWashViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *datas;

@end

@implementation MHWashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = WaterpurifierString(@"wash_tips_title", @"保养说明");
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    //[MHColorUtils colorWithRGB:0xF8F8F8];
    self.isTabBarHidden = YES;
    //self.isNavBarTranslucent = YES;
    
    self.datas =
    @[
        @{
            @"title":WaterpurifierString(@"wash_tips_use", @"保养（冲洗）功能使用说明"),
            @"detail":@[WaterpurifierString(@"wash_tips_use_detail1",@"小米净水器（升级版）在通电的情况下，常按智能触控龙头的“自来水”按键3秒，此时自来水蓝色灯闪烁，进入保养（冲洗）模式。"),WaterpurifierString(@"wash_tips_use_detail2",@"打开自来水龙头，冲洗水从浓缩水管流出，持续1分钟。"),WaterpurifierString(@"wash_tips_use_detail3",@"1分钟后，自动切换到自来水，关闭自来水龙头，即可完成保养。")]
         },
        @{
            @"title":WaterpurifierString(@"wash_tips_benefit", @"保养（冲洗）的好处"),
            @"detail":@[WaterpurifierString(@"wash_tips_benefit_detail1",@"以自来水对系统进行冲洗，可以有效冲洗掉反渗透膜表面拦截的污染物，对反渗透膜进行保养，避免污染物在反渗透膜表面沉积、结垢、滋生细菌，有效保障反渗透膜的使用寿命。"),WaterpurifierString(@"wash_tips_benefit_detail2",@"降低净水器内残存的浓缩水的浓度，避免水路、水管、阀体内部结垢，提升部件的使用寿命。")]
        },
        @{
            @"title":WaterpurifierString(@"wash_tips_note", @"保养（冲洗）的注意事项"),
            @"detail":@[WaterpurifierString(@"wash_tips_note_detail1",@"建议至少3天对机器进行一次保养。"),WaterpurifierString(@"wash_tips_note_detail2",@"建议在最后一次使用净水器后进行保养，可以防止污染物长时间在系统内沉积。"),WaterpurifierString(@"wash_tips_note_detail3",@"建议在出差前，对整机进行一次保养，避免长时间不用，滤芯变质。"),WaterpurifierString(@"wash_tips_note_detail4",@"保养（冲洗）后，系统会切换到自来水，注意及时关闭水龙头，避免自来水飞溅或者浪费水资源。")]
        },
        @{
            @"title":WaterpurifierString(@"wash_tips_other", @"小贴士"),
            @"detail":@[WaterpurifierString(@"wash_tips_other_detail1",@"保养不会消耗滤芯的使用寿命，反而会保障滤芯的使用寿命。"),WaterpurifierString(@"wash_tips_other_detail2",@"保养的时候，采用静音设计，整机功率只稍高于待机功率，不会浪费电。"),WaterpurifierString(@"wash_tips_other_detail3",@"保养的时候，按智能水龙头的任意键即可打断保养。")]
        }
    
    ];
    
//    "wash_tips_use" = "保养（冲洗）功能使用说明";
//    "wash_tips_use_detail" = "1、小米净水器（升级版）在通电的情况下，常按智能触控龙头的“自来水”按键3秒，此时自来水蓝色灯闪烁，进入保养（冲洗）模式；\n2、打开自来水龙头，冲洗水从浓缩水管流出，持续1分钟；\n3、1分钟后，自动切换到自来水，关闭自来水龙头，即可完成保养";
//    "wash_tips_benefit" = "保养（冲洗）的好处";
//    "wash_tips_benefit_detail" = "1、以自来水对系统进行冲洗，可以有效冲洗掉反渗透膜表面拦截的污染物，对反渗透膜进行保养，避免污染物在反渗透膜表面沉积、结垢、滋生细菌，有效保障反渗透膜的使用寿命。\n2、降低净水器内残存的浓缩水的浓度，避免水路、水管、阀体内部结垢，提升部件的使用寿命。";
//    "wash_tips_note" = "保养（冲洗）的注意事项";
//    "wash_tips_note_detail" = "1、建议至少3天对机器进行一次保养；\n2、建议在最后一次使用净水器后进行保养，可以防止污染物长时间在系统内沉积；\n3、建议在出差前，对整机进行一次保养，避免长时间不用，滤芯变质；\n4、保养（冲洗）后，系统会切换到自来水，注意及时关闭水龙头，避免自来水飞溅或者浪费水资源。";
//    "wash_tips_other" = "小贴士";
//    "wash_tips_other_detail" = "1、保养不会消耗滤芯的使用寿命，反而会保障滤芯的使用寿命；\n2、保养的时候，采用静音设计，整机功率只稍高于待机功率，不会浪费电；\n3、保养的时候，按智能水龙头的任意键即可打断保养";
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildSubviews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[MHWashImageTableViewCell class] forCellReuseIdentifier:ImageTipCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TextTipCell];
    self.tableView.tableFooterView = [[UIView alloc] init];
    //self.tableView.separatorInset = UIEdgeInsetsMake(0,15, 0, 15);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.datas.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [YMScreenAdapter sizeBy750:24];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [YMScreenAdapter sizeBy1080:1050];
    }else{
        return [YMScreenAdapter sizeBy1080:147];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MHWashImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageTipCell];
        cell.tipLabel.text = [NSString stringWithFormat:WaterpurifierString(@"wash_tips_detail", @"您已%@天没有保养（冲洗）过净水器了，请按时保养（冲洗），以保持滤芯的使用寿命"),self.days];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextTipCell];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:[YMScreenAdapter sizeBy750:30.0]];
        
        NSDictionary *item = [self.datas objectAtIndex:indexPath.row];
        cell.textLabel.text = [item objectForKey:@"title"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *item = [self.datas objectAtIndex:indexPath.row];
        NSString *title = [item objectForKey:@"title"];
        NSArray *detail = [item objectForKey:@"detail"];
        
        MHWashDetailViewController *controller = [[MHWashDetailViewController alloc] init];
        controller.detailTitle = title;
        controller.detail = detail;
        [self.navigationController pushViewController:controller animated:YES];
    }

}


@end
