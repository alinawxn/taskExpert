//
//  AllListsViewController.h
//  Checklists
//  任务列表view controller
//  Created by Matthijs on 12-24-13.
//  Copyright (c) 2013 Happy Bubsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailViewController.h"

@class DataModel;

@interface AllListsViewController : UITableViewController <TaskDetailViewControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic,strong)DataModel *dataModel;


@end
