//
//  SearchViewController.m
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import "SearchViewController.h"
#import "PropertyListing.h"
#import "ResultsViewController.h"
#import "AppDelegate.h"

static NSString * const BaseURLString = @"http://api.zoopla.co.uk/api/v1/property_listings.json?";

#define Token @"s5g5evsggh64guj2u8jq5cje";


@interface SearchViewController ()

@end

@implementation SearchViewController
{
        NSMutableArray *resultsArray;
    BOOL resultsFound;
 

}

//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
        resultsArray =[[NSMutableArray alloc]init];
    self.spinningWheel.hidesWhenStopped =YES;
    
    
    
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
  
    
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableString *appendString = [NSMutableString stringWithFormat:@"%@area=%@&api_key=s5g5evsggh64guj2u8jq5cje&radius=1&listing_status=rent&maximum_price=2000&minimum_beds=1&maximum_beds=2",BaseURLString,_area.text];
    
    
    @try {
        
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
                     [self.spinningWheel stopAnimating];
                     
                     NSInteger statusErrorCode = [operation.response statusCode];
                     
                     
                     if (statusErrorCode == 400){
                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:@"Invalid Parameters" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         
                         
                         resultsFound = NO;
                         [alert show];
                         
                          [self.spinningWheel stopAnimating];
                     }
                     else{
                         
                         
                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:@"Offline - Try Again Later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         
                         
                         resultsFound = NO;
                         [alert show];
                         
                          [self.spinningWheel stopAnimating];
                     }
                 }
                 
             }];
        

    }
    @catch (NSException *exception) {
        
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:exception.reason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        
        resultsFound = NO;
        [alert show];

         [self.spinningWheel stopAnimating];
        return;
        
        
    }
 
    
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
         [self.spinningWheel stopAnimating];
            
          myController.tableArray = [[NSMutableArray alloc] initWithArray:resultsArray];
           // [myController.tableResults reloadData];
                          [self.navigationController pushViewController: myController animated:YES];
        
          }

}





- (IBAction)searchProperties:(id)sender {
    //On button press, we will empty the previos reuslts and then will go to the json fetch method
    [resultsArray removeAllObjects];
    [self.spinningWheel startAnimating];
    
     [self jsonFetch];
    /*
     if internet{
     delete all data from core data
     fetch data from webservices

     
     [resultsArray removeAllObjects];
     [self.spinningWheel startAnimating];
     
     [self jsonFetch];
     }
     else{
     connect to core data
     get all data 
     add to array
     send array to next table view controller
     }
     */
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
