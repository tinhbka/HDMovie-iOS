//
//  VHDMovieByCateModel.h
//  MovieHDDemo
//
//  Created by Tinhvv on 5/11/17.
//  Copyright © 2017 Tinhvv. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VHDMovieByCateModel : JSONModel
@property (nonatomic, strong) NSString * CategoryName;
@property (nonatomic, strong) NSArray * Movies;
@property (nonatomic, strong) NSMutableArray * listMovie;
@property (nonatomic, strong) NSString * CategoryID;
@end
