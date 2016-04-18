# ZSTopChoose
快速集成一个滑动选择控制器
```objc
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

    
    [top addToController:self];
```
![Aaron Swartz](https://raw.githubusercontent.com/JungHsu/JHTopChoose/master/JHTopChoose.gif)