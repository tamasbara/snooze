//
//  SZHowToController.m
//  Funbers
//
//  Created by Tamas Bara on 26.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "SZHowToController.h"
#import "constants.h"
#import "UIColor+HexColor.h"

@interface SZHowToController ()
{
    __weak UINavigationController *_navigation;
}
@end

@implementation SZHowToController

- (id)initWithNavigation:(UINavigationController* )navigation
{
    self = [super initWithNibName:@"SZHowToController" bundle:Nil];
    if( self )
    {
        _navigation = navigation;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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


- (IBAction)clickBack:(id)sender
{
    [_navigation popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_lblTitle setFont:[UIFont fontWithName:@"DroidSans-Bold" size:22]];
    _lblTitle.text = NSLocalizedString(@"How", nil);
    
    [_lblText setFont:[UIFont fontWithName:@"DroidSans-Bold" size:26]];
    _lblText.text = NSLocalizedString(@"HowDetail", nil);
    
    _touchLayer.tag = TAG_ROOT_VIEW;
    
    _touchLayer.topAnchor = -50;
    NSString *lang = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    if( [lang isEqualToString:@"de"] )
    {
        _touchLayer.topAnchor = -30;
        CGRect frame = _touchLayer.frame;
        frame.origin.y = -30;
        _touchLayer.frame = frame;
    }
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if( screenBounds.size.height == 480 )
    {
        _touchLayer.bottomAnchor = -150;
        if( [lang isEqualToString:@"de"] ) _touchLayer.bottomAnchor = -180;
    }
    else if( [lang isEqualToString:@"de"] )
    {
        _touchLayer.bottomAnchor = -100;
    }

    _touchLayer.contentDynamic = NO;
    
    /*NSString *filename = [[NSBundle mainBundle] pathForResource:@"howto" ofType:@"txt"];
    if( filename )
    {
        _lblText.text = [NSString stringWithContentsOfFile:filename];
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
