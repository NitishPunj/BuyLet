//
//  CommentsViewController.h
//  BuyOrLet
//
//  Created by TAE on 19/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNEtworking.h>



@interface CommentsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
@property (strong, nonatomic) IBOutlet UITextField *commentText;
- (IBAction)post:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *editCommentView;
@property (strong, nonatomic) IBOutlet UITextView *editTextbox;
- (IBAction)updateButton:(id)sender;
- (IBAction)cancelEditButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *baseView;

@property(strong,nonatomic)   NSString *listingCategoryString;

@end
