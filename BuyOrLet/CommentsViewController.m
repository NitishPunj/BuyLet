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
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Make sure you call super first
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        self.editButtonItem.title = NSLocalizedString(@"Cancel", @"Cancel");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
    }
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
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
    
    Comment *comObject = [commentsArray objectAtIndex:indexPath.row];
    NSNumber *temp = comObject.userID;
    NSLog(@"%@",temp);
    
    
    [self deleteComment:(NSNumber*)temp :(NSIndexPath *)indexPath];
   
    
    
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete\nComment";
}



-(void)LoadJson{
//USING GET TO Fetch JSON DATA FROM THE WEBSERVICE
     [commentsArray removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
NSString* urlGetAll = [NSString stringWithFormat:@"%@/items.json",URL];
     [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-CM-Authorization"];
    
    [manager GET:urlGetAll parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // pass the response dictionary to the refine function
   [self refineCommentsForTableView:responseObject];
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

[MBProgressHUD hideHUDForView:self.view animated:YES];

}


-(void)refineCommentsForTableView:(NSArray *)responseObject{
//Logic to match the Listing Id with the cell for row from the parent View controller
    
    
    
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
    
   //  NSLog(@"%lu",(unsigned long)[commentsArray count]);

}


-(void)editComment{
    
//use PUT
//once sucessfully reload with added comment

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
    
    NSDictionary *parameters = @{
        @"item": @{
            @"name": commentText.text,
              @"category": listingCategoryString,
              
        }
        };
    
    
    [manager POST:urlGetAll parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // pass the response dictionary to the refine function
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
