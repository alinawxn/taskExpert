//
//  Checklist.h
//  Checklists
//  任务 model


#import <Foundation/Foundation.h>

@interface Checklist : NSObject<NSCoding>

//任务名
@property (nonatomic, copy) NSString *name;
//交付时间
@property (nonatomic, copy) NSString *deadLineDate;
@property (nonatomic, copy) NSString *deadLineHour;
@property (nonatomic, copy) NSString *deadLineMinute;
//执行人
@property (nonatomic, copy) NSString *taskTaker;
//任务描述
@property (nonatomic, copy) NSString *taskDescription;
//检查点列表
@property(nonatomic,strong) NSMutableArray *items;
@property(nonatomic, copy) NSDate *deadLine;
@property(nonatomic, copy) NSDate * closestCheckPoint;

@property(nonatomic,copy)NSString *iconName;


-(void)sortChecklistItems;
-(int)countUncheckedItems;

@end
