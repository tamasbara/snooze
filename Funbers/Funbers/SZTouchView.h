//
//  SZTouchView.h
//  Funbers
//
//  Created by Tamas Bara on 15.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZTouchDelegate <NSObject>
- (void)viewClicked:(UIView *)view;
- (void)gameDeleted:(int)tag;
- (void)fixLayout;
@end

@interface SZTouchView : UIView
@property (nonatomic, weak) id <SZTouchDelegate> delegate;
- (void)prepareLayoutNewLevelAppearing:(UIView *)view;
@property (nonatomic, assign) int topAnchor;
@property (nonatomic, assign) int bottomAnchor;
@property (nonatomic, assign) BOOL contentDynamic;
@property (nonatomic, assign) int scrollCount;
@end
