//
//  UIColor+ARGB.h
//  SQFramework
//
//  Created by Alexandre Oliveira Santos on 02/01/13.
//  Copyright (c) 2013 Squadra. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDoneButtonARGBColor 0xFF4086E8

@interface UIColor (ARGB)

+ (UIColor *) colorWithARGB:(NSUInteger) argb;
- (NSInteger) argbValue;

@end
