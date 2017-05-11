//
//  VHDBaseVC.m
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "VHDBaseVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface VHDBaseVC()
@property (nonatomic, strong) VHDNetworkManager *networkManager;
@end

@implementation VHDBaseVC

- (VHDNetworkManager *) networkManager{
    if (!_networkManager) {
        _networkManager = [VHDNetworkManager sharedService];
    }
    return _networkManager;
}

#pragma mark Loading
- (void)showLoading{
    [SVProgressHUD show];
}

- (void)showLoadingWithMessage:(NSString *)string{
    [SVProgressHUD showWithStatus:string];
}

- (void) showErrorWithStatus:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
}

- (void)dismissLoading{
    [SVProgressHUD dismiss];
}

@end
