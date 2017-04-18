//
//  learningCircleVC.h
//  回顾电商beeQuick
//
//  Created by 万宇 on 2017/3/27.
//  Copyright © 2017年 万宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYlearningCircleVC;
@protocol refreshDelegate <NSObject>//协议

- (void)transViewController:(YYlearningCircleVC*)learningVC;//下拉刷新协议方法
- (void)transForFootRefreshWithViewController:(YYlearningCircleVC*)learningVC;//上拉加载协议方法

@end


@interface YYlearningCircleVC : UIViewController
@property(nonatomic,strong)NSMutableArray *infos;
@property (nonatomic, assign) id<refreshDelegate>delegate;//代理属性
@property(nonatomic,weak)UITableView *tableView;

@end
