//
//  PhrasesMainViewController.h
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 01/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistenceManager.h"
#import "PhraseCardController.h"

@interface PhrasesMainViewController : UIViewController <PhraseCardDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, weak) IBOutlet UIButton *addCard;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

// data management
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
// search
@property (nonatomic, strong) NSFetchedResultsController *searchFetchedResultsController;
@property (nonatomic, strong) UISearchDisplayController *searchController;

- (IBAction)addCard:(id)sender;
@end
