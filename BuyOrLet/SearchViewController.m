//
//  SearchViewController.m
//  This class is performing the query request(Zoopla API) using the parameters added by the users and fetches the results and passes them to the Results view Controller
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//
//

#import "SearchViewController.h"
#import "PropertyListing.h"
#import "ResultsViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

static NSString * const BaseURLString = @"http://api.zoopla.co.uk/api/v1/property_listings.json?";

#define Token @"s5g5evsggh64guj2u8jq5cje";


@interface SearchViewController ()

@end

@implementation SearchViewController
{
        NSMutableArray *resultsArray;
    BOOL resultsFound;
 

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Get user preference
    return NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
        resultsArray =[[NSMutableArray alloc]init];
    self.spinningWheel.hidesWhenStopped =YES;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).identifierPath != nil) {
        [self.tabBarController setSelectedIndex:1];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).identifierPath = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)jsonFetch{
    
    
//using AFNetworking 3rd party library to get results from the Zoopla API
//another way just for reference  - needs refactoring
//NSString *string = [NSString stringWithFormat:@"%@", BaseURLString];
//NSURL *url = [NSURL URLWithString:string];
//NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //Unit Testing to catch all the exceptions with different parameters
    
    
    
    NSString *postFirst, *postSecond
     ,*areaFirst,* areaSecond;
    
    
   NSString * areaString = _area.text;
    NSString *newString = [areaString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
     NSArray *areaArray = [_area.text componentsSeparatedByString:@" "];
    
        
        if ([areaArray count] >= 2)
            
        {
            areaFirst = [areaArray objectAtIndex:0];
            
            
            areaSecond = [areaArray objectAtIndex:1];
            
        }
        else{
            
            areaFirst = [_area.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            areaSecond = @"";
        }
        
        

    
    
    
    
    
    NSArray *postCode = [_postcode.text componentsSeparatedByString:@" "];
    
    
    if ([postCode count] >= 2)
        
    {
 postFirst = [postCode objectAtIndex:0];
    
    
 postSecond = [postCode objectAtIndex:1];
        
    }
    else{ postFirst = _postcode.text;
     postSecond = @"";
    }
    
   
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableString *appendString;
    
    if(![_area.text isEqualToString:@""])
        
    {
  
   appendString = [NSMutableString stringWithFormat:@"%@postcode=%@+%@&area=%@+%@&api_key=s5g5evsggh64guj2u8jq5cje&radius=%@&listing_status=rent&maximum_price=%@&minimum_beds=1&maximum_beds=%@",BaseURLString,postFirst,postSecond,areaFirst,areaSecond,_radius.text,_rent.text,_beds.text];
    }
        
    else
        
   appendString = [NSMutableString stringWithFormat:@"%@postcode=%@&area=%@&api_key=s5g5evsggh64guj2u8jq5cje&radius=%@&listing_status=rent&maximum_price=%@&minimum_beds=1&maximum_beds=%@",BaseURLString,postFirst,newString,_radius.text,_rent.text,_beds.text];
        
    
    
    @try {
        //AFNetworking GET request
        
        [manager GET:appendString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // NSLog(@"JSON: %@", responseObject);
            //  NSString *constratintsError = NSString init
            
            NSLog(@"%@",responseObject);
            
            
            NSMutableDictionary* resultsDictionary  = (NSMutableDictionary*)responseObject;
            //--was testing the commented stuff--
            // NSLog(@"%@ that is the results",resultsDictionary);
            //NSArray *keyArray =[resultsDictionary allKeys];
            //NSLog(@"%@ keys",keyArray);
            
            
            NSArray *listingDict= [resultsDictionary objectForKey:@"listing"];
            
            resultsFound = YES;
            
            [ self addToRetrivedResults:listingDict];
            
            
            
        }
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 if(error!=nil){
                   //  [self.spinningWheel stopAnimating];
                     
                     NSInteger statusErrorCode = [operation.response statusCode];
                     
                     
                     if (statusErrorCode == 400){
                         
                         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No results found" message:@"Invalid Parameters"  preferredStyle:UIAlertControllerStyleAlert];
                        
//                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:@"Invalid Parameters" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                         
//
                         
                         
                         
                         [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                             NSLog(@"test");
                             
                         }]];
                         
                         resultsFound = NO;
                         [self presentViewController:alert animated:YES completion:nil];
                         
                         // [self.spinningWheel stopAnimating];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }
                     else{
                         
                         
                         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No results found" message:@"Offline - Try Again Later"  preferredStyle:UIAlertControllerStyleAlert];
                         
                         [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                             NSLog(@"test");
                         }]];
                         
                         //deprecated in ios 9
//                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:@"Offline - Try Again Later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                         
                         
                         resultsFound = NO;
                         [self presentViewController:alert animated:YES completion:nil];
                         
  
                         // [self.spinningWheel stopAnimating];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         
                         
                       

                     }
                 }
                 
             }];
        

    }
    @catch (NSException *exception) {
        
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );

        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No results found" message:exception.reason  preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"test");
        }]];
        
     
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self presentViewController:alert animated:YES completion:nil];
        resultsFound = NO;
       //  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:exception.reason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

        // [self.spinningWheel stopAnimating];
       
        return;
        
        
    }
 
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.area resignFirstResponder];
    [self.postcode resignFirstResponder];
    [self.radius resignFirstResponder];
    [self.street resignFirstResponder];
    [self.beds resignFirstResponder];
    [self.rent resignFirstResponder];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}







-(void)addToRetrivedResults:(NSArray *)listingDict{
    
    
  

    for(NSDictionary *d in listingDict){
        
        
        PropertyListing * property =[[PropertyListing alloc]init];
        
        property.agentName = [d valueForKey:@"agent_name"];
        property.agentNumber = [d valueForKey:@"agent_phone"];
        property.fullDescription = [d valueForKey:@"description"];
        property.detailURL =[d valueForKey:@"details_url"];
        property.displayableAddress =[d valueForKey:@"displayable_address"];
        NSArray * floorPlanArray = [d objectForKey:@"floor_plan"];
        
        
        property.floorPlanURL =[floorPlanArray objectAtIndex:0];
        NSLog(@"%@ ejshfdjsncs",property.floorPlanURL);
        
        property.imageURL = [d valueForKey:@"image_url"];
        property.listingID = [d valueForKey:@"listing_id"];
        property.listingStatus =[d valueForKey:@"listing_status"];
        property.houseType = [d valueForKey:@"property_type"];
        //if i wish to add a NSDictionary property in PropertyListing class
        //to use  this code - uncomment the Dictionary property in PropertyListinh.h File
        //property.rentDictionary = [d valueForKey:@"rental_prices"];
        //NSDictionary *rentDic = property.rentDictionary ;
        NSDictionary *rentDic = [d valueForKey:@"rental_prices"];
        NSString *rentString = [NSString stringWithFormat:@"PerMonth:%@ PerWeek:%@",[rentDic valueForKey:@"per_month"],[rentDic valueForKey:@"per_week"]];
        
       //NSLog(@"rent %@",rentString);
       
        property.rentalPrice = rentString;
        property.shortDescription = [d valueForKey:@"short_description"];
        property.thumbpailImageURL =[d valueForKey:@"thumbnail_url"];

        [resultsArray addObject:property];
        property = nil;
        
    }
    
        if(resultsArray !=nil){
            
   
           ResultsViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableResults"];
         //[self.spinningWheel stopAnimating];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
          myController.tableArray = [[NSMutableArray alloc] initWithArray:resultsArray];
            [myController.tableResults reloadData];
                          [self.navigationController pushViewController: myController animated:YES];
            
            
//            [self presentViewController: myController animated:YES completion:nil];
        
          }

}








- (IBAction)searchProperties:(id)sender {
    //On button press, we will empty the previous reuslts and then will go to the json fetch method
    [resultsArray removeAllObjects];
   
    //[self.spinningWheel startAnimating];
   //Third Party Library showing progress view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
     [self jsonFetch];
    

}

//
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//      ResultsViewController * rvc=  [segue destinationViewController];
//         rvc.tableArray = [[NSMutableArray alloc] initWithArray:resultsArray];
//        [rvc.tableResults reloadData];
//  
//    
//}

@end
