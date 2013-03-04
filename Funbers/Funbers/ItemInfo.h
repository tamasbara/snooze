//
//  ItemInfo.h
//  Funbers
//
//  Created by Tamas Bara on 25.02.13.
//  Copyright (c) 2013 SnoozeSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ItemInfo : NSManagedObject

@property (nonatomic, retain) NSNumber *level;
@property (nonatomic, retain) NSNumber *highscore;
@property (nonatomic, retain) NSNumber *hidden;
@property (nonatomic, retain) NSNumber *offset;

@end
