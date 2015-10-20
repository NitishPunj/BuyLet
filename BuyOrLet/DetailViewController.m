//
//  DetailViewController.m
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define mainQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.spinner startAnimating];
    // Do any additional setup after loading the view.
   [ self downloadAndDisplayImage];
    [self showText];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:longPress];
  
    
}

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
       
        
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
         [self addToBookmarks];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)downloadAndDisplayImage{
    [self.spinner startAnimating];
  //Testing the floor plan URL
    // NSString *str = self.item.floorPlanURL;
//NSLog(@"Getting %@...", self.item.floorPlanURL);
    NSString *str = self.item.imageURL;
       if(str!=nil){
      

           
           
           
   NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
           
   // using #import "UIImageView+AFNetworking.h" to download image and cache it
           
           
      [self.imageHouse setImageWithURLRequest:url placeholderImage:[UIImage imageNamed:@"house"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
          
          [self.imageHouse setImage:image];
          [self.spinner stopAnimating];

          
          
       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
           NSLog(@"Request failed with error: %@", error);
            self.imageHouse.image = [UIImage imageNamed:@"noimage.jpeg"];
           
           [self.spinner stopAnimating];

                  }];
    
           
           //   Was taking longer to download images so used the above code instead
//
//    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:url];
//    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
//    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//       // NSLog(@"Response: %@", responseObject);
//        self.imageHouse.image = responseObject;
//        [self.spinner stopAnimating];
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Image error: %@", error);
//         NSLog(@"Url Error- %@", url);
//         self.imageHouse.image = [UIImage imageNamed:@"noimage.jpeg"];
//        [self.spinner stopAnimating];
//        
//
//    }];
//    
//
//    [requestOperation start];
           
          
    
    }
else
{
    
    self.imageHouse.image = [UIImage imageNamed:@"noimage.jpeg"];
    
    [self.spinner stopAnimating];


}
    }

-(void)showText{

    self.detailDesciption.text = self.item.fullDescription;
    
}


-(void)callOrSendEmail{



}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (void)addToBookmarks {
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newBookmark = [NSEntityDescription insertNewObjectForEntityForName:@"Advert" inManagedObjectContext:context];
    
    [newBookmark setValue:self.item.agentName forKey:@"agentName"];
    [newBookmark setValue:self.item.agentNumber forKey:@"agentNumber"];
    [newBookmark setValue:self.item.detailURL forKey:@"detailURL"];
    [newBookmark setValue:self.item.displayableAddress forKey:@"displayableAddress"];
    [newBookmark setValue:self.item.floorPlanURL forKey:@"floorPlanURL"];
    [newBookmark setValue:self.item.fullDescription forKey:@"fullDescription"];
    [newBookmark setValue:self.item.houseType forKey:@"houseType"];
    [newBookmark setValue:self.item.imageURL forKey:@"imageURL"];
    [newBookmark setValue:self.item.listingID forKey:@"listingID"];
    [newBookmark setValue:self.item.listingStatus forKey:@"listingStatus"];
    [newBookmark setValue:self.item.rentalPrice forKey:@"rentalPrice"];
    [newBookmark setValue:self.item.shortDescription forKey:@"shortDescripton"];
    [newBookmark setValue:self.item.thumbpailImageURL forKey:@"thumpnailImageURL"];
    
     
    NSError *error = nil;
    
    if (![context save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:[NSString stringWithFormat:@"Bookmark cannot be added%@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        NSLog(@"Context Saved");
        
    }

}
@end
