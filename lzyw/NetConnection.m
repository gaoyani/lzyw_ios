//
//  NetConnection.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "NetConnection.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AFHTTPRequestOperationManager.h"

@implementation NetConnection

-(void)startConnect:(NSString*)connectUrl paramsDictionary:(NSMutableDictionary*)paramsDic{
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString * urlString = [appDelegate.domainNameUrl stringByAppendingString:connectUrl];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:5];
    if (paramsDic != nil) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"dic->%@",error);
        }
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        // 设置执行方式
        request.HTTPMethod = @"post";
        request.HTTPBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    }
   
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    [conn start];
    NSLog(@"执行POST");
}

-(void)startConnectGet:(NSString*)connectUrl {
    NSURL *url = [NSURL URLWithString:connectUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}

-(void)startConnectWithImage:(NSString*)connectUrl ImageUrl:(NSString*)imageUrl paramsDictionary:(NSMutableDictionary*)paramsDic{
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString * urlString = [appDelegate.domainNameUrl stringByAppendingString:connectUrl];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:5];
    if (paramsDic != nil) {
        NSError *error = nil;
        NSMutableData* contentData = [NSMutableData data];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"dic->%@",error);
        }
        
        [contentData appendData:jsonData];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        // 设置执行方式
        request.HTTPMethod = @"post";
        request.HTTPBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    }
    
    
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    [conn start];
    NSLog(@"执行POST");
}

-(void)startConnectWithImage: (NSString*)connectUrl paramsDictionary:(NSMutableDictionary*)paramsDic
                     picImage: (UIImage*)picImage  // IN
                     picFileName: (NSString *)picFileName;  // IN
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString * urlString = [appDelegate.domainNameUrl stringByAppendingString:connectUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"dic->%@",error);
        } else {
            [formData appendPartWithFormData:jsonData name:@"params"];
            if (picImage != nil) {
//                NSURL *fileURL = [NSURL URLWithString:picFilePath];
//                [formData appendPartWithFileURL:fileURL name:@"image" error:NULL];
                NSData *imageData = UIImagePNGRepresentation(picImage);
                [formData appendPartWithFileData:imageData name:@"image" fileName:picFileName mimeType:@""];
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *output = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", output);
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setValue:output forKey:message];
        [userInfoDic setValue:[NSNumber numberWithBool:true] forKey:succeed];
        [self.delegate NetConnectionResult:userInfoDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self connection:nil didFailWithError:error];
    }];
}

#pragma mark -
#pragma mark Connection DelegateMethod

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"收到回应");
    if (!self.connectData) {
        self.connectData = [NSMutableData data];
    } else {
        [self.connectData resetBytesInRange:NSMakeRange(0, [self.connectData length])];
        [self.connectData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"收到数据");
    [self.connectData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *output = [[NSString alloc] initWithData:self.connectData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", output);
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setValue:output forKey:message];
    [userInfoDic setValue:[NSNumber numberWithBool:true] forKey:succeed];
    [self.delegate NetConnectionResult:userInfoDic];
//    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:userInfoDic];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    assert(error);
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setValue:@"连接超时，请检查网络" forKey:errorMessage];
    [userInfoDic setValue:[NSNumber numberWithBool:false] forKey:succeed];
    [self.delegate NetConnectionResult:userInfoDic];
//    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:userInfoDic];
}

@end
