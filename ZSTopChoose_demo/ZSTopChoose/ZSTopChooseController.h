//
//  ZSTopChooseController.h
//
//  Created by 徐仲平 on 16/4/9.
//  Copyright © 2016年 徐仲平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSTopChooseController : UIViewController

@property (nonatomic,strong)NSArray *subChildViewController;

/**
 *  标题颜色
 */
@property (nonatomic,strong)UIColor *titleColor;

@property (nonatomic,strong)UIColor *selectedColor;

/**
 *  指示器颜色
 */
@property (nonatomic,strong)UIColor *indicatorColor;

/**
 *  添加到需要显示的控制器
 *
 *  @param controller 需要显示的控制器
 */
-(void)addToController:(UIViewController *)controller;

@end

@interface UIView (ZS_Extension)
@property (nonatomic,assign)CGFloat zs_width;
@property (nonatomic,assign)CGFloat zs_height;
@property (nonatomic,assign)CGFloat zs_x;
@property (nonatomic,assign)CGFloat zs_y;
@property (nonatomic,assign)CGSize zs_size;
@property (nonatomic,assign)CGPoint zs_origin;
@property (nonatomic,assign)CGFloat zs_centerX;
@property (nonatomic,assign)CGFloat zs_centerY;

@end


