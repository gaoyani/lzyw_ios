//
//  DetailInfoView.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/25.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYRatingView.h"
#import "StoreDetailInfo.h"

@interface StoreDetailInfoView : UIView
@property (weak, nonatomic) IBOutlet ZYRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *service;
@property (weak, nonatomic) IBOutlet UILabel *recommend;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *privilege;
@property (weak, nonatomic) IBOutlet UIButton *bookByPhone;

+(StoreDetailInfoView*)initView;
-(void)setInfo:(StoreDetailInfo*) storeInfo;

@end
