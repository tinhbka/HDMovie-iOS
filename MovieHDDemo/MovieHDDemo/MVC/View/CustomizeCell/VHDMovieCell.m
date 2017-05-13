//
//  VHDMovieCell.m
//  MovieHDDemo
//
//  Created by Tinhvv on 5/11/17.
//  Copyright © 2017 Tinhvv. All rights reserved.
//

#import "VHDMovieCell.h"
#import "UIImageView+AFNetworking.h"
@interface VHDMovieCell()
@property (weak, nonatomic) IBOutlet UIImageView *imvCover;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@end
@implementation VHDMovieCell{
    UIActivityIndicatorView *_loadingView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    
    _loadingView = [[UIActivityIndicatorView alloc] init];
    _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _loadingView.center = _imvCover.center;
    _loadingView.hidesWhenStopped = YES;
    [_imvCover addSubview:_loadingView];
    [_loadingView startAnimating];
}

- (void)fillData:(VHDMovieModel *)movie{
    _lbName.text = movie.MovieName;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:movie.Poster100x149]];
    
    [_imvCover setImageWithURLRequest:request placeholderImage:_imvCover.image success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [self dismissLoading];
        [UIView transitionWithView:_imvCover
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _imvCover.image = image;
                            [_lbName needsUpdateConstraints];
                            [_imvCover needsUpdateConstraints];
                        } completion:nil];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [self dismissLoading];
    }];
}

- (void) dismissLoading{
    [_loadingView stopAnimating];
}


@end
