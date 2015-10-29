//
//  LogInViewController.h
//  BuyOrLet
//
//  Created by TAE on 04/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *uName;
@property (strong, nonatomic) IBOutlet UITextField *uPass;
- (IBAction)lgBtn:(id)sender;

@end
