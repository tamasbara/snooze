//
//  UIColor+HexColor.m
//  Funbers
//
//  Created by Tamas Bara on 13.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(float)alpha
{
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
    
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha
{
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum alpha:alpha];
}

@end
