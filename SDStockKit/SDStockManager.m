//
//  SDStockManager.m
//  SimpleStocks
//
//  Created by Steve Derico on 11/26/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//
#import "AFNetworking.h"
#import "SDStockManager.h"

@implementation SDStockManager

+ (SDStockManager *)sharedManager {
    static SDStockManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SDStockManager alloc] init];
    });
    
    return _sharedManager;
}

@end
