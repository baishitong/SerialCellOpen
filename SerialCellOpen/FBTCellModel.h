//
//  FBTCellModel.h
//  SerialCellOpen
//
//  Created by zsw on 2017/3/17.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBTCellModel : NSObject
/**
 * 当前的id
 */
@property(nonatomic,copy)NSString *EditCheckID;//id

/**
 * level等级为它的级别 缩放等级 (第一级别:0 第二级别:1 第三级别:2)
 */
@property(nonatomic,assign)NSUInteger level;
/**
 * 当前的名称
 */
@property(nonatomic,copy)NSString *name;
/**
 * 父级id下标如果为“”,就代表他是level为0
 */
@property(nonatomic,copy)NSString *parentId;
/**
 *  是否展开
 */
@property (nonatomic,assign)BOOL  isOpen;

- (instancetype)sendModelData:(NSDictionary *)dic;

@end
