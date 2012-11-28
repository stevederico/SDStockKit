# SDStockKit

`SDStockKit` is a simple framework for interacting with Yahoo's Finance API. 


## Demo

Build and run the `SDStockKit Example` project in Xcode to see an inventory of the available `SDStockKit` components.

---

## SDStockManager

Sends request and parses response for stock information from Yahoo Finance API. Requires a delegate that adheres to the `SDStockManagerDelegate` Protocol.
> Requires the `AFNetworking` only available on iOS.

### Example Usage

```objective-c
[[SDStockManager sharedManager] setDelegate:self];
[[SDStockManager sharedManager] stockPriceWithSymbol:@"AAPL"];
```

### Example Delegate Methods
```objective-c
-(void)didRecieveStockInfo:(NSDictionary*)stockInfo{
  NSLog(@"STOCKINFO: %@",stockInfo);
}


-(void)didRecieveStockPrice:(NSNumber *)stockPrice forSymbol:(NSString*)symbol{
    NSLog(@"Stock: %@ Price: %@",symbol,stockPrice);
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:symbol,@"Symbol",stockPrice,@"Price", nil];
    [_stocks addObject:dict];
    [self.tableView reloadData];
}
```
---

## Contact

Steve Derico

- http://github.com/stevederico
- http://twitter.com/stevederico
- http://blog.stevederico.com

## License

SDStockKit is available under the MIT license. See the LICENSE file for more info.
