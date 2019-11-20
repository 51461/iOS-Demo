//
//  Person.m
//  ZuoYe
//
//  Created by 陈统帅 on 2019/9/26.
//  Copyright © 2019 陈统帅. All rights reserved.
//

#import "Person.h"

@implementation Person
-(void) test:(NSArray *)array
{
    NSLog(@"代理方法测试。。。");
    if ([self.delegate respondsToSelector:@selector(personFindHouse:)]) {
        [self.delegate personFindHouse:array];
        
    }
}
@end
