//
//  VHDHomeVC.m
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import "VHDHomeVC.h"
#import "KIImagePager.h"
#import "VHDMovieModel.h"
#import "VHDMovieByCateModel.h"
#import "VHDMovieCell.h"
#import "VHDHeaderView.h"

@interface VHDHomeVC () <KIImagePagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet KIImagePager *bannerSlider;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) VHDMovieModel *currentBannerModel;

@end
static NSString *movieCellID = @"movieCell";
@implementation VHDHomeVC{
    NSMutableArray *_listMovieBanner, *_listMovieByCategory;
    NSMutableArray *_listLinkBanner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"Say: %@",OMLang(@"Hello"));
    
    [self initData];
    
    [self showLoading];
    @weakify(self)
    [[self getDataForHome] subscribeNext:^(NSDictionary *dict) {
        @strongify(self)
        [self parseData:dict];
    }error:^(NSError * _Nullable error) {
        @strongify(self)
        [self showErrorWithStatus:@"Error"];
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
    [_collectionView registerNib:[UINib nibWithNibName:@"VHDMovieCell" bundle:nil] forCellWithReuseIdentifier:movieCellID];
    [_collectionView registerNib:[UINib nibWithNibName:@"VHDHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}

- (RACSignal *) getDataForHome{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.networkManager getDataForHomeWithCompletion:^(VHDResponseObject *responseObject) {
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

- (void) parseData:(NSDictionary *)dict{
    self->_listMovieBanner = [NSMutableArray array];
    self->_listMovieByCategory = [NSMutableArray array];
    self->_listLinkBanner = [NSMutableArray array];
    NSArray *movieBanners = [dict objectForKey:@"Movies_Banners"];
    NSArray *movieByCategory = [dict objectForKey:@"MoviesByCates"];
    
    if (movieBanners && movieBanners.count) {
        for(NSDictionary *dictBanner in movieBanners){
            VHDMovieModel *movieM = [[VHDMovieModel alloc] initWithDictionary:dictBanner error:nil];
            if (movieM) {
                [self->_listMovieBanner addObject:movieM];
                [self->_listLinkBanner addObject:movieM.Cover];
            }
        }
    }
    
    if (movieByCategory && movieByCategory.count) {
        for(NSDictionary *dictByCate in movieByCategory){
            VHDMovieByCateModel *movieByCateM = [[VHDMovieByCateModel alloc] initWithDictionary:dictByCate error:nil];
            if (movieByCateM) {
                if (movieByCateM.Movies && movieByCateM.Movies.count) {
                    movieByCateM.listMovie = [NSMutableArray array];
                    for (NSDictionary *dictMovie in movieByCateM.Movies) {
                        VHDMovieModel *movieM = [[VHDMovieModel alloc] initWithDictionary:dictMovie error:nil];
                        if (movieM) {
                            [movieByCateM.listMovie addObject:movieM];
                        }
                    }
                }
                [self->_listMovieByCategory addObject:movieByCateM];
            }
        }
    }
    [_collectionView reloadData];
    [self createBannerSliderView];
}

#pragma mark CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self->_listMovieByCategory.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    VHDMovieByCateModel *cateModel = [self->_listMovieByCategory objectAtIndex:section];
    return MIN(6, cateModel.listMovie.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VHDMovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:movieCellID forIndexPath:indexPath];
    VHDMovieByCateModel *cateModel = [self->_listMovieByCategory objectAtIndex:indexPath.section];
    [cell fillData:[cateModel.listMovie objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat margin = 10;
    CGFloat itemWidth = (collectionView.frame.size.width - margin * 4)/3;
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth * 1.6);
    return itemSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        VHDHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        VHDMovieByCateModel *cateModel = [self->_listMovieByCategory objectAtIndex:indexPath.section];
        headerView.lbTitle.text = cateModel.CategoryName;
        [[headerView.btnMore rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            DLog(@"Touch load more video");
        }];
        reusableview = headerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, 50.0);
}

#pragma mark Banner
- (void) createBannerSliderView{
    _bannerSlider.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    _bannerSlider.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _bannerSlider.slideshowTimeInterval = 3.0f;
    _bannerSlider.slideshowShouldCallScrollToDelegate = YES;
    _bannerSlider.delegate = self;
    [_bannerSlider reloadData];
    
    _currentBannerModel = [self->_listMovieBanner objectAtIndex:0];
    _movieName.text = _currentBannerModel.MovieName;
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return self->_listLinkBanner;
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index{
    
}

- (void)imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index{
    _currentBannerModel = [self->_listMovieBanner objectAtIndex:index];
    _movieName.text = _currentBannerModel.MovieName;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFill;
}


@end
