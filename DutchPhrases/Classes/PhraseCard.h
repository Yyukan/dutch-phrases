//
//  PhraseCard.h
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 02/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhraseCard : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UILabel *phraseLabel;
@property (weak, nonatomic) IBOutlet UILabel *topWord;
@property (weak, nonatomic) IBOutlet UITextView *translationText;

@end
