//
//  FBTTableView.h
//  SerialCellOpen
//
//  Created by zsw on 2017/3/17.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBTCellModel;
@class FBTTableView;

@protocol FBTTableViewDelegate <NSObject>
@optional

/**
 *  代理方法传递对应的三级模型数据(点击了第三级别的Cell)
 *
 *  @param checkTableView                TableView 对象
 *  @param clickCellModel         模型数据
 */


-(void)EditCheckTableView:(FBTTableView *)checkTableView arrayData:(FBTCellModel *)clickCellModel;


@end
@interface FBTTableView : UITableView
@property (nonatomic,weak) id<FBTTableViewDelegate> cusDelegate;

@property (nonatomic,assign)NSInteger selectSecIndexNum;
-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)arr;
+(instancetype)cusThiedTableView:(CGRect)frame dataArr:(NSArray *)arr;
@end
