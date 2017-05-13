//
//  VHDMovieDetailVC.m
//  MovieHDDemo
//
//  Created by Tinhvv on 5/13/17.
//  Copyright © 2017 Tinhvv. All rights reserved.
//

#import "VHDMovieDetailVC.h"
#import "VHDPlayMovieVC.h"

@interface VHDMovieDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imvBanner;
@property (weak, nonatomic) IBOutlet UIView *viewPoster;
@property (weak, nonatomic) IBOutlet UIImageView *imvPoster;
@property (weak, nonatomic) IBOutlet UILabel *lbMovieName;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayTrailer;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;



@end

@implementation VHDMovieDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [[_btnBack rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[_btnPlayTrailer rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self showLoading];
        @weakify(self)
        [[self getLinkPlay] subscribeNext:^(NSDictionary *responseData) {
            @strongify(self)
            NSString *playLink = [responseData objectForKey:@"LinkPlay"];
            VHDPlayMovieVC *playMovieVC = [[VHDPlayMovieVC alloc] init];
            playMovieVC.linkPlay = playLink;
            [self.navigationController presentViewController:playMovieVC animated:YES completion:nil];
        }error:^(NSError * _Nullable error) {
            @strongify(self)
            [self showErrorWithStatus:@"Get Detail Error"];
        } completed:^{
            @strongify(self)
            [self dismissLoading];
        }];
    }];
    
    [self showLoading];
    @weakify(self)
    [[self getDetailForMovie] subscribeNext:^(NSDictionary *responseData) {
        @strongify(self)
        NSString *posterLink = [responseData objectForKey:@"Poster214x321"];
        [self setImageForImageView:self.imvPoster url:[NSURL URLWithString:posterLink] animate:YES];
    }error:^(NSError * _Nullable error) {
        @strongify(self)
        [self showErrorWithStatus:@"Get Detail Error"];
    } completed:^{
        @strongify(self)
        [self dismissLoading];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    if (_movieM) {
        if (_movieM.Cover) {
            [self setImageForImageView:self.imvBanner url:[NSURL URLWithString:_movieM.Cover] animate:YES];
        }
        if (_movieM.MovieName && _movieM.MovieName.length) {
            _lbMovieName.text = _movieM.MovieName;
        }
    }
}

- (RACSignal *) getDetailForMovie{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.networkManager getDetailForMovie:self.movieM.MovieID ep:@"0" completion:^(VHDResponseObject *responseObject) {
            DLog(@"Get detail for movie: %@", responseObject.responseData);
            if (!responseObject.responseCode.boolValue) {
                [subscriber sendNext:(NSDictionary *)responseObject.responseData];
            }else{
                [subscriber sendError:nil];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *) getLinkPlay{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.networkManager getLinkPlayForMovie:self.movieM.MovieID ep:@"0" completion:^(VHDResponseObject *responseObject) {
            DLog(@"Get link play for movie: %@", responseObject.responseData);
            if (!responseObject.responseCode.boolValue) {
                [subscriber sendNext:(NSDictionary *)responseObject.responseData];
            }else{
                [subscriber sendError:nil];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
