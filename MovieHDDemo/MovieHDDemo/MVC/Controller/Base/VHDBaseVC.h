//
//  VHDBaseVC.h
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHDGlobal.h"
#import "VHDNetworkManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>

@interface VHDBaseVC : UIViewController
@property (nonatomic, strong, readonly) VHDNetworkManager *networkManager;

- (void) showLoading;
- (void) dismissLoading;
- (void) showLoadingWithMessage:(NSString *)string;
- (void) showErrorWithStatus:(NSString *)string;

- (void) setImageForImageView:(UIImageView *)imageView url:(NSURL *)url animate:(BOOL)animate;
@end
