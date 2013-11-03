//
//  PhraseCardController.m
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 03/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//

#import "Common.h"
#import "PhraseCardController.h"

@interface PhraseCardController ()

@end

@implementation PhraseCardController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.phraseText = @"";
        self.translationText = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TRC_ENTRY
    [UIUtils setBackgroundImage:self.view image:@"background"];
    // text field left padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 14)];
    self.phraseTextField.leftView = paddingView;
    self.phraseTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phraseTextField.backgroundColor = RGB(255, 228, 196);
    
    self.translationTextView.backgroundColor = RGB(255, 228, 196);
    self.translationTextView.text = self.translationText;
    self.phraseTextField.text = self.phraseText;
    
    [self.phraseTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    TRC_ENTRY
}

- (void)viewDidAppear:(BOOL)animated
{
    TRC_ENTRY
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPhrase:(Phrase *)phrase
{
    self.phrase = phrase;
    self.phraseText = [NSString stringWithString:phrase.phrase];
    self.translationText = [NSString stringWithString:phrase.translation];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate phraseCancel:self];
}
- (IBAction)done:(id)sender
{
    [self.delegate phraseSave:self];
}

@end
