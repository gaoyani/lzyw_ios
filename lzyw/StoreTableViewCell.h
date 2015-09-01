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
#import "StoreTableViewController.h"

@interface StoreTableViewCell : UITableViewCell<RatingViewDelegate> {
    StoreInfo* storeInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *storeImg;
@property (weak, nonatomic) IBOutlet UILabel *storeTitle;
@property (retain, nonatomic) IBOutlet ZYRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIButton *collectBtn;

@property StoreTableViewController* viewController;

+(StoreTableViewCell *)initStoreCellView;
-(void)setContent:(StoreInfo*)info;

@end
