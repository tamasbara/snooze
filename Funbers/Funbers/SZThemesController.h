//
//  SZThemesController.h
//  Funbers
//
//  Created by Tamas Bara on 22.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTouchView.h"

@interface SZThemesController : UIViewController <SZTouchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblThemes;
@property (weak, nonatomic) IBOutlet SZTouchView *touchLayer;
- (id)initWithNavigation:(UINavigationController* )navigation;
- (IBAction)clickBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UIView *colorDefault;
@property (weak, nonatomic) IBOutlet UIView *colorBlack;
@property (weak, nonatomic) IBOutlet UIView *colorGreen;
@property (weak, nonatomic) IBOutlet UIView *colorViolet;
@property (weak, nonatomic) IBOutlet UIView *colorRed;
@property (weak, nonatomic) IBOutlet UIView *itemDefault;
@property (weak, nonatomic) IBOutlet UIView *itemBlack;
@property (weak, nonatomic) IBOutlet UIView *itemGreen;
@property (weak, nonatomic) IBOutlet UIView *itemViolet;
@property (weak, nonatomic) IBOutlet UIView *itemRed;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end
