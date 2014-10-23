//
//  AllListsViewController.h
//  Checklists
//  任务列表view controller


#import <UIKit/UIKit.h>
#import "TaskDetailViewController.h"

@class DataModel;

@interface AllListsViewController : UITableViewController <TaskDetailViewControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic,strong)DataModel *dataModel;


@end
