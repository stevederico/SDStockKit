//
//  MasterViewController.h
//  SimpleStocks
//
//  Created by Steve Derico on 11/24/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "SDStockManager.h"
#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,SDStockManagerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
