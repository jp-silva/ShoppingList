//
//  Items.h
//  ShoppingList
//
//  Created by pedro on 1/17/13.
//  Copyright (c) 2013 jpsilva's company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categories, Units;

@interface Items : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * totalQuantity;
@property (nonatomic, retain) Categories *category;
@property (nonatomic, retain) Units *unit;

@end
