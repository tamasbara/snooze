//
//  SZHowToController.h
//  Funbers
//
//  Created by Tamas Bara on 26.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTouchView.h"

@interface SZHowToController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet SZTouchView *touchLayer;
- (id)initWithNavigation:(UINavigationController* )navigation;
- (IBAction)clickBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@end
