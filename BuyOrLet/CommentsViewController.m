//
// -------- CommentsViewController.m-----------------
//------------CommentsViewController impletemts ControllerViewController.h-------------
//  BuyOrLet
//
//  Created by TAE on 19/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.



/*CommentsViewController impletemts ControllerViewController.h
 This class contains a tableview which displays all the comments that corresond to a particular ListingID(Zoopla API)
 Custom cell used for the tableview which is an object of class CommentCellTableViewCell.h
  Third Party Libraries  used : AFNetworking and MBProgressHUD
 
 //By default editcommentView is hidden as it will only be shown when user wants to edit a comment.

 
 
*/



#import "CommentsViewController.h"
#import "Comment.h"
#import "CustomCell.h"
#import "MBProgressHUD.h"
#import "CommentCellTableViewCell.h"

#define URL @"https://cmshopper.herokuapp.com"
#define Token @"c0e3ec60745ed3f45376d5801b6d4088"



@interface CommentsViewController ()

{

    NSMutableArray * commentsArray;   // commentsArray contains an array of the Comment.h class objects.
    NSNumber * commentIDfor;
    NSIndexPath * indexForUpdate;
    NSString *username;
    
}


@end


@implementation CommentsViewController

@ synthesize commentText,listingCategoryString;

//By default editcommentView is hidden as it will only be shown when user wants to edit a comment.



- (void)viewDidLoad {
    [super viewDidLoad];
       //testing only
    //-------empty all previous objects from the commentsArray----------
//     [commentsArray count];
//    [commentsArray removeAllObjects];
//   // NSLog(@"%@",listingCategoryString);
    
    commentsArray = [[NSMutableArray alloc]init];
    //taking the username from the settings bundle and would show it in each comment added by the user.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults stringForKey:@"username_preference"];
    [self LoadJson];
 
}



//-------------The below code I ADDED TO ENABLE OR DISABLE EDITITNG but then I thought, I do not need it at the moment, So it is JUST HERE TO BE USED IN THE FUTURE---------------------




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
    //UIrefreshcontrol Added as a subview to our table view incase the user wants to reload the comments from the JSON Webservice manually again.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    refreshControl.backgroundColor = [UIColor grayColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    //refresh method will be called when we intiate a refresh control
    
    refreshControl.layer.zPosition = -1;
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

//---- used to resign the keyboard on touch on the view---------

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.commentText resignFirstResponder];
    [self.editTextbox resignFirstResponder];
    
}

//SearchViewcontroller implements UITextfieldDelegate and thus this method will be called to resign the keyboard on return from the commentText UItextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//SearchViewcontroller implements UITextViewDelegate and thus this method will be called to resign the keyboard on return from the editTextBox (UItextview
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
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
    
    static NSString *simpleTableIdentifier = @"SimpleCommentCell";
    //customcellClass: CommentCellTableViewCell used for the commentCell
    
    CommentCellTableViewCell *cell = (CommentCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    Comment *tempobject = [commentsArray objectAtIndex:indexPath.row];
 
    [cell.username setText:username];
    
    [cell.commentText setText:tempobject.commentText];
   //Testing: NSLog(@"%@",tempobject.dateAdded);
    
    
    [cell.dateAdded setText:tempobject.dateAdded];
    
    
    return cell;
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
   }
//Implementation for the Edit and Delete button on the cell
//

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        Comment *comObject = [commentsArray objectAtIndex:indexPath.row];
        NSNumber *temp = comObject.userID;
       // NSLog(@"%@",temp);
        
        [self deleteComment:(NSNumber*)temp :(NSIndexPath *)indexPath];
        

    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // It has to do with the edit button on tableview
        //this will be passed on to the edit button function
        Comment *comObject = [commentsArray objectAtIndex:indexPath.row];
       // NSNumber *temp = comObject.userID;
        
        //once user presses on the dit button we will hide the baseview and pass the appopriate user comment text to the editTextbox.
       // and then show the editCommentView
        
        [self.baseView setHidden:YES];
        
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
    
    //scrolling to the bottom of the table where the new comment gets added
    
    CGFloat height = self.commentsTable.contentSize.height - self.commentsTable.bounds.size.height;
    [self.commentsTable setContentOffset:CGPointMake(0, height) animated:YES];
    
    

}
 



- (IBAction)cancelEditButton:(id)sender {
    
    //if user cancels out of the ediditng then we only reload the specific row using the indexForUpdate(NSIndexPath*) array.
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
