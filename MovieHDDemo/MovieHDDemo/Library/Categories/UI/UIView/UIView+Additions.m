//
//  UIView+Additions.m
//  MedTalk
//
//  Created by Hieu Bui on 8/12/12.
//  Copyright (c) 2012 SETACINQ Vietnam. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView(Additions)

- (void)setWidth:(CGFloat)widthValue
{
    CGRect frame = self.frame;
    frame.size.width = widthValue;
    self.frame = frame;
    
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (CGFloat)originX{
    return self.frame.origin.x;
}
- (CGFloat)originY{
    return self.frame.origin.y;
}
- (void)setHeight:(CGFloat)heightValue
{
    CGRect frame = self.frame;
    frame.size.height = heightValue;
    self.frame = frame;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setOriginX:(CGFloat)xValue
{
    CGRect frame = self.frame;
    frame.origin.x = xValue;
    self.frame = frame;
}

- (void)setOriginY:(CGFloat)yValue
{
    CGRect frame = self.frame;
    frame.origin.y = yValue;
    self.frame = frame;
}

- (void)moveToBelowView:(UIView *)view
{
    [self moveToBelowView:view margin:0];
}

- (void)moveToUpView:(UIView*)view{
    [self moveToBelowView:view margin:-view.height];
}

- (void)moveToBelowView:(UIView *)view margin:(NSInteger) margin{
    if (!view || [view isKindOfClass:[NSNull class]]) {
        return;
    }
    CGRect frame = view.frame;
    [self setOriginY:frame.origin.y + frame.size.height + margin];
}

- (void)moveToRightSideOfView:(UIView *)view{
    [self moveToRightSideOfView:view margin:0];
}

- (void)moveToRightSideOfView:(UIView *)view margin:(NSInteger) margin{
    if (!view || [view isKindOfClass:[NSNull class]]) {
        return;
    }
    CGRect frame = view.frame;
    [self setOriginX:frame.origin.x + frame.size.width + margin];
}

- (void)moveToLeftSideOfView:(UIView *)view{
    [self moveToLeftSideOfView:view margin:0];
}
- (void)moveToLeftSideOfView:(UIView *)view margin:(NSInteger) margin{
    if (!view || [view isKindOfClass:[NSNull class]]) {
        return;
    }
    CGRect frame = view.frame;
    [self setOriginX:frame.origin.x - frame.size.width - margin];
}

- (void)createShadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity{
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = color.CGColor;
}

- (void)makeRoundCorner:(CGFloat) cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

- (void)makeRoundCornerAtTop:(CGFloat)cornerRadius{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)makeBorderWithWidth:(CGFloat) width andColor:(UIColor*) color{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

-(void)removeAllSubviews{
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)moveBy:(CGPoint) distance duration:(CGFloat) duration{
    [UIView animateWithDuration:duration animations:^{
        [self setOriginX:(self.frame.origin.x + distance.x)];
        [self setOriginY:(self.frame.origin.y + distance.y)];
    }];
}

- (void)moveHorizontalBy:(NSInteger) xDistance duration:(CGFloat) duration{
    [self moveBy:CGPointMake(xDistance, 0) duration:duration];
}

- (void)moveVerticalBy:(NSInteger) yDistance duration:(CGFloat) duration{
    [self moveBy:CGPointMake(0, yDistance) duration:duration];
}

- (void)hideViewAtDeviceBottomWithAnimation:(BOOL) isAnimate{
    if(self.hidden){
        return;
    }
    if(isAnimate){
        [UIView animateWithDuration:0.3 animations:^{
            [self setOriginY:[UIScreen mainScreen].bounds.size.height];
        }completion:^(BOOL finished) {
            self.hidden = TRUE;
        }];
    }
    else{
        self.hidden = TRUE;
        [self setOriginY:[UIScreen mainScreen].bounds.size.height];
    }
}

- (void)hideViewAtDeviceBottomWithAnimation:(BOOL) isAnimate remove:(BOOL) willRemove{
    if(self.hidden){
        return;
    }
    if(isAnimate){
        [UIView animateWithDuration:0.3 animations:^{
            [self setOriginY:[UIScreen mainScreen].bounds.size.height];
        }completion:^(BOOL finished) {
            self.hidden = TRUE;
            if(willRemove){
                [self removeFromSuperview];
            }
        }];
    }
    else{
        self.hidden = TRUE;
        [self setOriginY:[UIScreen mainScreen].bounds.size.height];
    }
}

- (void)showViewFromBottomOfView:(UIView *)view withAnimation:(BOOL) isAnimate{
    if(!self.hidden){
        return;
    }
    
    self.hidden = NO;
    if(isAnimate){
        [UIView animateWithDuration:0.3 animations:^{
            [self setOriginY:view.frame.size.height - self.frame.size.height];
        }completion:^(BOOL finished) {
            
        }];
    }
    else{
        [self setOriginY:view.frame.size.height - self.frame.size.height];
    }
}

- (void)expandToFillSuperView{
    if(self.superview){
        self.frame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
    }
}

- (void)goToCenterOfSuperView{
    if(self.superview){
        self.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2);
    }
}

- (void)showViewFromDeviceBottomWithAnimation:(BOOL) isAnimate{
    if(!self.hidden){
        return;
    }
    
    self.hidden = NO;
    if(isAnimate){
        [UIView animateWithDuration:0.3 animations:^{
            [self setOriginY:[UIScreen mainScreen].bounds.size.height - self.frame.size.height];
        }completion:^(BOOL finished) {
            
        }];
    }
    else{
        [self setOriginY:[UIScreen mainScreen].bounds.size.height - self.frame.size.height];
    }
}

-(void)setMasksToBounds{
    CALayer *viewLayer = [self layer];
    [viewLayer setMasksToBounds:YES];
}

#pragma mark - alignment
- (void) alignTo:(UIViewAlignment)a margins:(UIEdgeInsets)e
{
	//default is to align to superview
	[self alignTo:a ofRect:self.superview.bounds margins:e];
}

- (void) alignTo:(UIViewAlignment)a
{
	[self alignTo:a margins:UIEdgeInsetsZero];
}

- (void) alignTo:(UIViewAlignment)a ofRect:(CGRect)r margins:(UIEdgeInsets)e
{
	CGRect rect = self.frame;
	
	if (a & UIViewAlignmentCenterHorizontal)
		rect.origin.x = r.origin.x + (r.size.width-rect.size.width)/2.0;
	
	if (a & UIViewAlignmentCenterVertical)
		rect.origin.y = r.origin.y + (r.size.height-rect.size.height)/2.0;
	
	if (a & UIViewAlignmentTop)
		rect.origin.y = r.origin.y;
	
	if (a & UIViewAlignmentBottom)
		rect.origin.y = r.origin.y + r.size.height-self.frame.size.height;
	
	if (a & UIViewAlignmentLeft)
		rect.origin.x = r.origin.x;
	
	if (a & UIViewAlignmentRight)
		rect.origin.x = r.origin.x + r.size.width-self.frame.size.width;
	
	rect.origin.x += e.left;
	rect.origin.x -= e.right;
	
	rect.origin.y += e.top;
	rect.origin.y -= e.bottom;
	
	self.frame = CGRectIntegral(rect);
}

- (void) alignTo:(UIViewAlignment)a ofRect:(CGRect)rect
{
	[self alignTo:a ofRect:rect margins:UIEdgeInsetsZero];
}

-(UIImage *)getSnapshot{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

@end
