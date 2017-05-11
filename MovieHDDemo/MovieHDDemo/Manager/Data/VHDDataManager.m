//
//  VHDDataManager.m
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "VHDDataManager.h"

@implementation VHDDataManager
+ (instancetype)sharedData {
    static VHDDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [VHDDataManager new];
    });
    
    return _sharedInstance;
}
@end
