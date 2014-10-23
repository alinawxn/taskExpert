//
//  AddItemViewController.h
//  Checklists
//  添加检查点/编辑检查点 view controller


#import <UIKit/UIKit.h>
#import "Checklist.h"
#import "CKCalendarView.h"

@class ItemDetailViewController;
@class ChecklistItem;

@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item;

@end

@interface ItemDetailViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <ItemDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) ChecklistItem *itemToEdit;
@property (nonatomic, strong) Checklist *taskToEdit;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *checkPointDate;
@property (weak, nonatomic) IBOutlet UITextField *hour;
@property (weak, nonatomic) IBOutlet UITextField *minute;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;


- (IBAction)cancel;
- (IBAction)done;
- (IBAction)setDate:(id)sender;
- (IBAction)HourEndEditing:(id)sender;
- (IBAction)MinuteEndEditing:(id)sender;

@end
