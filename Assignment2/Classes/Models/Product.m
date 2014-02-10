//
//  Product.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "Product.h"
#import "NSObject+OSReflectionKit.h"
#import "NSDictionary+JSONSerialization.h"

@implementation Product

#pragma mark - OSReflectionKit

/**
 Overriding to return special key -> property mapping.
 */
+ (NSDictionary *) reflectionMapping {
    return @{@"id":@"identifier",
             @"colors":@"colors,<Color>",
             @"regularPrice":@"regularPrice,*",
             @"salePrice":@"salePrice,*",
             @"stores":@"stores,*"};
}

- (void)reflectionTranformsValue:(id)value forKey:(NSString *)propertyName
{
    if([propertyName isEqualToString:@"regularPrice"]) {
        // Convert the regular price integer to NSDecimaNumber
        self.regularPrice = [NSDecimalNumber decimalNumberWithMantissa:[value unsignedIntegerValue] exponent:-2 isNegative:NO];
    }
    else if([propertyName isEqualToString:@"salePrice"]) {
        // Convert the regular price integer to NSDecimaNumber
        self.salePrice = [NSDecimalNumber decimalNumberWithMantissa:[value unsignedIntegerValue] exponent:-2 isNegative:NO];
    }
    else if([propertyName isEqualToString:@"stores"]) {
        if([value isKindOfClass:[NSDictionary class]]) {
            self.stores = value;
        }
        else if([value isKindOfClass:[NSString class]]) {
            // Convert the stores string into NSDictionary
            self.stores = [NSDictionary JSON_dictionaryFromString:value];
        }
    }
}

#pragma mark - Public Methods

- (NSDictionary *) persistenceDictionary {
    NSMutableDictionary *dict = [[self reverseDictionary] mutableCopy];
    
    [dict removeObjectForKey:@"colors"];
    if(self.stores)
        dict[@"stores"] = [self.stores JSON_toString];
    
    // Fix Prices to store as integers
    if(self.regularPrice) {
        dict[@"regularPrice"] = [self.regularPrice decimalNumberByMultiplyingByPowerOf10:2];
    }
    if(self.salePrice) {
        dict[@"salePrice"] = [self.salePrice decimalNumberByMultiplyingByPowerOf10:2];
    }
    
    // Remove all NSNull objects
    NSArray *keysForNullValues = [dict allKeysForObject:[NSNull null]];
    [dict removeObjectsForKeys:keysForNullValues];
    
    return [dict copy];
}

- (UIImage *) photo {
    if(self.photoName) {
        return [UIImage imageNamed:self.photoName];
    }
    
    return nil;
}

- (UIImage *) thumbnail {
    if(self.photoName) {
        return [UIImage imageNamed:[self.photoName stringByAppendingString:@"_thumb"]];
    }
    
    return nil;
}

- (BOOL) setRegularPriceFromString:(NSString *) price {
    BOOL success = NO;
    
    // Only accept positive strings with only numbers
    BOOL onlyNumbers = [price rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]].location == NSNotFound;
    if([price length] > 0 && onlyNumbers) {
        self.regularPrice = [NSDecimalNumber decimalNumberWithString:price];
        success = YES;
    }
    
    return success;
}

- (BOOL) setSalePriceFromString:(NSString *) price {
    BOOL success = NO;
    
    // Only accept positive strings with only numbers
    BOOL onlyNumbers = [price rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]].location == NSNotFound;
    if([price longLongValue] >= 0 && onlyNumbers) {
        if([price length] > 0) {
            self.salePrice = [NSDecimalNumber decimalNumberWithString:price];
        }
        else {
            self.salePrice = [NSDecimalNumber decimalNumberWithMantissa:0 exponent:0 isNegative:NO];
        }
        success = YES;
    }
    
    return success;
}

@end
