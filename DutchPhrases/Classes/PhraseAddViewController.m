//
//  PhraseAddViewController.m
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 01/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//
#import "Common.h"
#import "PhraseAddViewController.h"

@interface PhraseAddViewController ()

@end

@implementation PhraseAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIUtils setBackgroundImage:self.view image:@"background"];
    // text field left padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 14)];
    self.phraseTextField.leftView = paddingView;
    self.phraseTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phraseTextField.backgroundColor = RGB(255, 228, 196);
    
    self.translationTextView.backgroundColor = RGB(255, 228, 196);
    self.translationTextView.text = @"";
    
    [self.phraseTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
