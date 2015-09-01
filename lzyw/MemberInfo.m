//
//  MemberInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "MemberInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "UrlConstants.h"

@implementation MemberInfo

-(MemberInfo*)init {
    self = [super init];
    if (self) {
        self.isLogin = NO;
        self.isAutoLogout = NO;
    }
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return self;
}

-(NSString*)getName {
    if (self.nickName != nil && self.nickName.length != 0) {
        return self.nickName;
    } else if (self.userName != nil && self.userName.length != 0){
        return self.userName;
    } else {
        return self.uidName;
    }
}

-(NSString*)getLocation {
    return [NSString stringWithFormat:@"%f,%f", self.longitude, self.latitude];
//    return @"0,0";
}

-(void)memberLogin:(NSString*)userName password:(NSString*)password isLogin:(BOOL)isLogin {
    interfaceType = InterfaceLogin;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:userName  forKey:@"user_name"];
    [paramsDic setValue:[Utils md5:(password == nil ? @"" : password)] forKey:@"password"];
    NSLog(@"Login:%@", [Utils getDeviceUUID]);
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: [NSNumber numberWithBool:isLogin] forKey:@"login"];
    
    [self.netConnection startConnect:loginUrl paramsDictionary:paramsDic];
}

-(void)memberLogout {
    interfaceType = InterfaceLogout;
    [self.netConnection startConnectGet:[NSString stringWithFormat:@"%@user_id/%@", logoutUrl, self.memberID]];
}

-(void)memberRegister:(NSString*)phoneNumber password:(NSString*)password authCode:(NSString*)authCode {
    interfaceType = InterfaceRegister;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:phoneNumber forKey:@"mobile_phone"];
    [paramsDic setValue:[Utils md5:password] forKey:@"password"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: authCode forKey:@"code"];
    
    [self.netConnection startConnect:registerUrl paramsDictionary:paramsDic];
}

-(void)getMemberInfo {
    interfaceType = InterfaceGetInfo;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[[UIApplication sharedApplication] delegate]).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    
    [self.netConnection startConnect:memberInfoUrl paramsDictionary:paramsDic];
}

-(void)resetPassword:(NSString *)phoneNumber password:(NSString *)password authCode:(NSString *)authCode {
    interfaceType = InterfaceResetPassword;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:phoneNumber forKey:@"mobile_phone"];
    [paramsDic setValue:[Utils md5:password] forKey:@"password"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: authCode forKey:@"code"];
    
    [self.netConnection startConnect:resetPasswordUrl paramsDictionary:paramsDic];
}

-(void)resetPayPassword:(NSString*)phoneNumber password:(NSString*)password safeAnswer:(NSString*)safeAnswer authCode:(NSString*)authCode {
    interfaceType = InterfaceResetPayPassword;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:phoneNumber forKey:@"mobile_phone"];
    [paramsDic setValue:[Utils md5:password] forKey:@"password"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: authCode forKey:@"code"];
    [paramsDic setValue: safeAnswer forKey:@"passwd_answer"];
    
    [self.netConnection startConnect:resetPayPasswordUrl paramsDictionary:paramsDic];
}

-(void)modifyPassword:(NSString*)oldPassword password:(NSString*)newPassword passwordType:(enum PasswordType)passwordType {
    interfaceType = InterfaceModifyPassword;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils md5:oldPassword] forKey:@"old_password"];
    [paramsDic setValue:[Utils md5:newPassword] forKey:@"password"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:[NSNumber numberWithInt:passwordType] forKey:@"password_type"];
    
    [self.netConnection startConnect:editPasswordUrl paramsDictionary:paramsDic];
}

-(void)modifyPhoneNumber:(NSString*)oldPhoneNum newPhoneNumber:(NSString*)newPhoneNum safeAnswer:(NSString*)safeAnswer authCode:(NSString*)authCode {
    interfaceType = InterfaceModifyPhoneNumber;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:oldPhoneNum forKey:@"old_mobile_phone"];
    [paramsDic setValue:newPhoneNum forKey:@"mobile_phone"];
    [paramsDic setValue:safeAnswer forKey:@"passwd_answer"];
    [paramsDic setValue:authCode forKey:@"code"];
    
    [self.netConnection startConnect:editPhoneNumUrl paramsDictionary:paramsDic];
}

-(void)modifyNormalInfo:(UIImage*)identImage identFileName:(NSString*)identFileName {
    interfaceType = InterfaceModifyNormalInfo;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:self.safeQuestion forKey:@"passwd_question"];
    [paramsDic setValue:self.safeAnswer forKey:@"passwd_answer"];
    [paramsDic setValue:self.email forKey:@"email"];
    [paramsDic setValue:self.birthday forKey:@"birthday"];
    [paramsDic setValue:self.billTitile forKey:@"invoice_title"];
    [paramsDic setValue:self.address forKey:@"invoice_address"];
    [paramsDic setValue:[NSNumber numberWithInt:self.idType] forKey:@"card_id_type"];
    [paramsDic setValue:self.identifyNum forKey:@"card_id"];
    
    [self.netConnection startConnectWithImage:editUserNormalInfoUrl paramsDictionary:paramsDic picImage:identImage picFileName:identFileName];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        if (interfaceType == InterfaceResetPassword || interfaceType == InterfaceResetPayPassword || interfaceType == InterfaceModifyPassword || interfaceType == InterfaceModifyPhoneNumber || interfaceType == InterfaceModifyNormalInfo) {
            NSString* resultMsg = [self parseResetPasswordResult: output];
            if ([resultMsg isEqualToString:succeed]) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:resultMsg forKey:errorMessage];
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            }
        } else if (interfaceType == InterfaceLogout) {
            NSString* resultMsg = [self parseLogoutResult: output];
            if ([resultMsg isEqualToString:succeed]) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:resultMsg forKey:errorMessage];
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            }
        } else {
            NSString* errMsg = [self parseMemberInfo: output];
            if ([errMsg isEqualToString:succeed]) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else if ([errMsg isEqualToString:alreadyLogin]){
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:alreadyLogin];
            } else if ([errMsg isEqualToString:@""]) {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:alreadyLogin];
                [userInfoDic setValue:(interfaceType == InterfaceRegister ? @"注册失败" : @"登录失败") forKey:errorMessage];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:alreadyLogin];
                [userInfoDic setValue:errMsg forKey:errorMessage];
            }
        }

    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    NSString* resultName = @"loginResult";
    if (interfaceType == InterfaceRegister) {
        resultName = @"registeResult";
    } else if (interfaceType == InterfaceResetPassword || interfaceType == InterfaceResetPayPassword) {
        resultName = @"resetResult";
    } else if (interfaceType == InterfaceGetInfo) {
        resultName = @"getInfoResult";
    } else if (interfaceType == InterfaceModifyPassword || interfaceType == InterfaceModifyPhoneNumber || interfaceType == InterfaceModifyNormalInfo) {
        resultName = @"submitResult";
    } else if(interfaceType == InterfaceLogout) {
        resultName = @"logoutResult";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:resultName object:self userInfo:userInfoDic];
}

-(NSString*)parseResetPasswordResult:(NSString*)jsonString {
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDic != nil && error == nil) {
        int errorCode = (int)[[jsonDic objectForKey:@"error"] integerValue];
        if (errorCode == 0) {
            return succeed;
        } else {
            if (interfaceType == InterfaceResetPayPassword || interfaceType == InterfaceModifyPassword || interfaceType == InterfaceModifyPhoneNumber) {
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) autoLogout:[[jsonDic objectForKey:@"is_login"] boolValue]];
            }
            
            return [jsonDic objectForKey:@"message"];
        }
    }
    
    return @"重置失败";
}

-(NSString*)parseLogoutResult:(NSString*)jsonString {
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDic != nil && error == nil) {
        int errorCode = (int)[[jsonDic objectForKey:@"error"] integerValue];
        if (errorCode == 0) {
            self.isLogin = NO;
            return succeed;
        } else {
            return [jsonDic objectForKey:@"message"];
        }
    }
    
    return @"退出登录失败";
}


-(NSString*)parseMemberInfo:(NSString*)jsonString {
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDic != nil && error == nil) {
        
        if (interfaceType == InterfaceGetInfo) {
            NSDictionary* contentDic = [jsonDic objectForKey:@"content"];
            if (contentDic == nil || contentDic.count == 0) {
                self.isAutoLogout = (self.isLogin && ![jsonDic objectForKey:@"is_login"]);
                AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate autoLogout:[[jsonDic objectForKey:@"is_login"] boolValue]];
            } else {
                [self parseInfo:contentDic];
                
                return succeed;
            }
        } else {
            int errorCode = (int)[[jsonDic objectForKey:@"error"] integerValue];
            if (errorCode == 0) {
                NSDictionary* contentDic = [jsonDic objectForKey:@"user_info"];
                [self parseInfo:contentDic];
                
                return succeed;
                
            } else if (errorCode == 2) {
                if (interfaceType == InterfaceRegister) {
                    return [jsonDic objectForKey:@"message"];
                } else {
                    return alreadyLogin;
                }
                
            } else {
                return [jsonDic objectForKey:@"message"];
            }

        }
        
    }
    
    return @"";
}

-(void)parseInfo:(NSDictionary*)contentDic {
    self.memberID = [contentDic objectForKey:@"user_id"];
    self.userName = [contentDic objectForKey:@"user_name"];
    self.nickName = [contentDic objectForKey:@"nickname"];
    self.uidName = [contentDic objectForKey:@"uid"];
    self.realName = [contentDic objectForKey:@"user_name"];
    self.sex = (int)[[contentDic objectForKey:@"sex"] integerValue];
    self.birthday = [contentDic objectForKey:@"birthday"];
    self.phoneNum = [contentDic objectForKey:@"mobile_phone"];
    self.imgUrl = [contentDic objectForKey:@"head_pic"];
    self.account = [contentDic objectForKey:@"user_money"];
    self.grades = [contentDic objectForKey:@"pay_points"];
    self.curLevel = [contentDic objectForKey:@"rank_name"];
    self.nextLevel = [contentDic objectForKey:@"next_rank_name"];
    self.curLevelPoints = (int)[[contentDic objectForKey:@"min_points"] integerValue];
    self.nextLevelPoints = (int)[[contentDic objectForKey:@"next_min_points"] integerValue];
    self.curPoints = (int)[[contentDic objectForKey:@"rank_points"] integerValue];
    self.promotionTips = [contentDic objectForKey:@"rank_tab"];
    self.mouthBook = [contentDic objectForKey:@"month_order"];
    self.mouthConsume = [contentDic objectForKey:@"month_money"];
    self.mouthGrades = [contentDic objectForKey:@"month_points"];
    self.recommend = [contentDic objectForKey:@"nocomment"];
    self.totalBook = [contentDic objectForKey:@"order_count"];
    self.totleConsume = [contentDic objectForKey:@"order_money"];
    self.safeQuestion = [contentDic objectForKey:@"passwd_question"];
    self.safeAnswer = [contentDic objectForKey:@"passwd_answer"];
    self.email = [contentDic objectForKey:@"email"];
    self.billTitile = [contentDic objectForKey:@"invoice_title"];
    self.address = [contentDic objectForKey:@"invoice_address"];
    self.idType = (int)[[contentDic objectForKey:@"card_id_type"] integerValue];
    self.identifyNum = [contentDic objectForKey:@"card_id"];
    self.identifyImg = [contentDic objectForKey:@"card_id_pic"];
    
    self.isSetPayPassword = [[contentDic objectForKey:@"is_set_payment_password"] boolValue];
    
    self.isLogin = true;

}


@end
