//
//  DetailViewController.h
//  BuyOrLet
//
//  Created by TAE on 05/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyListing.h"
#import "AppDelegate.h"

@interface DetailViewController : UIViewController<UIScrollViewDelegate>

@property(strong,nonatomic) PropertyListing *item;
@property (weak
           , nonatomic) IBOutlet UIImageView *imageHouse;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) IBOutlet UITextView *detailDesciption;


@property (strong,nonatomic) NSManagedObjectContext *context;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;


@end
