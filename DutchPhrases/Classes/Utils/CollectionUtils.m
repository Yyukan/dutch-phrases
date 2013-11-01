//
//  CollectionUtils.m
//  DutchGrammarBook
//
//  Created by Oleksandr Shtykhno on 01/11/2012.
//  Copyright (c) 2012 Oleksandr Shtykhno. All rights reserved.
//

#import "CollectionUtils.h"

@implementation CollectionUtils


+(NSArray *) sortedKeysForDictionary:(NSDictionary *)dictionary reverse:(BOOL) reverse
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dictionary allKeys]];
    NSArray *result = [array sortedArrayUsingSelector:@selector(localizedCompare:)];
    if (reverse)
    {
        return [[result reverseObjectEnumerator] allObjects];
    }
    return result;
}


@end
