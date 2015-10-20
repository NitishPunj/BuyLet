//
//  ResultsViewController.h
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"


@interface ResultsViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray* tableArray;
@property (strong, nonatomic) IBOutlet UITableView *tableResults;


@end
