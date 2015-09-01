//
//  SetPayPasswordViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/15.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "AppDelegate.h"
#import "UrlConstants.h"
#import "Constants.h"

@interface SetPayPasswordViewController ()

@end

@implementation SetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isReset ? @"忘记支付密码" : @"设置支付密码";
    
    memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetResult:)
     name:@"resetResult"
     object:nil];
    
    authCodeTask = [[AuthCodeTask alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(authCodeResult:)
     name:@"authCodeResult"
     object:nil];
    
    isAuthCodeInvalid = NO;
    isCountDown = NO;
    
    self.safeQustion.text = [NSString stringWithFormat:@"%@%@", self.safeQustion.text, memberInfo.safeQuestion];
    
    UIImage* bgImg = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.phoneNumBG.image = bgImg;
    self.passwordBG.image = bgImg;
    self.passwordConfirmBG.image = bgImg;
    self.safeAnswerBG.image = bgImg;
    self.safeQustionBG.image = bgImg;
    self.authCodeBG.image = bgImg;

    [self.resetBtn setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.resetBtn setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    [self resetAuthCodeBtn:YES];
    
    self.phoneNumber.text = memberInfo.phoneNum;
    
    self.phoneNumber.delegate = self;
    self.authCode.delegate = self;
    self.safeAnswer.delegate = self;
    self.password.delegate = self;
    self.passwordConfirm.delegate = self;
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
        [authCodeTask getAuthCode:self.phoneNumber.text autoCodeUrl:paymentPasswordAuthCodeUrl];
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

- (IBAction)resetClick:(id)sender {
    if ([self checkInput]) {
        [self.loadingView setLoadingText:@"正在提交..."];
        [self.loadingView showView];
        [memberInfo resetPayPassword:self.phoneNumber.text password:self.password.text safeAnswer:self.safeAnswer.text authCode:self.authCode.text];
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
    }
    
    return YES;
}

-(void)resetResult:(NSNotification*)notification {
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
