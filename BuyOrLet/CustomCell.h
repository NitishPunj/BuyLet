//
//  CustomCell.h
//  BuyOrLet
//
//  Created by TAE on 08/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UILabel *shortDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;



@end
