//
//  PhraseAddViewController.h
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 01/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhraseAddViewController;

@protocol PhraseAddDelegate <NSObject>
- (void)phraseSave:(PhraseAddViewController *)controller;
- (void)phraseCancel:(PhraseAddViewController *)controller;
@end

@interface PhraseAddViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *phraseTextField;
@property (nonatomic, weak) IBOutlet UITextView *translationTextView;
@property (nonatomic, weak) id <PhraseAddDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
