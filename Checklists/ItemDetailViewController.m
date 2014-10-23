//
//  AddItemViewController.m
//  Checklists


#import "ItemDetailViewController.h"
#import "ChecklistItem.h"

@interface ItemDetailViewController () <CKCalendarDelegate>
@property(nonatomic, strong) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *selectedDate;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic) BOOL dateFlag, hourFlag, minuteFlag, hourLaterFlag, minuteLaterFlag, dateLaterFlag;
@property(nonatomic) BOOL calendarFlag;//calendar是否显示的flag
@end

@implementation ItemDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.itemToEdit != nil) {
        self.dateFlag = YES;
        self.hourFlag = YES;
        self.minuteFlag = YES;
        self.title = @"编辑检查点";
        self.textField.text = self.itemToEdit.text;
        self.checkPointDate.text = self.itemToEdit.checkPointDate;
        self.hour.text = self.itemToEdit.checkPointHour;
        self.minute.text = self.itemToEdit.checkPointMinute;
        self.doneBarButton.enabled = YES;
        self.calendarFlag = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel
{
  [self.delegate itemDetailViewControllerDidCancel:self];
}

- (IBAction)done
{
    if (!self.dateFlag || !self.hourFlag || !self.minuteFlag) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请填写正确信息" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }else if([self checkpointLaterThanDeadling]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"检查点时间不得晚于任务提交时间" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }else {
        if (self.itemToEdit == nil) {
            ChecklistItem *item = [[ChecklistItem alloc] init];
            item.text = self.textField.text;
            item.checkPointDate = self.checkPointDate.text;
            item.checkPointHour = self.hour.text;
            item.checkPointMinute = self.minute.text;
            item.checked = NO;
            item.checkPoint = [self dateString:self.checkPointDate.text hourString:self.hour.text minuteString:self.minute.text];
            [self.delegate itemDetailViewController:self didFinishAddingItem:item];
        } else {
            self.itemToEdit.text = self.textField.text;
            self.itemToEdit.checkPointDate = self.checkPointDate.text;
            self.itemToEdit.checkPointHour = self.hour.text;
            self.itemToEdit.checkPointMinute = self.minute.text;
            self.itemToEdit.checkPoint = [self dateString:self.checkPointDate.text hourString:self.hour.text minuteString:self.minute.text];
            [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
        }
    }
}

#pragma mark - calendar
//日历-----------------------------------
-(void)calendarView{
    self.calendar = [[CKCalendarView alloc] init];
    [self.view addSubview:self.calendar];
    self.calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [NSDate date];
    
    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    self.calendar.frame = CGRectMake(self.view.frame.size.width/2-150,self.calendarButton.frame.origin.y + self.calendarButton.frame.size.height, 300, 320);
    [self.view addSubview:self.calendar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
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
    self.selectedDate = date;
    self.checkPointDate.text = [self.dateFormatter stringFromDate:date];
    [self.calendar setHidden:YES];
    self.calendarFlag = NO;
    [self DateEndEditing];
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
//----------------------------------------------------
#pragma mark - algorithm
-(BOOL)checkpointLaterThanDeadling{
    NSDate *deadLineDate = [self.dateFormatter dateFromString:self.taskToEdit.deadLineDate];
    int deadlineMinute = [self.taskToEdit.deadLineMinute intValue];
    int deadlineHour = [self.taskToEdit.deadLineHour intValue];
    int hourInt = [self.hour.text intValue];
    if (![self.hour.text isEqual:@"0"]&&![self.hour.text isEqual: @"00"]&& hourInt == 0) {
        hourInt = 1000;
    }
    int minuteInt = [self.minute.text intValue];
    if ((![self.minute.text isEqual:@"0"]||![self.minute.text isEqual: @"00"])&&minuteInt == 0) {
        minuteInt = 1000;
    }
    
    if([deadLineDate compare:self.selectedDate] == NSOrderedDescending){
        return NO;
    }else if([deadLineDate compare:self.selectedDate] == NSOrderedSame && deadlineHour > hourInt){
        return NO;
    }else if([deadLineDate compare:self.selectedDate] == NSOrderedSame && deadlineHour == hourInt && deadlineMinute > minuteInt){
        return NO;
    }else{
        return YES;
    }

}


//----------------------------------------------------
#pragma mark - didEndEditingTests
- (IBAction)HourEndEditing:(id)sender {
    int hourInt = [self.hour.text intValue];
    if (![self.hour.text isEqual:@"0"]&&![self.hour.text isEqual: @"00"]&& hourInt == 0) {
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

- (IBAction)DateEndEditing{
    NSDate *todayDate = [NSDate date];
    //today比选定时间晚
    if ([todayDate compare:self.selectedDate] == NSOrderedDescending) {
        self.checkPointDate.layer.borderWidth = 1;
        self.checkPointDate.layer.borderColor = [[UIColor redColor] CGColor];
        self.dateFlag = NO;
    }else{//today比选定时间早
        self.checkPointDate.layer.borderWidth = 0;
        self.dateFlag = YES;
    }
}

#pragma mark - tableview
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  return nil;
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
	return YES;
}

#pragma mark - other functions
-(NSDate *)dateString:(NSString *)date hourString:(NSString *)hour minuteString:(NSString *)minute{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateShort = [self.dateFormatter dateFromString:date];
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


