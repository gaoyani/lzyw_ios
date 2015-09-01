//
//  BaseViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/24.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "BaseViewController.h"
#import "Utils.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Utils getDeviceVersion] >= 7.0) {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
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
