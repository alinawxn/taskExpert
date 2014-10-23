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
@property(nonatomic, strong) NSDate *selectedDate;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic) BOOL dateFlag, hourFlag, minuteFlag;
@property(nonatomic) BOOL calendarFlag;//calendar是否显示的flag

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.checklistToEdit != nil) {
        self.title = @"编辑任务";
        
        //checklist数据放入各个文本框
        self.dateFlag = true;
        self.minuteFlag = true;
        self.hourFlag = true;
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
    self.calendarFlag = NO;
    self.selectedDate = date;
    [self DateEndEditing];
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
    
    
    //判断是否有格子未填
    if([self.taskName.text  isEqual: @""] || [self.taskTaker.text  isEqual: @""] || [self.dateField.text  isEqual: @""] || [self.hour.text  isEqual: @""] || [self.minute.text  isEqual: @""] || [self.taskDescription.text  isEqual: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请填写全部信息" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }else if(!self.dateFlag || !self.hourFlag || !self.minuteFlag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请填写正确信息" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }else{
        if (self.checklistToEdit == nil) {
            
            Checklist *checklist = [[Checklist alloc] init];
            checklist.name = self.taskName.text;
            checklist.taskTaker = self.taskTaker.text;
            checklist.taskDescription = self.taskDescription.text;
            checklist.deadLineDate = self.dateField.text;
            checklist.deadLineHour = self.hour.text;
            checklist.deadLineMinute = self.minute.text;
            checklist.deadLine = [self date:self.selectedDate hourString:self.hour.text minuteString:self.minute.text];
            checklist.closestCheckPoint = checklist.deadLine;
            [self.delegate TaskDetailViewController:self didFinishAddingChecklist:checklist];
            
        } else {
            self.checklistToEdit.name = self.taskName.text;
            self.checklistToEdit.taskTaker = self.taskTaker.text;
            self.checklistToEdit.taskDescription = self.taskDescription.text;
            self.checklistToEdit.deadLineDate = self.dateField.text;
            self.checklistToEdit.deadLineHour = self.hour.text;
            self.checklistToEdit.deadLineMinute = self.minute.text;
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
            NSDate *dateT = [self.dateFormatter dateFromString:self.dateField.text];
            self.checklistToEdit.deadLine = [self date:dateT hourString:self.hour.text minuteString:self.minute.text];
            NSIndexPath *iP = [NSIndexPath indexPathForRow:0 inSection:0];
            ChecklistItem *oclItem = self.checklistToEdit.items[iP.row];
            self.checklistToEdit.closestCheckPoint = oclItem.checkPoint;
            
            [self.delegate TaskDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
        }
    }
}

#pragma mark - didEndEditingTests
//Date
- (IBAction)DateEndEditing{
    NSDate *todayDate = [NSDate date];
    
    //today比选定时间晚
    if ([todayDate compare:self.selectedDate] == NSOrderedDescending) {
        self.dateField.layer.borderWidth = 1;
        self.dateField.layer.borderColor = [[UIColor redColor] CGColor];
        self.dateFlag = NO;
    }else{//today比选定时间早
        self.dateField.layer.borderWidth = 0;
        self.dateFlag = YES;
    }
}

- (IBAction)HourEndEditing:(id)sender {
    int hourInt = [self.hour.text intValue];
    if (![self.hour.text isEqual:@"0"]&&![self.hour.text isEqual: @"00"]&&hourInt == 0) {
        hourInt = 1000;
    }
    if (hourInt<0 || hourInt >= 24) {
        self.hour.layer.borderColor = [[UIColor redColor] CGColor];
        self.hour.layer.borderWidth = 1;
        self.hourFlag = NO;
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请填写合理时间（00~24）" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        //[alert show];
    }else{
        self.hour.layer.borderWidth = 0;
        self.hourFlag = YES;
    }
}

- (IBAction)MinuteEndEditing:(id)sender {
    int minuteInt = [self.minute.text intValue];
    if ((![self.minute.text isEqual:@"0"]||![self.minute.text isEqual: @"00"])&&minuteInt == 0) {
        minuteInt = 1000;
    }
    if (minuteInt<0 || minuteInt >= 59) {
        self.minute.layer.borderColor = [[UIColor redColor] CGColor];
        self.minute.layer.borderWidth = 1;
        self.minuteFlag = NO;
    }else{
        self.minute.layer.borderWidth = 0;
        self.minuteFlag = YES;
    }
}

#pragma mark - other functions
-(NSDate *)date:(NSDate *)date hourString:(NSString *)hour minuteString:(NSString *)minute{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
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
