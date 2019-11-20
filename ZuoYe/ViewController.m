//
//  ViewController.m
//  ZuoYe
//
//  Created by 陈统帅 on 2019/8/6.
//  Copyright © 2019 陈统帅. All rights reserved.
//

#import "ViewController.h"
#import "Page2ViewController.h"
#import "SLDatePicker.h"
#import "UIColor+Category.h"
#import "Masonry.h"

@interface ViewController ()
#pragma mark --test

@property (nonatomic, weak) UIView *alphaBackgroundView;

@property (nonatomic, weak) SLGeneralDatePickerView *pickerView;
@property (nonatomic, weak) SLGeneralDatePickerView *pickerView2;

@property (nonatomic, weak) UIView *topContainerView;
@property (nonatomic, weak) UIButton *doneButton;
@property (nonatomic, weak) UIButton *cancelButton;


@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *labels;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)  NSArray *listTeams;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *buttons;


- (IBAction)exitNumber:(id)sender;
- (IBAction)startFind:(id)sender;
- (IBAction)chuanZhi:(id)sender;

- (IBAction)setStartTime:(id)sender;
- (IBAction)setStopTime:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"team" ofType:@"plist"];
    self.listTeams = [[NSArray alloc] initWithContentsOfFile:path];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --UITableViewDataSource 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"123UITableViewDataSource 协议方法");
    return [self.listTeams count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    NSUInteger row = [indexPath row];
    NSDictionary *rowDict = self.listTeams[row];
    cell.textLabel.text = rowDict[@"name"];
    NSString *imagePath = [[NSString alloc] initWithFormat: @"球队图片/%@.png", rowDict[@"image"]];
    cell.imageView.image = [UIImage imageNamed:imagePath];
//    NSLog(@"%@",imagePath);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark --注册键盘
- (void)viewWillAppear:(BOOL)animated{
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    //注销键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    //注销键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
}
- (void) keyboardDidShow: (NSNotification *)notif{
    NSLog(@"键盘打开");
}
- (void) keyboardDidHide: (NSNotification *)notif{
    NSLog(@"键盘关闭");
}
#pragma mark --实现UITextFieldDelegate委托协议方法
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"TextField获得焦点，点击return键");
    return TRUE;
}

- (IBAction)exitNumber:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)startFind:(id)sender {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"team" ofType:@"plist"];
    self.listTeams = [[NSArray alloc] initWithContentsOfFile:path];
    NSString * ids=self.textView.text;
    NSString * start=self.labels.text;
    NSString * stop=self.label.text;
    NSMutableArray * showList = [[NSMutableArray alloc] initWithArray:self.listTeams];
    for (NSDictionary *dict in showList) {
        NSLog(@"id=%@",dict[@"id"]);
//        if (![dict[@"id"] isEqualToString:ids]) {
////            [showList removeObject:dict];
//        }
    }
    NSLog(@"showList%lu",(unsigned long)[showList count]);
    int count=[showList count];
//    NSMutableArray *delete = [NSMutableArray alloc];
//    NSString *afterString = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"  z/-"]] componentsJoinedByString:@""];
    stop = [stop stringByReplacingOccurrencesOfString:@"-" withString:@""];
    start = [start stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (ids.length) {
        for (int i=0; i<count; i++) {
            NSDictionary *dict=showList[i];
            NSLog(@"i=%d,id=%@,ids=%@",i,dict[@"id"],ids);
            if ([dict[@"id"] isEqualToString:ids]) {
                NSString * str = dict[@"time"];
                str=[str stringByReplacingOccurrencesOfString:@"-" withString:@""];
                int zuihou=[stop intValue]-[str intValue];
                int kaishi=[str intValue] -[start intValue];
                NSLog(@"最后=%d,开始=%d",zuihou,kaishi);
                if(zuihou>=0&kaishi>=0){
                    NSLog(@"保留,%@,ids=%@",dict[@"id"],ids);
                }else{
                    NSLog(@"移除,%@,ids=%@stop=%d",dict[@"id"],ids,[stop intValue]);
                    [showList removeObjectAtIndex:i];
                    count--;
                    i--;
                }
            }else{
                NSLog(@"移除,%@,ids=%@",dict[@"id"],ids);
                [showList removeObjectAtIndex:i];
                count--;
                i--;
                //            NSNumber * deleteid=[[NSNumber alloc] initWithInt:i];
                //            [delete addObject:deleteid];
            }
        }
    }else{
        for (int i=0; i<count; i++) {
            NSDictionary *dict=showList[i];
//            NSLog(@"i=%d,id=%@,ids=%@",i,dict[@"id"],ids);
            NSString * str = dict[@"time"];
            str=[str stringByReplacingOccurrencesOfString:@"-" withString:@""];
            int zuihou=[stop intValue]-[str intValue];
            int kaishi=[str intValue] -[start intValue];
            NSLog(@"最后=%d,开始=%d",zuihou,kaishi);
            if(zuihou>=0&kaishi>=0){
                NSLog(@"保留,%@,ids=%@",dict[@"id"],ids);
            }else{
                NSLog(@"移除,%@,ids=%@stop=%d",dict[@"id"],ids,[stop intValue]);
                [showList removeObjectAtIndex:i];
                count--;
                i--;
            }
        }
    }
//    for (NSDictionary *dict in showList) {
//        NSLog(@"id=%@",dict[@"id"]);
//    }
//    for (NSNumber * delet in delete) {
//    }
    if ([showList count]==0) {
        self.tableView.separatorStyle = UITableViewCellAccessoryNone;
//        self.buttons.hidden = TRUE ;
        NSDictionary *add = [NSDictionary dictionaryWithObjectsAndKeys:@"查无数据",@"name", nil];
        [showList addObject:add];
    }
    self.listTeams=[[NSArray alloc] initWithArray:showList];
    NSUInteger con = [showList count];
    NSLog(@"%@,%@,%@，%lu",ids,start,stop,(unsigned long)con);
//    [showList writeToFile:@"show.plist" atomically:TRUE];
//    self.listTeams = [[NSArray alloc] initWithContentsOfFile:@"show.plist"];
    [self.tableView reloadData];
}
#pragma mark 传值
- (IBAction)chuanZhi:(id)sender {
    UITableViewCell *UTCell = (UITableViewCell *)[[sender superview] superview];
    NSString *name=  UTCell.textLabel.text;
    NSMutableArray * showList = [[NSMutableArray alloc] initWithArray:self.listTeams];
    NSMutableArray *show=[NSMutableArray arrayWithCapacity:4];
    int con = [showList count];
    for (int i=0; i<con; i++) {
        NSDictionary *dict=showList[i];
        if ([dict[@"name"] isEqualToString:name]) {
            [show addObject:dict[@"id"]];
            [show addObject:dict[@"name"]];
            [show addObject:dict[@"time"]];
            NSString *imagePath = [[NSString alloc] initWithFormat: @"球队图片/%@.png", dict[@"image"]];
            [show addObject:imagePath];
            break;
        }else{
            [showList removeObjectAtIndex:i];
            con--;
            i--;
        }
    }
//    NSLog(@"%@",name);
    for (NSString *abc in showList) {
        NSLog(@"%@",abc);
    }
    NSArray *array= @[@"1",@"tom",@"2019-08-10",@"球队图片/Australia.png"];
    Page2ViewController *page2ViewController=[[Page2ViewController alloc] init];
    Person *p=[[Person alloc] init];
    p.name=@"someOne";
    p.delegate = page2ViewController;
    [p test:show];
//    receive.ids=@"1";
//    receive.name=@"李白";
//    receive.time=@"2019-08-10";
//    receive.imageView=[UIImage imageNamed:@"球队图片/Australia.png"];
//    [self.navigationController pushViewController:receive animated:YES];
    
}


- (IBAction)setStartTime:(id)sender {
//    NSLog(@"选择开始时间");
//    NSDate *selectedDate = self.datePicker.date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSString *dateString = [formatter stringFromDate:selectedDate];
//    self.labels.text = dateString;
//    NSLog(@"开始时间:%@",dateString);
    self.alphaBackgroundView.hidden = NO;
    self.pickerView2.hidden = YES;
    self.pickerView.hidden = NO;
    //如果只需要默认值，则屏蔽这行代码
    [self.pickerView setupPickerViewDataWithDefaultSelectedDate:[NSDate date] dateFormatter:@"yyyy-MM-dd" datePickerMode:SLDatePickerModeDate];
}
- (IBAction)setStopTime:(id)sender {
//    NSLog(@"选择结束时间");
//    NSDate *selectedDate = self.datePicker.date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSString *dateString = [formatter stringFromDate:selectedDate];
//    self.label.text = dateString;
//    NSLog(@"结束时间:%@",dateString);
    self.alphaBackgroundView.hidden = NO;
    self.pickerView.hidden = YES;
    self.pickerView2.hidden = NO;
    //如果只需要默认值，则屏蔽这行代码
    [self.pickerView setupPickerViewDataWithDefaultSelectedDate:[NSDate date] dateFormatter:@"yyyy-MM-dd" datePickerMode:SLDatePickerModeDate];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.pickerView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.alphaBackgroundView);
        make.height.equalTo(@(260.f));
    }];
    
    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.alphaBackgroundView);
        make.height.equalTo(@(260.f));
    }];
    
    [self.topContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alphaBackgroundView);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.height.equalTo(@40.f);
    }];
    
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topContainerView);
        make.right.equalTo(self.topContainerView.mas_right);
        make.width.equalTo(@(60.f));
    }];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.doneButton);
        make.left.equalTo(self.topContainerView.mas_left);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark --设置时间
- (void)doneButtonTapped:(id)sender {
    if (self.pickerView.hidden==NO) {
        NSLog(@"开始时间。。。。。。。。。。");
        NSDate *selectedDate = self.pickerView.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:selectedDate];
        self.labels.text = dateString;
    }else{
        NSLog(@"结束时间。。。。。。。。。。");
        NSDate *selectedDate2 = self.pickerView2.date;
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        NSString *dateString  = [formatter2 stringFromDate:selectedDate2];
        self.label.text = dateString;
    }
    self.alphaBackgroundView.hidden = YES;
    NSLog(@"g.date = %@, a.date = %@", self.pickerView.date, self.pickerView2.date);
}

- (void)cancelButtonTapped:(id)sender {
    self.alphaBackgroundView.hidden = YES;
    NSLog(@"取消选择");
}

#pragma mark - Getter
- (UIView *)alphaBackgroundView {
    if (!_alphaBackgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.28f];
        view.hidden = YES;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonTapped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:recognizer];
        
        _alphaBackgroundView = view;
    }
    
    return _alphaBackgroundView;
}


- (SLGeneralDatePickerView *)pickerView {
    if (!_pickerView) {
        SLGeneralDatePickerView *view = [[SLGeneralDatePickerView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        [self.alphaBackgroundView addSubview:view];
        
        _pickerView = view;
    }
    
    return _pickerView;
}

- (SLGeneralDatePickerView *)pickerView2 {
    if (!_pickerView2) {
        SLGeneralDatePickerView *view = [[SLGeneralDatePickerView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        [self.alphaBackgroundView addSubview:view];
        _pickerView2 = view;
    }
    return _pickerView2;
}

- (UIView *)topContainerView {
    if (!_topContainerView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHex:0x5CACEE];
        [self.alphaBackgroundView addSubview:view];
        _topContainerView = view;
    }
    return _topContainerView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:button];
        _doneButton = button;
    }
    return _doneButton;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:button];
        _cancelButton = button;
    }
    return _cancelButton;
}

@end
