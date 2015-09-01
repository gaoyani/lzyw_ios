//
//  MemberInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

enum SexType { male, female};
enum IdentType { IdentNull, IdentIDCard, IdentPassport, IdentOfficerCard, IdentOther};

enum InterfaceType { InterfaceLogin, InterfaceLogout, InterfaceRegister, InterfaceGetInfo, InterfaceResetPassword, InterfaceResetPayPassword, InterfaceModifyPassword, InterfaceModifyPhoneNumber, InterfaceModifyNormalInfo};

enum PasswordType { PasswordTypeNone, PasswordTypeLogin, PasswordTypePay };

@interface MemberInfo : NSObject<NetConnectionDelegate> {
    enum InterfaceType interfaceType;
}

@property NSString* memberID;
@property NSString* nickName;
@property NSString* realName;
@property NSString* userName;
@property NSString* uidName;
@property NSString* phoneNum;
@property int sex;
@property NSString* birthday;
@property NSString* email;
@property NSString* billTitile;
@property NSString* address;
@property int idType;
@property NSString* identifyNum;
@property NSString* identifyImg;

@property BOOL isLogin;
@property BOOL isAutoLogout;
@property BOOL isSetPayPassword;
@property double longitude;
@property double latitude;
@property NSString* imgUrl;
@property NSString* curLevel;
@property int curLevelPoints;
@property NSString* nextLevel;
@property int nextLevelPoints;
@property int curPoints;
@property NSString* promotionTips;
@property NSString* account;
@property NSString* grades;
@property NSString* mouthBook;
@property NSString* mouthConsume;
@property NSString* mouthGrades;
@property NSString* recommend;
@property NSString* totalBook;
@property NSString* totleConsume;

@property NSString* safeQuestion;
@property NSString* safeAnswer;

//public List<CardInfo> cardList = new ArrayList<CardInfo>();

-(MemberInfo*)init;
-(NSString*)getName;
-(NSString*)getLocation;

@property NetConnection* netConnection;
-(void)memberLogin:(NSString*)userName password:(NSString*)password isLogin:(BOOL)isLogin;
-(void)memberLogout;
-(void)memberRegister:(NSString*)phoneNumber password:(NSString*)password authCode:(NSString*)authCode;
-(void)getMemberInfo;
-(void)resetPassword:(NSString*)phoneNumber password:(NSString*)password authCode:(NSString*)authCode;
-(void)resetPayPassword:(NSString*)phoneNumber password:(NSString*)password safeAnswer:(NSString*)safeAnswer authCode:(NSString*)authCode;
-(void)modifyPassword:(NSString*)oldPassword password:(NSString*)newPassword passwordType:(enum PasswordType)passwordType;
-(void)modifyPhoneNumber:(NSString*)oldPhoneNum newPhoneNumber:(NSString*)newPhoneNum safeAnswer:(NSString*)safeAnswer authCode:(NSString*)authCode;
-(void)modifyNormalInfo:(UIImage*)identImage identFileName:(NSString*)identFileName;
//-(NSString*)parseMemberInfo:(NSString*)jsonString;

@end
