//
//  PhraseCardController.h
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 03/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Phrase.h"

@class PhraseCardController;

@protocol PhraseCardDelegate <NSObject>
- (void)phraseSave:(PhraseCardController *)controller;
- (void)phraseCancel:(PhraseCardController *)controller;
@end

@interface PhraseCardController : UIViewController

@property (nonatomic, strong) NSString *phraseText;
@property (nonatomic, strong) NSString *translationText;

@property (nonatomic, weak) IBOutlet UITextField *phraseTextField;
@property (nonatomic, weak) IBOutlet UITextView *translationTextView;
@property (nonatomic, assign) Phrase *phrase;

@property (nonatomic, weak) id <PhraseCardDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


-(void)initPhrase:(Phrase *)phrase;
@end
