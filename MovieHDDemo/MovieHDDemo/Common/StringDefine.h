//
//  StringDefine.h
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#ifndef StringDefine_h
#define StringDefine_h

//MARK: - API
static NSString * const kPOST                           = @"POST";
static NSString * const kGET                            = @"GET";

static NSString *const kSign = @"sign=790657bff0963e6e0bf882a763633c7e";

//MARK: - API Path
static NSString * const kPathRegister                   = @"api/register";
static NSString * const kPathLogin                      = @"api/auth";
static NSString * const kPathGetHome = @"movie/homepage?";
static NSString * const kPathGetListCategory = @"category/menu?key=phim&";
//static NSString * const kPathGetLinkPlay = @"movie/homepage?";
//static NSString * const kPathGetMovieForCategory = @"movie/homepage?";
//static NSString * const kPathSearch = @"movie/homepage?";
//static NSString * const kPathGetMovieDetail = @"movie/homepage?";


// Register
static NSString * const kUserName                       = @"username";
static NSString * const kPassword                       = @"password";
static NSString * const kNickName                       = @"nickname";
static NSString * const kEmail                          = @"email";
static NSString * const kComment                        = @"comment";


static NSString *const kDeviceID                        = @"device_code";
static NSString *const kDeviceVersion                   = @"device_version";
static NSString *const kDevicePlatform                  = @"device_platform";
static NSString *const kDeviceName                      = @"device_name";
static NSString *const kAppType                         = @"app_type";

static NSString * const kSandboxMode                     = @"sandbox_mode";

#endif /* StringDefine_h */
