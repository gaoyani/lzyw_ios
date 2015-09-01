//
//  RegisterViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/28.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "UrlConstants.h"
#import "Constants.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员注册";
    
    memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(registeResult:)
     name:@"registeResult"
     object:nil];
    
    authCodeTask = [[AuthCodeTask alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(authCodeResult:)
     name:@"authCodeResult"
     object:nil];

    isAuthCodeInvalid = NO;
    isCountDown = NO;
    
    self.phoneNumBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.passwordBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.passwordConfirmBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.authCodeBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    
    [self.registerBtn setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    [self resetAuthCodeBtn:YES];
    
    self.agree.selected = YES;
    [self.agree setImage:[UIImage imageNamed:@"login_checked.png"]forState:UIControlStateNormal];
    
    self.phoneNumber.delegate = self;
    self.password.delegate = self;
    self.passwordConfirm.delegate = self;
    self.authCode.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)resetAuthCodeBtn:(BOOL)isValid {
    if (isValid) {
        [self.authCodeBtn setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
        [self.authCodeBtn setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
        [self.authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.authCodeBtn setBackgroundImage:[[UIImage imageNamed:@"reservation_invalid"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    }
}

- (IBAction)getAuthCodeClick:(id)sender {
    if (isCountDown) {
        return;
    }
    
    if ([self.phoneNumber.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入注册手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else {
        countDownSeconds = 90;
        [self resetAuthCodeBtn:NO];
        isCountDown = YES;
        [authCodeTask getAuthCode:self.phoneNumber.text autoCodeUrl:registerAuthCodeUrl];
    }
}

-(void)authCodeResult:(NSNotification*)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        isAuthCodeInvalid = NO;
        authCodeSave = [[userInfoDic objectForKey:message] integerValue];
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
    } else {
        [self resetAuthCodeBtn:YES];
        isCountDown = NO;
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[userInfoDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
}

- (void)timerAdvanced:(NSTimer *)timer {
    countDownSeconds--;
    [self.authCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d秒)", countDownSeconds] forState:UIControlStateNormal];
    if (countDownSeconds == 0) {
        isCountDown = NO;
        isAuthCodeInvalid = YES;
        [countDownTimer invalidate];
        countDownTimer = nil;
        [self resetAuthCodeBtn:YES];
    }
}

- (IBAction)agreeClick:(id)sender {
    self.agree.selected = !self.agree.selected;
    if (self.agree.selected) {
        [self.agree setImage:[UIImage imageNamed:@"login_checked.png"]forState:UIControlStateNormal];
    } else {
        [self.agree setImage:[UIImage imageNamed:@"login_checkbox.png"]forState:UIControlStateNormal];
    }
}

- (IBAction)registerClick:(id)sender {
    if ([self checkInput]) {
        [self.loadingView showView];
        [memberInfo memberRegister:self.phoneNumber.text password:self.password.text authCode:self.authCode.text];
    }
}

-(BOOL)checkInput {
    if ([self.phoneNumber.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入注册手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    } else if (self.password.text.length < 6){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入六位以上注册密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    } else if (![self.password.text isEqualToString:self.passwordConfirm.text]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"两次输入密码不一致，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    } else if([self.authCode.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    } else if (isAuthCodeInvalid){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"验证码失效，请重新获取" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    } else if (authCodeSave  != [self.authCode.text integerValue]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"验证码错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    } else if (!self.agree.selected) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请阅读《乐自由我手机应用软件用户注册及使用协议》" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    }

    return YES;
}

-(void)registeResult:(NSNotification*)notification {
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
