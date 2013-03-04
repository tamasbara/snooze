//
//  UIColor+HexColor.h
//  Funbers
//
//  Created by Tamas Bara on 13.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(float)alpha;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;
@end
