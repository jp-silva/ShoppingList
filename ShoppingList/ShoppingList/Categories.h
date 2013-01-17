//
//  Categories.h
//  ShoppingList
//
//  Created by pedro on 1/16/13.
//  Copyright (c) 2013 jpsilva's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Items;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *items;
@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Items *)value;
- (void)removeItemsObject:(Items *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
