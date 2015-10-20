//
//  CommentsViewController.h
//  BuyOrLet
//
//  Created by TAE on 19/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
@property (strong, nonatomic) IBOutlet UITextField *commentText;
- (IBAction)post:(id)sender;

@end
