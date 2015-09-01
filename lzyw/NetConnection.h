//
//  NetConnection.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NetConnectionDelegate <NSObject>

@required
-(void)NetConnectionResult:(NSMutableDictionary *)result;

@end


@interface NetConnection : NSObject

@property(assign,nonatomic)id<NetConnectionDelegate> delegate;

@property NSMutableData* connectData;

-(void)startConnect:(NSString*)connectUrl paramsDictionary:(NSMutableDictionary*)paramsDic;
-(void)startConnectGet:(NSString*)connectUrl;
-(void)startConnectWithImage: (NSString*)connectUrl
                    paramsDictionary:(NSMutableDictionary*)paramsDic
                    picImage: (UIImage*)picImage
                    picFileName: (NSString *)picFileName;

@end

