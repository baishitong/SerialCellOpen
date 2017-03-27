//
//  FBTCellModel.m
//  SerialCellOpen
//
//  Created by zsw on 2017/3/17.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "FBTCellModel.h"

@implementation FBTCellModel
- (instancetype)sendModelData:(NSDictionary *)dic{
    
    if (self == [super init]) {
        
        self.EditCheckID = dic[@"idd"];
        self.level = [dic[@"level"] integerValue];
        self.name = dic[@"name"];
        self.parentId = dic[@"parentId"];
        
        if([self.parentId isEqualToString:@" "]){
            self.isOpen = YES;
        }else{
            self.isOpen = NO;
        }
    }
    return self;
}
@end
