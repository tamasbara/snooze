//
//  SZLevelItem.h
//  Funbers
//
//  Created by Tamas Bara on 20.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInfo.h"

@interface SZLevelItem : NSObject
- (id)initWithView:(UIView *)view;
- (void)setNewFrame:(CGRect)frame;
- (void)reset;
@property (nonatomic, readonly, assign) BOOL moved;
@property (nonatomic, assign, setter = setNewFrame:) CGRect newFrame;
@property (nonatomic, readonly, strong) UIView *view;
@property (nonatomic, strong, setter = setItemInfo:) ItemInfo *info;
@end
