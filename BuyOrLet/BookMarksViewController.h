//
//  BookMarksViewController.h
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookMarksViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *bookmarksTable;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBookmarks;

@end
