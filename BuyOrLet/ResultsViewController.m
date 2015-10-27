//
//  ResultsViewController.m
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import "ResultsViewController.h"
#import "PropertyListing.h"
#import "CustomCell.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CommentsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableResults addSubview:refreshControl];

}


- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self.tableResults reloadData];
    
    
    if(refreshControl){
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    
    [refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(_tableArray != nil)
    
    {

            
         if([_tableArray count] < 1)
             
             
            {
                
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableResults.bounds.size.width, self.tableResults.bounds.size.height)];
                
                messageLabel.text = @"Ambiguition in Area field.  Please try using postcode only";
                messageLabel.textColor = [UIColor blackColor];
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
                [messageLabel sizeToFit];
                
                self.tableResults.backgroundView = messageLabel;
                self.tableResults.separatorStyle = UITableViewCellSeparatorStyleNone;
                
    
                
                return 0;
                
            }
        
        
        else
        return 1;
    }
    
    return 0;
    
    
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_tableArray count];
}

//-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//       
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleCell";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    PropertyListing *pL = [_tableArray objectAtIndex:[indexPath row]];
    
   [ cell.shortDescriptionLabel setText: pL.shortDescription];
    NSString *tempTitle = [NSString stringWithFormat:@"Available for %@ %@ ",pL.listingStatus,pL.rentalPrice];
  [cell.progressIndicator startAnimating];
    
    
    [cell.priceLabel setText:tempTitle];
    [cell.actionbutton setTag:indexPath.row];
     [cell.actionbutton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *strThumbnailURL = pL.thumbpailImageURL;
    if(strThumbnailURL!=nil)
    {
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in background
    dispatch_async(concurrentQueue, ^{
        NSURL *imageURL = [NSURL URLWithString:strThumbnailURL];
        
        NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
        
        
        if (image !=nil){
            
           
            
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            //testing with begin updates for a cell at row instead of reloading the whole table
          //  [self.tableResults beginUpdates];
            cell.thumbnailImage.image = [UIImage imageWithData:image];
           // [self.tableResults endUpdates];
            
        });
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
       
            cell.thumbnailImage.image = [UIImage imageNamed:@"house.jpeg"];
                
       

            });
        
        }
        
        
    });
        
        [cell.progressIndicator stopAnimating];
       
        

    return cell;
    
    }
    
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
     
            cell.thumbnailImage.image = [UIImage imageNamed:@"house"];
                   
        });
        
        [cell.progressIndicator stopAnimating];
        
        return cell;

    
    }

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_tableArray removeObjectAtIndex:indexPath.row];
        
        

           [self.tableResults beginUpdates];

        
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
      //    just for future use to be used, as it will reload a prticular row rather than reloading the whole table
//        [self.tableResults reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//        
        

        
        
          [self.tableResults endUpdates];

       // [_tableResults reloadData]; no need to reload whole table
    }

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // For some reason the tableview does not do it automatically
    [self.tableResults deselectRowAtIndexPath:self.tableResults.indexPathForSelectedRow
                                  animated:YES];
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    
    
}



 //Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"DetailSegue"])
    {
     NSIndexPath *indexPath = [self.tableResults indexPathForSelectedRow];
   
    PropertyListing *item = self.tableArray[indexPath.row];
      
    
    DetailViewController *viewController = [segue destinationViewController];
    viewController.item = item;
        
    }
    
        
}


- (void)didTapButton:(id)sender {
       
    UIButton *button = (UIButton *)sender;
    
    // Find Point in Superview
    //    CGPoint pointInSuperview = [button.superview convertPoint:button.center toView:self.tableResults];
    //
    //    // Infer Index Path
    //    NSIndexPath *indexPath = [self.tableResults indexPathForRowAtPoint:pointInSuperview];
    //    PropertyListing *item = self.tableArray[indexPath.row];
    
    
    // In the above code: Not that level of precision required so  I used [button.tag] instead : cell for row at index path method assigns a tab to every button which is used in this methood to get the property Listing ID which is passed to the Comments View Controller

    
  PropertyListing *   item = self.tableArray[button.tag];
//    
//    
//    NSLog(@"%@ this listing id",item.listingID);
//    
//    NSLog(@"%@ this listing id",item.listingID);
//    
//    NSLog(@"%ld this listing id",(long)button.tag);
//    
    
    
    CommentsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsTable"];
    
    viewController.listingCategoryString = item.listingID;
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
    
}





@end
