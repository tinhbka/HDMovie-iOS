//
//  ViewUtils.m
//
//  Version 1.0
//
//  Created by Nick Lockwood on 19/11/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/ViewUtils
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "UIView+Utils.h"


@implementation UIView (Utils)

//nib loading

+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner {
	//default values
	NSString *nibName = nibNameOrNil ? : NSStringFromClass(self);
	NSBundle *bundle = bundleOrNil ? : [NSBundle mainBundle];

	//cache nib to prevent unnecessary filesystem access
	static NSCache *nibCache = nil;
	if (nibCache == nil) {
		nibCache = [[NSCache alloc] init];
	}
	NSString *pathKey = [NSString stringWithFormat:@"%@.%@", bundle.bundleIdentifier, nibName];
	UINib *nib = [nibCache objectForKey:pathKey];
	if (nib == nil) {
		NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
		if (nibPath) nib = [UINib nibWithNibName:nibName bundle:bundle];
		[nibCache setObject:nib ? :[NSNull null] forKey:pathKey];
	}
	else if ([nib isKindOfClass:[NSNull class]]) {
		nib = nil;
	}

	if (nib) {
		//attempt to load from nib
		NSArray *contents = [nib instantiateWithOwner:owner options:nil];
		UIView *view = [contents count] ? [contents objectAtIndex:0] : nil;
		NSAssert([view isKindOfClass:self], @"First object in nib '%@' was '%@'. Expected '%@'", nibName, view, self);
		return view;
	}

	//unable to load
	return nil;
}

- (void)loadContentsWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil {
	NSString *nibName = nibNameOrNil ? : NSStringFromClass([self class]);
	UIView *view = [UIView instanceWithNibName:nibName bundle:bundleOrNil owner:self];
	if (view) {
		view.frame = self.contentBounds;
		[self addSubview:view];
	}
}

//view searching

- (UIView *)viewMatchingPredicate:(NSPredicate *)predicate {
	if ([predicate evaluateWithObject:self]) {
		return self;
	}
	for (UIView *view in self.subviews) {
		UIView *match = [view viewMatchingPredicate:predicate];
		if (match) return match;
	}
	return nil;
}

- (UIView *)viewWithTag:(NSInteger)tag type:(Class)type {
	return [self viewMatchingPredicate:[NSPredicate predicateWithBlock: ^BOOL (id evaluatedObject, NSDictionary *bindings)
	{
	    return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:type];
	}]];
}

- (UIView *)viewOfType:(Class)type {
	return [self viewMatchingPredicate:[NSPredicate predicateWithBlock: ^BOOL (id evaluatedObject, NSDictionary *bindings)
	{
	    return [evaluatedObject isKindOfClass:type];
	}]];
}

- (NSArray *)viewsMatchingPredicate:(NSPredicate *)predicate {
	NSMutableArray *matches = [NSMutableArray array];
	if ([predicate evaluateWithObject:self]) {
		[matches addObject:self];
	}
	for (UIView *view in self.subviews) {
		//check for subviews
		//avoid creating unnecessary array
		if ([view.subviews count]) {
			[matches addObjectsFromArray:[view viewsMatchingPredicate:predicate]];
		}
		else if ([predicate evaluateWithObject:view]) {
			[matches addObject:view];
		}
	}
	return matches;
}

- (NSArray *)viewsWithTag:(NSInteger)tag {
	return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock: ^BOOL (id evaluatedObject, NSDictionary *bindings)
	{
	    return [evaluatedObject tag] == tag;
	}]];
}

- (NSArray *)viewsWithTag:(NSInteger)tag type:(Class)type {
	return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock: ^BOOL (id evaluatedObject, NSDictionary *bindings)
	{
	    return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:type];
	}]];
}

- (NSArray *)viewsOfType:(Class)type {
	return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock: ^BOOL (id evaluatedObject, NSDictionary *bindings)
	{
	    return [evaluatedObject isKindOfClass:type];
	}]];
}

//first responder

- (UIView *)firstResponder {
	return [self viewMatchingPredicate:[NSPredicate predicateWithBlock: ^BOOL (id evaluatedObject, NSDictionary *bindings)
	{
	    return [evaluatedObject isFirstResponder];
	}]];
}

//frame accessors

- (CGPoint)origin {
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (CGFloat)top {
	return self.origin.y;
}

- (void)setTop:(CGFloat)top {
	CGRect frame = self.frame;
	frame.origin.y = top;
	self.frame = frame;
}

- (CGFloat)left {
	return self.origin.x;
}

- (void)setLeft:(CGFloat)left {
	CGRect frame = self.frame;
	frame.origin.x = left;
	self.frame = frame;
}

- (CGFloat)right {
	return self.left + self.width;
}

- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)bottom {
	return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)width {
	return self.size.width;
}

- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height {
	return self.size.height;
}

- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat)x {
	return self.center.x;
}

- (void)setX:(CGFloat)x {
	self.center = CGPointMake(x, self.center.y);
}

- (CGFloat)y {
	return self.center.y;
}

- (void)setY:(CGFloat)y {
	self.center = CGPointMake(self.center.x, y);
}

//bounds accessors

- (CGSize)boundsSize {
	return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size {
	CGRect bounds = self.bounds;
	bounds.size = size;
	self.bounds = bounds;
}

- (CGFloat)boundsWidth {
	return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width {
	CGRect bounds = self.bounds;
	bounds.size.width = width;
	self.bounds = bounds;
}

- (CGFloat)boundsHeight {
	return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height {
	CGRect bounds = self.bounds;
	bounds.size.height = height;
	self.bounds = bounds;
}

//content getters

- (CGRect)contentBounds {
	return CGRectMake(0.0f, 0.0f, self.boundsWidth, self.boundsHeight);
}

- (CGPoint)contentCenter {
	return CGPointMake(self.boundsWidth / 2.0f, self.boundsHeight / 2.0f);
}

//additional frame setters

- (void)setLeft:(CGFloat)left right:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = left;
	frame.size.width = right - left;
	self.frame = frame;
}

- (void)setWidth:(CGFloat)width right:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - width;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setTop:(CGFloat)top bottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = top;
	frame.size.height = bottom - top;
	self.frame = frame;
}

- (void)setHeight:(CGFloat)height bottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - height;
	frame.size.height = height;
	self.frame = frame;
}

@end
