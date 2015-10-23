//
//  CustomCell.m
//  BuyOrLet
//
//  Created by TAE on 08/10/2015.
//  Copyright (c) 2015 TAE. All rights reserved.
//

#import "CustomCell.h"
//@interface CustomCell()
//@property (copy, nonatomic) void (^didTapButtonBlock)(id sender);
//@end

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
    
    
//     [self.actionbutton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)didTapButton:(id)sender {
//    if (self.didTapButtonBlock) {
//        self.didTapButtonBlock(sender);
//    }
//}



@end
