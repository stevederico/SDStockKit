//
//  SDStockManager.m
//  SDStockKit
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

#import "AFNetworking.h"
#import "SDStockManager.h"

static NSString *yahooLoadStockDetailsURLString = @"http://query.yahooapis.com/v1/public/yql?q=select%%20*%%20from%%20yahoo.finance.quotes%%20where%%20symbol%%20%%3D%%20%%22%@%%22&format=json&env=store%%3A%%2F%%2Fdatatables.org%%2Falltableswithkeys&callback=cbfunc";


@implementation SDStockManager

@synthesize stockSymbol = _stockSymbol;
@synthesize delegate = _delegate;

+(SDStockManager *)sharedManager {
    static SDStockManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SDStockManager alloc] init];
    });
    
    return _sharedManager;
}

-(void)stockInfoWithSymbol:(NSString*)stockSymbol{

    self.stockSymbol = stockSymbol;
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:yahooLoadStockDetailsURLString, [stockSymbol stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestUrl];
    
    __block NSDictionary *responseDict;
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSString *trimmedResponse = [requestOperation.responseString stringByReplacingOccurrencesOfString:@"cbfunc" withString:@""];
        
        NSCharacterSet *removeSet = [NSCharacterSet characterSetWithCharactersInString:@"();"];
        NSString *jsonResponse = [[trimmedResponse componentsSeparatedByCharactersInSet: removeSet] componentsJoinedByString: @""];
        
        responseDict = [NSJSONSerialization JSONObjectWithData:[jsonResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        
        responseDict = [[[responseDict valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"quote"];
        
    
        if (error) {
            [self.delegate didFailWithError:error];
        }else{
            [self.delegate didRecieveStockInfo:responseDict];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate didFailWithError:error];
    }];
    
    [requestOperation start];

}

-(void)stockPriceWithSymbol:(NSString*)stockSymbol{

    self.stockSymbol = stockSymbol;
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:yahooLoadStockDetailsURLString, [stockSymbol stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestUrl];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSString *trimmedResponse = [requestOperation.responseString stringByReplacingOccurrencesOfString:@"cbfunc" withString:@""];
        
        NSCharacterSet *removeSet = [NSCharacterSet characterSetWithCharactersInString:@"();"];
        NSString *jsonResponse = [[trimmedResponse componentsSeparatedByCharactersInSet: removeSet] componentsJoinedByString: @""];
        
        NSDictionary *responseDict =  [NSJSONSerialization JSONObjectWithData:[jsonResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
           [self.delegate didFailWithError:error];
        }else{
            NSString *stockPriceString = [[[[responseDict valueForKey:@"query"] valueForKey:@"results"] valueForKey:@"quote"] valueForKey:@"LastTradePriceOnly"];
            
            NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:stockPriceString];
            
            [self.delegate didRecieveStockPrice:decimalNumber forSymbol:stockSymbol];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate didFailWithError:error];
    }];
    
    [requestOperation start];
    

}

@end
