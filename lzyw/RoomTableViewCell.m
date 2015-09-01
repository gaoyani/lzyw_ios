//
//  StoreTableViewCell.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/18.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "RoomTableViewCell.h"
#import "StoreDetailInfo.h"
#import "RoomReservationViewController.h"
#import "AppDelegate.h"

@implementation RoomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(RoomTableViewCell *)initRoomCellView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"RoomCell" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)setContent:(ServiceBaseInfo*)baseInfo serviceType:(int)type{
    serviceInfo = baseInfo;
    serviceType = type;
    
    self.nameTitle.text = [NSString stringWithFormat:@"%@：", baseInfo.nameTitle];
    self.name.text = baseInfo.name;
    self.otherTitle.text = [NSString stringWithFormat:@"%@：", baseInfo.otherTitle];
    self.otherInfo.text = baseInfo.otherInfo;
    self.consumeTitle.text = [NSString stringWithFormat:@"%@：", baseInfo.consumeTitle];
    self.consumeValue.text = baseInfo.consumeValue;
    self.priceType.text = [NSString stringWithFormat:@"%@：", baseInfo.priceType];
    self.priceValue.text = [NSString stringWithFormat:@"¥%@", baseInfo.price];
    
    if (serviceType == ServiceTypeRoom) {
        self.consumeOriginal.hidden = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:baseInfo.iconUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.roomImg.image = image;
            });
        }
    });
}

- (IBAction)reservationClick:(id)sender {
    if (serviceType == ServiceTypeRoom) {
        RoomInfo* roomInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).roomInfo;
        roomInfo.serviceID = serviceInfo.serviceID;
        roomInfo.name = serviceInfo.name;
        roomInfo.otherInfo = serviceInfo.otherInfo;
        roomInfo.price = serviceInfo.price;
        roomInfo.priceType = serviceInfo.priceType;
        
        RoomReservationViewController* viewController = [[RoomReservationViewController alloc] initWithNibName:@"RoomReservationViewController" bundle:nil];
        [self.parentViewController.navigationController pushViewController:viewController animated:YES];
    }
}

@end
