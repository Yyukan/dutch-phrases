//
//  PhrasesMainViewController.m
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 01/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//
#import "Common.h"
#import "PhrasesMainViewController.h"

@interface PhrasesMainViewController ()

@end

@implementation PhrasesMainViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue activity

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PhraseAdd"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        PhraseAddViewController *controller = [navigationController viewControllers][0];
        controller.delegate = self;
    }
}

#pragma mark - PhraseAddDelegate

- (void)phraseSave:(PhraseAddViewController *)controller
{
    TRC_ENTRY
    [self dismissViewControllerAnimated:YES completion:nil];
    
    TRC_DBG(@"Phrase %@", controller.phraseTextField.text);
    TRC_DBG(@"Translation %@", controller.translationTextView.text)
}

- (void)phraseCancel:(PhraseAddViewController *)controller
{
    TRC_ENTRY
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
