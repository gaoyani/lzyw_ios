//
//  AppDelegate.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ShareViewController.h"

@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.domainNameUrl = @"http://182.92.158.59/api.php";     //lezi
//    self.domainNameUrl = @"http://125.35.14.247/lezi/api.php"; //huiwei
//    self.domainNameUrl = @"http://192.168.22.233/lezi/api.php"; //huzhangfei
    
    self.storeDetailInfo = [[StoreDetailInfo alloc] init];
    self.roomInfo = [[RoomInfo alloc] init];
    
    self.memberInfo = [[MemberInfo alloc] init];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:autoLoginKey]) {
        [self.memberInfo memberLogin:[userDefaults valueForKey:userNameKey] password:[userDefaults valueForKey:passwordKey] isLogin:NO];
    } else {
        self.memberInfo.memberID = @"";
    }
    
    
    self.publicInfo = [[PublicInfo alloc] init];
    [self.publicInfo getNetData];
    
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.mapManager start:@"pVfWlmXFbBDDBYXlQBfn1iyA" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
//    self.locationManager = [[CLLocationManager alloc] init];
//    BOOL enable=[CLLocationManager locationServicesEnabled];
//    //是否具有定位权限
//    int status=[CLLocationManager authorizationStatus];
//    [self.locationManager requestAlwaysAuthorization];
//    
//    if(!enable || status<3){
//        //请求权限
//        [self.locationManager requestWhenInUseAuthorization];
//    }
    
    //设置tabbar
    UITabBarController* tabBarController = (UITabBarController*)self.window.rootViewController;
    ShareViewController* shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:shareViewController];
//    [tabBarController presentViewController:n animated:NO completion:nil];
    
    NSArray *oldArray = tabBarController.viewControllers;
    NSArray *newArray = [[NSArray alloc] initWithObjects:oldArray[0],oldArray[1],navigationViewController,oldArray[3],nil];
    
    tabBarController.viewControllers = newArray;

    UITabBar* tabBar = tabBarController.tabBar;
    UITabBarItem* tabBarItem0 = [tabBar.items objectAtIndex:0];
    UITabBarItem* tabBarItem1 = [tabBar.items objectAtIndex:1];
    UITabBarItem* tabBarItem2 = [tabBar.items objectAtIndex:2];
    UITabBarItem* tabBarItem3 = [tabBar.items objectAtIndex:3];
    
    [tabBar setBackgroundImage:[[UIImage imageNamed:@"tab_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 0, 0)]];
    UIImage* tabMainImage = [UIImage imageNamed:@"tab_main_down"];
    
    tabBarItem0.selectedImage = [Utils scaleToSize:tabMainImage size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];
    tabBarItem0.image = [Utils scaleToSize:[UIImage imageNamed:@"tab_main"] size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];
    tabBarItem0.titlePositionAdjustment = UIOffsetMake(0, 15);
    tabBarItem0.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    
    tabBarItem1.selectedImage = [Utils scaleToSize:[UIImage imageNamed:@"tab_search_down"] size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];
    tabBarItem1.image = [Utils scaleToSize:[UIImage imageNamed:@"tab_search"] size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];;
    tabBarItem1.titlePositionAdjustment = UIOffsetMake(0, 15);
    tabBarItem1.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    
    tabBarItem2.selectedImage = [Utils scaleToSize:[UIImage imageNamed:@"tab_share_down"] size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];
    tabBarItem2.image = [Utils scaleToSize:[UIImage imageNamed:@"tab_share"] size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];;
    tabBarItem2.titlePositionAdjustment = UIOffsetMake(0, 15);
    tabBarItem2.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    
    tabBarItem3.selectedImage = [Utils scaleToSize:[UIImage imageNamed:@"tab_member_down"] size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];
    tabBarItem3.image = [Utils scaleToSize:[UIImage imageNamed:@"tab_member"] size:CGSizeMake(48*tabMainImage.size.width/tabMainImage.size.height, 48)];;
    tabBarItem3.titlePositionAdjustment = UIOffsetMake(0, 15);
    tabBarItem3.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    
    //导航栏背景色及标题
    if ([Utils getDeviceVersion] < 7.0) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.0f green:133/255.0 blue:0.0f alpha:1]];
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0f green:133/255.0 blue:0.0f alpha:1]];
//        [[UINavigationBar appearance] setTranslucent:NO];
        if([Utils getDeviceVersion] > 8.0 && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            [[UINavigationBar appearance] setTranslucent:NO];
        } else {
            [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:1.0f green:133/255.0 blue:0.0f alpha:1]];
        }
    }
    
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIColor whiteColor],NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20],NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navTitleArr];
    
    //设置返回按钮图片
    UIImage *backUP=[UIImage imageNamed:@"button_back_up"];
    UIImage *backDown=[UIImage imageNamed:@"button_back_down"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backUP resizableImageWithCapInsets:UIEdgeInsetsMake(0, backUP.size.width, 0, 0)]
                          forState:UIControlStateNormal
                        barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backDown resizableImageWithCapInsets:UIEdgeInsetsMake(0, backDown.size.width, 0, 0)]
                          forState:UIControlStateHighlighted
                         barMetrics:UIBarMetricsDefault];
    
    //去掉返回按钮的标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000.f, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}

-(void)autoLogout:(BOOL)isLogin {
    if (!self.memberInfo.isLogin || isLogin) {
        return;
    }
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"安全提示" message:@"您的帐号在另一个设备登录，您被迫下线，如果这不是您本人操作，那么您的密码可能已经泄露，请联系我们修改密码。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
    self.memberInfo = nil;
    self.memberInfo = [[MemberInfo alloc] init];
    self.memberInfo.memberID = @"0";
    self.memberInfo.isLogin = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//设置屏幕旋转
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}



@end
