//
//  OrderDetailViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"
#import "OrderDetailInfo.h"

@interface OrderDetailViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *orderSN;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITableView *subOrderTableView;
@property (weak, nonatomic) IBOutlet UIButton *pay;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@property OrderDetailInfo* orderDetailInfo;

@end
