//
//  AddStockViewController.h
//  SimpleStocks
//
//  Created by Steve Derico on 11/24/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStockViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UITextField *symbolField;
- (IBAction)addStockTapped:(id)sender;

@end
