//
//  SettingViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "SettingViewController.h"
#import "MemberEditViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface SettingViewController () {
    PublicInfo* publicInfo;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    publicInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).publicInfo;
    
    UIImage* bgImg = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.cityBG.image = bgImg;
    self.autoLoginBG.image = bgImg;
    self.acountSettingBG.image = bgImg;
    
    [self.logout setBackgroundImage:[[UIImage imageNamed:@"button_pink_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.logout setBackgroundImage:[[UIImage imageNamed:@"button_pink_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *cityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityClick)];
    [self.city addGestureRecognizer:cityTap];
    
    UITapGestureRecognizer *acountSettingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acountSettingClick:)];
    [self.acountSetting addGestureRecognizer:acountSettingTap];
    
    self.cityPicker.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutResult:) name:@"logoutResult" object:nil];
}

-(void)cityClick {
    self.cityPicker.hidden = NO;
    [self.cityPicker reloadAllComponents];
}

- (IBAction)autoLoginValueChanged:(id)sender {
    UISwitch* autoLoginSwitch = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults]  setBool:autoLoginSwitch.isOn forKey:autoLoginKey];
}

- (IBAction)acountSettingClick:(id)sender {
    MemberEditViewController* viewController = [[MemberEditViewController alloc] initWithNibName:@"MemberEditViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)logoutClick:(id)sender {
    MemberInfo* memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    [memberInfo memberLogout];
}

-(void)logoutResult:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[userInfoDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
}

#pragma mark pickerview function
/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return publicInfo.cityArray.count;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:row];
    return cityInfo.name;
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:row];
    self.city.text = cityInfo.name;
    self.cityPicker.hidden = YES;
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
