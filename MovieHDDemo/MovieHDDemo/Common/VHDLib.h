//
//  VHDLib.h
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *OMLang(NSString *key);
//replace "{KEY}" by "VALUE"
NSString *OMLangDict(NSString *key, NSDictionary *dict);

@interface VHDLib : NSObject
+(void)setValue:(id)value forKey:(NSString*)key;
+(id)valueForkey:(NSString*)key;
+(id)valueForkey:(NSString*)key defaultValue:(id)value;

@end
