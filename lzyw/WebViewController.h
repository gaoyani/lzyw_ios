//
//  WebViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property LoadingView* loadingView;

@property NSString* urlString;

@end
