//
//  AboutViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/11.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "AboutViewController.h"
#import "AgreementViewController.h"
#import "Constants.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于软件";
    
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.appVersion.text = version;
    
    UITapGestureRecognizer *agreementTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementClick)];
    [self.agreement addGestureRecognizer:agreementTap];
}

-(void)agreementClick {
    AgreementViewController* veiwController = [[AgreementViewController alloc] initWithNibName:@"AgreementViewController" bundle:nil];
    veiwController.agreementType = agreement_software;
    [self.navigationController pushViewController:veiwController animated:YES];
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
