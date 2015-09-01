//
//  LoginViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "Constants.h"
#import "ResetPasswordViewController.h"
#import "Constants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员登录";
    self.navigationItem.rightBarButtonItem = [self customRightButton];
//    [self.navigationItem setHidesBackButton:YES]; //屏蔽左侧返回键
    
    memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loginResult:)
     name:@"loginResult"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    
    self.userNameBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.passwordBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    [self.login setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.login setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:rememberMeKey]) {
        self.userName.text = [[NSUserDefaults standardUserDefaults] valueForKey:userNameKey];
    }
    
    self.autoLogin.selected = [[NSUserDefaults standardUserDefaults] boolForKey:autoLoginKey];
    [self setAutoLogin];
    self.rememberMe.selected = [[NSUserDefaults standardUserDefaults] boolForKey:rememberMeKey];
    [self setRememberMe];
    
    self.forgetPassword.userInteractionEnabled = YES;
    UITapGestureRecognizer* forgetPasswordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordClick)];
    [self.forgetPassword addGestureRecognizer:forgetPasswordTap];
    
    CGRect rx = [UIScreen mainScreen].bounds;
    self.loadingView = [LoadingView initView];
    [self.loadingView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    self.loadingView.hidden = YES;
    [self.loadingView setLoadingText:@"正在登录..."];
    [self.view addSubview:self.loadingView];
    
    self.userName.delegate = self;
    self.password.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)forgetPasswordClick {
    NSLog(@"click forget password");
    ResetPasswordViewController* viewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(UIBarButtonItem*)customRightButton{
    UIImage *btnUP=[UIImage imageNamed:@"button_title_bg_up.png"];
    UIImage *btnDown=[UIImage imageNamed:@"button_title_bg_down.png"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    btn.frame=CGRectMake(0, 0, 60, self.navigationController.navigationBar.frame.size.height-10);
    [btn setBackgroundImage:btnUP forState:UIControlStateNormal];
    [btn setBackgroundImage:btnDown forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}

-(void)registerBtnClick{
    RegisterViewController* viewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
 }

- (IBAction)autoLoginClick:(id)sender {
    self.autoLogin.selected = !self.autoLogin.selected;
    [self setAutoLogin];
}

-(void)setAutoLogin {
    if (self.autoLogin.selected) {
        [self.autoLogin setImage:[UIImage imageNamed:@"login_checked.png"]forState:UIControlStateNormal];
    } else {
        [self.autoLogin setImage:[UIImage imageNamed:@"login_checkbox.png"]forState:UIControlStateNormal];
    }
}

- (IBAction)rememberMeClick:(id)sender {
    self.rememberMe.selected = !self.rememberMe.selected;
    [self setRememberMe];
}

-(void)setRememberMe {
    if (self.rememberMe.selected) {
        [self.rememberMe setImage:[UIImage imageNamed:@"login_checked.png"]forState:UIControlStateNormal];
    } else {
        [self.rememberMe setImage:[UIImage imageNamed:@"login_checkbox.png"]forState:UIControlStateNormal];
    }
}

- (IBAction)loginClick:(id)sender {
    [self.loadingView showView];
    if ([self.userName.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入用户名或手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        self.loadingView.hidden = YES;
    } else {
        if ([self.password.text isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"请输入登录密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            self.loadingView.hidden = YES;
        } else {
            [memberInfo memberLogin:self.userName.text password:self.password.text isLogin:NO];
        }
    }
}

-(void)loginResult:(NSNotification *)notification {
    self.loadingView.hidden = YES;
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [[NSUserDefaults standardUserDefaults]  setValue:self.userName.text forKey:userNameKey];
        [[NSUserDefaults standardUserDefaults]  setValue:self.password.text forKey:passwordKey];
        [[NSUserDefaults standardUserDefaults]  setBool:self.rememberMe.selected forKey:rememberMeKey];
        [[NSUserDefaults standardUserDefaults]  setBool:self.autoLogin.selected forKey:autoLoginKey];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([[userInfoDic objectForKey:alreadyLogin] boolValue]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"您的账号已在另一个设备登录，是否继续登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alter show];
        } else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[userInfoDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }
    }
}



#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [memberInfo memberLogin: self.userName.text password:self.password.text isLogin:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.memberInfo.isLogin) {
        [self.navigationController popViewControllerAnimated:YES];
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
