 //
//  FBTTableView.m
//  SerialCellOpen
//
//  Created by zsw on 2017/3/17.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "FBTTableView.h"
#import "FBTCellModel.h"

@interface FBTTableView ()<UITableViewDelegate,UITableViewDataSource>{
    
    FBTCellModel *selectSuperModel;
    
}
/**
 *  所有的数据模型数组
 */
@property (nonatomic,strong)NSMutableArray *allArrData;
/**
 *  显示的模型数据数组
 */
@property (nonatomic,strong)NSMutableArray *showArrData;

@end




@implementation FBTTableView

static NSString *cellID=@"cellID";


-(NSMutableArray *)allArrData{
    if (_allArrData==nil) {
        _allArrData=[NSMutableArray array];
    }
    return _allArrData;
}
-(NSMutableArray *)showArrData{
    if (_showArrData==nil) {
        _showArrData=[NSMutableArray array];
    }
    return _showArrData;
}
-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)arr{
    if (self=[super initWithFrame:frame style:UITableViewStylePlain]) {
        
        [self dealData:arr]; // 处理数据
        [self someUISet];   // 一些设置
    }
    return self;
}

+(instancetype)cusThiedTableView:(CGRect)frame dataArr:(NSArray *)arr{
    return [[self alloc]initWithFrame:frame dataArr:arr];
}

#pragma mark 处理数据

-(void)dealData:(NSArray *)arr{
    
    [self.allArrData addObjectsFromArray:arr];//传进来全部的模型
    
    for (FBTCellModel *model in self.allArrData) {//遍历模型 模型中的isOpen是根据父节点判断的
        
        if (model.isOpen) {
            [self.showArrData addObject:model]; // 第一次初始化 添加展开的数据模型
            NSLog(@"显示的%ld",self.showArrData.count);
        }
    }
}
#pragma mark 一些UI设置
-(void)someUISet{
    self.delegate=self;
    self.dataSource=self;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.showsHorizontalScrollIndicator=self.showsVerticalScrollIndicator=NO;
}

#pragma mark -TableView的数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.showArrData.count;//展示现在放在isOpen为Yes的数组
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *strCellID=@"cellID";
    UITableViewCell *cellWithSystem=[tableView dequeueReusableCellWithIdentifier:strCellID];
    if (cellWithSystem==nil) {
        cellWithSystem=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strCellID];
    }
    //不允许选中
    cellWithSystem.selectionStyle=UITableViewCellSelectionStyleNone;
    //赋值
    FBTCellModel *model=self.showArrData[indexPath.row];
    cellWithSystem.textLabel.text=model.name;
    //    cellWithSystem.detailTextLabel.text=modelWithIndex.rightShowName;
    cellWithSystem.detailTextLabel.font=[UIFont systemFontOfSize:12.0];
    //就是级别低的cell与级别高的cell 的lable的
    cellWithSystem.indentationWidth=30;   // 缩放宽度
    cellWithSystem.indentationLevel=model.level;  // 缩放等级
    
    cellWithSystem.accessoryView = nil;//右侧的箭头
    [self setCellIsSelectAndNor:cellWithSystem modelData:model tableView:tableView];  //
    
    return cellWithSystem;
    
}

/**
 *
 *  @param changeCell  cell
 *  @param modelData 模型数据
 *  @param tableView TableView对象
 */
-(void)setCellIsSelectAndNor:(UITableViewCell *)changeCell modelData:(FBTCellModel *)modelData tableView:(UITableView *)tableView{
    for (NSInteger i=0;i<self.allArrData.count;i++) {
        FBTCellModel *nextModel=self.allArrData[i];
        NSLog(@"%@-----%@",modelData.EditCheckID,nextModel.parentId);
        //遍历全部的数据和已经显示的数据 即全部数据的父级节点和当前模型的id。
        if ([modelData.EditCheckID isEqualToString: nextModel.parentId]) {
            UIImageView *choiceImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,12,6)];
            choiceImage.image=[UIImage imageNamed:@"upArrow"];
            NSLog(@"显示可显示的cell");
            changeCell.accessoryView=choiceImage;
        }
    }
    
}

#pragma mark -TableView的代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSLog(@"%f",CGFLOAT_MIN);
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
#pragma mark 点击了Cell的处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FBTCellModel *modelData=self.showArrData[indexPath.row]; // 选中的模型
    [self dealWithClickData:modelData index:indexPath tableView:tableView];// 删除和添加对应的数据,返回最终的下标
}
#pragma mark  处理点击后的操作,返回结束的下标
-(NSInteger)dealWithClickData:(FBTCellModel *)modelData index:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    BOOL isSelectAndHideView = false;
    NSInteger count = 0;
    for (NSInteger i=0;i<self.allArrData.count;i++) {
        
        FBTCellModel *nextModel=self.allArrData[i];
        if (modelData.EditCheckID==nextModel.parentId) {
            count++;
        }
    }
    if (count == 0) {
        isSelectAndHideView = YES;
    }else{
        isSelectAndHideView = NO;
    }
    
    
    if (isSelectAndHideView) {
        
        if ([self.cusDelegate respondsToSelector:@selector(EditCheckTableView:arrayData:)]) { //同时代理传值
            [self.cusDelegate EditCheckTableView:self arrayData:modelData];
        }
    }
    NSInteger nextIndex=indexPath.row+1;   // 下一个下标
    NSInteger endIndex=nextIndex; // 结束的下标
    
    FBTCellModel *selectModel=modelData;                  //选中的模型数据
    
    BOOL isOpenSection=NO;
    //小于总数组
    for (NSInteger i=0;i<self.allArrData.count;i++) {
        FBTCellModel *nextModel=self.allArrData[i];
        if(selectModel.EditCheckID==nextModel.parentId){ // 选择的cell的ID=所有数据中模型的父节点  如果存在就说明当前选择的模型的id等于某些模型的父节点。且将这个模型的isOpen更改，展开他们。
            //nextModel一定是它的子节点，它的子节点一定isOpen 都是NO  而最初的section的isOpen变为了NO。
            nextModel.isOpen=!nextModel.isOpen;
            if (nextModel.isOpen) {
                [self.showArrData insertObject:nextModel atIndex:endIndex]; // 添加到数组中
                endIndex++;
                isOpenSection=YES;
            }
            else{
                endIndex=[self deleteDataInShaowDataArr:selectModel]; // 删除对应的数据(只需要删除一次)
                isOpenSection=NO;
                break;
            }
        }
    }
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=nextIndex; i<endIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0]; //获得需要修正的indexPath
        
        [indexPathArray addObject:indexPath];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //更改图片的方向
    if (isOpenSection) {
        cell.accessoryView.transform = CGAffineTransformMakeRotation(-M_PI);
        [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone]; //插入或者删除相关节点
    }else{
        cell.accessoryView.transform = CGAffineTransformMakeRotation(0);
        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //    NSLog(@"开始位置：%zi 和 结束位置:%zi",nextIndex,endIndex);
    
    
    
    return endIndex;
}
/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param selectModel 选中的模型
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */

-(NSUInteger)deleteDataInShaowDataArr:(FBTCellModel *)selectModel{
    
    NSInteger startIndex=[self.showArrData indexOfObject:selectModel]+1;
    NSInteger endIndex=startIndex;
    for (NSInteger i=startIndex; i<self.showArrData.count; i++) {
        FBTCellModel *model=self.showArrData[i];
        model.isOpen=NO;
        if (model.level>selectModel.level) { // 通过判断 缩放级别来 要删除的数组下标(删除的缩放级别一定大于选中的缩放级别)
            endIndex++;
        }
        else break;
    }
    NSRange deleteWithRang={startIndex,endIndex-(startIndex)};
    [self.showArrData removeObjectsInRange:deleteWithRang]; // 通过区间删除数据中的元素
    
    return endIndex;
}






@end
