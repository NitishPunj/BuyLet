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

@end
