//
//  SDStockManager.h
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

#import <Foundation/Foundation.h>

@protocol SDStockManagerDelegate <NSObject>

@optional

-(void)didRecieveStockInfo:(NSDictionary*)stockInfo;
-(void)didRecieveStockPrice:(NSNumber *)stockPrice forSymbol:(NSString*)symbol;

-(void)didFailWithError:(NSError*)error;

@end

@interface SDStockManager : NSObject{
    __weak id delegate;
}

@property(nonatomic,strong) NSString *stockSymbol;
@property(nonatomic,weak) id <SDStockManagerDelegate> delegate;

+(SDStockManager *)sharedManager;
-(void)stockInfoWithSymbol:(NSString*)stockSymbol completion:(void (^)(NSDictionary *information))completion;
-(void)stockPriceWithSymbol:(NSString*)stockSymbol completion:(void (^)(NSDictionary *information))completion;
@end
