//
//  ViewController.m
//  JHTopChooseDemo
//
//  Created by 徐仲平 on 16/4/10.
//  Copyright © 2016年 JungHsu. All rights reserved.
//

#import "ViewController.h"
#import "JHTopChooseController.h"
#import "JHTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    JHTopChooseController *top=[[JHTopChooseController alloc]init];
    
    
    JHTableViewController *one=[[JHTableViewController alloc]init];
    one.title=@"one";
    JHTableViewController *two=[[JHTableViewController alloc]init];
    two.title=@"two";
    JHTableViewController *three=[[JHTableViewController alloc]init];
    three.title=@"three";
    JHTableViewController *four=[[JHTableViewController alloc]init];
    four.title=@"four";
    JHTableViewController *five=[[JHTableViewController alloc]init];
    five.title=@"five";
    JHTableViewController *six=[[JHTableViewController alloc]init];
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
