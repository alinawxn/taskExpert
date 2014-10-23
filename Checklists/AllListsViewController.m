//
//  AllListsViewController.m
//  Checklists


#import "AllListsViewController.h"
#import "Checklist.h"
#import "ChecklistViewController.h"

#import "ChecklistItem.h"

#import "DataModel.h"

@interface AllListsViewController ()

@end

@implementation AllListsViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark view

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    self.navigationController.delegate = self;
    
    NSInteger index = [self.dataModel indexOfSelectedChecklist];
    
    if(index >=0 && index <[self.dataModel.lists count]){
        
        Checklist *checklist = self.dataModel.lists[index];
        
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }
}

#pragma mark - UINavigationController delegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(viewController ==self){
        
        [self.dataModel setIndexOfSelectedChecklist:-1];
        [self.dataModel sortChecklists];
        [self.tableView reloadData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModel.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    Checklist *checklist = self.dataModel.lists[indexPath.row];
    
    cell.textLabel.text = checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dl = [dateFormatter stringFromDate:checklist.deadLine];
    
    int count = [checklist countUncheckedItems];
    if([checklist.items count]==1){
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"任务结点：%@",dl];
    }else if(count ==0){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"任务完成"];
    }else{
        NSIndexPath *iP = [NSIndexPath indexPathForRow:0 inSection:0] ;
        ChecklistItem *clItem = checklist.items[iP.row];
        NSString *cp = [dateFormatter stringFromDate:clItem.checkPoint];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"下一个检查点：%@",cp];
    }
    
    cell.imageView.image = [UIImage imageNamed:checklist.iconName];
    
    
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];
    Checklist *checklist = self.dataModel.lists[indexPath.row];

  [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.dataModel.lists removeObjectAtIndex:indexPath.row];

  NSArray *indexPaths = @[indexPath];
  [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
    ChecklistViewController *controller = segue.destinationViewController;
    controller.checklist = sender;
  } else if ([segue.identifier isEqualToString:@"AddChecklist"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    TaskDetailViewController *controller = (TaskDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    controller.checklistToEdit = nil;
  }
}

//taskdetail 界面 cancel事件代理
- (void)TaskDetailViewControllerDidCancel:(TaskDetailViewController *)controller
{
    [self.dataModel sortChecklists];
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)TaskDetailViewController:(TaskDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist
{
    [self.dataModel.lists addObject:checklist];
    
    ChecklistItem *item = [[ChecklistItem alloc] init];
    item.text = @"任务结点";
    item.checkPointDate = checklist.deadLineDate;
    item.checkPointHour = checklist.deadLineHour;
    item.checkPointMinute = checklist.deadLineMinute;
    item.checked = NO;
    item.checkPoint = [self dateString:item.checkPointDate hourString:item.checkPointHour minuteString:item.checkPointMinute];
    [checklist.items addObject:item];
    
    [self.dataModel sortChecklists];

    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)TaskDetailViewController:(TaskDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist
{
    
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];

    TaskDetailViewController *controller = (TaskDetailViewController *)navigationController.topViewController;
    controller.delegate = self;

    Checklist *checklist = self.dataModel.lists[indexPath.row];
    controller.checklistToEdit = checklist;

    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - other functions
-(NSDate *)dateString:(NSString *)date hourString:(NSString *)hour minuteString:(NSString *)minute{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateShort = [dateFormatter dateFromString:date];
    NSLog(@"HERE");
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateShort];
    NSLog(@"HERE2");
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.year = components.year;
    comps.month = components.month;
    comps.day = components.day;
    comps.hour = [hour integerValue];
    comps.minute = [minute integerValue];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDate *fullVersionDate = [calendar dateFromComponents:comps];
    return fullVersionDate;
}


@end
