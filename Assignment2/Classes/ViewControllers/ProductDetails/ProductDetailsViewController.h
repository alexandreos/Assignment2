//
//  DetailViewController.h
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

/**
 The product object to be displayed.
 */
@property (strong, nonatomic) Product *product;

@end
