//
//  CommentsViewController.m
//  BuyOrLet
//
//  Created by TAE on 19/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//Third Party Libraries  used : AFNetworking and MBProgressHUD

#import "CommentsViewController.h"
#import "Comment.h"
#import "CustomCell.h"
#import "MBProgressHUD.h"

#define URL @"https://cmshopper.herokuapp.com"
#define Token @"c0e3ec60745ed3f45376d5801b6d4088"



@interface CommentsViewController ()

{

    NSMutableArray * commentsArray;
    NSNumber * commentIDfor;
    NSIndexPath * indexForUpdate;
    
}


@end


@implementation CommentsViewController

@ synthesize commentText,listingCategoryString;




- (void)viewDidLoad {
    [super viewDidLoad];
    [commentsArray removeAllObjects];
   // NSLog(@"%@",listingCategoryString);
    
    commentsArray = [[NSMutableArray alloc]init];
    
    [self LoadJson];
  //   self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



//The below code I ADDED TO ENABLE OR DISABLE EDITITNG but then I thought, I do not need it at the moment, So it is JUST HERE TO BE USED IN THE FUTURE
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    // Make sure you call super first
//    [super setEditing:editing animated:animated];
//    
//    if (editing)
//    {
//        self.editButtonItem.title = NSLocalizedString(@"Cancel", @"Cancel");
//    }
//    else
//    {
//        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
//    }
//}

//  How to use ??
//- (BOOL)textFieldShouldClear:(UITextField *)textField {
//    return YES;
//}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // For some reason the tableview does not do it automatically
    [self.commentsTable deselectRowAtIndexPath:self.commentsTable.indexPathForSelectedRow
                                     animated:YES];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.backgroundColor = [UIColor grayColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.commentsTable addSubview:refreshControl];
    

    
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {

    
    [self.commentsTable reloadData];
    
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



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
   
        return 1;
 
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
     NSLog(@"%lu",(unsigned long)[commentsArray count]);
    return [commentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleCell";
    UITableViewCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];

    }
    
    Comment *tempobject = [commentsArray objectAtIndex:indexPath.row];

    [cell.detailTextLabel setText:tempobject.commentText];
    NSLog(@"%@",tempobject.commentText);
    
    
    return cell;
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
   }


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        Comment *comObject = [commentsArray objectAtIndex:indexPath.row];
        NSNumber *temp = comObject.userID;
        NSLog(@"%@",temp);
        
        [self deleteComment:(NSNumber*)temp :(NSIndexPath *)indexPath];
        

    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // It has to do with the edit button on tableview
        //this will be passed on to the edit button function
        Comment *comObject = [commentsArray objectAtIndex:indexPath.row];
       // NSNumber *temp = comObject.userID;
        [self.baseView setHidden:YES];
        
//        
//        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//            self.editCommentView.backgroundColor = [UIColor clearColor];
//            
//            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//            blurEffectView.frame = self.view.bounds;
//            blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//            
//            [self.editCommentView addSubview:blurEffectView];
//        }  
//        else {
//            self.editCommentView.backgroundColor = [UIColor blackColor];
//        }
        self.editTextbox.text = comObject.commentText;
       
        
        commentIDfor = comObject.userID;
        indexForUpdate = indexPath;
        
        [self.editCommentView setHidden:NO];


    }];
    editAction.backgroundColor = [UIColor orangeColor];
    
    return @[deleteAction, editAction];
}


//changed the default Title
//This code is not in use at the moment
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"Delete\nComment";
//}



-(void)LoadJson{
//USING GET TO Fetch JSON DATA FROM THE WEBSERVICE USING AF Networking
     [commentsArray removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
NSString* urlGetAll = [NSString stringWithFormat:@"%@/items.json",URL];
     [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-CM-Authorization"];
    
    
    @try {
    
    [manager GET:urlGetAll parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // pass the response dictionary to the refine function
   [self refineCommentsForTableView:responseObject];
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(error!=nil){
            //  [self.spinningWheel stopAnimating];
            
            NSInteger statusErrorCode = [operation.response statusCode];
            
            
            if (statusErrorCode == 400){
                
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No results found" message:@"Invalid Parameters"  preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"test11");
                }]];
                
                
                
                [self presentViewController:alert animated:YES completion:nil];
                

                
                
//                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:@"Invalid Parameters" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                
//                
//               
//                [alert show];
//                
                // [self.spinningWheel stopAnimating];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            else{
                
                
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No results found" message:@"Offline - Try Again Later"  preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSLog(@"test15");
                }]];
                
                
                
                [self presentViewController:alert animated:YES completion:nil];
                

                
                
                
                
                
//                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:@"Offline - Try Again Later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
              
            }
        }
        
    }];

        
    }
        
    @catch (NSException *exception){
    
        
        
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"No results found" message:exception.reason  preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"test15");
        }]];
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        
        [self presentViewController:alert animated:YES completion:nil];
        
        

        
        
        
        
        
//        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No results founds" message:exception.reason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        
        
        
        //[alert show];
        

      
    
    }
        
        
}


-(void)refineCommentsForTableView:(NSArray *)responseObject{
//Logic to match the Listing Id with the cell for row from the Resuts View controller
    
    
    
    for (NSDictionary * dict in responseObject)
    {
        NSString *tempString = [dict objectForKey:@"category"];

        if([tempString isEqualToString:listingCategoryString])
        {
        
            // using the addToCommentAray method,which will add the dict "commentArray"
            
            [ self addToCommentArray:dict];
            
            
          //  NSLog(@"test to check if dict has anything in it %@",dict);
            
        
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.commentsTable reloadData];
    
}



//Going to use the Comment.h
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)addToCommentArray:(NSDictionary*)dict
{
    
  //Not saving into Core data but just using a subclass of NSManagedObject Comment.h to save data into the array afterwards
    
    NSEntityDescription *mytempEntity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:[self managedObjectContext]];
    
    Comment *addComment = [[Comment alloc] initWithEntity:mytempEntity insertIntoManagedObjectContext:nil];

    
    addComment.listingID = [dict objectForKey:@"category"];
    NSString * dateString =[dict objectForKey:@"updated_at"];
    addComment.dateAdded = dateString;
    
    addComment.commentText = [dict objectForKey:@"name"];
    
    //addComment.userID =[dict objectForKey:@"id"];
    
    NSInteger idComment = [[dict objectForKey:@"id"]integerValue];
    
     addComment.userID =@(idComment);
    NSLog(@"%@",addComment.userID);
    
   [ commentsArray addObject:addComment];
    
  

}




- (IBAction)updateButton:(id)sender {
    
    [self putWebServiceForEditComment:commentIDfor :indexForUpdate];
    
}

-(void)putWebServiceForEditComment:(NSNumber*)temp :(NSIndexPath *)indexPath{

    
    
    NSInteger idComment = [temp integerValue];
    NSLog(@"%ld",idComment);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
  NSString* urlGetAll = [NSString stringWithFormat:@"%@/items/%ld.json",URL,idComment];
    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-CM-Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Sending the parameters dictionary to our POST request with the format specified on our web service
    
    NSDictionary *parameters = @{
                                 @"item": @{
                                         @"name": _editTextbox.text,
                                         @"category": listingCategoryString,
                                         
                                         }
                                 };
    
    
    [manager PUT :urlGetAll parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // Pass the response dictionary to the Method below
        
       
        [self updateCommentArrayAtIndex:responseObject :indexPath];
        
         [self.editCommentView setHidden:YES];
        [self.baseView setHidden:NO];
        
       // [_commentsTable reloadData];
        
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.commentsTable beginUpdates];
        [self.commentsTable reloadRowsAtIndexPaths:@[indexForUpdate] withRowAnimation:UITableViewRowAnimationRight];
        [self.commentsTable endUpdates];
        

        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
         [self.editCommentView setHidden:YES];
        [self.baseView setHidden:NO];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.commentsTable beginUpdates];
        [self.commentsTable reloadRowsAtIndexPaths:@[indexForUpdate] withRowAnimation:UITableViewRowAnimationLeft];
        [self.commentsTable endUpdates];
        

        
    }];
    


}


-(void)updateCommentArrayAtIndex:(NSDictionary *)dictComment :(NSIndexPath*)indexPath{
    
    //Not saving into Core data but just using a subclass of NSManagedObject Comment.h to save data into the array afterwards
    
    NSEntityDescription *mytempEntity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:[self managedObjectContext]];
    
    Comment *addComment = [[Comment alloc] initWithEntity:mytempEntity insertIntoManagedObjectContext:nil];
    
    
    addComment.listingID = [dictComment objectForKey:@"category"];
    NSString * dateString =[dictComment objectForKey:@"updated_at"];
    addComment.dateAdded = dateString;
    
    addComment.commentText = [dictComment objectForKey:@"name"];
    
    //addComment.userID =[dictComment objectForKey:@"id"];
    
    NSInteger idComment = [[dictComment objectForKey:@"id"]integerValue];
    addComment.userID =@(idComment);
    NSLog(@"%@",addComment.userID);
    
    
    [self.commentsTable beginUpdates];

[commentsArray replaceObjectAtIndex:indexPath.row withObject:addComment];
    
     [self.commentsTable endUpdates];
    
    
}




-(void)deleteComment:(NSNumber*)temp :(NSIndexPath *)indexPath {
// using DELETE of AFNetworking
    

    NSInteger idComment = [temp integerValue];
    NSLog(@"%ld",idComment);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString* urlGetAll = [NSString stringWithFormat:@"%@/items/%ld.json",URL,idComment];
    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-CM-Authorization"];
    
    
    
    
    
    
    [manager DELETE:urlGetAll parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);

        NSLog(@"Delete Successfull ");
        //If delete ha been successful we will reload the table by fetching the json again: temprorary for testing (Full proof)
        //OR I am  going to reload table only by deleting the row at index path (Almost full proof)
        
        [commentsArray removeObjectAtIndex:indexPath.row];
        [self.commentsTable reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:Deleting Comment %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}



- (IBAction)post:(id)sender {
    
   // Method on Button Post to Add comment
  //  Using POST of AFNetworking
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

     NSString* urlGetAll = [NSString stringWithFormat:@"%@/items.json",URL];
    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-CM-Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Sending the parameters dictionary to our POST request with the format specified on our web service
    
    NSDictionary *parameters = @{
        @"item": @{
            @"name": commentText.text,
              @"category": listingCategoryString,
              
        }
        };
    
    
    [manager POST:urlGetAll parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // Pass the response dictionary to the addNewCommentRoTableView Method
        [self addNewCommentToTableView:responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
    }];
    
    
    
}




-(void)addNewCommentToTableView:(NSDictionary *)responseObject{
    
    
// On Post comment: After successfully receicving the response object, I add it to "addToCommentArray" array and reload my commentsTable
    
    
    [self addToCommentArray:responseObject];
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   [self.commentsTable reloadData];
    
    //scrolling to tthe bottom of the table where the new comment gets added
    
    CGFloat height = self.commentsTable.contentSize.height - self.commentsTable.bounds.size.height;
    [self.commentsTable setContentOffset:CGPointMake(0, height) animated:YES];
    
    

}
 



- (IBAction)cancelEditButton:(id)sender {
    [self.editCommentView setHidden:YES];
    [self.baseView setHidden:NO];
    
    [self.commentsTable beginUpdates];
    [self.commentsTable reloadRowsAtIndexPaths:@[indexForUpdate] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.commentsTable endUpdates];

    
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
