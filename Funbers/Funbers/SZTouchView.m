//
//  SZTouchView.m
//  Funbers
//
//  Created by Tamas Bara on 15.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "SZTouchView.h"
#import "constants.h"

#define TV_SCROLL_NONE 0
#define TV_SCROLL_UP 1
#define TV_SCROLL_DOWN 2

@interface SZTouchView ()
{
    __weak UIView *_currentTouchedView;
    BOOL _viewMoved;
    BOOL _viewsScrolled;
    BOOL _viewMovedLeft;
    int _scrollDirection;
    CGRect _originalFrame;
}
@end

@implementation SZTouchView

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if( self )
    {
        _bottomAnchor = -1;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        _bottomAnchor = -1;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //NSLog( [NSString stringWithFormat:@"touchesBegan, touch: %@", touch] );
    _currentTouchedView = nil;
    _viewMoved = NO;
    _viewsScrolled = NO;
    _viewMovedLeft = NO;
    _scrollDirection = TV_SCROLL_NONE;
    
    UIView *view = touch.view;
    if( view.tag != TAG_ROOT_VIEW )
    {
        if( view.tag == 0 )
        {
            view = view.superview;
            if( view.tag == 0 ) view = view.superview;
        }
        
        if( view.tag > 0 )
        {
            _currentTouchedView = view;
            _originalFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    
    [super touchesBegan:touches withEvent:event];
}

- (void)prepareLayoutNewLevelAppearing:(UIView *)view
{
    int y = self.frame.origin.y;
    
    if( y < 0 )
    {
        if( view.frame.origin.y < abs(y) )
        {
            y += 80;
            CGRect frame = self.frame;
            frame.origin.y = y;
            self.frame = frame;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [touches anyObject];
    //NSLog( [NSString stringWithFormat:@"touchesEnded, touch: %@", touch] );
    
    if( _currentTouchedView != nil && !_viewsScrolled )
    {
        if( _viewMoved )
        {
            if( _currentTouchedView.tag > TAG_LEVEL_START && _currentTouchedView.tag < TAG_MOVE_LIMIT )
            {
                if( _currentTouchedView.frame.origin.x < 180 )
                {
                    [UIView animateWithDuration:0.6 animations:^{
                        _currentTouchedView.frame = _originalFrame;
                        _currentTouchedView.alpha = 1;
                    }];
                }
                else
                {
                    [_delegate gameDeleted:_currentTouchedView.tag];
                }
            }
        }
        else if( !_viewMovedLeft )
        {
            [_delegate viewClicked:_currentTouchedView];
        }
    }
    else if( _viewsScrolled )
    {
        int diffY = 0;
        if( _scrollCount > 0 && _scrollDirection == TV_SCROLL_DOWN )
        {
            int offset = -1 * ( _scrollCount - [self visibleSubviews] ) * 80;
            if( offset < _topAnchor ) offset = _topAnchor;
            //if( offset > 0 ) offset *= -1;
            diffY = offset - self.frame.origin.y;
        }
        else if( _scrollDirection == TV_SCROLL_UP && _bottomAnchor != -1 )
        {
            diffY = _bottomAnchor - self.frame.origin.y;
        }
        else
        {
            diffY = _topAnchor - self.frame.origin.y;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y += diffY;
            self.frame = frame;
        }];
    }
}

- (void)layoutSubviews
{
    /*CGRect frame = self.frame;
    frame.origin.y = -160;
    self.frame = frame;*/
    [super layoutSubviews];
    [_delegate fixLayout];
}

- (int)visibleSubviews
{
    int count = 0;
    for( UIView *v in self.subviews )
    {
        if( !v.hidden ) ++count;
    }
    
    return count;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //NSLog( [NSString stringWithFormat:@"touchesMoved, touch: %@", touch] );
    CGPoint loc = [touch locationInView:self];
    CGPoint locPrev = [touch previousLocationInView:self];
    int diffX = loc.x - locPrev.x;
    int diffY = loc.y - locPrev.y;
    
    int diffXA = abs(diffX);
    int diffYA = abs(diffY);
    
    if( _currentTouchedView != nil && _contentDynamic )
    {
        if( diffX > 0 && !_viewsScrolled )
        {
            if( _currentTouchedView.tag < TAG_MOVE_LIMIT )
            {
                CGRect frame = _currentTouchedView.frame;
                frame.origin.x += diffX;
                _currentTouchedView.frame = frame;
                float alpha = 150 - (frame.origin.x - _originalFrame.origin.x);
                if( alpha > 0 ) alpha = alpha / 100;
                else alpha = 0;
                _currentTouchedView.alpha = alpha;
            }
            
            _viewMoved = YES;
        }
        
        if( diffX < 0 ) _viewMovedLeft = YES;
    }
    
    if( diffYA > diffXA )
    {
        if( !_viewMoved )
        {
            _viewsScrolled = YES;
            _scrollDirection = TV_SCROLL_UP;
            if( diffY > 0 ) _scrollDirection = TV_SCROLL_DOWN;
            
            /*for( UIView* view in _viewsToMove )
            {
                CGRect frame = view.frame;
                frame.origin.y += diffY;
                view.frame = frame;
            }*/
            
            CGRect frame = self.frame;
            frame.origin.y += diffY;
            self.frame = frame;
        }
    }
}

@end
