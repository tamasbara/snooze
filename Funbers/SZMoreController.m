//
//  SZMoreController.m
//  Funbers
//
//  Created by Tamas Bara on 22.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "SZMoreController.h"
#import "constants.h"
#import "SZThemesController.h"
#import "UIColor+HexColor.h"
#import "SZHowToController.h"
#import "iTellAFriend.h"

@interface SZMoreController ()
{
    __weak UINavigationController *_navigation;
}
@end

@implementation SZMoreController

- (id)initWithNavigation:(UINavigationController* )navigation
{
    self = [super initWithNibName:@"SZMoreController" bundle:Nil];
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
    _lbl1.text = NSLocalizedString(@"Tell", nil );
    
    [_lbl3 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    _lbl3.text = NSLocalizedString(@"Themes", nil );
    
    [_lbl4 setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    _lbl4.text = NSLocalizedString(@"How", nil );
    
    [_lblMore setFont:[UIFont fontWithName:@"DroidSans-Bold" size:22]];
    _lblMore.text = NSLocalizedString(@"More", nil);
    
    _viewTellAFriend.tag = TAG_TELL_A_FRIEND;
    _viewThemes.tag = TAG_THEMES;
    _viewHowToPlay.tag = TAG_HOW_TO_PLAY;
    _touchLayer.tag = TAG_ROOT_VIEW;
    
    int topAnchor = 76;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if( screenBounds.size.height > 480 ) topAnchor = 146;
    
    _touchLayer.delegate = self;
    _touchLayer.topAnchor = topAnchor;
    _touchLayer.contentDynamic = NO;
    
    CGRect frame = _touchLayer.frame;
    frame.origin.y = topAnchor;
    _touchLayer.frame = frame;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewClicked:(UIView *)view
{
    if( view.tag == TAG_HOW_TO_PLAY )
    {
        SZHowToController *more = [[SZHowToController alloc] initWithNavigation:_navigation];
        [_navigation pushViewController:more animated:YES];
    }
    else if( view.tag == TAG_THEMES )
    {
        SZThemesController *more = [[SZThemesController alloc] initWithNavigation:_navigation];
        [_navigation pushViewController:more animated:YES];
    }
    else if( view.tag == TAG_TELL_A_FRIEND )
    {
        /*if( [MFMailComposeViewController canSendMail] )
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"Funbers"];
            [mail setMessageBody:NSLocalizedString(@"Mail", nil) isHTML:NO];
            [mail setToRecipients:[NSArray arrayWithObject:@"cudarammsch@gmail.com"]];
            [self presentViewController:mail animated:YES completion:^{}];
        }
        else NSLog(@"no mail support");*/
        
        if ([[iTellAFriend sharedInstance] canTellAFriend]) {
            UINavigationController* tellAFriendController = [[iTellAFriend sharedInstance] tellAFriendController];
            [self presentModalViewController:tellAFriendController animated:YES];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"error: %@, result: %d", error, result);
}

- (void)fixLayout
{
}

- (void)gameDeleted:(int)tag
{
}

@end
