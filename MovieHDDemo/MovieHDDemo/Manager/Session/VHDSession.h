//
//  VHDSession.h
//  BaseProject
//
//  Created by Tinhvv on 4/20/16.
//  Copyright © 2016 Tinhvv. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSessionKey             @"kSessionKey"
#define kSessionVersion         @"1.0"

@interface VHDSession : NSObject

+ (instancetype)sharedSession;

/**
 * Add your session properties here
 */
@property (strong, nonatomic) NSString *uniqueToken;

@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *deviceOs;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *deviceToken;
@property (assign, nonatomic) BOOL isAuthenticated;
@property (strong, nonatomic) NSNumber *currentUserId;



// Auth token
@property (strong, nonatomic) NSString *authToken;

- (void)save;
- (void)restoreSessionIfNeeded;
- (void)clearSessionData;
- (void)printDescription;

@end
