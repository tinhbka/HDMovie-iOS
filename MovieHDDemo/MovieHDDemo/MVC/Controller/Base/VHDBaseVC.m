//
//  VHDBaseVC.m
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "VHDBaseVC.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImageView+AFNetworking.h"
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

#pragma mark Load Image
- (void)setImageForImageView:(UIImageView *)imageView url:(NSURL *)url animate:(BOOL)animate{
    UIActivityIndicatorView *_loadingView = [[UIActivityIndicatorView alloc] init];
    _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _loadingView.center = imageView.center;
    _loadingView.hidesWhenStopped = YES;
    [imageView addSubview:_loadingView];
    [_loadingView startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak UIImageView *weakImageView = imageView;
    [imageView setImageWithURLRequest:request placeholderImage:imageView.image success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [_loadingView stopAnimating];
        if (animate) {
            [UIView transitionWithView:weakImageView
                              duration:0.5f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakImageView.image = image;
                            } completion:nil];

        }else{
            weakImageView.image = image;
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [_loadingView stopAnimating];
    }];
}

@end
