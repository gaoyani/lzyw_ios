//
//  StoreTableViewCell.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/18.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYRatingView.h"
#import "StoreInfo.h"
#import "ServiceBaseInfo.h"
#import "StoreDetailInfo.h"

@interface RoomTableViewCell : UITableViewCell {
    ServiceBaseInfo* serviceInfo;
    int serviceType;
}

@property (weak, nonatomic) IBOutlet UIImageView *roomImg;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *otherTitle;
@property (weak, nonatomic) IBOutlet UILabel *otherInfo;
@property (weak, nonatomic) IBOutlet UILabel *consumeTitle;
@property (weak, nonatomic) IBOutlet UILabel *consumeValue;
@property (weak, nonatomic) IBOutlet UILabel *consumeOriginal;
@property (weak, nonatomic) IBOutlet UILabel *priceType;
@property (weak, nonatomic) IBOutlet UILabel *priceValue;
@property (weak, nonatomic) IBOutlet UIButton *reservation;

@property UIViewController* parentViewController;


+(RoomTableViewCell *)initRoomCellView;
-(void)setContent:(ServiceBaseInfo*) roomInfo serviceType:(int)serviceType;

@end
