//
//  DetailInfoView.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/25.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreDetailInfoView.h"
#import "NewsInfo.h"

@implementation StoreDetailInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(StoreDetailInfoView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"StoreDetailInfoView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)setInfo:(StoreDetailInfo*) storeInfo {
    [self.ratingView setImagesDeselected:@"store_rating_off.png" partlySelected:@"store_rating_on.png" fullSelected:@"store_rating_on.png" andDelegate:nil];
    [self.ratingView displayRating:storeInfo.stars];
    [self.ratingView setEditable:false];
    
    self.service.text = storeInfo.service;
    self.recommend.text = storeInfo.recommend;
    self.address.text = storeInfo.address;
    
    [self setPrivileges:storeInfo.newsArray];
}

-(void)setPrivileges:(NSArray*) newsArray {
    NSString* privilegeMsg = @"";
    for (int i=0; i<newsArray.count; i++) {
        NewsInfo* info = [newsArray objectAtIndex:i];
        privilegeMsg = [privilegeMsg stringByAppendingString:[NSString stringWithFormat:@"%d.%@    ",i+1,info.title]];
    }
    self.privilege.text = privilegeMsg;
    
    CGRect rx = [UIScreen mainScreen].bounds;
    CGRect frame = self.privilege.frame;
    frame.origin.x = rx.size.width;
    self.privilege.frame = frame;
    
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:8.8f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:999999];
    
    frame = self.privilege.frame;
    frame.origin.x = -rx.size.width;
    self.privilege.frame = frame;
    [UIView commitAnimations];
}

@end
