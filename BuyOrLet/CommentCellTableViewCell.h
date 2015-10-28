//
//  CommentCellTableViewCell.h
//  BuyOrLet
//
//  Created by TAE on 28/10/2015.
//  Copyright © 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UITextView *commentText;
@property (strong, nonatomic) IBOutlet UILabel *dateAdded;
@end
