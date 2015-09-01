//
//  DetailPicturesView.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/23.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPicturesView : UIView<UIScrollViewDelegate> {
    CGRect rx;
    int viewHeight;
    int boundHeight;
}

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIScrollView* scrollView;
@property UIPageControl* pageControl;
@property UIActivityIndicatorView* indicatorView;

-(void)initView;
-(void)setPictures:(NSString*)pic360Url picUrlArray:(NSArray*)picArray;
@end
