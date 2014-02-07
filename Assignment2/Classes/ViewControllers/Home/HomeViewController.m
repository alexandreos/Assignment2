//
//  MasterViewController.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductsViewController.h"
#import "DatabaseManager.h"
#import <NSObject+OSReflectionKit.h>

typedef NS_ENUM(NSInteger, JSONSegmentIndex) {
    JSONSegmentIndexiPhone5 = 0,
    JSONSegmentIndexiNexus5,
    JSONSegmentIndexiWP
};

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViewJSON;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlJSON;


@end

@implementation HomeViewController

#pragma mark - View Lifecicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar *toolbarAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDoneTapped:)];
    toolbarAccessoryView.items = @[buttonDone];
    self.textViewJSON.inputAccessoryView = toolbarAccessoryView;
    
    // Setup the default segment
    [self setupViewContentsWithSegmentIndex:self.segmentedControlJSON.selectedSegmentIndex];
}

#pragma mark - Private Instance Methods

- (void) setupViewContentsWithSegmentIndex:(JSONSegmentIndex) segmentIndex {
    
    NSString *jsonString = nil;
    switch (segmentIndex) {
        case JSONSegmentIndexiPhone5:
            jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iPhone5" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
            break;
            
        case JSONSegmentIndexiNexus5:
            jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Nexus5" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
            break;
            
        case JSONSegmentIndexiWP:
            jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WP" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
            break;
    }
    
    self.textViewJSON.text = jsonString;
}

- (void) pushToProductsViewController {

    ProductsViewController *productsViewController = [[ProductsViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:productsViewController animated:YES];
}

#pragma mark UI Actions

- (IBAction)segmentedControlJSONChanged:(id)sender {
    [self setupViewContentsWithSegmentIndex:self.segmentedControlJSON.selectedSegmentIndex];
}

- (void) buttonDoneTapped:(id) sender {
    [self.textViewJSON resignFirstResponder];
}

- (IBAction)buttonShowAllProductsTapped:(id)sender {
    
    [self pushToProductsViewController];
}

- (IBAction)buttonCreateProductTapped:(id)sender {

    // Create the product from the JSON string
    NSError *error = nil;
    
    Product *product = [Product objectFromJSON:self.textViewJSON.text error:&error];
    
    if(product == nil) {
        // Present an error message
        NSString *errorMessage = [error localizedDescription];
        if(errorMessage == nil) {
            errorMessage = @"Something went wrong while trying to convert the JSON string into a Product object.";
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    else {
        
        // Save the object
        DatabaseContext *dbContext = [[DatabaseManager sharedManager] dbContext];
        
        if([dbContext insertProduct:product error:&error]) {
            // Push to the all products view
            [self pushToProductsViewController];
        }
        else {
            NSString *errorMessage = [error localizedDescription];
            if(errorMessage == nil) {
                errorMessage = @"Something went wrong while trying to save the Product object into the database.";
            }
            
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }
}

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = textView.frame;
        // This constant value is just for the sake of simplicity in this assignment. I know how to get this info dynamically.
        frame.size.height -= 194;
        textView.frame = frame;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = textView.frame;
        // This constant value is just for the sake of simplicity in this assignment. I know how to get this info dynamically.
        frame.size.height += 194;
        textView.frame = frame;
    }];
}

@end
