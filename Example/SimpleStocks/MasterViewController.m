//
//  MasterViewController.m
//  SimpleStocks
//
// Copyright (c) 2012 Steve Derico (http://stevederico.com/)
//                                 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//                                 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//                                 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MasterViewController.h"

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
							
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //SDStockManagerDelegate Callback
    [[SDStockManager sharedManager] setDelegate:self];
    [[SDStockManager sharedManager] stockPriceWithSymbol:@"GOOG" completion:nil];
    [[SDStockManager sharedManager] stockPriceWithSymbol:@"AAPL" completion:nil];
    
    //Block-Based Callback
    [[SDStockManager sharedManager] stockInfoWithSymbol:@"AAPL" completion:^(NSDictionary *information) {
        NSLog(@"StockInfo-Block: %@",information);
    }];
    [[SDStockManager sharedManager] stockPriceWithSymbol:@"IBM" completion:^(NSDictionary *information) {
        NSLog(@"StockPrice-Block: %@",information);
    }];
    
    NSArray *stocks = [NSArray arrayWithObjects:@"GOOG",@"AAPL",@"IBM", nil];

    //Array Support
    [[SDStockManager sharedManager] stockPriceWithSymbols:stocks completion:^(NSDictionary *information) {
        NSLog(@"StockPrice-Array: %@",information);
    }];
    [[SDStockManager sharedManager] stockInfoWithSymbols:stocks completion:^(NSDictionary *information) {
        NSLog(@"StockInfo-Array: %@",information);
    }];
//
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_stocks count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [[[_stocks objectAtIndex:indexPath.row]  valueForKey:@"Symbol"] description];
    cell.detailTextLabel.text = [[[_stocks objectAtIndex:indexPath.row] valueForKey:@"Price"] description];
}


#pragma mark - SDStockKit

-(void)didRecieveStockInfo:(NSDictionary*)stockInfo{

    NSLog(@"StockInfo-Delegate: %@",stockInfo);

}

-(void)didRecieveStockPrice:(NSNumber *)stockPrice forSymbol:(NSString*)symbol{
    
    NSLog(@"Delegate-Stock: %@ Price: %@",symbol,stockPrice);
    
    static NSNumberFormatter *numberFormatter = nil;
    if (!numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    NSString *currencyString = [numberFormatter stringFromNumber:stockPrice];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:symbol,@"Symbol",currencyString,@"Price", nil];
    
    [_stocks addObject:dict];
    
    [self.tableView reloadData];
    
}

- (void)didFailWithError:(NSError *)error{
    NSLog(@"Error: %@",[error description]);

}

@end
