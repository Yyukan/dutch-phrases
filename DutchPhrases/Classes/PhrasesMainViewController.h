//
//  PhrasesMainViewController.h
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 01/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistenceManager.h"
#import "PhraseAddViewController.h"

@interface PhrasesMainViewController : UIViewController <PhraseAddDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

// data management
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end
