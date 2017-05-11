//
//  Marcro.h
//  Template Project
//
//  Created by tranduc on 7/16/15.
//  Copyright (c) 2015 OMI. All rights reserved.
//

#ifndef Template_Project_Marcro_h
#define Template_Project_Marcro_h

#define K_TEMP_VERSION @"1.0"

/** Get image by name*/
#define Image(x)  [UIImage imageNamed:x]

/** String by format*/
#define $S(format, ...) [NSString stringWithFormat:format, ## __VA_ARGS__]

/** String is null or empty**/
#define StringIsNullOrEmpty(x)    ((x == nil || [x isEqual:[NSNull null]] || [x length] == 0) ? YES : NO)

#pragma mark - DLOG

#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
# define DLog(...)
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#ifdef DEBUG
# define ULog(fmt, ...){ UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ## __VA_ARGS__] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; }
#else
# define ULog(...)
#endif

#pragma mark - COLOR

/** UIColor: Color From Hex **/
#define COLOR_FROM_HEX(rgbValue)([UIColor UIColorFromRGB:rgbValue])

/** UIColor: Color from RGB **/

#define RGB(r, g, b)[UIColor colorWithRed : r / 255.0 green : g / 255.0 blue : b / 255.0 alpha : 1]

/** UIColor: Color from RGBA **/

#define COLOR_FROM_RGBA(r, g, b, a) ([UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a])

#define RGBA(r, g, b, a)[UIColor colorWithRed : r / 255.0 green : g / 255.0 blue : b / 255.0 alpha : a]

#pragma mark - SCREEN INFORMATION

/** Float: Portrait Screen Height **/
#define SCREEN_HEIGHT_PORTRAIT ([[UIScreen mainScreen] bounds].size.height)

/** Float: Portrait Screen Width **/
#define SCREEN_WIDTH_PORTRAIT ([[UIScreen mainScreen] bounds].size.width)

/** Float: Landscape Screen Height **/
#define SCREEN_HEIGHT_LANDSCAPE ([[UIScreen mainScreen] bounds].size.width)

/** Float: Landscape Screen Width **/
#define SCREEN_WIDTH_LANDSCAPE ([[UIScreen mainScreen] bounds].size.height)

/** CGRect: Portrait Screen Frame **/
#define SCREEN_FRAME_PORTRAIT (CGRectMake(0, 0, SCREEN_WIDTH_PORTRAIT, SCREEN_HEIGHT_PORTRAIT))

/** CGRect: Landscape Screen Frame **/
#define SCREEN_FRAME_LANDSCAPE (CGRectMake(0, 0, SCREEN_WIDTH_LANDSCAPE, SCREEN_HEIGHT_LANDSCAPE))

/** Float: Screen Scale **/
#define SCREEN_SCALE ([[UIScreen mainScreen] scale])

/** CGSize: Screen Size Portrait **/
#define SCREEN_SIZE_PORTRAIT (CGSizeMake(SCREEN_WIDTH_PORTRAIT * SCREEN_SCALE, SCREEN_HEIGHT_PORTRAIT * SCREEN_SCALE))

/** CGSize: Screen Size Landscape **/
#define SCREEN_SIZE_LANDSCAPE (CGSizeMake(SCREEN_WIDTH_LANDSCAPE * SCREEN_SCALE, SCREEN_HEIGHT_LANDSCAPE * SCREEN_SCALE))

// Message Bagnumber
#define K_MESSAGE_NUMBER_COLOR RBGA(230, 40, 40, 255)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif
