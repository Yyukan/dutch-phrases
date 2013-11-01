//
//  PersistenceManager.h
//  GTI
//
//  Created by Oleksandr Shtykhno on 06/11/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Common.h"

@interface PersistenceManager : NSObject
{
	NSManagedObjectModel *_managedObjectModel;
	NSManagedObjectContext *_managedObjectContext;		
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (PersistenceManager *)sharedPersistenceManager;

- (void)saveManagedContext;

@end
