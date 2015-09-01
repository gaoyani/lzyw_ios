//
//  OrderTableViewCell.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"
#import "ListViewController.h"

@interface OrderTableViewCell : UITableViewCell {
    OrderInfo* orderInfo;
}

@property (weak, nonatomic) IBOutlet UILabel *orderSN;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *detialInfo;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *operation1;
@property (weak, nonatomic) IBOutlet UIButton *operation2;
@property (weak, nonatomic) IBOutlet UIButton *operation3;

@property ListViewController* listViewController;

-(void)setContent:(OrderInfo*)orderInfo;

@end
