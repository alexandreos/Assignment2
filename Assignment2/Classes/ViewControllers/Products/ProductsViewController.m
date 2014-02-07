//
//  ProductsViewController.m
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "ProductsViewController.h"
#import "DatabaseManager.h"
#import "ProductDetailsViewController.h"

@interface ProductsViewController ()

@property (nonatomic, strong) NSArray *products;

@end

@implementation ProductsViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNotificationObservers];
    
    [self reloadProducts];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void) registerNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSaveProductNotification:)
                                                 name:kDatabaseContextDidSaveProductNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDeleteProductNotification:)
                                                 name:kDatabaseContextDidDeleteProductNotification
                                               object:nil];
}

- (void) didSaveProductNotification:(NSNotification *) notification {
    [self reloadProducts];
}

- (void) didDeleteProductNotification:(NSNotification *) notification {
    [self reloadProducts];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    Product *product = self.products[indexPath.row];
    cell.textLabel.text = product.name;
    cell.detailTextLabel.text = product.productDescription;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = self.products[indexPath.row];
    
    ProductDetailsViewController *productDetailsViewController = [[ProductDetailsViewController alloc] init];
    productDetailsViewController.product = product;
    
    [self.navigationController pushViewController:productDetailsViewController animated:YES];
}

#pragma mark - Private Methods

- (void) reloadProducts {
    self.products = [[[DatabaseManager sharedManager] dbContext] readAllProductsWithError:nil];
    [self.tableView reloadData];
}

@end
