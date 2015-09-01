//
//  StoreTableViewCell.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/18.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "Constants.h"

@implementation StoreTableViewCell

- (void)awakeFromNib {
    //初始化评分视图,代理为ViewController自己
    [self.ratingView setImagesDeselected:@"store_rating_off.png" partlySelected:@"store_rating_on.png" fullSelected:@"store_rating_on.png" andDelegate:self];
    //设置评分
    [self.ratingView displayRating:1.5];
    [self.ratingView setEditable:false];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectResult:) name:@"collectResult" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//实现代理方法
-(void)ratingChanged:(float)newRating {
    
}

+(StoreTableViewCell *)initStoreCellView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"StoreCell" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)setContent:(StoreInfo*)info {
    storeInfo = info;
    self.storeTitle.text = storeInfo.name;
    self.price.text = storeInfo.cpp;
    self.address.text = storeInfo.address;
    self.distance.text = storeInfo.distance;
    [self.ratingView displayRating:storeInfo.stars];

    [self.collectBtn setBackgroundImage:[UIImage imageNamed:(storeInfo.favorite ? @"heart_act" : @"heart")] forState:UIControlStateNormal];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:storeInfo.iconUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.storeImg.image = image;
            });
        }
    });
}

- (IBAction)collectClick:(id)sender {
    [storeInfo collect:!storeInfo.favorite];
}

-(void)collectResult:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    NSString* storeID = [resultDic objectForKey:@"store_id"];
    if ([storeID isEqualToString:storeInfo.storeID]) {
        BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
        if (isSucceed) {
            storeInfo.favorite = !storeInfo.favorite;
            [self.collectBtn setBackgroundImage:[UIImage imageNamed:(storeInfo.favorite ? @"heart_act" : @"heart")] forState:UIControlStateNormal];
            
            [self.viewController resetCollect:(StoreDetailInfo*)storeInfo];
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[resultDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

@end
