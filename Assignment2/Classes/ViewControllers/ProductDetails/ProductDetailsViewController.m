//
//  DetailViewController.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "DatabaseManager.h"
#import "NSDictionary+JSONSerialization.h"
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "ProductColorsViewController.h"

@interface ProductDetailsViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buttonThumbnail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UIButton *buttonColors;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRegularPrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSalePrice;
@property (weak, nonatomic) IBOutlet UITextView *textViewStores;

@property (weak, nonatomic) UIView<UITextInput> *currentTextInput;

@end

@implementation ProductDetailsViewController

#pragma mark - View Ligecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(320, 568);
    
    // Load colors of the product
    self.product.colors = [[[DatabaseManager sharedManager] dbContext] readAllColorsForProductId:self.product.identifier error:nil];
    
    [self.buttonThumbnail setBackgroundImage:[self.product thumbnail] forState:UIControlStateNormal];
    self.textFieldName.text = self.product.name;
    self.textFieldRegularPrice.text = [self.product.regularPrice stringValue];
    self.textFieldSalePrice.text = [self.product.salePrice stringValue];
    self.textViewDescription.text = self.product.productDescription;
    self.textViewStores.text = [self.product.stores JSON_toString];
    
    self.navigationItem.rightBarButtonItem = [self buttonOptions];
    
    if([self.product.colors count] > 0) {
        [self.buttonColors setTitle:[[self.product.colors valueForKeyPath:@"name"] componentsJoinedByString:@" | "] forState:UIControlStateNormal];
    }
    else {
        self.buttonColors.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (void) buttonDoneTapped:(id) sender {
    [self.currentTextInput resignFirstResponder];
}

- (void) updateProduct {
    
    self.product.name = self.textFieldName.text;
    
    if(![self.product setRegularPriceFromString:self.textFieldRegularPrice.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Invalid regular price!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    if(![self.product setSalePriceFromString:self.textFieldSalePrice.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Invalid sale price!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    
    self.product.productDescription = self.textViewDescription.text;
    
    NSError *error = nil;
    
    if(![[[DatabaseManager sharedManager] dbContext] updateProduct:self.product error:&error]) {
        NSString *errorMessage = [error localizedDescription];
        if(errorMessage == nil) {
            errorMessage = [NSString stringWithFormat:@"Something went wrong while trying to update '%@'", self.product.name];
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Product updated!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
}

- (void) deleteProduct {
     NSError *error = nil;
    if(![[[DatabaseManager sharedManager] dbContext] deleteProduct:self.product error:&error]) {
        NSString *errorMessage = [error localizedDescription];
        if(errorMessage == nil) {
            errorMessage = [NSString stringWithFormat:@"Something went wrong while trying to delete '%@'", self.product.name];
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Product deleted!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) buttonOptionsTapped:(id) sender {
    
    [self.currentTextInput resignFirstResponder];
    
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:@"Delete"
                        otherButtonTitles:@"Update", nil]
     showFromBarButtonItem:sender animated:YES];
}

- (IBAction)buttonThumbnailTapped:(id)sender {
    if(self.product.photoName)
    {
        IDMPhoto *photo = [IDMPhoto photoWithImage:[self.product photo]];
        IDMPhotoBrowser *photoBrowser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
        [self presentViewController:photoBrowser animated:YES completion:nil];
    }
}

- (IBAction)buttonColorsTapped:(id)sender {
    ProductColorsViewController *colorsViewController = [[ProductColorsViewController alloc] initWithStyle:UITableViewStylePlain];
    colorsViewController.colors = self.product.colors;
    [self.navigationController pushViewController:colorsViewController animated:YES];
}


#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self didBeginTextInput:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self didEndTextInput:textField];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self didBeginTextInput:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self didEndTextInput:textView];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == [actionSheet destructiveButtonIndex]) {
        [self deleteProduct];
    } else if(buttonIndex != [actionSheet cancelButtonIndex]) {
        [self updateProduct];
    }
}

#pragma mark - Private Methods

- (UIBarButtonItem *) buttonOptions {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                         target:self
                                                         action:@selector(buttonOptionsTapped:)];
}

- (UIBarButtonItem *) buttonDone {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDoneTapped:)];
}

- (void) didBeginTextInput:(UIView<UITextInput> *) textInput {
    
    self.navigationItem.rightBarButtonItem = [self buttonDone];
    
    self.currentTextInput = textInput;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.scrollView.frame;
        // This constant value is just for the sake of simplicity in this assignment. I know how to get this info dynamically.
        frame.size.height -= 194;
        self.scrollView.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = textInput.frame;
        frame.origin.y += frame.size.height;
        [self.scrollView scrollRectToVisible:frame animated:NO];
    }];
}

- (void) didEndTextInput:(UIView<UITextInput> *) textInput {
    
    self.navigationItem.rightBarButtonItem = [self buttonOptions];
    
    self.currentTextInput = nil;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.scrollView.frame;
        // This constant value is just for the sake of simplicity in this assignment. I know how to get this info dynamically.
        frame.size.height += 194;
        self.scrollView.frame = frame;
    }];
}

@end
