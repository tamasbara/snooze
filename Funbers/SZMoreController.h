//
//  SZMoreController.h
//  Funbers
//
//  Created by Tamas Bara on 22.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SZTouchView.h"

@interface SZMoreController : UIViewController <SZTouchDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblMore;
- (id)initWithNavigation:(UINavigationController* )navigation;
- (IBAction)clickBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet SZTouchView *touchLayer;
@property (weak, nonatomic) IBOutlet UIView *viewTellAFriend;
@property (weak, nonatomic) IBOutlet UIView *viewThemes;
@property (weak, nonatomic) IBOutlet UIView *viewHowToPlay;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end
