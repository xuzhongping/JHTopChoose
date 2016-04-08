//
//  ZSTopChooseController.m
//
//  Created by 徐仲平 on 16/4/9.
//  Copyright © 2016年 徐仲平. All rights reserved.
//

#import "ZSTopChooseController.h"
#define STATUS_HEIGHT 20
#define INDICATOR_HEIGHT 2
#define TITLEVIEW_HEIGHT 35
#define ANIMATE_DURATION 0.25



@interface ZSTopChooseController ()<UIScrollViewDelegate>

/**
 *  上次选中的按钮
 */
@property (nonatomic,strong)UIButton *selectedBtn;

/**
 *  指示器
 */
@property (nonatomic,weak)UIView *indicatorView;

/**
 *  内容scrollView
 */
@property (nonatomic,weak)UIScrollView *contentView;

/**
 *  标签按钮数组
 */
@property (nonatomic,strong)NSMutableArray *titleButtons;
/**
 *  标签view
 */
@property (nonatomic,weak)UIView *titleView;
/**
 *  标签名
 */
@property (nonatomic,strong)NSMutableArray *titles;

@end

@implementation ZSTopChooseController

-(NSMutableArray *)titleButtons{
    
    if (!_titleButtons) {
        _titleButtons=[NSMutableArray array];
    }
    return _titleButtons;
}

-(NSMutableArray *)titles{
    
    if (!_titles) {
        _titles=[NSMutableArray array];
    }
    return _titles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //内容控制器
    if (!_subChildViewController.count) return;
    for (UIViewController *controller in _subChildViewController) {
        
        [self.titles addObject:controller.title];
        [self addChildViewController:controller];
    }
    
    //内容scrollView
    UIScrollView *contentView=[[UIScrollView alloc]init];
    
    contentView.frame=self.view.bounds;
    contentView.backgroundColor=[UIColor whiteColor];
    contentView.delegate=self;
    [self.view insertSubview:contentView atIndex:0];
    
    //设置scrollView的contentSize
    contentView.contentSize=CGSizeMake(self.childViewControllers.count * self.view.zs_width, 0);
    //设置分页
    contentView.pagingEnabled=YES;
    //水平方向不显示滚动条
    contentView.showsHorizontalScrollIndicator=NO;
    //禁止弹簧效果
    contentView.bounces=NO;
    
    self.contentView=contentView;
    
    //标签view
    UIView *titleView=[[UIView alloc]init];
    titleView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titleView.zs_x=0;
    titleView.zs_y=self.navigationController.navigationBar.zs_height+STATUS_HEIGHT;
    titleView.zs_width=self.view.zs_width;
    titleView.zs_height=TITLEVIEW_HEIGHT;
    self.titleView=titleView;
    
    [self.view addSubview:titleView];
    
    //指示器
    UIView *indicatorView=[[UIView alloc]init];
    
    indicatorView.backgroundColor=_indicatorColor?_indicatorColor:[UIColor redColor];
    
    indicatorView.zs_height=INDICATOR_HEIGHT;
    indicatorView.zs_y=titleView.zs_height-indicatorView.zs_height;
    
    self.indicatorView=indicatorView;
    [titleView addSubview:indicatorView];
    
    //标签
    for (NSInteger i=0; i<self.titles.count; i++) {
        UIButton *titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        titleBtn.tag=i;
        [titleBtn setTitle:self.titles[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [titleBtn setTitleColor:self.titleColor?self.titleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.selectedColor?self.selectedColor:[UIColor redColor] forState:UIControlStateSelected];
        
        titleBtn.zs_width = self.view.zs_width / self.titles.count;
        titleBtn.zs_height = titleView.zs_height;
        titleBtn.zs_x = titleBtn.zs_width * i;
        
        [titleView addSubview:titleBtn];
        [self.titleButtons addObject:titleBtn];
        //监听点击
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) { //默认选中第一行
            titleBtn.selected=YES;
            self.selectedBtn=titleBtn;
            [titleBtn.titleLabel sizeToFit];
            self.indicatorView.zs_width=titleBtn.titleLabel.zs_width;
            self.indicatorView.zs_centerX=titleBtn.zs_centerX;
            
            [self scrollViewDidEndScrollingAnimation:contentView];
        }
    }
    
    
    
}
-(void)titleClick:(UIButton *)button{
    
    self.selectedBtn.selected=NO;
    button.selected=YES;
    self.selectedBtn=button;
    
    //移动指示器到对应按钮位置
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.indicatorView.zs_width=button.titleLabel.zs_width;
        self.indicatorView.zs_centerX=button.zs_centerX;
    }];
    
    //    self.contentView.contentOffset=CGPointMake(button.tag * self.view.widtxh, 0);
    [self.contentView setContentOffset:CGPointMake(button.tag * self.view.zs_width, 0) animated:YES];
    
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    //添加对应的控制器view到内容scrollView
    NSInteger index=scrollView.contentOffset.x / self.view.zs_width;
    
    UITableViewController *vc=self.childViewControllers[index];
    vc.view.zs_x=scrollView.contentOffset.x;
    vc.view.zs_y=0;
    vc.view.zs_size=self.view.zs_size;
    vc.tableView.contentInset=UIEdgeInsetsMake(CGRectGetMaxY(self.titleView.frame), 0,self.tabBarController.tabBar.zs_height, 0);
    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    [scrollView addSubview:vc.view];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //拿到滑动的位置所对应的索引
    NSInteger index=scrollView.contentOffset.x / self.view.zs_width;
    
    [self titleClick:self.titleButtons[index]];
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}


-(void)addToController:(UIViewController *)controller{
    
    controller.automaticallyAdjustsScrollViewInsets=NO;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
}
@end


@implementation UIView (ZS_Extension)
-(void)setZs_width:(CGFloat)zs_width{

    CGRect frame=self.frame;
    
    frame.size.width=zs_width;
    
    self.frame=frame;
}

-(void)setZs_height:(CGFloat)zs_height{
    
    CGRect frame=self.frame;
    
    frame.size.height=zs_height;
    
    self.frame=frame;
    
}

-(void)setZs_x:(CGFloat)zs_x{
    CGRect frame=self.frame;
    
    frame.origin.x=zs_x;
    
    self.frame=frame;
    
}

-(void)setZs_y:(CGFloat)zs_y{
    CGRect frame=self.frame;
    
    frame.origin.y=zs_y;
    
    self.frame=frame;
    
    
}

-(void)setZs_size:(CGSize)zs_size{
    
    CGRect frame=self.frame;
    
    frame.size=zs_size;
    
    self.frame=frame;
    
}

-(void)setZs_origin:(CGPoint)zs_origin{
    
    CGRect frame=self.frame;
    
    frame.origin=zs_origin;
    
    self.frame=frame;
    
}

-(void)setZs_centerX:(CGFloat)zs_centerX{
    
    CGPoint center=self.center;
    
    center.x=zs_centerX;
    
    self.center=center;
    
}

-(void)setZs_centerY:(CGFloat)zs_centerY{
    CGPoint center=self.center;
    center.y=zs_centerY;
    
    self.center=center;
    
}


-(CGFloat)zs_width{
    
    return self.frame.size.width;
}

-(CGFloat)zs_height{
    
    return self.frame.size.height;
}

-(CGFloat)zs_x{
    
    return self.frame.origin.x;
}

-(CGFloat)zs_y{
    
    return self.frame.origin.y;
}

-(CGSize)zs_size{
    
    return self.frame.size;
}

-(CGPoint)zs_origin{
    
    return self.frame.origin;
}

-(CGFloat)zs_centerX{
    
    return self.center.x;
}

-(CGFloat)zs_centerY{
    
    return self.center.y;
}
@end

