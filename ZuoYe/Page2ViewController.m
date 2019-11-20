//
//  Page2ViewController.m
//  ZuoYe
//
//  Created by 陈统帅 on 2019/8/12.
//  Copyright © 2019 陈统帅. All rights reserved.
//

#import "Page2ViewController.h"

@interface Page2ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ids;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)exitPage:(id)sender;
-(void) personFindHouse:(NSArray *)array;
@end

@implementation Page2ViewController
static NSString *i;
static NSString *n;
static NSString *t;
static NSString *img;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ids.text = i;
    self.name.text = n;
    self.time.text = t;
    self.imageView.image =  [UIImage imageNamed:img];
    NSLog(@"%@",self.ids.text);
    NSLog(@"%@",self.ids);
}

-(void) personFindHouse:(NSArray *)array
{
    i=[array objectAtIndex:0];
    n=[array objectAtIndex:1];
    t=[array objectAtIndex:2];
    img=[array objectAtIndex:3];
    NSLog(@"%@,%@,%@,%@",i,n,t,img);
//    for (NSString * a in array) {
//        NSLog(@"%@",a);
//    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
}



- (IBAction)exitPage:(id)sender {
    NSLog(@"返回主视图");
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
