//
//  SearchViewController.h
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface SearchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *area;
@property (strong, nonatomic) IBOutlet UITextField *street;
@property (strong, nonatomic) IBOutlet UITextField *radius;
@property (strong, nonatomic) IBOutlet UITextField *postcode;
@property (strong, nonatomic) IBOutlet UITextField *beds;
@property (strong, nonatomic) IBOutlet UITextField *rent;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinningWheel;


- (IBAction)searchProperties:(id)sender;
@end
