//
//  UIView+Additions.h
//  MedTalk
//
//  Created by Hieu Bui on 8/12/12.
//  Copyright (c) 2012 SETACINQ Vietnam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

enum
{
	UIViewAlignmentTop                  = 1 << 0,
	UIViewAlignmentBottom               = 1 << 1,
	UIViewAlignmentLeft                 = 1 << 2,
	UIViewAlignmentRight                = 1 << 3,
	UIViewAlignmentCenterHorizontal     = 1 << 4,
	UIViewAlignmentCenterVertical       = 1 << 5,
	UIViewAlignmentCenter               = UIViewAlignmentCenterHorizontal | UIViewAlignmentCenterVertical,
    UIViewAlignmentTopLeft              = UIViewAlignmentTop | UIViewAlignmentLeft,
    UIViewAlignmentTopRight             = UIViewAlignmentTop | UIViewAlignmentRight
}
typedef UIViewAlignment; // (accepts masking)
/*
 Examples:
 
 Align myView to the far left of its superview, with 10px margin:
 [myView alignTo:UIViewAlignmentLeft withMargins:UIEdgeInsetsMake(0,10,0,0)];
 
 Align myView to the top left of its superview:
 [myView alignTo:(UIViewAlignmentTop | UIViewAlignmentLeft)];
 
 Align myView bottom & centered in the given rect:
 [myView alignTo:(UIViewAlignmentCenterHorizontal | UIViewAlignmentBottom) ofRect:otherRect];
 */

@interface UIView(Additions)

- (void)setWidth:(CGFloat)widthValue;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)originX;
- (CGFloat)originY;
- (void)setHeight:(CGFloat)heightValue;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (void)setOriginX:(CGFloat)xValue;
- (void)setOriginY:(CGFloat)yValue;
- (void)moveToBelowView:(UIView *)view;
- (void)moveToUpView:(UIView *)view;
- (void)moveToBelowView:(UIView *)view margin:(NSInteger) margin;
- (void)moveToRightSideOfView:(UIView *)view;
- (void)moveToRightSideOfView:(UIView *)view margin:(NSInteger) margin;
- (void)moveToLeftSideOfView:(UIView *)view;
- (void)moveToLeftSideOfView:(UIView *)view margin:(NSInteger) margin;
- (void)createShadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;
- (void)removeAllSubviews;
- (void)makeRoundCorner:(CGFloat) cornerRadius;
- (void)makeRoundCornerAtTop:(CGFloat) cornerRadius;
- (void)makeBorderWithWidth:(CGFloat) width andColor:(UIColor*) color;
- (void)moveBy:(CGPoint) distance duration:(CGFloat) duration;
- (void)moveHorizontalBy:(NSInteger) xDistance duration:(CGFloat) duration;
- (void)moveVerticalBy:(NSInteger) yDistance duration:(CGFloat) duration;
- (void)hideViewAtDeviceBottomWithAnimation:(BOOL) isAnimate;
- (void)hideViewAtDeviceBottomWithAnimation:(BOOL) isAnimate remove:(BOOL) willRemove;
- (void)showViewFromDeviceBottomWithAnimation:(BOOL) isAnimate;
- (void)showViewFromBottomOfView:(UIView *)view withAnimation:(BOOL) isAnimate;
- (void)expandToFillSuperView;
- (void)goToCenterOfSuperView;

- (void) setMasksToBounds;

// Aligns frame based on the bounds of the sender's superview
- (void) alignTo:(UIViewAlignment)a;
- (void) alignTo:(UIViewAlignment)a margins:(UIEdgeInsets)e;

// Aligns frame based on the given rect
- (void) alignTo:(UIViewAlignment)a ofRect:(CGRect)r;
- (void) alignTo:(UIViewAlignment)a ofRect:(CGRect)r margins:(UIEdgeInsets)e;

-(UIImage *) getSnapshot;
@end
