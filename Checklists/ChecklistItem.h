//
//  ChecklistItem.h
//  Checklists
//  检查点 model


#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject <NSCoding>



@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *checkPointDate;
@property (nonatomic, copy) NSString *checkPointHour;
@property (nonatomic, copy) NSString *checkPointMinute;
@property (nonatomic, copy) NSDate *checkPoint;
@property (nonatomic, assign) BOOL checked;



- (void)toggleChecked;

@end
