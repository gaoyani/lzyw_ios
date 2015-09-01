//
//  DetailPicturesView.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/23.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "DetailPicturesView.h"

@implementation DetailPicturesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initView {
    rx = [UIScreen mainScreen].bounds;
    viewHeight = rx.size.width*2/3;
    boundHeight = 2;
    [self addBounds];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, boundHeight, rx.size.width, viewHeight-boundHeight*2)];
    [self addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.center=CGPointMake(rx.size.width*0.5, viewHeight-10);
    self.pageControl.currentPageIndicatorTintColor=[UIColor grayColor];
    self.pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    self.pageControl.currentPage=1;
    [self addSubview:self.pageControl];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = CGPointMake(rx.size.width*0.5, viewHeight*0.5);
    [self.indicatorView startAnimating]; // 开始旋转
    [self.indicatorView setHidesWhenStopped:YES]; //当旋转结束时隐藏
    [self addSubview:self.indicatorView];

}

-(void)setPictures:(NSString*)pic360Url picUrlArray:(NSArray*)picArray {
    
    if (pic360Url != nil && ![pic360Url isEqualToString:@""]) {
        [self load360Pic:pic360Url];
        return;
    }
    
    int width = picArray.count*rx.size.width;
    self.scrollView.contentSize=CGSizeMake(width, viewHeight);
    self.scrollView.pagingEnabled=YES;
    
    self.pageControl.numberOfPages=picArray.count;
    
    for (int i=0; i<picArray.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL * url = [NSURL URLWithString:[picArray objectAtIndex:i]];
            NSData * data = [[NSData alloc]initWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc]initWithData:data];
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView *itemImage=[[UIImageView alloc] init];
                    itemImage.image = image;
                    itemImage.frame=CGRectMake(i*rx.size.width, 0, rx.size.width, viewHeight-boundHeight*2);
                    [self.scrollView addSubview:itemImage];
                    
                    [self.indicatorView stopAnimating]; // 结束旋转
                });
            }
        });

    }

}

-(void)load360Pic:(NSString*)pic360Url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:pic360Url];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                int width = image.size.width*viewHeight/image.size.height;
                UIImageView *itemImage=[[UIImageView alloc] init];
                itemImage.image = image;
                itemImage.frame=CGRectMake(0, 0, width, viewHeight-boundHeight*2);
                itemImage.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:itemImage];
                
                self.scrollView.frame = CGRectMake(0, boundHeight, rx.size.width, viewHeight-boundHeight*2);
                [self.scrollView setContentOffset:CGPointMake((width-rx.size.width)/2, 0) animated:NO];
                self.scrollView.contentSize = CGSizeMake(width, viewHeight);
                
                [self.indicatorView stopAnimating]; // 结束旋转
            });
        }
    });
}

-(void)addBounds {
    UIImageView *topLine=[[UIImageView alloc] init];
    topLine.backgroundColor = [UIColor orangeColor];
    topLine.frame=CGRectMake(0, 0, rx.size.width, 2);
    [self addSubview:topLine];

    UIImageView *bottomLine=[[UIImageView alloc] init];
    bottomLine.backgroundColor = [UIColor orangeColor];
    bottomLine.frame=CGRectMake(0, viewHeight-2, rx.size.width, 2);
    [self addSubview:bottomLine];

}

//#pragma mark 当滑动ViewPager时停下来 让对应的指示器进行改变
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offSetX = scrollView.contentOffset.x;
    int index = offSetX/self.frame.size.width;
    self.pageControl.currentPage=index;
}

@end
