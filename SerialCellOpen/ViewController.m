//
//  ViewController.m
//  SerialCellOpen
//
//  Created by zsw on 2017/3/17.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "ViewController.h"
#import "FBTTableView.h"
#import "FBTCellModel.h"
#define screenWidthW  [[UIScreen mainScreen] bounds].size.width
#define screenHeightH [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()<FBTTableViewDelegate>
@property (nonatomic, strong)NSMutableArray *backAllArray;
@property (nonatomic, strong)FBTTableView *tableView;
@end

@implementation ViewController


- (NSMutableArray *)backAllArray {
    if (!_backAllArray) {
        _backAllArray = [NSMutableArray array];
    }
    return _backAllArray;
}

//-(FBTTableView *)tableView{
//    if (_tableView==nil) {
//        _tableView=[FBTTableView cusThiedTableView:CGRectMake(0,0,screenWidthW,screenHeightH) dataArr:self.backAllArray];
//        _tableView.cusDelegate=self;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

// 此demo时仿照 冷求慧大神的三级展开的思路 自己稍微改了下 适合多级展开。 冷求慧大神的qq 1205632644 他的项目都放在了code4。


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *dataArray =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"center" ofType:@"plist"]];
    // idd为 当期的id。level 为当期的级别，name 为当前的信息。parentId 为你的父级的id。 isOpen来记录：是否展开。
    for (NSDictionary *dic in dataArray) {
        NSLog(@"%@",dic);
        FBTCellModel *cellModel = [[FBTCellModel alloc]init];
        [cellModel sendModelData:dic];
        [self.backAllArray addObject:cellModel];
    }
    NSLog(@"%ld",self.backAllArray.count);
    self.tableView = [FBTTableView cusThiedTableView:CGRectMake(0,64,screenWidthW,screenHeightH) dataArr:self.backAllArray];
    self.tableView.cusDelegate = self;
    [self.view addSubview:self.tableView];
   
}


-(void)EditCheckTableView:(FBTTableView *)checkTableView arrayData:(FBTCellModel *)clickCellModel{

      NSLog(@"%@",clickCellModel.name);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
