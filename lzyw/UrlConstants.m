//
//  URLConstants.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "UrlConstants.h"

NSString* const mainPageUrl = @"/index/index/";
NSString* const publicInfoUrl = @"/index/app_public/";
NSString* const newsInfoUrl = @"/index/news_info/";
NSString* const agreementUrl = @"/index/get_agreement/";

NSString* const qrInfoUrl = @"/qrcode/index/";

NSString* const storeInfoUrl = @"/Business/business_info/";
NSString* const roomInfoUrl = @"/Business/room_info/";
NSString* const mapStoreListUrl = @"/Business/business_map/";
NSString* const recommendStoreListUrl = @"/Business/business_list/";
NSString* const aroundStoreListUrl = @"/Business/business_ambitus/";
NSString* const collectStoreListUrl = @"/Business/business_collect/";
NSString* const collectStoreUrl = @"/Business/collect_business/";

NSString* const loginUrl = @"/user/login/";
NSString* const logoutUrl = @"/user/login_out/";
NSString* const registerUrl = @"/user/register/";
NSString* const memberInfoUrl = @"/user/user_info/";
NSString* const resetPasswordUrl = @"/user/reset_rassword/";
NSString* const resetPayPasswordUrl = @"/user/reset_payment_password/";

NSString* const editUserInfoUrl = @"/user/edit_user/";
NSString* const editPhoneNumUrl = @"/user/edit_phone/";
NSString* const editPasswordUrl = @"/user/edit_password/";
NSString* const editUserNormalInfoUrl = @"/user/edit_user_use/";

NSString* const orderListUrl = @"/user/order_list/";
NSString* const orderDetailUrl = @"/user/order_info/";
NSString* const pointListUrl = @"/user/user_pay_points/";
NSString* const commentListUrl = @"/user/user_comment/";

NSString* const operateOrderUrl = @"/user/order_operable/";
NSString* const operateSubOrderUrl = @"/order/calendar_operable/";

NSString* const paymentUrl = @"/order/set_pay_status/";
NSString* const confirmRechargeUrl = @"/pay/update/";
NSString* const createRechargeUrl = @"/pay/insert/";

NSString* const registerAuthCodeUrl = @"/user/getcode/"; //login
NSString* const editInfoAuthCodeUrl = @"/user/geteditcode/"; //edit info
NSString* const paymentPasswordAuthCodeUrl = @"/user/get_payment_code/"; //set or reset pay password
NSString* const resetPasswordAuthCodeUrl = @"/user/getpasswordcode/"; //reset password

NSString* const addRoomOrderUrl = @"/order/order_insert/";
NSString* const reservationDetailUrl = @"/order/index/";

NSString* const submitCommentUrl = @"/comment/comment_insert";

NSString* const getPayResultUrl = @"/respond/verify_pay/";

@implementation UrlConstants

@end
