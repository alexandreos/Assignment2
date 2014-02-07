//
//  UIColor+ARGB.m
//  SQFramework
//
//  Created by Alexandre Oliveira Santos on 02/01/13.
//  Copyright (c) 2013 Squadra. All rights reserved.
//

#import "UIColor+ARGB.h"

@implementation UIColor (ARGB)

+ (UIColor *) colorWithARGB:(NSUInteger) argb
{
    unsigned char a,r,g,b;
    
    a = (argb & 0xFF000000) >> 24;
    r = (argb & 0x00FF0000) >> 16;
    g = (argb & 0x0000FF00) >> 8;
    b = (argb & 0x000000FF);
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a/255.0)];
}

- (NSInteger) argbValue
{
    int numComponents = CGColorGetNumberOfComponents(self.CGColor);
    
    NSInteger argb = 0;
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        
        unsigned char r = (components[0]*0x00FF0000);
        unsigned char g = (components[1]*0x0000FF00);
        unsigned char b = (components[2]*0x000000FF);
        unsigned char a = (components[3]*0xFF000000);
        
        argb = a + r + g + b;
    }
    
    return argb;
}

@end
