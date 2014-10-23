//
//  DataModel.h
//  Checklists


#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(nonatomic,strong)NSMutableArray *lists;

-(void)saveChecklists;

-(NSInteger)indexOfSelectedChecklist;

-(void)setIndexOfSelectedChecklist:(NSInteger)index;

-(void)sortChecklists;


@end
