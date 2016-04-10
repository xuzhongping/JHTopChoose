//
//  JHTopChooseController.m
//
//  Created by 徐仲平 on 16/4/9.
//  Copyright © 2016年 徐仲平. All rights reserved.
//

#import "JHTopChooseController.h"
#define STATUS_HEIGHT 20
#define INDICATOR_HEIGHT 2
#define TITLEVIEW_HEIGHT 35
#define ANIMATE_DURATION 0.25



@interface JHTopChooseController ()<UIScrollViewDelegate>

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

@implementation JHTopChooseController

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
    contentView.contentSize=CGSizeMake(self.childViewControllers.count * self.view.jh_width, 0);
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
    titleView.jh_x=0;
    titleView.jh_y=self.navigationController.navigationBar.jh_height+STATUS_HEIGHT;
    titleView.jh_width=self.view.jh_width;
    titleView.jh_height=TITLEVIEW_HEIGHT;
    self.titleView=titleView;
    
    [self.view addSubview:titleView];
    
    //指示器
    UIView *indicatorView=[[UIView alloc]init];
    
    indicatorView.backgroundColor=_indicatorColor?_indicatorColor:[UIColor redColor];
    
    indicatorView.jh_height=INDICATOR_HEIGHT;
    indicatorView.jh_y=titleView.jh_height-indicatorView.jh_height;
    
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
        
        titleBtn.jh_width = self.view.jh_width / self.titles.count;
        titleBtn.jh_height = titleView.jh_height;
        titleBtn.jh_x = titleBtn.jh_width * i;
        
        [titleView addSubview:titleBtn];
        [self.titleButtons addObject:titleBtn];
        //监听点击
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) { //默认选中第一行
            titleBtn.selected=YES;
            self.selectedBtn=titleBtn;
            [titleBtn.titleLabel sizeToFit];
            self.indicatorView.jh_width=titleBtn.titleLabel.jh_width;
            self.indicatorView.jh_centerX=titleBtn.jh_centerX;
            
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
        self.indicatorView.jh_width=button.titleLabel.jh_width;
        self.indicatorView.jh_centerX=button.jh_centerX;
    }];
    
    //    self.contentView.contentOffset=CGPointMake(button.tag * self.view.widtxh, 0);
    [self.contentView setContentOffset:CGPointMake(button.tag * self.view.jh_width, 0) animated:YES];
    
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    //添加对应的控制器view到内容scrollView
    NSInteger index=scrollView.contentOffset.x / self.view.jh_width;
    
    UITableViewController *vc=self.childViewControllers[index];
    vc.view.jh_x=scrollView.contentOffset.x;
    vc.view.jh_y=0;
    vc.view.jh_size=self.view.jh_size;
    vc.tableView.contentInset=UIEdgeInsetsMake(CGRectGetMaxY(self.titleView.frame), 0,self.tabBarController.tabBar.jh_height, 0);
    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    [scrollView addSubview:vc.view];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //拿到滑动的位置所对应的索引
    NSInteger index=scrollView.contentOffset.x / self.view.jh_width;
    
    [self titleClick:self.titleButtons[index]];
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}


-(void)addToController:(UIViewController *)controller{
    
    controller.automaticallyAdjustsScrollViewInsets=NO;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
}
@end


@implementation UIView (JHExtension)
-(void)setJh_width:(CGFloat)jh_width{
    
    CGRect frame=self.frame;
    
    frame.size.width=jh_width;
    
    self.frame=frame;
}

-(void)setJh_height:(CGFloat)jh_height{
    
    CGRect frame=self.frame;
    
    frame.size.height=jh_height;
    
    self.frame=frame;
    
}

-(void)setJh_x:(CGFloat)jh_x{
    CGRect frame=self.frame;
    
    frame.origin.x=jh_x;
    
    self.frame=frame;
    
}

-(void)setJh_y:(CGFloat)jh_y{
    CGRect frame=self.frame;
    
    frame.origin.y=jh_y;
    
    self.frame=frame;
    
    
}

-(void)setJh_size:(CGSize)jh_size{
    
    CGRect frame=self.frame;
    
    frame.size=jh_size;
    
    self.frame=frame;
    
}

-(void)setJh_origin:(CGPoint)jh_origin{
    
    CGRect frame=self.frame;
    
    frame.origin=jh_origin;
    
    self.frame=frame;
    
}

-(void)setJh_centerX:(CGFloat)jh_centerX{
    
    CGPoint center=self.center;
    
    center.x=jh_centerX;
    
    self.center=center;
    
}

-(void)setJh_centerY:(CGFloat)jh_centerY{
    CGPoint center=self.center;
    center.y=jh_centerY;
    
    self.center=center;
    
}


-(CGFloat)jh_width{
    
    return self.frame.size.width;
}

-(CGFloat)jh_height{
    
    return self.frame.size.height;
}

-(CGFloat)jh_x{
    
    return self.frame.origin.x;
}

-(CGFloat)jh_y{
    
    return self.frame.origin.y;
}

-(CGSize)jh_size{
    
    return self.frame.size;
}

-(CGPoint)jh_origin{
    
    return self.frame.origin;
}

-(CGFloat)jh_centerX{
    
    return self.center.x;
}

-(CGFloat)jh_centerY{
    
    return self.center.y;
}
@end

