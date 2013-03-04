//
//  SZMainController.h
//  Funbers
//
//  Created by Tamas Bara on 13.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTouchView.h"
#import "SZViewController.h"

@interface SZMainController : UIViewController <SZTouchDelegate, SZGameDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblNewGame;
@property (weak, nonatomic) IBOutlet UILabel *lblMore;
- (id)initWithNaviagation:(UINavigationController *)navigation;
@property (weak, nonatomic) IBOutlet SZTouchView *touchLayer;
@property (weak, nonatomic) IBOutlet UIView *viewNewGame;
@property (weak, nonatomic) IBOutlet UIView *viewMore;
@property (weak, nonatomic) IBOutlet UIView *viewLevel2;
@property (weak, nonatomic) IBOutlet UIView *viewLevel3;
@property (weak, nonatomic) IBOutlet UIView *viewLevel4;
@property (weak, nonatomic) IBOutlet UIView *viewLevel5;
@property (weak, nonatomic) IBOutlet UIView *viewLevel6;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel2;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel3;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel4;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel5;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel6;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewNewGame;
@property (weak, nonatomic) IBOutlet UILabel *lblNewGameBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel2Btn;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel3Btn;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel4Btn;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel5Btn;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel6Btn;
@end
