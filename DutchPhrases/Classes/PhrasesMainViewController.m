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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // initial data load
    [self fetchedResultControllerInitialLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Phrase" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor *orderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"phrase" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:orderDescriptor, nil]];
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"domain == %@ AND status == %@", self.domain, STATUS_OCCUPATION_NORMAL]];

	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	
    self.fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
	
	return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    TRC_DBG(@"Before update [%i] entites", controller.fetchedObjects.count);
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	UITableView *tableView = self.tableView;
    
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    
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
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhraseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Phrase *phrase = (Phrase *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.detailTextLabel setText: phrase.translation];
    [cell.textLabel setText:phrase.phrase];
    
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
        Phrase *phrase = [self.fetchedResultsController objectAtIndexPath:indexPath];

        [self.managedObjectContext deleteObject:phrase];
        [[PersistenceManager sharedPersistenceManager] saveManagedContext];
        TRC_DBG(@"Removed phrase [%@]", phrase.phrase);
    }
}
@end
