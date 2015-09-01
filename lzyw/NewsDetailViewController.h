//
//  NewsDetailViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/11.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"

@interface NewsDetailViewController : BaseViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *newsTitle;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *readTimes;
@property (strong, nonatomic) IBOutlet UILabel *sendTime;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet LoadingView *loadingView;

@property NSString* newsID;

@end
