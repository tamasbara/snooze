//
//  SZThemesController.m
//  Funbers
//
//  Created by Tamas Bara on 22.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "SZThemesController.h"
#import "constants.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"

@interface SZThemesController ()
{
    __weak UINavigationController *_navigation;
}
@end

@implementation SZThemesController

- (id)initWithNavigation:(UINavigationController* )navigation
{
    self = [super initWithNibName:@"SZThemesController" bundle:Nil];
    if( self )
    {
        _navigation = navigation;
    }
    
    return self;
}

- (IBAction)clickBack:(id)sender
{
    [_navigation popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_lbl1 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    [_lbl2 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    [_lbl3 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    [_lbl4 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    [_lbl5 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    [_lblThemes setFont:[UIFont fontWithName:@"DroidSans-Bold" size:22]];
    
    
    _colorBlack.layer.borderColor = [UIColor whiteColor].CGColor;
    _colorBlack.layer.borderWidth = 1;
    _itemBlack.tag = TAG_THEME_BLACK;
    
    _colorDefault.layer.borderColor = [UIColor whiteColor].CGColor;
    _colorDefault.layer.borderWidth = 1;
    _colorDefault.backgroundColor = [UIColor colorWithHexString:@THEME_DEFAULT alpha:1];
    _itemDefault.tag = TAG_THEME_DEFAULT;
    
    _colorRed.layer.borderColor = [UIColor whiteColor].CGColor;
    _colorRed.layer.borderWidth = 1;
    _colorRed.backgroundColor = [UIColor colorWithHexString:@THEME_RED alpha:1];
    _itemRed.tag = TAG_THEME_RED;
    
    _colorGreen.layer.borderColor = [UIColor whiteColor].CGColor;
    _colorGreen.layer.borderWidth = 1;
    _colorGreen.backgroundColor = [UIColor colorWithHexString:@THEME_GREEN alpha:1];
    _itemGreen.tag = TAG_THEME_GREEN;
    
    _colorViolet.layer.borderColor = [UIColor whiteColor].CGColor;
    _colorViolet.layer.borderWidth = 1;
    _colorViolet.backgroundColor = [UIColor colorWithHexString:@THEME_VIOLET alpha:1];
    _itemViolet.tag = TAG_THEME_VIOLET;
    
    /*_viewTellAFriend.tag = TAG_TELL_A_FRIEND;
    _viewAbout.tag = TAG_ABOUT;
    _viewThemes.tag = TAG_THEMES;
    _viewHowToPlay.tag = TAG_HOW_TO_PLAY;*/
    _touchLayer.tag = TAG_ROOT_VIEW;
    
    int topAnchor = 46;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if( screenBounds.size.height > 480 ) topAnchor = 86;
    
    _touchLayer.delegate = self;
    _touchLayer.topAnchor = topAnchor;
    _touchLayer.contentDynamic = NO;
    
    CGRect frame = _touchLayer.frame;
    frame.origin.y = topAnchor;
    _touchLayer.frame = frame;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *theme = [def objectForKey:@"theme"];
    if( theme == nil )
    {
        _topView.backgroundColor = [UIColor colorWithHexString:@THEME_DEFAULT alpha:0.8];
        self.view.backgroundColor = [UIColor colorWithHexString:@THEME_DEFAULT alpha:1];
    }
    else
    {
        _topView.backgroundColor = [UIColor colorWithHexString:theme alpha:0.8];
        self.view.backgroundColor = [UIColor colorWithHexString:theme alpha:1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewClicked:(UIView *)view
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if( view == _itemRed )
    {
        _topView.backgroundColor = [UIColor colorWithHexString:@THEME_RED alpha:0.8];
        self.view.backgroundColor = [UIColor colorWithHexString:@THEME_RED alpha:1];
        [def setValue:@THEME_RED forKey:@"theme"];
    }
    else if( view == _itemViolet )
    {
        _topView.backgroundColor = [UIColor colorWithHexString:@THEME_VIOLET alpha:0.8];
        self.view.backgroundColor = [UIColor colorWithHexString:@THEME_VIOLET alpha:1];
        [def setValue:@THEME_VIOLET forKey:@"theme"];
    }
    else if( view == _itemGreen )
    {
        _topView.backgroundColor = [UIColor colorWithHexString:@THEME_GREEN alpha:0.8];
        self.view.backgroundColor = [UIColor colorWithHexString:@THEME_GREEN alpha:1];
        [def setValue:@THEME_GREEN forKey:@"theme"];
    }
    else if( view == _itemBlack )
    {
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.view.backgroundColor = [UIColor blackColor];
        [def setValue:@"0x000000" forKey:@"theme"];
    }
    else if( view == _itemDefault )
    {
        _topView.backgroundColor = [UIColor colorWithHexString:@THEME_DEFAULT alpha:0.8];
        self.view.backgroundColor = [UIColor colorWithHexString:@THEME_DEFAULT alpha:1];
        [def setValue:@THEME_DEFAULT forKey:@"theme"];
    }
}

- (void)fixLayout
{
}

- (void)gameDeleted:(int)tag
{
}

@end
