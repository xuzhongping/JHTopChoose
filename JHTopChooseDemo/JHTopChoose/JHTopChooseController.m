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
@property (nonatomic,weak)UIScrollView *titleView;
/**
 *  标签名
 */
@property (nonatomic,strong)NSMutableArray *titles;

@end

@implementation JHTopChooseController

-(NSMutableArray *)titleButtons{
    
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

-(NSMutableArray *)titles{
    
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

-(void)setSubChildViewController:(NSArray<UIViewController *> *)subChildViewController{

    _subChildViewController = subChildViewController;
   
    //内容控制器
    if (!_subChildViewController.count) return;
    for (UIViewController *controller in _subChildViewController) {
        
        [self.titles addObject:controller.title];
        [self addChildViewController:controller];
    }
    
    
    /** 默认最大每页标题数等于总标题数 */
    _maxTitleCount = _maxTitleCount ? _maxTitleCount : _titles.count;
    
    _indicatorColor = _indicatorColor ? _indicatorColor : [UIColor redColor];
    
    _titleColor = _titleColor ? _titleColor : [UIColor grayColor];
    _selectedTitleColor = _selectedTitleColor ? _selectedTitleColor : [UIColor redColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat btnW = self.view.jh_width / _maxTitleCount;
    

    
    //初始化内容scrollView
    UIScrollView *contentView = [[UIScrollView alloc]init];
    
    contentView.frame = self.view.bounds;
    contentView.backgroundColor   =   [UIColor whiteColor];
    contentView.delegate  =  self;
    [self.view insertSubview:contentView atIndex:0];
    
    //设置scrollView的contentSize
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.jh_width, 0);
    //设置分页
    contentView.pagingEnabled = YES;
    //水平方向不显示滚动条
    contentView.showsHorizontalScrollIndicator = NO;
    //禁止弹簧效果
    contentView.bounces = NO;
    self.contentView = contentView;
    
    //初始化标签view
    UIScrollView *titleView = [[UIScrollView alloc]init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
  
    titleView.jh_x = 0;
    titleView.jh_y = self.navigationController.navigationBar.jh_height+STATUS_HEIGHT;
    titleView.jh_width = self.view.jh_width;
    titleView.jh_height = TITLEVIEW_HEIGHT;
    titleView.contentSize = CGSizeMake(_titles.count * btnW, 0);
    titleView.showsHorizontalScrollIndicator = NO;
    self.titleView = titleView;
    
    [self.view addSubview:titleView];
    
    //指示器
    UIView *indicatorView = [[UIView alloc]init];
    
    indicatorView.backgroundColor = _indicatorColor;
    
    indicatorView.jh_height = INDICATOR_HEIGHT;
    indicatorView.jh_y = titleView.jh_height-indicatorView.jh_height;
    
    self.indicatorView = indicatorView;
    [titleView addSubview:indicatorView];
    
    //标签
    for (NSInteger i = 0; i<self.titles.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        titleBtn.tag = i;
        [titleBtn setTitle:self.titles[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleBtn setTitleColor:_titleColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        
        titleBtn.jh_width  =  btnW;
        titleBtn.jh_height  =  titleView.jh_height;
        titleBtn.jh_x  =  titleBtn.jh_width * i;
        
        [titleView addSubview:titleBtn];
        [self.titleButtons addObject:titleBtn];
        //监听点击
        [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) { //默认选中第一行
            [self titleClick:titleBtn];
            [titleBtn.titleLabel sizeToFit];
            self.indicatorView.jh_width = titleBtn.titleLabel.jh_width;
            self.indicatorView.jh_centerX = titleBtn.jh_centerX;

        }
    }
    
    
    
}
#pragma mark - 标签的点击
-(void)titleClick:(UIButton *)button{
    
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    //移动指示器到对应按钮位置
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.indicatorView.jh_width = button.titleLabel.jh_width;
        self.indicatorView.jh_centerX = button.jh_centerX;
    }];
    
   /** 移动contentView到对应的位置并添加控制器的view */
    CGFloat offsetX = button.tag * self.view.jh_width;
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    

    /** 自动滑动titleView到中间 */
    CGFloat x = button.center.x - _titleView.frame.size.width * 0.5;
    
    if (x <= 0 ) {
        x = 0;
    }else if (x >= _titleView.contentSize.width - _titleView.frame.size.width){
        
        x = _titleView.contentSize.width - _titleView.frame.size.width;

    }
    [_titleView setContentOffset:CGPointMake(x, 0) animated:YES];
    
    UITableViewController *vc = self.childViewControllers[button.tag];
    vc.view.frame = CGRectMake(offsetX, 0, _contentView.jh_width, _contentView.jh_height);
    vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(_titleView.frame), 0, self.tabBarController.tabBar.jh_height,0);

    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    [_contentView addSubview:vc.view];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

    //拿到滑动的位置所对应的索引
    NSInteger index = scrollView.contentOffset.x / self.view.jh_width;
    
    [self titleClick:self.titleButtons[index]];

}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    CGFloat index = scrollView.contentOffset.x / _contentView.jh_width;
//    
//    NSUInteger leftTitleIndex = index;
//    NSUInteger rightTitleIndex = index + 1;
//    
//    _titleColor
//}


-(void)addToController:(UIViewController *)controller{
    
    controller.automaticallyAdjustsScrollViewInsets = NO;
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
}
@end


@implementation UIView (JHExtension)
-(void)setJh_width:(CGFloat)jh_width{
    
    CGRect frame = self.frame;
    
    frame.size.width = jh_width;
    
    self.frame = frame;
}

-(void)setJh_height:(CGFloat)jh_height{
    
    CGRect frame = self.frame;
    
    frame.size.height = jh_height;
    
    self.frame = frame;
    
}

-(void)setJh_x:(CGFloat)jh_x{
    CGRect frame = self.frame;
    
    frame.origin.x = jh_x;
    
    self.frame = frame;
    
}

-(void)setJh_y:(CGFloat)jh_y{
    CGRect frame = self.frame;
    
    frame.origin.y = jh_y;
    
    self.frame = frame;
    
    
}

-(void)setJh_size:(CGSize)jh_size{
    
    CGRect frame = self.frame;
    
    frame.size = jh_size;
    
    self.frame = frame;
    
}

-(void)setJh_origin:(CGPoint)jh_origin{
    
    CGRect frame = self.frame;
    
    frame.origin = jh_origin;
    
    self.frame = frame;
    
}

-(void)setJh_centerX:(CGFloat)jh_centerX{
    
    CGPoint center = self.center;
    
    center.x = jh_centerX;
    
    self.center = center;
    
}

-(void)setJh_centerY:(CGFloat)jh_centerY{
    CGPoint center = self.center;
    center.y = jh_centerY;
    
    self.center = center;
    
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

