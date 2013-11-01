//
//  UIUtils.m
//  WikiQuote
//
//  Created by Oleksandr Shtykhno on 01/07/2012.
//  Copyright (c) 2012 shtykhno.net. All rights reserved.
//

#import "UIUtils.h"
#define FONT_HATTORI @"Hattori Hanzo"

@implementation UIUtils

+ (void)setBackgroundImage:(UIView *)view image:(NSString *)image
{
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:image]];
    view.backgroundColor = background;
}

+ (UIColor *) colorFromHexString:(NSString *)hexString 
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIFont *)fontForContentCell
{
    return [UIFont fontWithName:FONT_HATTORI size:16.0f];
}

+ (UIFont *)fontForSectionCell
{
    return [UIFont fontWithName:FONT_HATTORI size:16.0f];
}

+ (UIBarButtonItem *)toolbarSpacer
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

+ (UIBarButtonItem *)toolbarFixed:(CGFloat) width
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item.width = width;
    return item;
}

+ (UIBarButtonItem *)toolbarImage:(NSString *)name
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.enabled = NO;
    button.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:name];

    // adjust frame
    CGRect buttonFrame = button.frame;
    buttonFrame.size = image.size;
    button.frame = buttonFrame;

    [button setImage:image forState:UIControlStateNormal];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
