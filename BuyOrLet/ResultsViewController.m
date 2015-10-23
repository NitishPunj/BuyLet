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
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(_tableArray != nil)
    return 1;
    else{
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Ambiguous data" message:@"Please be more precise" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [view show];

    return  0;
    }
    
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
            cell.thumbnailImage.image = [UIImage imageWithData:image];
            //reload will display the images
            [self.tableResults reloadData];
        });
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.thumbnailImage.image = [UIImage imageNamed:@"house.jpeg"];
                //reload will display the images
                [self.tableResults reloadData];
                
            });
        
        }
        
        
    });
        
        [cell.progressIndicator stopAnimating];
       
        

    return cell;
    
    }
    
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.thumbnailImage.image = [UIImage imageNamed:@"house"];
            //reload will display the images
            [self.tableResults reloadData];
            
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [_tableResults reloadData];
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
        
        NSLog(@"%@ this listing id",item.listingID);
        
        NSLog(@"%@ this listing id",item.listingID);
        

    
    DetailViewController *viewController = [segue destinationViewController];
    viewController.item = item;
        
    }
    
        
}


- (void)didTapButton:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
    UIButton *button = (UIButton *)sender;
    
    // Find Point in Superview
    // Not very efficient to use so  I used [button.tag]
    //    CGPoint pointInSuperview = [button.superview convertPoint:button.center toView:self.tableResults];
    //
    //    // Infer Index Path
    //    NSIndexPath *indexPath = [self.tableResults indexPathForRowAtPoint:pointInSuperview];
    //    PropertyListing *item = self.tableArray[indexPath.row];
    //
    
  PropertyListing *   item = self.tableArray[button.tag];
    
    
    NSLog(@"%@ this listing id",item.listingID);
    
    NSLog(@"%@ this listing id",item.listingID);
    
    NSLog(@"%ld this listing id",(long)button.tag);
    
    
    
    CommentsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsTable"];
    
    viewController.listingCategoryString = item.listingID;
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
    
}





@end
