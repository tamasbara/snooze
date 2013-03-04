//
//  SZMainController.m
//  Funbers
//
//  Created by Tamas Bara on 13.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import "SZMainController.h"
#import "SZViewController.h"
#import "UIColor+HexColor.h"
#import "SZTouchView.h"
#import "SZLevelItem.h"
#import "constants.h"
#import "SZMoreController.h"
#import <CoreData/CoreData.h>
#import "ItemInfo.h"

@interface SZMainController ()
{
    __weak UINavigationController *_navigation;
    NSArray *_items;
    NSArray *_levelButtons;
    UIView *_viewToAnimate;
    
    NSManagedObjectContext *_mainContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
}
@end

@implementation SZMainController

- (id)initWithNaviagation:(UINavigationController *)navigation
{
    self = [super initWithNibName:@"SZMainController" bundle:nil];
    if( self )
    {
        _navigation = navigation;
        _mainContext = [[NSManagedObjectContext alloc] init];
        _mainContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
        
        NSError *error;
        NSArray *arr = [_mainContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"ItemInfo"] error:&error];
        if( arr.count == 0 )
        {
            for( int i = 1; i < 7; i++ )
            {
                ItemInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"ItemInfo" inManagedObjectContext:_mainContext];
                info.hidden = [NSNumber numberWithInt:(i>1?1:0)];
                info.level = [NSNumber numberWithInt:i];
                info.offset = [NSNumber numberWithInt:0];
                info.highscore = [NSNumber numberWithInt:0];
            }
            
            [_mainContext save:&error];
            
            NSLog(@"core data initialized");
        }
    }
    
    return self;
}

- (NSString *)documentsDirectory
{
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if( _managedObjectModel == nil )
    {
        NSString *pathToModel = [[NSBundle mainBundle] pathForResource:@"ItemInfo" ofType:@"momd"];
        NSURL *storeURL = [NSURL fileURLWithPath:pathToModel];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if( _persistentStoreCoordinator == nil )
    {
        NSString *pathToLocalStore = [[self documentsDirectory] stringByAppendingPathComponent:@"ItemInfo.sqlite"];
        NSLog(@"SQLITE STORE PATH: %@", pathToLocalStore);
        NSURL *storeURL = [NSURL fileURLWithPath:pathToLocalStore];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                             initWithManagedObjectModel:[self managedObjectModel]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *e = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:options
                                       error:&e]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:e forKey:NSUnderlyingErrorKey];
            NSString *reason = @"Could not create persistent store.";
            NSException *exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                                       reason:reason
                                                     userInfo:userInfo];
            @throw exc;
        }
        
        _persistentStoreCoordinator = psc;
    }
    
    return _persistentStoreCoordinator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    _lblNewGame.font = [UIFont fontWithName:@"DroidSans-Bold" size:28];
    _lblNewGame.text = NSLocalizedString(@"New", nil );
    _lblMore.font = [UIFont fontWithName:@"DroidSans-Bold" size:28];
    _lblMore.text = NSLocalizedString(@"More", nil);
    
    SZLevelItem *itemLevel1 = [[SZLevelItem alloc] initWithView:_viewNewGame];
    SZLevelItem *itemLevel2 = [[SZLevelItem alloc] initWithView:_viewLevel2];
    SZLevelItem *itemLevel3 = [[SZLevelItem alloc] initWithView:_viewLevel3];
    SZLevelItem *itemLevel4 = [[SZLevelItem alloc] initWithView:_viewLevel4];
    SZLevelItem *itemLevel5 = [[SZLevelItem alloc] initWithView:_viewLevel5];
    SZLevelItem *itemLevel6 = [[SZLevelItem alloc] initWithView:_viewLevel6];
    
    _items = [NSArray arrayWithObjects:itemLevel1, itemLevel2, itemLevel3, itemLevel4, itemLevel5, itemLevel6, nil];
    
    NSError *error;
    NSArray *arr = [_mainContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"ItemInfo"] error:&error];
    if( arr.count > 0 )
    {
        for( ItemInfo *info in arr )
        {
            SZLevelItem *item = [_items objectAtIndex:(info.level.intValue - 1)];
            //if(info.level.intValue == 1) info.hidden = 0;
            item.info = info;
        }
    }
    
    _levelButtons = [NSArray arrayWithObjects:_lblLevel2Btn, _lblLevel3Btn, _lblLevel4Btn, _lblLevel5Btn, _lblLevel6Btn, nil];
    
    _lblLevel2.font = [UIFont fontWithName:@"DroidSans-Bold" size:28];
    _lblLevel3.font = [UIFont fontWithName:@"DroidSans-Bold" size:28];
    _lblLevel4.font = [UIFont fontWithName:@"DroidSans-Bold" size:28];
    _lblLevel5.font = [UIFont fontWithName:@"DroidSans-Bold" size:28];
    _lblLevel6.font = [UIFont fontWithName:@"DroidSans-Bold" size:28];
    
    [self initLabel:_lblNewGameBtn];
    [self initLabel:_lblLevel2Btn];
    [self initLabel:_lblLevel3Btn];
    [self initLabel:_lblLevel4Btn];
    [self initLabel:_lblLevel5Btn];
    [self initLabel:_lblLevel6Btn];
    
    self.view.tag = TAG_ROOT_VIEW;
    _viewLevel2.tag = TAG_LEVEL_2;
    _viewLevel3.tag = TAG_LEVEL_3;
    _viewLevel4.tag = TAG_LEVEL_4;
    _viewLevel5.tag = TAG_LEVEL_5;
    _viewLevel6.tag = TAG_LEVEL_6;
    _viewNewGame.tag = TAG_NEW_GAME;
    _viewMore.tag = TAG_MORE;
    
    int topAnchor = -160;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if( screenBounds.size.height > 480 )
    {
        topAnchor = -80;
        CGRect frame = _touchLayer.frame;
        frame.origin.y = -80;
        _touchLayer.frame = frame;
    }
    
    _touchLayer.scrollCount = 7;
    _touchLayer.delegate = self;
    _touchLayer.topAnchor = topAnchor;
    _touchLayer.contentDynamic = YES;
}

- (void)initLabel:(UILabel *)label
{
    [label setFont:[UIFont fontWithName:@"DroidSans-Bold" size:28]];
    [label setTextColor:[UIColor colorWithHexString:@"0xF1F8E8" alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SZLevelItem *item = [_items objectAtIndex:0];
    
    int highscore = item.info.highscore.intValue;
    if( highscore )
    {
        _imgViewNewGame.hidden = YES;
        _lblNewGameBtn.text = [NSString stringWithFormat:@"%d", highscore];
        [_lblNewGame setText:@"Level 1"];
        _viewNewGame.tag = TAG_LEVEL_1;
    }
    
    for( int i = 0; i < _levelButtons.count; i++ )
    {
        item = [_items objectAtIndex:(i + 1)];
        UILabel *btn = [_levelButtons objectAtIndex:i];
        btn.text = [NSString stringWithFormat:@"%d", item.info.highscore.intValue];
    }
    
    if( _viewToAnimate != nil )
    {
        UIView *v = _viewToAnimate;
        [_touchLayer prepareLayoutNewLevelAppearing:v];
        _viewToAnimate = nil;
        v.alpha = 0;
        [UIView animateWithDuration:1.6 animations:^{
            v.hidden = NO;
            v.alpha = 1;
        }];
    }
    
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

- (void)viewClicked:(UIView *)view
{
    if( view.tag == TAG_NEW_GAME || view.tag == TAG_LEVEL_1 )
    {
        SZLevelItem *item = [_items objectAtIndex:0];
        SZViewController *game = [[SZViewController alloc] initWithIndex:0 navigation:_navigation highscore:item.info.highscore.intValue];
        
        game.delegate = self;
        [_navigation pushViewController:game animated:YES];
    }
    else if( view.tag < TAG_NEW_GAME )
    {
        int index = view.tag - TAG_LEVEL_1;
        SZLevelItem *item = [_items objectAtIndex:index];
        SZViewController *game = [[SZViewController alloc] initWithIndex:index navigation:_navigation highscore:item.info.highscore.intValue];
        
        game.delegate = self;
        [_navigation pushViewController:game animated:YES];
    }
    else if( view.tag == TAG_MORE )
    {
        SZMoreController *more = [[SZMoreController alloc] initWithNavigation:_navigation];
        [_navigation pushViewController:more animated:YES];
        
        //SZLevelItem *item = [_items objectAtIndex:4];
        //NSLog(@"info5: %@", item.info );
        
        /*NSError *error;
        NSArray *arr = [_mainContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"ItemInfo"] error:&error];
        for( ItemInfo *info in arr )
        {
            SZLevelItem *item = [_items objectAtIndex:(info.level.intValue - 1)];
            //if(info.level.intValue == 1) info.hidden = 0;
            item.info = info;
            [_mainContext deleteObject:info];
        }
        
        [_mainContext save:&error];*/
    }
}

- (void)fixLayout
{
    for( SZLevelItem *item in _items )
    {
        if( item.moved )
        {
            item.view.frame = item.newFrame;
        }
    }
}

- (void)gameDeleted:(int)tag
{
    int level = tag - TAG_LEVEL_START;
    
    SZLevelItem *item = [_items objectAtIndex:(level - 1)];
    item.info.highscore = [NSNumber numberWithInt:0];
    if( level > 1 ) item.info.hidden = [NSNumber numberWithInt:1];
    
    if( level == 1 )
    {
        _viewNewGame.alpha = 0;
        _viewNewGame.tag = TAG_NEW_GAME;
        CGRect frame = _viewNewGame.frame;
        frame.origin.x = 20;
        _viewNewGame.frame = frame;
        _lblNewGame.text = NSLocalizedString(@"New", nil );
        _lblNewGameBtn.text = @"";
        _imgViewNewGame.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            _viewNewGame.alpha = 1;
        }];
    }
    else if( level < 7 )
    {
        SZLevelItem *item = [_items objectAtIndex:(level - 1)];
        item.view.hidden = YES;
        [item reset];
        //[_touchLayer removeViewForMove:item.view];
        
        NSMutableArray *arr = [NSMutableArray array];
        for( int i = level; i < _items.count; i++ )
        {
            item = [_items objectAtIndex:i];
            if( !item.view.hidden ) [arr addObject:item];
            else
            {
                UIView *v = item.view;
                CGRect frame = v.frame;
                frame.origin.y += 80;
                item.newFrame = frame;
            }
        }
        
        if( arr.count > 0 )
        {
            [UIView animateWithDuration:1 animations:^{
                for( item in arr )
                {
                    UIView *v = item.view;
                    CGRect frame = v.frame;
                    frame.origin.y += 80;
                    item.newFrame = frame;
                }
            }];
        }
        else
        {
            if( _touchLayer.frame.origin.y != -160 )
            {
                [UIView animateWithDuration:0.6 animations:^{
                    CGRect frame = _touchLayer.frame;
                    int moveY = 80;
                    frame.origin.y -= moveY;
                    _touchLayer.frame = frame;
                }];
            }
        }
    }
    
    [_mainContext save:nil];
}

- (void)newHighscore:(int)highscore level:(int)level
{
    SZLevelItem *item = [_items objectAtIndex:(level - 1)];
    item.info.highscore = [NSNumber numberWithInt:highscore];
    [_mainContext save:nil];
}

- (void)levelFinished:(int)level
{
    //SZLevelItem *item = [_items objectAtIndex:4];
    //NSLog(@"info5: %@", item.info );
    
    BOOL saveChanges = NO;
    if( level < 6 )
    {
        SZLevelItem *item = [_items objectAtIndex:level];
        if( item.info.hidden.intValue == 1 )
        {
            item.info.hidden = [NSNumber numberWithInt:0];
            item.view.frame = item.newFrame;
            saveChanges = YES;
            _viewToAnimate = item.view;
            
            for( int i = level + 1; i < _items.count; i++ )
            {
                item = [_items objectAtIndex:i];
                if( item.moved )
                {
                    CGRect frame = item.view.frame;
                    frame.origin.y -= 80;
                    item.newFrame = frame;
                }
            }
            
            [self fixGap];
            [_navigation popViewControllerAnimated:YES];
        }
    }
    
    if( saveChanges ) [_mainContext save:nil];
}

- (void)fixGap
{
    int yPositionPrevious = -1;
    for( SZLevelItem *item in _items )
    {
        int yPosition = item.newFrame.origin.y;
        if( yPositionPrevious != -1 )
        {
            if( yPositionPrevious > yPosition + 80 )
            {
                NSLog(@"gap detected");
                CGRect frame = item.newFrame;
                frame.origin.y += 80;
                item.newFrame = frame;
                yPosition += 80;
            }
        }
        
        yPositionPrevious = yPosition;
    }
}

@end
