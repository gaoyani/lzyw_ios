//
//  RecommendView.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/17.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendItemInfo.h"

@interface RecommendView : UIView {
    RecommendItemInfo* recommendItemInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;



+(RecommendView *)initRecommendView;
-(void)setContent:(RecommendItemInfo*)info;

@end
