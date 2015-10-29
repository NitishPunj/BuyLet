//coreData class for PropertyListings
//  Advert.h
//  BuyOrLet
//
//  Created by TAE on 15/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface Advert : NSManagedObject

@property (nonatomic, retain) NSString * agentName;
@property (nonatomic, retain) NSString * agentNumber;
@property (nonatomic, retain) NSString * fullDescription;
@property (nonatomic, retain) NSString * displayableAddress;
@property (nonatomic, retain) NSString * floorPlanURL;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * listingID;
@property (nonatomic, retain) NSString * listingStatus;
@property (nonatomic, retain) NSString * houseType;
@property (nonatomic, retain) NSString * rentalPrice;
@property (nonatomic, retain) NSString * shortDescripton;
@property (nonatomic, retain) NSString * thumpnailImageURL;
@property (nonatomic, retain) NSString * detailURL;
@property (nonatomic, retain) NSSet *userComment;
@end

@interface Advert (CoreDataGeneratedAccessors)

- (void)addUserCommentObject:(Comment *)value;
- (void)removeUserCommentObject:(Comment *)value;
- (void)addUserComment:(NSSet *)values;
- (void)removeUserComment:(NSSet *)values;

@end
