//
//  ZYRatingView.h
//  RatingViewDemo
//
//  Created by zhangyuc on 13-5-22.
//  Copyright (c) 2013年 zhangyuc. All rights reserved.
//

#import <UIKit/UIKit.h>


//设置代理
@protocol RatingViewDelegate <NSObject>
//代理方法
-(void)ratingChanged:(float)newRating;

@end


@interface ZYRatingView : UIView{
    //声明星图片视图
    UIImageView *s1,*s2,*s3,*s4,*s5;
    //声明三种图片对象：未选中，选中一部分，全选中
    UIImage *unselectedImage,*partlySelectedImage,*fullySelectedImage;
    //声明代理
    id<RatingViewDelegate> viewDelegate;
    
    
    float starRating, lastRating;//开始等级，最后等级
	float height, width; // 每张星图的高度和宽度
    bool editable; //是否可以点击评分
}

//为星图片视图设置setter方法
@property(nonatomic,retain) UIImageView *s1;
@property(nonatomic,retain) UIImageView *s2;
@property(nonatomic,retain) UIImageView *s3;
@property(nonatomic,retain) UIImageView *s4;
@property(nonatomic,retain) UIImageView *s5;

//设置评分的星图
-(void)setImagesDeselected:(NSString *)unselectedImage partlySelected:(NSString *)partlySelectedImage
			  fullSelected:(NSString *)fullSelectedImage andDelegate:(id<RatingViewDelegate>)d;
//设置评分
-(void)displayRating:(float)rating;
//设置等级
-(float)rating;
//设置是否可以点击评分
-(void)setEditable:(bool)isEditable;

@end
