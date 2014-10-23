//
//  ChecklistsViewController.m
//  Checklists


#import "ChecklistViewController.h"
#import "ChecklistItem.h"
#import "Checklist.h"

@interface ChecklistViewController ()

@end

@implementation ChecklistViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.checklist.name;
    NSIndexPath *iP = [NSIndexPath indexPathForRow:0 inSection:0];
    ChecklistItem *oclItem = self.checklist.items[iP.row];
    self.checklist.closestCheckPoint = oclItem.checkPoint;
    self.taskTaker.text = self.checklist.taskTaker;
    self.taskDescription.text = self.checklist.taskDescription;
    self.deadLine.text = [NSString stringWithFormat:@"%@, %@:%@", self.checklist.deadLineDate, self.checklist.deadLineHour, self.checklist.deadLineMinute];
    [self.checklist sortChecklistItems];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  return [_items count];
    return [self.checklist.items count];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
  UILabel *label = (UILabel *)[cell viewWithTag:1001];

  if (item.checked) {
    label.text = @"√";
  } else {
    label.text = @"";
  }
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
//  ChecklistItem *item = _items[indexPath.row];
    ChecklistItem *item = self.checklist.items[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = item.text;
    
    NSString *dateString = [self.dateFormatter stringFromDate:item.checkPoint];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dateString];
    //cell.detailTextLabel.text = item.text;
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

//  ChecklistItem *item = _items[indexPath.row];
    ChecklistItem *item = self.checklist.items[indexPath.row];
  [item toggleChecked];

  [self configureCheckmarkForCell:cell withChecklistItem:item];

//  [self saveChecklistItems];

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//  [_items removeObjectAtIndex:indexPath.row];
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
//  [self saveChecklistItems];

    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark delegate

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item
{
    
//  NSInteger newRowIndex = [_items count];
    NSInteger newRowIndex = [self.checklist.items count];
    
    [self.checklist.items addObject:item];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.checklist sortChecklistItems];
    [self.tableView reloadData];

//  [self saveChecklistItems];
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item
{
    [self.checklist sortChecklistItems];
    [self.tableView reloadData];
//  NSInteger index = [_items indexOfObject:item];
    NSInteger index = [self.checklist.items indexOfObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0]    ;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];

//  [self saveChecklistItems];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.taskToEdit = self.checklist;
  } else if ([segue.identifier isEqualToString:@"EditItem"]) {
      UINavigationController *navigationController = segue.destinationViewController;
      ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
      controller.delegate = self;
      controller.taskToEdit = self.checklist;
      NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
      //controller.itemToEdit = _items[indexPath.row];
      controller.itemToEdit = self.checklist.items[indexPath.row];
      
  }
}

@end
