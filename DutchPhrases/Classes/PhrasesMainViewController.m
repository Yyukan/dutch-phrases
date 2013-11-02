//
//  PhrasesMainViewController.m
//  DutchPhrases
//
//  Created by Oleksandr Shtykhno on 01/11/2013.
//  Copyright (c) 2013 Oleksandr Shtykhno. All rights reserved.
//
#import "Common.h"
#import "PhrasesMainViewController.h"
#import "Phrase.h"
#import "PhraseCard.h"

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

- (void)loadView {
    [super loadView];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // change search bar text color
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    [UIUtils setBackgroundImage:self.view image:@"background"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhraseCard" bundle:nil] forCellReuseIdentifier:@"PhraseCard"];

    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    [UIUtils setBackgroundImage:self.searchDisplayController.searchResultsTableView image:@"background"];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"PhraseCard" bundle:nil] forCellReuseIdentifier:@"PhraseCard"];

    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self fetchedResultControllerInitialLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    _searchFetchedResultsController.delegate = nil;
    _searchFetchedResultsController = nil;
    _managedObjectContext = nil;
}

#pragma mark - Managed object context

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    self.managedObjectContext = [[PersistenceManager sharedPersistenceManager] managedObjectContext];
    return _managedObjectContext;
}

#pragma mark - Fetch controller and delegate 

- (void)fetchedResultControllerInitialLoad
{
    if (!_fetchedResultsController)
    {
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error])
        {
            // Update to handle the error appropriately.
            NSLog(@"Error while initial loading of data %@, %@", error, [error userInfo]);
            exit(EXIT_FAILURE);
        }
        
        TRC_DBG(@"Fetched [%i] items", _fetchedResultsController.fetchedObjects.count);
    }
}

- (NSFetchedResultsController *)fetchedResultsControllerWithSearch:(NSString *)searchString
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];

    NSSortDescriptor *orderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"phrase" ascending:YES];

    NSPredicate *filterPredicate = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Phrase" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];

    NSMutableArray *predicateArray = [NSMutableArray array];
    if (searchString.length)
    {
        [predicateArray addObject:[NSPredicate predicateWithFormat:@"phrase CONTAINS[cd] %@", searchString]];
        if(filterPredicate)
        {
            filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:filterPredicate, [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray], nil]];
        }
        else
        {
            filterPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
        }
    }
    [fetchRequest setPredicate:filterPredicate];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:orderDescriptor, nil]];

    
	NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    resultsController.delegate = self;
    
    NSError *error = nil;
    if (![resultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return resultsController;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [self fetchedResultsControllerWithSearch:nil];
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)searchFetchedResultsController
{
    if (_searchFetchedResultsController != nil)
    {
        return _searchFetchedResultsController;
    }
    _searchFetchedResultsController = [self fetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
    return _searchFetchedResultsController;
}

- (UITableView *)tableViewForController:(NSFetchedResultsController *)controller {
    return controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    return tableView == self.tableView ? self.fetchedResultsController : self.searchFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    TRC_DBG(@"Before update [%i] entites", controller.fetchedObjects.count);
    
    [[self tableViewForController:controller]  beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	UITableView *tableView = [self tableViewForController:controller];
    
	switch(type)
    {
		case NSFetchedResultsChangeInsert:
            TRC_DBG(@"INSERT");
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			TRC_DBG(@"DELETE");
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
		case NSFetchedResultsChangeUpdate:
            TRC_DBG(@"UPDATE");
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:NO];
			break;
			
		case NSFetchedResultsChangeMove:
            TRC_DBG(@"MOVE");
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = [self tableViewForController:controller];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableViewForController:controller] endUpdates];
    
    TRC_DBG(@"After update [%i] entities", controller.fetchedObjects.count);
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
    TRC_DBG(@"Phrase %@", controller.phraseTextField.text);
    TRC_DBG(@"Translation %@", controller.translationTextView.text)
    
    // create managed entity
    Phrase *phrase = [NSEntityDescription insertNewObjectForEntityForName:@"Phrase" inManagedObjectContext:self.managedObjectContext];
    phrase.phrase = controller.phraseTextField.text;
    phrase.translation = controller.translationTextView.text;
    
    // save managed context when insert new record
    [[PersistenceManager sharedPersistenceManager] saveManagedContext];
    TRC_DBG(@"Phrase [%@] has been saved...", controller.phraseTextField.text);
}

- (void)phraseCancel:(PhraseAddViewController *)controller
{
    TRC_ENTRY
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self fetchedResultsControllerForTableView:tableView].fetchedObjects.count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    TRC_ENTRY
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhraseCard";
    
    PhraseCard *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[PhraseCard alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
    
    Phrase *phrase = (Phrase *)[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    
    [cell.translationText setText: phrase.translation];
    [cell.phraseLabel setText:phrase.phrase];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Phrase *phrase = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];

        [self.managedObjectContext deleteObject:phrase];
        [[PersistenceManager sharedPersistenceManager] saveManagedContext];
        TRC_DBG(@"Removed phrase [%@]", phrase.phrase);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

#pragma mark - Search Bar

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    // if you care about the scope save off the index to be used by the serchFetchedResultsController
    //self.savedScopeButtonIndex = scope;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView;
{
    TRC_ENTRY
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    TRC_ENTRY
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    TRC_ENTRY
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    TRC_DBG(@"Text %@", searchText)
}

@end
