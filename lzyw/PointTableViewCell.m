//
//  PointTableViewCell.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "PointTableViewCell.h"

@implementation PointTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(PointInfo*)pointInfo {
    self.storeName.text = pointInfo.name;
    self.time.text = pointInfo.time;
    self.pointType.text = pointInfo.type;
    self.price.text = pointInfo.price;
}

@end
