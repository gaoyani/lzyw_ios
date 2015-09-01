//
//  subOrderTableViewCell.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailInfo.h"
#import "OrderDetailViewController.h"

@interface SubOrderTableViewCell : UITableViewCell {
    SubOrderInfo* subOrderInfo;
    NSString* orderID;
    NSString* roomID;
}

@property (weak, nonatomic) IBOutlet UILabel *subOrderID;
@property (weak, nonatomic) IBOutlet UILabel *subOrderContent;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *operation1;
@property (weak, nonatomic) IBOutlet UIButton *operation2;

@property OrderDetailViewController* viewController;

-(void)setContent:(SubOrderInfo*)orderInfo orderID:(NSString*)orderId roomID:(NSString*)roomId;

@end
