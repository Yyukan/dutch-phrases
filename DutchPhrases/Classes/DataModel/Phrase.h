//
//  Phrase.h
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 01/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Phrase : NSManagedObject

@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) NSString * translation;

@end
