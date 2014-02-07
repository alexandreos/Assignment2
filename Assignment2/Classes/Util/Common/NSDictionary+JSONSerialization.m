//
//  NSDictionary+JSONSerialization.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "NSDictionary+JSONSerialization.h"

@implementation NSDictionary (JSONSerialization)

- (NSString *) JSON_toString
{
    return [self JSON_toString:nil];
}

- (NSString *) JSON_toString:(NSError **)error
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:error];
    NSString *resultAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return resultAsString;
}

+ (NSDictionary *) JSON_dictionaryFromString:(NSString *) json
{
    return [self JSON_dictionaryFromString:json error:nil];
}

+ (NSDictionary *) JSON_dictionaryFromString:(NSString *) json error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                           options: NSJSONReadingMutableContainers
                                             error: error];
}

@end
