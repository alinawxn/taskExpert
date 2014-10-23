//
//  Checklist.m
//  Checklists


#import "Checklist.h"
#import "ChecklistItem.h"

@implementation Checklist


//count

-(int)countUncheckedItems{
    
    int count = 0;
    for(ChecklistItem *item in self.items){
        if(!item.checked){
            count+=1;
        }
    }
    return count;
    
}

-(id)init{
    
    if((self = [super init])){
        self.items = [[NSMutableArray alloc]initWithCapacity:20];
        self.iconName = @"Appointments";
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if((self =[super init])){
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.deadLineDate = [aDecoder decodeObjectForKey:@"DeadLineDate"];
        self.deadLineHour = [aDecoder decodeObjectForKey:@"DeadLineHour"];
        self.deadLineMinute = [aDecoder decodeObjectForKey:@"DeadLineMinute"];
        self.taskTaker = [aDecoder decodeObjectForKey:@"TaskTaker"];
        self.taskDescription = [aDecoder decodeObjectForKey:@"TaskDescription"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
        self.deadLine = [aDecoder decodeObjectForKey:@"DeadLine"];
        self.closestCheckPoint = [aDecoder decodeObjectForKey:@"ClosestCheckPoint"];
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.deadLineDate forKey:@"DeadLineDate"];
    [aCoder encodeObject:self.deadLineHour forKey:@"DeadLineHour"];
    [aCoder encodeObject:self.deadLineMinute forKey:@"DeadLineMinute"];
    [aCoder encodeObject:self.taskTaker forKey:@"TaskTaker"];
    [aCoder encodeObject:self.taskDescription forKey:@"TaskDescription"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
    [aCoder encodeObject:self.deadLine forKey:@"DeadLine"];
    [aCoder encodeObject:self.closestCheckPoint forKey:@"ClosestCheckPoint"];
}


-(NSComparisonResult)compare:(Checklist*)otherChecklist{
    return [self.closestCheckPoint compare:otherChecklist.closestCheckPoint];
}

-(void)sortChecklistItems{
    
    [self.items sortUsingSelector:@selector(compare:)];
    
}



@end
