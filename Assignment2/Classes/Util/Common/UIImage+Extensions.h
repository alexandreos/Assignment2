//
//  UIImage+Extensions.h
//  Karmalot
//
//  Created by Alexandre on 22/03/13.
//  Copyright (c) 2013 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>

// iPhone 5 support
#define Retina4ImageName(regular) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : [regular stringByAppendingString:@"-568h"])

@interface UIImage (Extensions)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *) imageMaskedFromImage:(UIImage *) image color:(UIColor *)color;

@end
