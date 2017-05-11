//
//  UILabel+Extension.m
//  PPFoundation,
//  Helper Functions and Classes for Ordinary Application Development on iPhone
//
//  Created by meinside on 10. 7. 16.
//
//  last update: 12.07.18.
//

#import "UILabel+Additions.h"


@implementation UILabel (UILabelAdditions)

- (UILabelResizeResult)alignToTop {
	CGFloat originalLabelHeight = self.frame.size.height;

	CGRect rect = [self textRectForBounds:self.bounds limitedToNumberOfLines:999];

	CGRect newRect = self.frame;
	newRect.size.height = rect.size.height;

	self.frame = newRect;

	if (self.frame.size.height == originalLabelHeight)
		return UILabelResizedNoChange;
	else
		return UILabelResized;
}

- (UILabelResizeResult)enlargeHeightToKeepFontSize {
	CGFloat originalLabelHeight = self.frame.size.height;

	CGRect rect = [self textRectForBounds:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 9999.0f) limitedToNumberOfLines:999];

	CGRect newRect = self.frame;
	newRect.size.height = rect.size.height;

	self.frame = newRect;

	if (self.frame.size.height == originalLabelHeight)
		return UILabelResizedNoChange;
	else
		return UILabelResized;
}

- (UILabelResizeResult)resizeFontSizeToKeepCurrentRect:(CGFloat)initialFontSize {
	CGFloat originalLabelHeight = self.frame.size.height;
	CGFloat labelHeight = 0.0f;
	UIFont *font = self.font;

	CGFloat minFontSize;
	minFontSize = self.minimumScaleFactor;

	for (CGFloat f = initialFontSize; f > minFontSize; f -= 1.0f) {
		font = [font fontWithSize:f];
		CGSize constraintSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
		CGSize labelSize = [self.text sizeWithFont:font
		                         constrainedToSize:constraintSize
		                             lineBreakMode:NSLineBreakByWordWrapping];

		labelHeight = labelSize.height;
		if (labelHeight <= originalLabelHeight)
			break;
	}

	self.font = font;

	if (labelHeight == originalLabelHeight)
		return UILabelResizedNoChange;
	else if (labelHeight < originalLabelHeight)
		return UILabelResized;
	else
		return UILabelResizeFailed;
}

@end
