//
//  MainMenuView.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/13.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MainMenu {
    MenuMainPage, MenuMember, MenuSearch, MenuShare, MenuSetting, MenuAbout
};

@interface MainMenuInfo : NSObject
@property UIImage* image;
@property NSString* title;

@end

@interface MainMenuView : UIView<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray* menuArray;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UIViewController* viewController;

+(MainMenuView *)initView;
-(void)viewShow;
-(void)viewDisappear;

@end
