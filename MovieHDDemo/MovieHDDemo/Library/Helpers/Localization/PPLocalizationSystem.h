//
//  LocalizationSystem.h
//  Battle of Puppets
//
//  Created by Juan Albero Sanchis on 27/02/10.
//  Copyright Aggressive Mediocrity 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LSSTRING(key) \
	[[LocalizationSystem sharedLocalSystem] localizedStringForKey : (key)value : (key)]

#define LocalizationSetLanguage(language) \
	[[LocalizationSystem sharedLocalSystem] setLanguage : (language)]

#define LocalizationGetLanguage \
	[[LocalizationSystem sharedLocalSystem] getLanguage]

#define LocalizationReset \
	[[LocalizationSystem sharedLocalSystem] resetLocalization]

@interface PPLocalizationSystem : NSObject {
	NSString *language;
}

// you really shouldn't care about this functions and use the MACROS
+ (PPLocalizationSystem *)sharedLocalSystem;

//gets the string localized
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment;

//sets the language
- (void)setLanguage:(NSString *)language;

//gets the current language
- (NSString *)getLanguage;

//resets this system.
- (void)resetLocalization;

@end
