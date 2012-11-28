//
//  MasterViewController.m
//  SimpleStocks
//
//  Created by Steve Derico on 11/24/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "AddStockViewController.h"
#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController (){

    NSMutableArray *_stocks;

}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stocks", @"Stocks");
        _stocks = [[NSMutableArray alloc] init];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];


    
    [[SDStockManager sharedManager] setDelegate:self];
    [[SDStockManager sharedManager] stockPriceWithSymbol:@"GOOG"];
    [[SDStockManager sharedManager] stockPriceWithSymbol:@"AAPL"];
    [[SDStockManager sharedManager] stockInfoWithSymbol:@"AAPL"];
    [[SDStockManager sharedManager] stockPriceWithSymbol:@"IBM"];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_stocks count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    cell.textLabel.text = [[[_stocks objectAtIndex:indexPath.row]  valueForKey:@"Symbol"] description];
    cell.detailTextLabel.text = [[[_stocks objectAtIndex:indexPath.row] valueForKey:@"Price"] description];
}

#pragma Show

- (void)showAddStock{
    AddStockViewController *addStockViewController = [[AddStockViewController alloc] initWithNibName:@"AddStockViewController" bundle:nil];
    [self.navigationController pushViewController:addStockViewController animated:YES];
}


#pragma mark - SDStockKit

-(void)didRecieveStockInfo:(NSDictionary*)stockInfo{

    NSLog(@"STOCKINFO: %@",stockInfo);

}

-(void)didRecieveStockPrice:(NSNumber *)stockPrice forSymbol:(NSString*)symbol{
    
    NSLog(@"Stock: %@ Price: %@",symbol,stockPrice);
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:symbol,@"Symbol",stockPrice,@"Price", nil];
    
    [_stocks addObject:dict];
    
    [self.tableView reloadData];
    
}

- (void)didFailWithError:(NSError *)error{
    NSLog(@"Error: %@",[error description]);

}

@end
