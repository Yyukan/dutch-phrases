//
//  StringUtils.m
//  GTI
//
//  Created by Oleksandr Shtykhno on 07/11/2011.
//  Copyright (c) 2011 shtykhno.net. All rights reserved.
//

#import "Logger.h"
#import "StringUtils.h"

@implementation StringUtils

+ (NSString *) replaceString:(NSString *)string regularExpression:(NSString *)regexp with:(NSString *)pattern
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression         
                                  regularExpressionWithPattern:regexp
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    return [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:pattern];
}

+ (NSArray *) findAll:(NSString *)string regularExpression:(NSString *)regularExpression
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression         
                                  regularExpressionWithPattern:regularExpression
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionSearch
                                  error:&error];
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in matches) 
    {
        NSRange matchRange = [match rangeAtIndex:0];
        [result addObject:[string substringWithRange:matchRange]];
    }
    return result;    
}

+ (NSArray *) findAllByFirstGroup:(NSString *)string regularExpression:(NSString *)regularExpression
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression         
                                  regularExpressionWithPattern:regularExpression
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionSearch
                                  error:&error];
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in matches) 
    {
        NSRange matchRange = [match rangeAtIndex:1];
        [result addObject:[string substringWithRange:matchRange]];
    }
    return result;    
}

+ (NSString *) replaceFirstGroupAll:(NSString *)string regularExpression:(NSString *)regexp
{
    NSError *error = NULL;
    // create regular expression
    NSRegularExpression *regex = [NSRegularExpression         
                                  regularExpressionWithPattern:regexp
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionSearch
                                  error:&error];
    NSMutableString *result = [NSMutableString string];
    
    // return array of matches    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSUInteger lastMatchSymbolLocation = 0; 
    for (NSTextCheckingResult *match in matches) 
    {
        NSRange matchRange = [match rangeAtIndex:0];
        NSRange groupMatchRange = [match rangeAtIndex:1];
        
        [result appendString:[string substringWithRange:NSMakeRange(lastMatchSymbolLocation, matchRange.location - lastMatchSymbolLocation)]];
        [result appendString:[string substringWithRange:groupMatchRange]];
        
        lastMatchSymbolLocation = matchRange.location + matchRange.length;
    }    
    [result appendString:[string substringFromIndex:lastMatchSymbolLocation]];    
    
    return result;
}

+ (BOOL) isEmptyString:(NSString *) string 
{
    if([string length] == 0) 
    { 
        return YES;
    } 
    else if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) 
    {
        return YES;
    }
    return NO;
}


@end
