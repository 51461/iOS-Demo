//
//  Person.h
//  ZuoYe
//
//  Created by 陈统帅 on 2019/9/26.
//  Copyright © 2019 陈统帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;
//定义代理的协议
@protocol PersonDelegate <NSObject>
//可选方法
@optional
-(void)personFindHouse : (NSArray *)array;
//必要方法
@required
@end
NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,weak) id<PersonDelegate> delegate;

-(void) test:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
