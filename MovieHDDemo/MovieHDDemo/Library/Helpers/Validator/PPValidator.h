//
//  PPValidator.h
//  ReengPlus
//
//  Created by Mai Huy Dong on 5/1/14.
//  Copyright (c) 2014 ROXWIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPValidator : NSObject
+ (NSString *)getString:(NSInteger)i;
+ (NSNumber *)getSafeInt:(id)obj;
+ (NSNumber *)getSafeFloat:(id)obj;
+ (NSNumber *)getSafeBool:(id)obj;
+ (NSString *)getSafeString:(id)obj;
+ (BOOL)isPhoneNumber:(NSString *)phoneStr;
@end
