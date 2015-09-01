//
//  RecommendView.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/17.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "RecommendView.h"
#import "StoreDetailViewController.h"
#import "WebViewController.h"
#import "NewsDetailViewController.h"
#import "AppDelegate.h"

@implementation RecommendView

-(void)awakeFromNib {
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *viewClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
    [self.imageView addGestureRecognizer:viewClick];
}

-(void)imageViewClick{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&object != nil) {
        object = [object nextResponder];
    }
    UIViewController *parentController=(UIViewController*)object;
    
    if (recommendItemInfo.type == RecommendTypeStore) {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StoreDetailViewController* viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"StoreDetailViewController"];
        viewController.storeID = recommendItemInfo.content;
        [parentController.navigationController pushViewController:viewController animated:YES];
    } else if (recommendItemInfo.type == RecommendTypeWeb) {
        WebViewController* viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        viewController.urlString = recommendItemInfo.content;
        viewController.hidesBottomBarWhenPushed = YES;
        [parentController.navigationController pushViewController:viewController animated:YES];
    } else {
        NewsDetailViewController* viewController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
        viewController.newsID = recommendItemInfo.content;
        viewController.hidesBottomBarWhenPushed = YES;
        [parentController.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)setContent:(RecommendItemInfo*)info
{
    recommendItemInfo = info;
    self.title.text = info.title;
    self.price.text = [NSString stringWithFormat:@"¥%@",info.price];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:info.picUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    });
}

/**  *  初始化代码:  *  *  @return [nibView objectAtIndex:0]  */
+ (RecommendView *)initRecommendView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"RecommendView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
