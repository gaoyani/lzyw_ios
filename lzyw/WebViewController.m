//
//  WebViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商户主页";
    
    self.webView.scalesPageToFit =YES;
    self.webView.delegate = self;
    
    CGRect rx = [UIScreen mainScreen].bounds;
    self.loadingView = [LoadingView initView];
    [self.loadingView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.loadingView showView];
    [self.view addSubview:self.loadingView];

    NSURL *url =[NSURL URLWithString:self.urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.loadingView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.loadingView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
