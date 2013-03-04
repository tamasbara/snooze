//
//  SZLevelItem.m
//  Funbers
//
//  Created by Tamas Bara on 20.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "SZLevelItem.h"

@interface SZLevelItem ()
{
    CGRect _originalFrame;
}
@end

@implementation SZLevelItem

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if( self )
    {
        _view = view;
        _newFrame = view.frame;
        _originalFrame = view.frame;
    }
    
    return self;
}

- (void)setNewFrame:(CGRect)frame
{
    if( frame.origin.y != _originalFrame.origin.y ) _moved = YES;
    else _moved = NO;
    _newFrame = frame;
    _view.frame = frame;
    _info.offset = [NSNumber numberWithInt:(frame.origin.y - _originalFrame.origin.y)];
}

- (void)setItemInfo:(ItemInfo *)info
{
    _info = info;
    _view.hidden = info.hidden.intValue == 1;
    if( info.offset.intValue != 0 )
    {
        _moved = YES;
        _newFrame.origin.y += info.offset.intValue;
    }
}

- (void)reset
{
    _view.frame = _newFrame;
    
    if( _view.frame.origin.y != _originalFrame.origin.y ) _moved = YES;
    else _moved = NO;
}

- (NSString *)description
{
    NSString *orig = [NSString stringWithFormat:@"%.0f,%.0f,%.0f,%.0f", _originalFrame.origin.x, _originalFrame.origin.y, _originalFrame.size.width, _originalFrame.size.height];
    
    NSString *new = [NSString stringWithFormat:@"%.0f,%.0f,%.0f,%.0f", _newFrame.origin.x, _newFrame.origin.y, _newFrame.size.width, _newFrame.size.height];
    
    return [NSString stringWithFormat:@"orig: %@, new: %@, hidden: %d", orig, new, _view.hidden ];
}

@end
