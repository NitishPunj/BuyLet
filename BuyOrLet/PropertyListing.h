//
//  PropertyListing.h
//  BuyOrLet
//
//  Created by TAE on 08/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyListing : NSObject
@property (strong,nonatomic) NSString * agentName;
@property (strong,nonatomic) NSString * agentNumber;
@property (strong,nonatomic) NSString * fullDescription;
@property (strong,nonatomic) NSString * detailURL;
@property (strong,nonatomic) NSString * displayableAddress;
@property (strong,nonatomic) NSString * floorPlanURL;
@property (strong,nonatomic) NSString * imageURL;
@property (strong,nonatomic) NSString * listingID;
@property (strong,nonatomic) NSString * listingStatus;
@property (strong,nonatomic) NSString * houseType;
@property (strong,nonatomic) NSString * rentalPrice;
@property (strong,nonatomic) NSString * shortDescription;
@property (strong,nonatomic) NSString * thumbpailImageURL;
//@property (strong,nonatomic) NSDictionary * rentDictionary;
/*
 
 
 @property (nonatomic, retain) NSString * agentName;
 @property (nonatomic, retain) NSNumber * agentNumber;
 @property (nonatomic, retain) NSString * fullDescription;
 @property (nonatomic, retain) NSString * displayableAddress;
 @property (nonatomic, retain) NSString * floorPlanURL;
 @property (nonatomic, retain) NSString * imageURL;
 @property (nonatomic, retain) NSNumber * listingID;
 @property (nonatomic, retain) NSString * listingStatus;
 @property (nonatomic, retain) NSString * houseType;
 @property (nonatomic, retain) NSString * rentalPrice;
 @property (nonatomic, retain) NSString * shortDescripton;
 @property (nonatomic, retain) NSString * thumpnailImageURL;
 @property (nonatomic, retain) NSString * detailURL;
 @property (nonatomic, retain) NSSet *userComment;
 @end
 
 */

@end
