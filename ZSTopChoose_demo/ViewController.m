//
//  ViewController.m
//  ZSTopChoose_demo
//
//  Created by 徐仲平 on 16/4/9.
//  Copyright © 2016年 zoneSure. All rights reserved.
//

#import "ViewController.h"
#import "ZSTopChooseController.h"
#import "ZSTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZSTopChooseController *top=[[ZSTopChooseController alloc]init];
    
    
    ZSTableViewController *one=[[ZSTableViewController alloc]init];
    one.title=@"one";
    ZSTableViewController *two=[[ZSTableViewController alloc]init];
    two.title=@"two";
    ZSTableViewController *three=[[ZSTableViewController alloc]init];
    three.title=@"three";
    ZSTableViewController *four=[[ZSTableViewController alloc]init];
    four.title=@"four";
    ZSTableViewController *five=[[ZSTableViewController alloc]init];
    five.title=@"five";
    ZSTableViewController *six=[[ZSTableViewController alloc]init];
    six.title=@"six";
    top.subChildViewController=@[one,two,three,four,five,six];
    
    //    top.titleColor=[UIColor yellowColor];
    //    top.selectedColor=[UIColor greenColor];
    //    top.indicatorColor=[UIColor greenColor];
    
    [top addToController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
