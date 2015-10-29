//
//  PropertyListing.h
//  BuyOrLet
//  Property listing Class used to serve as my userdefiend data type for storing the adverts fetched from the Zoopla Api
//  Created by TAE on 08/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <Foundation/Foundation.h>
//below properties used for storing and presenting the fetched information from Zoopla API
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
