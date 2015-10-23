//
//  Comment.h
//  BuyOrLet
//
//  Created by TAE on 21/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Advert;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * commentText;
@property (nonatomic, retain) NSString * listingID;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) Advert *userComment;

@end
