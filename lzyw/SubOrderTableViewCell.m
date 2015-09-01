//
//  subOrderTableViewCell.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "SubOrderTableViewCell.h"
#import "Constants.h"
#import "RoomReservationViewController.h"

@implementation SubOrderTableViewCell

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

-(void)setContent:(SubOrderInfo*)info orderID:(NSString*)orderId roomID:(NSString*)roomId{
    subOrderInfo = info;
    orderID = orderId;
    roomID = roomId;
    self.subOrderID.text = subOrderInfo.ID;
    self.subOrderContent.text = subOrderInfo.info;
    self.status.text = subOrderInfo.state;
    self.price.text = [NSString stringWithFormat:@"¥%@", subOrderInfo.price];
    self.operationView.hidden = NO;
    if (subOrderInfo.operations.count == 2) {
        self.operation1.hidden = NO;
        self.operation2.hidden = NO;
        [self setButton:(int)[[subOrderInfo.operations objectAtIndex:0] integerValue] button:self.operation1];
        [self setButton:(int)[[subOrderInfo.operations objectAtIndex:1] integerValue] button:self.operation2];
    } else if (subOrderInfo.operations.count == 1) {
        self.operation1.hidden = NO;
        self.operation2.hidden = YES;
        [self setButton:(int)[[subOrderInfo.operations objectAtIndex:0] integerValue] button:self.operation1];
    } else {
        self.operationView.hidden = YES;
    }
}

-(void)setButton:(int)operation button:(UIButton*)button {
    [button setTag:operation];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    UIImage* orangeUp = [[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:edgeInsets];
    UIImage* orangeDown = [[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:edgeInsets];
    UIImage* pinkUp = [[UIImage imageNamed:@"button_pink_up"] resizableImageWithCapInsets:edgeInsets];
    UIImage* pinkDown = [[UIImage imageNamed:@"button_pink_down"] resizableImageWithCapInsets:edgeInsets];
    
    switch (operation) {
        case OrderOperationCancel:
            [button setBackgroundImage:orangeUp forState:UIControlStateNormal];
            [button setBackgroundImage:orangeDown forState:UIControlStateHighlighted];
            [button setTitle:@"取消订单" forState:UIControlStateNormal];
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
            
        default:
            break;
    }
}

- (IBAction)operationClick:(id)sender {
    UIButton* button = (UIButton*)sender;
    int operation = (int)button.tag;
    switch (operation) {
        case OrderOperationCancel:
        case OrderOperationDelete:
            [subOrderInfo operationOrder:operation];
            break;
            
        case OrderOperationReorder:{
            RoomReservationViewController* viewController = [[RoomReservationViewController alloc] initWithNibName:@"RoomReservationViewController" bundle:nil];
            viewController.reservationVia = ReservationViaSubOrder;
            viewController.orderID = orderID;
            viewController.subOrderID = subOrderInfo.ID;
            viewController.roomID = roomID;
            [self.viewController.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)operateResult:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    NSString* orderID = [resultDic objectForKey:@"order_id"];
    if ([orderID isEqualToString:subOrderInfo.ID]) {
        BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
        if (isSucceed) {
            [self.viewController.subOrderTableView reloadData];
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[resultDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}


@end
