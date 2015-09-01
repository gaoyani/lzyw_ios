//
//  OrderTableViewCell.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "Constants.h"
#import "PayOrderViewController.h"
#import "RoomReservationViewController.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(operateResult:)
     name:@"operateResult"
     object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//+(StoreTableViewCell *)initStoreCellView
//{
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"StoreCell" owner:nil options:nil];
//    return [nibView objectAtIndex:0];
//}

-(void)setContent:(OrderInfo*)info {
    orderInfo = info;
    self.orderSN.text = orderInfo.orderID;
    self.orderTime.text = orderInfo.time;
    self.detialInfo.text = orderInfo.info;
    self.price.text = [NSString stringWithFormat:@"¥%@", orderInfo.price];
    self.orderState.text = orderInfo.state;
    self.storeName.text = orderInfo.storeName;
    self.phoneNum.text = orderInfo.phoneNumber;
    
    if (orderInfo.operations.count == 3) {
        self.operation1.hidden = NO;
        self.operation2.hidden = NO;
        self.operation3.hidden = NO;
        [self setButton:(int)[[orderInfo.operations objectAtIndex:0] integerValue] button:self.operation1];
        [self setButton:(int)[[orderInfo.operations objectAtIndex:1] integerValue] button:self.operation2];
        [self setButton:(int)[[orderInfo.operations objectAtIndex:2] integerValue] button:self.operation3];
    } else if (orderInfo.operations.count == 2) {
        self.operation1.hidden = NO;
        self.operation2.hidden = NO;
        self.operation3.hidden = YES;
        [self setButton:(int)[[orderInfo.operations objectAtIndex:0] integerValue] button:self.operation1];
        [self setButton:(int)[[orderInfo.operations objectAtIndex:1] integerValue] button:self.operation2];
    } else if (orderInfo.operations.count == 1) {
        self.operation1.hidden = NO;
        self.operation2.hidden = YES;
        self.operation3.hidden = YES;
        [self setButton:(int)[[orderInfo.operations objectAtIndex:0] integerValue] button:self.operation1];
    } else {
        self.operation1.hidden = YES;
        self.operation2.hidden = YES;
        self.operation3.hidden = YES;
    }
}

-(void)setButton:(int)operation button:(UIButton*)button {
    [button setTag:operation];
    button.hidden = NO;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    UIImage* orangeUp = [[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:edgeInsets];
    UIImage* orangeDown = [[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:edgeInsets];
    UIImage* pinkUp = [[UIImage imageNamed:@"button_pink_up"] resizableImageWithCapInsets:edgeInsets];
    UIImage* pinkDown = [[UIImage imageNamed:@"button_pink_down"] resizableImageWithCapInsets:edgeInsets];
    UIImage* blueUp = [[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:edgeInsets];
    UIImage* blueDown = [[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:edgeInsets];
    
    switch (operation) {
        case OrderOperationCancel:
            [button setBackgroundImage:orangeUp forState:UIControlStateNormal];
            [button setBackgroundImage:orangeDown forState:UIControlStateHighlighted];
            [button setTitle:@"取消订单" forState:UIControlStateNormal];
            break;
            
        case OrderOperationComment:
            [button setBackgroundImage:blueUp forState:UIControlStateNormal];
            [button setBackgroundImage:blueDown forState:UIControlStateHighlighted];
            [button setTitle:@"我要点评" forState:UIControlStateNormal];
            button.hidden = YES;
            break;
            
        case OrderOperationConfirm:
            [button setBackgroundImage:blueUp forState:UIControlStateNormal];
            [button setBackgroundImage:blueDown forState:UIControlStateHighlighted];
            [button setTitle:@"确认订单" forState:UIControlStateNormal];
            break;
            
        case OrderOperationDelete:
            [button setBackgroundImage:pinkUp forState:UIControlStateNormal];
            [button setBackgroundImage:pinkDown forState:UIControlStateHighlighted];
            [button setTitle:@"删除订单" forState:UIControlStateNormal];
            break;
            
        case OrderOperationReorder:
            [button setBackgroundImage:orangeUp forState:UIControlStateNormal];
            [button setBackgroundImage:orangeDown forState:UIControlStateHighlighted];
            [button setTitle:@"再次预订" forState:UIControlStateNormal];
            break;
            
        case OrderOperationPay:
            [button setBackgroundImage:pinkUp forState:UIControlStateNormal];
            [button setBackgroundImage:pinkDown forState:UIControlStateHighlighted];
            [button setTitle:@"立即支付" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (IBAction)operationClick:(id)sender {
    UIButton* button = (UIButton*)sender;
    int operation = (int)button.tag;
    switch (operation) {
        case OrderOperationCancel:
        case OrderOperationConfirm:
        case OrderOperationDelete:
            [orderInfo operationOrder:operation];
            break;
            
        case OrderOperationComment:
            break;
            
        case OrderOperationReorder: {
            RoomReservationViewController* viewController = [[RoomReservationViewController alloc] initWithNibName:@"RoomReservationViewController" bundle:nil];
            viewController.reservationVia = ReservationViaOrder;
            viewController.orderID = orderInfo.ID;
            viewController.roomID = orderInfo.roomID;
            [self.listViewController.parentNavigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case OrderOperationPay: {
            PayOrderViewController* viewController = [[PayOrderViewController alloc] initWithNibName:@"PayOrderViewController" bundle:nil];
            viewController.orderID = orderInfo.ID;
            viewController.orderSNValue = orderInfo.orderID;
            viewController.storeNameValue = orderInfo.storeName;
            viewController.priceType = orderInfo.info;
            viewController.pricePay = orderInfo.price;
            viewController.isFromOrder = YES;
            [self.listViewController.parentNavigationController pushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }

}

-(void)operateResult:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    NSString* orderID = [resultDic objectForKey:@"order_id"];
    if ([orderID isEqualToString:orderInfo.ID]) {
        BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
        if (isSucceed) {
            [self.listViewController.tableView reloadData];
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[resultDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

@end
