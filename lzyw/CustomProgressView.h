//
//  CustomProgressView.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/3.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomProgressView : UIView

@property (nonatomic) CGFloat progress; //0.0 ~ 1.0
@property (nonatomic, retain) UIImage *trackImage;
@property (nonatomic, retain) UIImage *progressImage;
@property(nonatomic, retain) UIColor *progressTintColor;
@property(nonatomic, retain) UIColor *trackTintColor;

- (void)setProgress:(CGFloat)progress;
- (void)setTrackImage:(UIImage *)trackImage;
- (void)setProgressImage:(UIImage *)progressImage;
- (void)setTrackTintColor:(UIColor *)trackTintColor;
- (void)setProgressTintColor:(UIColor *)progressTintColor;

@end
