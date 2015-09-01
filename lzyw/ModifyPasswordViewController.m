//
//  ModifyPasswordViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    UIImage* bgImg = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.oldPasswordBG.image = bgImg;
    self.passwordBG.image = bgImg;
    self.confirmPasswordBG.image = bgImg;
    
    [self.submit setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.submit setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    self.oldPassword.delegate = self;
    self.password.delegate = self;
    self.confirmPassword.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitResult:) name:@"submitResult" object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)submitClick:(id)sender {
    if ([self checkInput]) {
        [self.loadingView setLoadingText:@"正在提交..."];
        [self.loadingView showView];
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo modifyPassword:self.oldPassword.text password:self.password.text passwordType:self.isModifyPayPassword ? PasswordTypePay : PasswordTypeLogin];
    }
}

-(BOOL)checkInput {
    if (self.oldPassword.text.length < 6 || self.password.text.length < 6) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入六位以上字符密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    }
    
    if (![self.password.text isEqualToString:self.confirmPassword.text]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"两次输入的密码不一致，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    }
    
    return YES;
}

-(void)submitResult:(NSNotification*)notification {
    self.loadingView.hidden = YES;
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[userInfoDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
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
