//
//  ChecklistItem.m
//  Checklists


#import "ChecklistItem.h"

@implementation ChecklistItem



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checkPointDate = [aDecoder decodeObjectForKey:@"CheckPointDate"];
        self.checkPointHour = [aDecoder decodeObjectForKey:@"CheckPointHour"];
        self.checkPointMinute = [aDecoder decodeObjectForKey:@"CheckPointMinute"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.checkPoint = [aDecoder decodeObjectForKey:@"CheckPoint"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeObject:self.checkPointDate forKey:@"CheckPointDate"];
    [aCoder encodeObject:self.checkPointHour forKey:@"CheckPointHour"];
    [aCoder encodeObject:self.checkPointMinute forKey:@"CheckPointMinute"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.checkPoint forKey:@"CheckPoint"];
}

- (void)toggleChecked
{
    self.checked = !self.checked;
}

-(NSComparisonResult)compare:(ChecklistItem*)otherChecklistItem{
    return [self.checkPoint compare:otherChecklistItem.checkPoint];
}

@end
