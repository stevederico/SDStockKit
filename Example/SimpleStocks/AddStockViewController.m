//
//  AddStockViewController.m
//  SimpleStocks
//
//  Created by Steve Derico on 11/24/12.
//  Copyright (c) 2012 Bixby Apps. All rights reserved.
//

#import "AddStockViewController.h"

@interface AddStockViewController ()

@end

@implementation AddStockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Add Stock";
        self.symbolField.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.symbolField becomeFirstResponder];
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addStockTapped:(id)sender {
}





@end
