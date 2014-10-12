//
//  TaskDetailViewController.m
//  Checklists
//
//  Created by Xiaonan Wang on 10/2/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "TaskDetailViewController.h"

@interface TaskDetailViewController () <CKCalendarDelegate>

@property(nonatomic, strong) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic) BOOL calendarFlag;//calendar是否显示的flag

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.checklistToEdit != nil) {
        self.title = @"编辑任务";
        
        //checklist数据放入各个文本框
        self.taskName.text = self.checklistToEdit.name;
        self.taskTaker.text = self.checklistToEdit.taskTaker;
        self.dateField.text = self.checklistToEdit.deadLineDate;
        self.hour.text = self.checklistToEdit.deadLineHour;
        self.minute.text = self.checklistToEdit.deadLineMinute;
        self.taskDescription.text = self.checklistToEdit.taskDescription;
        self.doneBarButton.enabled = YES;
    }
    self.calendarFlag = NO;
    
    //textview加边框
    self.taskDescription.layer.borderColor = [[UIColor grayColor]CGColor];
    self.taskDescription.layer.borderWidth = 0.4;
}

//触摸关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//添加任务打开时的firstResponder
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    [self.taskName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  部件
//日历-----------------------------------
-(void)calendarView{
    self.calendar = [[CKCalendarView alloc] init];
    [self.view addSubview:self.calendar];
    self.calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    self.calendar.frame = CGRectMake(self.view.frame.size.width/2-150,self.calendarButton.frame.origin.y + self.calendarButton.frame.size.height, 300, 320);
    [self.view addSubview:self.calendar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (IBAction)setDate:(id)sender {
    //日历未打开时，打开日历，并关闭键盘
    if (self.calendarFlag == NO) {
        [self calendarView];
        [self.view endEditing:YES];
        self.calendarFlag = YES;
    }else{//日历打开时，关闭日历
        [self.calendar setHidden:YES];
        self.calendarFlag = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateField.text = [self.dateFormatter stringFromDate:date];
    [self.calendar setHidden:YES];
}
//----------------------------------------------------

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //获取新的文本内容
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //判断是否为空，根据属性开启或禁止done按钮
    if([newText length] >0){
        self.doneBarButton.enabled = YES;
    }else{
        self.doneBarButton.enabled = NO;
    }
    return YES;
}


#pragma mark - Navigation bar
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)cancel{
    [self.delegate TaskDetailViewControllerDidCancel:self];
}

//done时，checklist获取数据
- (IBAction)done{
    if (self.checklistToEdit == nil) {
        
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.taskName.text;
        checklist.taskTaker = self.taskTaker.text;
        checklist.taskDescription = self.taskDescription.text;
        checklist.deadLineDate = self.dateField.text;
        checklist.deadLineHour = self.hour.text;
        checklist.deadLineMinute = self.minute.text;
        
        [self.delegate TaskDetailViewController:self didFinishAddingChecklist:checklist];
        
    } else {
        self.checklistToEdit.name = self.taskName.text;
        self.checklistToEdit.taskTaker = self.taskTaker.text;
        self.checklistToEdit.taskDescription = self.taskDescription.text;
        self.checklistToEdit.deadLineDate = self.dateField.text;
        self.checklistToEdit.deadLineHour = self.hour.text;
        self.checklistToEdit.deadLineMinute = self.minute.text;
        [self.delegate TaskDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}



@end
