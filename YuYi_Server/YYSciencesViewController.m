//
//  YYSciencesViewController.m
//  YuYi_Server
//
//  Created by wylt_ios_1 on 2017/3/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYSciencesViewController.h"
#import "YYlearningCircleVC.h"
#import <Masonry.h>
#import "UIButton+Badge.h"
#import "UIColor+colorValues.h"
#import "YYpostCardVC.h"
#import "NSObject+Formula.h"
@interface YYSciencesViewController ()<UIScrollViewDelegate>
//跟button的监听事件有关
@property(weak, nonatomic)UIView *cardLineView;
//
@property(weak, nonatomic)UIScrollView *cardDetailView;
//根据scrollView滚动距离设置滚动线位置时候需要
@property(strong, nonatomic)NSArray *cardCategoryButtons;
//设置滚动线约束时候需要
@property(strong, nonatomic)UIView *cardsView;
@property(nonatomic,strong)NSArray *hotInfos;
@property(nonatomic,strong)NSArray *selectInfos;
@property(nonatomic,strong)NSArray *recentInfos;
//子控制器
@property(weak, nonatomic)YYlearningCircleVC *hotCardVC;
@property(weak, nonatomic)YYlearningCircleVC *selectCardVC;
@property(weak, nonatomic)YYlearningCircleVC *recentCardVC;
//发帖btn
@property(weak, nonatomic)UIButton *postMessageBtn;
//optionView
@property(weak, nonatomic)UIView *backView;
@property(weak, nonatomic)UIView *noticeView;

@end

@implementation YYSciencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学术圈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
- (void)loadData {
    self.hotInfos = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"4",@"5",@"6", nil];
    self.selectInfos = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    self.recentInfos = [NSArray arrayWithObjects:@"1",@"2", nil];
    [self setupUI];
}
//
-(void)setupUI{
    self.navigationController.navigationBar.hidden = true;
    //添加帖子分类
    UIView *cardsView = [[UIView alloc]init];
    cardsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardsView];
    //
    self.cardsView = cardsView;
    //添加商家分类按钮
    UIButton *hotCardButton = [[UIButton alloc]init];
    UIButton *selectCardButton = [[UIButton alloc]init];
    UIButton *recentCardButton = [[UIButton alloc]init];
    //设置按钮标题
    [hotCardButton setTitle:@"热门" forState:UIControlStateNormal];
    [selectCardButton setTitle:@"精选" forState:UIControlStateNormal];
    [recentCardButton setTitle:@"最新" forState:UIControlStateNormal];
    //把按钮添加到一个数组中
    NSArray *cardCategoryButtons = @[hotCardButton,selectCardButton,recentCardButton];
    //
    self.cardCategoryButtons = cardCategoryButtons;
    //循环把各个按钮通用的部分设置
    for (int i = 0; i < cardCategoryButtons.count; i ++) {
        UIButton *btn = cardCategoryButtons[i];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        //
        btn.tag = i;
        //添加按钮的监听事件
        [btn addTarget:self action:@selector(shopCategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cardsView addSubview:btn];
    }
    
    //添加滑动线
    UIView *cardLineView = [[UIView alloc]init];
    [cardLineView setBackgroundColor:[UIColor greenColor]];
    [cardsView addSubview:cardLineView];
    self.cardLineView = cardLineView;
    
    //添加帖子信息
    UIScrollView *cardDetailView = [[UIScrollView alloc]init];
    //打开分页符
    cardDetailView.pagingEnabled = YES;
    //取消滚动条
    cardDetailView.showsVerticalScrollIndicator = NO;
    cardDetailView.showsHorizontalScrollIndicator = NO;
    cardDetailView.bounces = false;
    cardDetailView.backgroundColor = [UIColor orangeColor];
    //添加帖子详情
    [self.view addSubview:cardDetailView];
    //
    self.cardDetailView = cardDetailView;
    //
    self.cardDetailView.delegate = self;
    //
    YYlearningCircleVC *hotCardVC = [[YYlearningCircleVC alloc]init];
    YYlearningCircleVC *selectCardVC = [[YYlearningCircleVC alloc]init];
    YYlearningCircleVC *recentCardVC = [[YYlearningCircleVC alloc]init];
    //传数据
    hotCardVC.infos = self.hotInfos;
    selectCardVC.infos = self.selectInfos;
    recentCardVC.infos = self.recentInfos;
    //
    hotCardVC.view.backgroundColor = [UIColor whiteColor];
    selectCardVC.view.backgroundColor = [UIColor blueColor];
    recentCardVC.view.backgroundColor = [UIColor whiteColor];
    
    //添加子控件的view
    [cardDetailView addSubview:hotCardVC.view];
    [cardDetailView addSubview:selectCardVC.view];
    [cardDetailView addSubview:recentCardVC.view];
    //建立父子关系
    [self addChildViewController:hotCardVC];
    [self addChildViewController:selectCardVC];
    [self addChildViewController:recentCardVC];
    //告诉程序已经添加成功
    [hotCardVC didMoveToParentViewController:self];
    [selectCardVC didMoveToParentViewController:self];
    [recentCardVC didMoveToParentViewController:self];
    //
    self.hotCardVC = hotCardVC;
    self.selectCardVC = selectCardVC;
    self.recentCardVC = recentCardVC;
    //添加右侧消息中心按钮
    UIButton *informationBtn = [[UIButton alloc]init];
    [self.view addSubview:informationBtn];
    [informationBtn setImage:[UIImage imageNamed:@"inform"] forState:UIControlStateNormal];
    informationBtn.badgeValue = @" ";
    informationBtn.badgeBGColor = [UIColor redColor];
    informationBtn.badgeFont = [UIFont systemFontOfSize:0.1];
    informationBtn.badgeOriginX = 16;
    informationBtn.badgeOriginY = 1;
    informationBtn.badgePadding = 0.1;
    informationBtn.badgeMinSize = 5;
    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置帖子分类约束
    [cardsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(64);
    }];
    //设置按钮约束
    [cardCategoryButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.bottom.offset(0);
    }];
    //循环设置按钮的等宽
    for (int i = 0; i < cardCategoryButtons.count-1; i ++) {
        UIButton *currentBtn = cardCategoryButtons[i];
        UIButton *nextBtn = cardCategoryButtons[i+1];
        //
        if (i==0) {
            [currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
            }];
            
        }
        if (i==cardCategoryButtons.count-2) {
            [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-([UIScreen mainScreen].bounds.size.width-170));
            }];
        }
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(currentBtn);
            make.left.equalTo(currentBtn.mas_right);
        }];
        
    }
    //设置滑动线的约束
    [cardLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.offset(2);
        make.bottom.equalTo(hotCardButton);
        make.centerX.equalTo(hotCardButton);
    }];
    //约束
    [cardDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(cardsView.mas_bottom);
    }];
    [cardDetailView layoutIfNeeded];
    [hotCardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
    [selectCardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(hotCardVC.view.mas_right);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
    [recentCardVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.equalTo(selectCardVC.view.mas_right);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
    }];
    [informationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hotCardButton);
        make.right.offset(-20);
    }];
    
}

//按钮的监听事件
-(void)shopCategoryButtonClick:(UIButton*)sender{
    
    [self.cardDetailView setContentOffset:CGPointMake(sender.tag*self.cardDetailView.bounds.size.width, 0) animated:YES];
    if (sender.tag == 0) {
        self.hotInfos = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
        self.hotCardVC.infos = self.hotInfos;
    }else if (sender.tag == 1){
        self.selectInfos = [NSArray arrayWithObjects:@"1",@"2", nil];
        self.selectCardVC.infos = self.selectInfos;
    }else if (sender.tag == 2){
        self.recentInfos = [NSArray arrayWithObjects:@"1", nil];
        self.recentCardVC.infos = self.recentInfos;
    }
}
-(void)informationBtnClick:(UIButton*)sender{
    //大蒙布View
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    backView.alpha = 0.2;
    [self.view addSubview:backView];
    self.backView = backView;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    backView.userInteractionEnabled = YES;
    //添加tap手势：
    //    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    //将手势添加至需要相应的view中
    //    [backView addGestureRecognizer:tapGesture];
    
    //提示框
    UIView *noticeView = [[UIView alloc]init];
    noticeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noticeView];
    self.noticeView = noticeView;
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.width.offset(300);
        make.height.offset(200);
    }];
    //noticeLabel
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.text = @"提示";
    noticeLabel.font = [UIFont systemFontOfSize:17];
    noticeLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [noticeView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(noticeView);
        make.top.offset(25);
    }];
    //contentLabel
    UILabel *contentLabel = [[UILabel alloc]init];
    //提示内容
    contentLabel.text = @"此功能暂时只对专业医生开放，你暂时还没有权限，去看看别的吧";
    contentLabel.numberOfLines = 2;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [noticeView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.top.equalTo(noticeLabel.mas_bottom).offset(25);
        make.right.offset(-25);
    }];
    //confirmButton
    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
    confirmButton.backgroundColor = [UIColor colorWithHexString:@"#25f368"];
    [noticeView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(60);
    }];
    //添加关闭提示框按钮的点击事件
    [confirmButton addTarget:self action:@selector(closeNoticeView:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)closeNoticeView:(UIButton*)sender{
    for (UIView *view in self.noticeView.subviews) {
        [view removeFromSuperview];
    }
    [self.noticeView removeFromSuperview];
    [self.backView removeFromSuperview];
}
-(void)postMassageBtnClick:(UIButton*)sender{
    NSLog(@"跳转发帖页面");
    YYpostCardVC *postCardVC = [[YYpostCardVC alloc]init];
    [self.navigationController pushViewController:postCardVC animated:true];
}
//根据偏移距离设置滚动线的位置

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取偏移量
    CGFloat offSetX = self.cardDetailView.contentOffset.x;
    // NSLog(@"%f",offSetX);
    //找到按钮数组的第一个按钮和最后一个按钮
    UIButton *firstBtn = self.cardCategoryButtons.firstObject;
    UIButton *lastBtn = self.cardCategoryButtons.lastObject;
    //滚动线的滑动范围
    CGFloat dis = lastBtn.center.x - firstBtn.center.x;
    //获取这个范围的最大值和最小值
    CGFloat leftValue = -(dis/2);
    CGFloat rightValue = dis/2;
    //要求的值所在的数值区域
    YHValue resValue = YHValueMake(leftValue, rightValue);
    //参照数值的区域
    YHValue conValue = YHValueMake(0, (self.cardCategoryButtons.count-1)*self.cardDetailView.bounds.size.width);
    //偏移距离
    CGFloat res = [NSObject resultWithConsult:offSetX andResultValue:resValue andConsultValue:conValue];
    UIButton *secondBtn = self.cardCategoryButtons[1];
    //按钮所在view宽和scrollView的宽不相等，所以需要减去该距离
    CGFloat d = self.view.center.x - secondBtn.center.x;
    //根据偏移距离设置滚动线的位置
    [self.cardLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.offset(2);
        make.bottom.equalTo(self.cardsView);
        make.centerX.offset(res-d);
    }];
    
    //
    [self.cardLineView layoutIfNeeded];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
    //添加右侧发帖按钮
    UIButton *postMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, self.view.frame.size.height-114, 50, 50)];
    [[UIApplication sharedApplication].keyWindow addSubview:postMessageBtn];
    self.postMessageBtn = postMessageBtn;
    [postMessageBtn setImage:[UIImage imageNamed:@"postamessage"] forState:UIControlStateNormal];
    [postMessageBtn addTarget:self action:@selector(postMassageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
    [self.postMessageBtn removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
