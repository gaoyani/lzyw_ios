//
//  ItemListView.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/13.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemListView : UIView<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* newsArray;
}

@property (strong, nonatomic) IBOutlet UIView *dlgView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property UIViewController* parentViewController;

+(ItemListView *)initView;
-(void)viewShow;
-(void)setNewsArray:(NSMutableArray*)array;
@end
