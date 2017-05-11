//
//  VHDMovieModel.h
//  MovieHDDemo
//
//  Created by Tinhvv on 5/11/17.
//  Copyright © 2017 Tinhvv. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VHDMovieModel : JSONModel
@property (nonatomic, strong) NSString* Cover;
@property (nonatomic, strong) NSString* MovieName;
@property (nonatomic, strong) NSString* CategoryName;
@property (nonatomic, strong) NSString* MovieID;
@property (nonatomic, strong) NSString* KnownAs;
@property (nonatomic, strong) NSString* Movielink;
@property (nonatomic, strong) NSString* Slug;
@property (nonatomic, strong) NSString* CategoryID;
@property (nonatomic, strong) NSString* Poster100x149;
@end
