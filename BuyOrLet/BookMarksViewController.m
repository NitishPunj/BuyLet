//
//  BookMarksViewController.m
//  BuyOrLet
//  SMS and Mail functionaltiy added to support Communication between buyer and seller
//  IOS 9 updated: Core Spotlight feature Added :D yoho. It works!
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import "BookMarksViewController.h"
#import "CustomCell.h"
#import "AppDelegate.h"
#import "Advert.h"
#import "UIImageView+AFNetworking.h"
#import <MessageUI/MessageUI.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>





@interface BookMarksViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>{

    NSMutableArray * bookmarkArray;
    NSMutableArray * filteredData;
    BOOL isFiltered;
   

}

@end

@implementation BookMarksViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"OpenMyViewController" object:nil];
    
}
- (void)cacheUpdated:(NSNotification *)notification {
    

    [self.bookmarksTable reloadData];

}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
[[NSNotificationCenter defaultCenter] removeObserver:self];


}


-(void)setupCoreSpotlightSearch{
//    CSSearchableItemAttributeSet *attributeSet;
//    attributeSet = [[CSSearchableItemAttributeSet alloc]
//                    initWithItemContentType:(NSString *)kUTTypeImage];
//    
//    attributeSet.title = @"BuyorLet";
//    attributeSet.contentDescription = @"Finding properties is easy";
//   // attributeSet.keywords = @[keywords];
//    
//    
//    UIImage *image = [UIImage imageNamed:@"house"];
//    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
//    attributeSet.thumbnailData = imageData;
    
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for(int i=0; i<bookmarkArray.count;i++)
        
    
    {
        Advert *tempAd = [bookmarkArray objectAtIndex:i];
        
        [mutArray addObject:tempAd];
    }
    
    NSMutableArray *arrayOfItems = [[NSMutableArray alloc] init];
    
    for(int i=0; i<mutArray.count;i++) {
        
        
         Advert *tempAd = [bookmarkArray objectAtIndex:i];
        
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString*)kUTTypeJSON];
        attributeSet.title = tempAd.agentName;
        attributeSet.contentDescription = tempAd.shortDescripton;
        
        attributeSet.keywords = @[tempAd.displayableAddress];
        
//        
//        UIImage *image = [UIImage imageNamed:@"house"];
//            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
//           attributeSet.thumbnailData = imageData;
//        
        
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:tempAd.thumpnailImageURL]];
      attributeSet.thumbnailData = imageData;
        
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:tempAd.displayableAddress domainIdentifier:@"com.iphone.app" attributeSet:attributeSet];
       
        [arrayOfItems addObject:item];
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:[arrayOfItems mutableCopy] completionHandler: ^(NSError * __nullable error) {
        NSLog(@"Spotlight Log");
    }];
    
    
//    
//    CSSearchableItem *item = [[CSSearchableItem alloc]
//                              initWithUniqueIdentifier:@"com.buylet"
//                              domainIdentifier:@"spotlight.sam"
//                              attributeSet:attributeSet];
//    
//    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item]
//                                                   completionHandler: ^(NSError * __nullable error) {
//                                                       if (!error)
//                                                           NSLog(@"Search item indexed");
//                                                   }];
//

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Advert *pL;
    
    if(isFiltered)
    { pL = [filteredData objectAtIndex:[indexPath row]];
    }
    else
        pL = [bookmarkArray objectAtIndex:[indexPath row]];
    
   NSString * stringNumber = pL.agentNumber;
    NSString * agentName = pL.agentName;
//Comment one of them out
   [self showSMS:stringNumber:agentName];
    //Issue with the email but sms works
   // [self showEmail:agentName :stringNumber];


    
}

- (void)showSMS:(NSString*)numb :(NSString*)name {
    
    if(![MFMessageComposeViewController canSendText]) {
        
        
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your device doesn't support SMS!"  preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"test11");
        }]];
        
        
       
        [self presentViewController:alert animated:YES completion:nil];

        
//        
//        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [warningAlert show];
        return;
    }
    
    NSArray *recipent =[NSArray arrayWithObject:numb];
    NSString *message = [NSString stringWithFormat:@"Hello %@", name];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipent];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}



- (void)showEmail:(NSString*)file :(NSString*)agentNumber {
    
    NSString *emailTitle = @"Property Enquiry";
    NSString *messageBody = [NSString stringWithFormat:@"Hello %@",file];
    
    NSArray *toRecipents = [NSArray arrayWithObject:@"dd@zoopla.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
       // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Advert"];
    
    [bookmarkArray removeAllObjects];
  
    
    bookmarkArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.bookmarksTable reloadData];
    [self setupCoreSpotlightSearch];


}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        
        [filteredData removeAllObjects];
        isFiltered = FALSE;
        
        
    }
    else
    {
        isFiltered = TRUE;
        filteredData = [[NSMutableArray alloc] init];
        
        for (Advert* ad in bookmarkArray)
        {
            NSRange nameRange = [ad.agentName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [ad.shortDescripton rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredData addObject:ad];
            }
        }
    }
    
    [self.bookmarksTable reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(bookmarkArray != nil)
        return 1;
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleCell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    Advert *pL;
    
    if(isFiltered)
    { pL = [filteredData objectAtIndex:[indexPath row]];
    }
    else
    pL = [bookmarkArray objectAtIndex:[indexPath row]];
    
    [cell.adentName setText:pL.agentName];
    
    [ cell.shortDescriptionLabel setText: pL.shortDescripton];
    NSString *tempTitle = [NSString stringWithFormat:@"Available for %@ %@ ",pL.listingStatus,pL.rentalPrice];
    [cell.progressIndicator startAnimating];
    
    
    [cell.priceLabel setText:tempTitle];
    NSString *strThumbnailURL = pL.thumpnailImageURL;
    
  
    if(strThumbnailURL!=nil)
    {
        NSURL *url = [NSURL URLWithString:pL.thumpnailImageURL];
        
      
          [cell.thumbnailImage setImageWithURL:url];
        
        
        
//  ------  Using AF Networking for downloading images now, but the below code can  be used instead----------------  AF networking works better as it cashes the images and make them availe in offline mode for  a time
        
        
        
//        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        //this will start the image loading in background
//        dispatch_async(concurrentQueue, ^{
//            NSURL *imageURL = [NSURL URLWithString:strThumbnailURL];
//            
//            NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
//            
//            
//            if (image !=nil){
//                
//                
//                
//                //this will set the image when loading is finished
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.thumbnailImage.image = [UIImage imageWithData:image];
//
//            }
//            else {
//              
//                    cell.thumbnailImage.image= [UIImage imageNamed:@"house.jpeg"];
//
//                    
//              
//            }
//            
//            
//        });
//        
//
//        
//        
         [cell.progressIndicator stopAnimating];
        return cell;
        
    }
    
    else {
       
            cell.thumbnailImage.image = [UIImage imageNamed:@"noimage"];
          
        
            
        
        
        [cell.progressIndicator stopAnimating];
        
        return cell;
        
        
    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete object from database
        
            
             [context deleteObject:[bookmarkArray objectAtIndex:indexPath.row]];
        
             NSError *error = nil;
             if (![context save:&error])
             {
             NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
              return;
             }
         
             else{ // Remove from table view
             [bookmarkArray removeObjectAtIndex:indexPath.row];
             [self.bookmarksTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  
             }
      
        
        
        
    }
    
    
        
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete\nBookmark";
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
if(isFiltered)
    return NO;
    
   else
    return YES;
    
   
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    
    
    if(isFiltered)
        
        return [filteredData count];
    else
    return [bookmarkArray count];
}



- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"  message:@"Failed to send SMS!"  preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"test11");
            }]];
              [self presentViewController:alert animated:YES completion:nil];
            
//            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
