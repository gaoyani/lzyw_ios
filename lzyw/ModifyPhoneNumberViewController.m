//
//  ModifyPhoneNumberViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ModifyPhoneNumberViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AuthCodeTask.h"
#import "UrlConstants.h"

@interface ModifyPhoneNumberViewController () {
    MemberInfo* memberInfo;
    int authCodeSave;
    BOOL isAuthCodeInvalid;
    BOOL isCountDown;
    int countDownSeconds;
    
    AuthCodeTask* authCodeTask;
    NSTimer* countDownTimer;
}

@end

@implementation ModifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改手机号码";
    
    memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(submitResult:)
     name:@"submitResult"
     object:nil];
    
    authCodeTask = [[AuthCodeTask alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(authCodeResult:)
     name:@"authCodeResult"
     object:nil];
    
    isAuthCodeInvalid = NO;
    isCountDown = NO;
    
    self.safeQuestion.text = [NSString stringWithFormat:@"%@%@", self.safeQuestion.text, memberInfo.safeQuestion];
    
    UIImage* bgImg = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.oldPhoneNumBG.image = bgImg;
    self.phoneNumBG.image = bgImg;
    self.safeAnswerBG.image = bgImg;
    self.safeQuestionBG.image = bgImg;
    self.authCodeBG.image = bgImg;
    
    [self.submit setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.submit setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    [self resetAuthCodeBtn:YES];
    
    self.oldPhoneNum.text = memberInfo.phoneNum;
    
    self.phoneNum.delegate = self;
    self.authCode.delegate = self;
    self.safeAnswer.delegate = self;
    self.oldPhoneNum.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)resetAuthCodeBtn:(BOOL)isValid {
    if (isValid) {
        [self.getAuthCode setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
        [self.getAuthCode setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
        [self.getAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.getAuthCode setBackgroundImage:[[UIImage imageNamed:@"reservation_invalid"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    }
}

- (IBAction)getAuthCodeClick:(id)sender {
    if (isCountDown) {
        return;
    }
    
    if ([self.phoneNum.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入注册手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else {
        countDownSeconds = 90;
        [self resetAuthCodeBtn:NO];
        isCountDown = YES;
        [authCodeTask getAuthCode:self.phoneNum.text autoCodeUrl:editInfoAuthCodeUrl];
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
    [self.getAuthCode setTitle:[NSString stringWithFormat:@"重新获取(%d秒)", countDownSeconds] forState:UIControlStateNormal];
    if (countDownSeconds == 0) {
        isCountDown = NO;
        isAuthCodeInvalid = YES;
        [countDownTimer invalidate];
        countDownTimer = nil;
        [self resetAuthCodeBtn:YES];
    }
}

- (IBAction)submitClick:(id)sender {
    if ([self checkInput]) {
        [self.loadingView setLoadingText:@"正在提交..."];
        [self.loadingView showView];
        [memberInfo modifyPhoneNumber:self.oldPhoneNum.text newPhoneNumber:self.phoneNum.text safeAnswer:self.safeAnswer.text authCode:self.authCode.text];
    }
}

-(BOOL)checkInput {
    if ([self.oldPhoneNum.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入注册手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return NO;
    } else if (self.phoneNum.text.length < 6){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入六位以上注册密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
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
