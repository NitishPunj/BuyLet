//
//  LogInViewController.m
//  BuyOrLet
//
//  Created by TAE on 04/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import "LogInViewController.h"
//#import "AFNetworking.h"
#import "SearchViewController.h"
//#import "AFNetworkReachabilityManager.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   _uName.text = [defaults valueForKey:@"username_preference"];
    _uPass.text = [defaults valueForKey:@"password_preference"];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)shouldAutorotate {
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"enableRotation"];
    
    if (enabled) {
        return NO;
    } else {
        return YES;
    }
}


-(void)showView{

    
    [self performSegueWithIdentifier: @"ShowOnline" sender: self];
//[self.tabBarController setSelectedIndex:0];
//
//    SearchViewController *viewController = [[SearchViewController alloc] init];
//    [self.tabBarController pushViewController:viewController animated:YES];
//    
    
    

}

- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}


-(void)checkConnection{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL wifiEnabled = [defaults boolForKey:@"use_wifi_preference"];
    
    BOOL dataEnabled = [defaults boolForKey:@"use_data_preference"];
    
    
    
    
    BOOL connect = [self connected];
    if (!connect)
        
        NSLog(@" no internet");
    
    else
        NSLog(@"internet working");
    

    
    
    //***************** Only For Simulator Testing ***********************
    if (wifiEnabled || dataEnabled)
    {
        
        if(!wifiEnabled){
            
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No Wifi Access" message:@"Turn on Access"  preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"test122");
                
            }]];
            
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            }else
            
            {
                [self showView];
            }
        }
    else if(!dataEnabled){
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No Mobile Data" message:@"Turn On Mobile Access"  preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"test123");
            
        }]];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        

        
        
            }
        else
        {
                [self showView];
            }
    
    
    
    
    
    

}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)lgBtn:(id)sender {
    
    [self checkConnection];
    
    
}
@end
