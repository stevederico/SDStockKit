//
//  SDStockManager.h
//  SimpleStocks
//
//  Created by Steve Derico on 11/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDStockManager : NSObject

@property(nonatomic,strong) NSString *stockSymbol;

+(SDStockManager *)sharedManager;
-(void)stockInfoWithSymbol:(NSString*)stockSymbol;
@end
