//
//  MainViewController.m
//  LGSideMenuControllerDemo
//

#import "MainViewController.h"
#import "VHDHomeVC.h"
#import "LeftViewController.h"


@interface MainViewController ()

@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromLittle;
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];

    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (BOOL)isLeftViewStatusBarHidden {
    return super.isLeftViewStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"MainViewController deallocated");
}

@end
