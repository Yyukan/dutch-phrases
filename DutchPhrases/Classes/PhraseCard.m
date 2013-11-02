//
//  PhraseCard.m
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 02/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//
#import "Common.h"
#import "PhraseCard.h"

@implementation PhraseCard

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib{
    self.mainView.layer.cornerRadius = 5;
    self.mainView.layer.masksToBounds = YES;
    self.mainView.backgroundColor = RGB(255, 228, 196);
    self.topView.backgroundColor = RGB(255, 228, 196	);
    self.buttomView.backgroundColor = RGB(218, 80, 40);
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [UIView new];
    self.selectedBackgroundView = [UIView new];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
