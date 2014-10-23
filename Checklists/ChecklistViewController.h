//
//  ChecklistsViewController.h
//  Checklists
//  检查点列表view controller


#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class Checklist;

@interface ChecklistViewController : UITableViewController <ItemDetailViewControllerDelegate>

@property (nonatomic, strong) Checklist *checklist;
@property (weak, nonatomic) IBOutlet UILabel *taskTaker;
@property (weak, nonatomic) IBOutlet UILabel *deadLine;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;


@end
