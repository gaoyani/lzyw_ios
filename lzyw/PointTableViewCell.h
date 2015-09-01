//
//  PointTableViewCell.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointInfo.h"

@interface PointTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *pointType;
@property (weak, nonatomic) IBOutlet UILabel *price;

-(void)setContent:(PointInfo*)pointInfo;

@end
