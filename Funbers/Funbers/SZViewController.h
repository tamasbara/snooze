//
//  SZViewController.h
//  Funbers
//
//  Created by Tamas Bara on 12.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZGameDelegate <NSObject>
- (void)levelFinished:(int)level;
- (void)newHighscore:(int)highscore level:(int)level;
@end

@interface SZViewController : UIViewController
- (id)initWithIndex:(int)index navigation:(UINavigationController* )navigation highscore:(int)highscore;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
- (IBAction)clickBack:(id)sender;
- (IBAction)clickReset:(id)sender;
@property (weak, nonatomic) id <SZGameDelegate> delegate;
@end
