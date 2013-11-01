//
//  CollectionUtils.h
//  DutchGrammarBook
//
//  Created by Oleksandr Shtykhno on 01/11/2012.
//  Copyright (c) 2012 Oleksandr Shtykhno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionUtils : NSObject

+(NSArray *) sortedKeysForDictionary:(NSDictionary *)dictionary reverse:(BOOL) reverse;

@end
