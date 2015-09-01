//
//  NewsDetailViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/11.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsInfo.h"
#import "Constants.h"

@interface NewsDetailViewController () {
    NewsInfo* newsInfo;
}

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠资讯";
    
    self.webView.scalesPageToFit =YES;
    self.webView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo:) name:@"updateInfo" object:nil];
    
    newsInfo = [[NewsInfo alloc] init];
    [newsInfo getInfo:self.newsID];
}

-(void)updateInfo:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self initInfo];
        self.infoView.hidden = NO;
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[userInfoDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        self.loadingView.hidden = YES;
    }
}

-(void)initInfo {
    self.newsTitle.text = newsInfo.title;
    self.author.text = newsInfo.author;
    self.readTimes.text = newsInfo.scanTimes;
    self.sendTime.text = newsInfo.time;
    
    NSURL *url =[NSURL URLWithString:newsInfo.content];
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
