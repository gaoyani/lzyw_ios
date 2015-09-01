//
//  OrderDetailViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "SubOrderTableViewCell.h"
#import "Constants.h"
#import "PayOrderViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self.pay setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.pay setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    self.subOrderTableView.delegate = self;
    self.subOrderTableView.dataSource = self;
    [self.subOrderTableView registerNib:[UINib nibWithNibName:@"SubOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"SubOrderTableViewCell"];
    
    //ios8 解决分割线没有左对齐问题
    if ([self.subOrderTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.subOrderTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.subOrderTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.subOrderTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateInfo:)
     name:@"updateInfo"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    [self.orderDetailInfo getInfo:self.orderDetailInfo.ID];
}

-(void)updateInfo:(NSNotification *)notification {
    NSDictionary* result = notification.userInfo;
    if ([[result objectForKey:succeed] boolValue]) {
        [self setInfo];
        [self.subOrderTableView reloadData];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    self.loadingView.hidden = YES;
}

-(void)setInfo {
    self.orderSN.text = self.orderDetailInfo.orderID;
    self.storeName.text = self.orderDetailInfo.storeName;
    self.orderTime.text = self.orderDetailInfo.time;
    self.phoneNumber.text = self.orderDetailInfo.phoneNumber;
    self.address.text = self.orderDetailInfo.address;
    self.status.text = self.orderDetailInfo.state;
    self.price.text = [NSString stringWithFormat:@"¥%@",self.orderDetailInfo.price];
    
    if ([self.orderDetailInfo isNoPayment]) {
        self.pay.hidden = NO;
    }
    
//    if (!Data.orderDetialInfo.state.equals("已完成")) {
//        ((LinearLayout)findViewById(R.id.rg_tab)).setVisibility(View.GONE);
//    }
}

- (IBAction)payClick:(id)sender {
    PayOrderViewController* viewController = [[PayOrderViewController alloc] initWithNibName:@"PayOrderViewController" bundle:nil];
    viewController.orderID = self.orderDetailInfo.ID;
    viewController.orderSNValue = self.orderDetailInfo.orderID;
    viewController.storeNameValue = self.orderDetailInfo.storeName;
    viewController.priceType = self.orderDetailInfo.info;
    viewController.pricePay = self.orderDetailInfo.price;
    viewController.isFromOrder = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderDetailInfo.subOrderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubOrderInfo* subOrderInfo = [self.orderDetailInfo.subOrderList objectAtIndex:indexPath.row];
    if (subOrderInfo.operations.count == 0) {
        return 45;
    } else {
        return 80;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SubOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubOrderTableViewCell" forIndexPath:indexPath];
    [cell setContent:[self.orderDetailInfo.subOrderList objectAtIndex:indexPath.row] orderID:self.orderDetailInfo.ID roomID:self.orderDetailInfo.roomID];
    cell.viewController = self;
    
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell layoutIfNeeded];
    return cell;
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

@end
