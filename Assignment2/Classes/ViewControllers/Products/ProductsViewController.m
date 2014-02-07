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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.products = [[[DatabaseManager sharedManager] dbContext] readAllProductsWithError:nil];
    [self.tableView reloadData];
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

@end
