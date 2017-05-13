//
//  VHDPlayMovieVC.m
//  MovieHDDemo
//
//  Created by Tinhvv on 5/13/17.
//  Copyright © 2017 Tinhvv. All rights reserved.
//

#import "VHDPlayMovieVC.h"
#import "JDVideoModel.h"
#import "JDPlayerView.h"
#import "JDPlayer.h"

@interface VHDPlayMovieVC ()<JDPlayerDelegate>
@property(nonatomic,assign) BOOL applicationIdleTimerDisabled;
@property(nonatomic,strong) AVPlayer* avPlayer;

@property(nonatomic,strong) JDPlayer* player;
@property(nonatomic,assign) BOOL shouldRotate;

@end

@implementation VHDPlayMovieVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldRotate = YES;
    [self addObserver];
    [self playVideo];
    
    UIButton *buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    [buttonClose setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [self.view addSubview:buttonClose];
    
    [[buttonClose rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_player pauseContent];
        _player = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.view bringSubviewToFront:buttonClose];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)addObserver
{
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)playVideo
{
    JDVideoModel* videoModel = [[JDVideoModel alloc]init];
    videoModel.streamURL = [NSURL URLWithString:_linkPlay];
    
    [self.player loadVideoModel:videoModel];
}

#pragma mark - App States

- (void)applicationWillResignActive
{
    self.player.jdView.countdownToHide = -1;
    
    if (self.player.state == JDPlayerStatePlaying)
    {
        [self.player pauseContent:NO recordCurrentTime:YES completionHandler:nil];
    }
}

- (void)applicationDidBecomeActive
{
    self.player.jdView.countdownToHide = -1;
}

- (void)videoPlayer:(JDPlayer*)videoPlayer didPlayToEnd:(JDVideoModel *)videoModel
{
//    if(self.currentIndex < self.testUrls.count)
//    {
//        JDVideoModel* nextTrack = [[JDVideoModel alloc]init];
//        nextTrack.streamURL = [NSURL URLWithString:self.testUrls[self.currentIndex++]];
//        
//        if(self.currentIndex == self.testUrls.count - 1)
//        {
//            nextTrack.hasNext = NO;
//        }
//        else
//        {
//            nextTrack.hasNext = YES;
//        }
//        
//        [self.player loadVideoModel:nextTrack];
//    }
}

- (void) videoPlayer:(JDPlayer *)videoPlayer didNextVideoButtonPressed:(JDVideoModel *)videoModel
{
    [self videoPlayer:videoPlayer didPlayToEnd:videoModel];
}

- (void)handleErrorCode:(JDPlayerErrorCode)errorCode track:(JDVideoModel *)track customMessage:(NSString*)customMessage
{
    NSLog(@"errorCode : %ld,message : %@ , url : %@",(long)errorCode,customMessage,track.streamURL);
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    return self.shouldRotate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return self.shouldRotate;
}

- (JDPlayer *)player
{
    if(!_player)
    {
        _player = [[JDPlayer alloc] init];
        _player.delegate = self;
        [self.view addSubview:_player.jdView];
        _player.jdView.frame = self.view.bounds;
    }
    
    return _player;
}


@end
