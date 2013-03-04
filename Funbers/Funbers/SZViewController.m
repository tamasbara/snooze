//
//  SZViewController.m
//  Funbers
//
//  Created by Tamas Bara on 12.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "SZViewController.h"
#import "UIColor+HexColor.h"
#import "constants.h"

@interface SZViewController ()
{
    NSMutableArray *_btns;
    UIButton *_currentBtn;
    BOOL _started;
    UIButton *_btnUp;
    UIButton *_btnUpRight;
    UIButton *_btnRight;
    UIButton *_btnDownRight;
    UIButton *_btnDown;
    UIButton *_btnDownLeft;
    UIButton *_btnLeft;
    UIButton *_btnUpLeft;
    int _counter;
    int _highscore;
    int _rows;
    int _columns;
    __weak UINavigationController *_navigation;
    UIColor *_darkBlue;
    UIColor *_back1;
    UIColor *_back2;
    UILabel *_lblHs;
}
@end

@implementation SZViewController

- (id)initWithIndex:(int)index navigation:(UINavigationController* )navigation highscore:(int)highscore
{
    self = [super initWithNibName:@"SZViewController" bundle:Nil];
    if( self )
    {
        _rows = index + 5;
        _columns = _rows;
        _navigation = navigation;
        _highscore = highscore;
        //_highscore = 0;
        
        _darkBlue = [UIColor colorWithHexString:@"0x225953" alpha:1];
        _back1 = [UIColor colorWithWhite:1 alpha:0.5];
        _back2 = [UIColor colorWithWhite:1 alpha:0.6];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _btns = [NSMutableArray arrayWithCapacity:(_rows * _columns)];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int yOffset = screenBounds.size.height - 340;
    
    int btnSize = 320 / _rows;
    int xOffset = (320 % _rows) / 2;
    
    int cellCounter = 0;
    for(int row = 0; row < _rows; row++)
    {
        for(int column = 0; column < _columns; column++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(xOffset + column * btnSize, yOffset + row * btnSize, btnSize, btnSize)];
            
            //UIImage *gradient = [UIImage imageNamed:@"gradient3"];
            //[btn setBackgroundImage:gradient forState:UIControlStateNormal];
            
            if( cellCounter % 2 == 0 ) [btn setBackgroundColor:_back1];
            else [btn setBackgroundColor:_back2];
            
            btn.tag = cellCounter;
            ++cellCounter;
            
            [btn setTitleColor:_darkBlue forState:UIControlStateNormal];
            
            //[btn.layer setBorderWidth:1];
            btn.titleLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:22];
            //btn.titleLabel.shadowColor = [UIColor darkGrayColor];
            //btn.titleLabel.shadowOffset = CGSizeMake(1, 1);
            //[btn.layer setBorderColor:[[UIColor colorWithWhite:1 alpha:0.2] CGColor]];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            [_btns addObject:btn];
        }
        
        if( _rows % 2 == 0 ) ++cellCounter;
    }
    
    [_lblLevel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:22]];
    _lblLevel.text = [NSString stringWithFormat:@"Level %d", (_rows - 4)];
    
    _lblHs = [[UILabel alloc] initWithFrame:CGRectMake(80, yOffset - 40, 160, 30)];
    [_lblHs setTextColor:_darkBlue];
    [_lblHs setTextAlignment:NSTextAlignmentCenter];
    [_lblHs setBackgroundColor:[UIColor clearColor]];
    _lblHs.font = [UIFont fontWithName:@"DroidSans" size:20];
    
    NSString *hsString = [NSString stringWithFormat:@"Highscore %d/%d", _highscore, (_rows * _columns)];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:hsString];
    int rangeSize = _highscore < 10 ? 1 : 2;
    [as addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSans-Bold" size:20] range:NSMakeRange(10, rangeSize)];
    [_lblHs setAttributedText:as];
    
    [self.view addSubview:_lblHs];
    
    _started = NO;
    
    _currentBtn = [_btns objectAtIndex:0];
    [_currentBtn setBackgroundColor:_darkBlue];
    
    CGRect frame = CGRectMake( ( _columns - 5 ) * 320, 0, 320, 320 );
    self.view.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *theme = [def objectForKey:@"theme"];
    if( theme == nil )
    {
        self.view.backgroundColor = [UIColor colorWithHexString:@THEME_DEFAULT alpha:1];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithHexString:theme alpha:1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicked:(UIButton *)btn
{
    if( !_started )
    {
        if( btn == _currentBtn )
        {
            [self startGame];
            //[_delegate playing];
        }
        else
        {
            if( _currentBtn.tag % 2 == 0 ) [_currentBtn setBackgroundColor:_back1];
            else [_currentBtn setBackgroundColor:_back2];
            [btn setBackgroundColor:_darkBlue];
            _currentBtn = btn;
        }
    }
    else if( btn == _btnUp || btn == _btnUpRight || btn == _btnRight || btn == _btnDownRight || btn == _btnDown || btn == _btnDownLeft || btn == _btnLeft || btn == _btnUpLeft )
    {
        //[_delegate playing];
        [self updateHighscore];
        [self switchButtons:btn];
    }
}

- (void)startGame
{
    if( !_started )
    {
        _started = YES;
        if( _currentBtn.tag % 2 == 0 ) [_currentBtn setBackgroundColor:_back1];
        else [_currentBtn setBackgroundColor:_back2];
        
        [_currentBtn setTitle:@"1" forState:UIControlStateNormal];
        
        _counter = 1;
        [self updateHighscore];
        _counter = 2;
    }
    
    [self getButtons];
}

- (void)updateHighscore
{
    if( _highscore < _counter )
    {
        _highscore = _counter;
        [_delegate newHighscore:_highscore level:(_rows - 4)];
        
        NSString *hsString = [NSString stringWithFormat:@"Highscore %d/%d", _highscore, (_rows * _columns)];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:hsString];
        int rangeSize = _highscore < 10 ? 1 : 2;
        [as addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DroidSans-Bold" size:20] range:NSMakeRange(10, rangeSize)];
        [_lblHs setAttributedText:as];
    }
}

- (void)resetGame
{
    if( _started )
    {
        for( UIButton *btn in _btns )
        {
            [btn.titleLabel setText:@""];
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
        
        [self removeHighlighted];
        
        _started = NO;
        
        _currentBtn = [_btns objectAtIndex:0];
        [_currentBtn setBackgroundColor:_darkBlue];
        
        _btnUp = nil;
        _btnUpRight = nil;
        _btnRight = nil;
        _btnDownRight = nil;
        _btnDown = nil;
        _btnDownLeft = nil;
        _btnLeft = nil;
        _btnUpLeft = nil;
    }
}

- (void)getButtons
{
    int index = [_btns indexOfObject:_currentBtn];
    int currentColumn = index % _rows;
    int currentRow = index / _columns;
    
    CGPoint point = CGPointMake(currentColumn, currentRow - 3);
    _btnUp = [self checkPoint:point];
    
    point = CGPointMake(currentColumn + 2, currentRow - 2);
    _btnUpRight = [self checkPoint:point];
    
    point = CGPointMake(currentColumn + 3, currentRow);
    _btnRight = [self checkPoint:point];
    
    point = CGPointMake(currentColumn + 2, currentRow + 2);
    _btnDownRight = [self checkPoint:point];
    
    point = CGPointMake(currentColumn, currentRow + 3);
    _btnDown = [self checkPoint:point];
    
    point = CGPointMake(currentColumn - 2, currentRow + 2);
    _btnDownLeft = [self checkPoint:point];
    
    point = CGPointMake(currentColumn - 3, currentRow);
    _btnLeft = [self checkPoint:point];
    
    point = CGPointMake(currentColumn - 2, currentRow - 2);
    _btnUpLeft = [self checkPoint:point];
}

- (id)checkPoint:(CGPoint)point
{
    UIButton *btn = nil;
    
    if( point.x >= 0 && point.x < _columns && point.y >= 0 && point.y < _rows )
    {
        int index = point.y * _columns + point.x;
        btn = [_btns objectAtIndex:index];
        if( btn.titleLabel.text.length == 0 )
        {
            [btn setBackgroundColor:_darkBlue];
        }
        else btn = nil;
    }
    
    return btn;
}

- (void)removeHighlighted
{
    if( _btnUp ) [self resetButtonColor:_btnUp];
    if( _btnUpRight ) [self resetButtonColor:_btnUpRight];
    if( _btnRight ) [self resetButtonColor:_btnRight];
    if( _btnDownRight ) [self resetButtonColor:_btnDownRight];
    if( _btnDown ) [self resetButtonColor:_btnDown];
    if( _btnDownLeft ) [self resetButtonColor:_btnDownLeft];
    if( _btnLeft ) [self resetButtonColor:_btnLeft];
    if( _btnUpLeft ) [self resetButtonColor:_btnUpLeft];
}

- (void)resetButtonColor:(UIButton *)btn
{
    if( btn.tag % 2 == 0 ) [btn setBackgroundColor:_back1];
    else [btn setBackgroundColor:_back2];
}

- (void)switchButtons:(UIButton *)btn
{
    if( btn )
    {
        [btn setTitle:[NSString stringWithFormat:@"%d", _counter] forState:UIControlStateNormal];
        ++_counter;
        [self removeHighlighted];
        _currentBtn = btn;
        [self getButtons];
        
        if( _counter == ( _rows * _columns + 1 ) )
        //if( _counter == 4 )
        {
            [_delegate levelFinished:(_rows - 4)];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog( [NSString stringWithFormat:@"clickedButtonAtIndex: %d", buttonIndex] );
    
    /*NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
     int savedLevel = [defs integerForKey:@"level"];
     if( savedLevel == _level )
     {
     [defs setInteger:(_level + 1) forKey:@"level"];
     }
     
     if( buttonIndex == 1 )
     {
     [_navigation popViewControllerAnimated:NO];
     
     SZViewController *gameController = [[SZViewController alloc] initWithNibName:[self nibName] level:(_level + 1)];
     [gameController setNavigation:_navigation];
     
     [_navigation pushViewController:gameController animated:NO];
     }*/
}

- (IBAction)clickBack:(id)sender
{
    [_navigation popViewControllerAnimated:YES];
}

- (IBAction)clickReset:(id)sender
{
    [self resetGame];
}

@end
