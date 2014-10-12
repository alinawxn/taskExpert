//
//  ChecklistsViewController.h
//  Checklists
//  检查点列表view controller
//  Created by Matthijs on 30-09-13.
//  Copyright (c) 2013 Happy Bubsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class Checklist;

@interface ChecklistViewController : UITableViewController <ItemDetailViewControllerDelegate>

@property (nonatomic, strong) Checklist *checklist;
@property (weak, nonatomic) IBOutlet UILabel *taskTaker;
@property (weak, nonatomic) IBOutlet UILabel *deadLine;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;

@end
