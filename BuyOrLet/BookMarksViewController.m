//
//  BookMarksViewController.m
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import "BookMarksViewController.h"
#import "CustomCell.h"
#import "AppDelegate.h"
#import "Advert.h"
#import "UIImageView+AFNetworking.h"


@interface BookMarksViewController (){

    NSMutableArray * bookmarkArray;
    NSMutableArray * filteredData;
    BOOL isFiltered;
   

}

@end

@implementation BookMarksViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [self.bookmarksTable reloadData];
    // Do any additional setup after loading the view.
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Advert"];
    
    [bookmarkArray removeAllObjects];
  
    
    bookmarkArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.bookmarksTable reloadData];

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
    
    
    [ cell.shortDescriptionLabel setText: pL.shortDescripton];
    NSString *tempTitle = [NSString stringWithFormat:@"Available for %@ %@ ",pL.listingStatus,pL.rentalPrice];
    [cell.progressIndicator startAnimating];
    
    
    [cell.priceLabel setText:tempTitle];
    NSString *strThumbnailURL = pL.thumpnailImageURL;
    
  
    if(strThumbnailURL!=nil)
    {
        NSURL *url = [NSURL URLWithString:pL.thumpnailImageURL];
        
      
          [cell.thumbnailImage setImageWithURL:url];
        
        
        
//  ------  Using AF Networking for downloading images now, but the below code can  be used instead----------------
        
        
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
