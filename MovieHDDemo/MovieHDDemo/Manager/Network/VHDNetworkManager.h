//
//  VHDNetworkManager.h
//  BaseProject
//
//  Created by Tinhvv on 8/12/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VHDResponseObject.h"

typedef void(^VHDResponseBlock)(VHDResponseObject* responseObject);

@interface VHDNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedService;

#pragma mark - Auth
- (NSURLSessionDataTask *) resgisterWithEmail:(NSString *)loginId
                   password:(NSString *)password
                   nickname:(NSString *)nickName
                      email:(NSString *)email
                    comment:(NSString *)comment
                 completion:(VHDResponseBlock)completion;

- (NSURLSessionDataTask *) loginWithEmail:(NSString *)userName
               password:(NSString *)password
             completion:(VHDResponseBlock)completion;

- (void) getDataForHomeWithCompletion:(VHDResponseBlock) completion;
@end
