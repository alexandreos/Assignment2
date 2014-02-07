//
//  NSDictionary+JSONSerialization.h
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONSerialization)

- (NSString *) JSON_toString;
- (NSString *) JSON_toString:(NSError **)error;

+ (NSDictionary *) JSON_dictionaryFromString:(NSString *) json;
+ (NSDictionary *) JSON_dictionaryFromString:(NSString *) json error:(NSError **)error;

@end
