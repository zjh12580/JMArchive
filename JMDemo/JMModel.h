//
//  JMModel.h
//  JMDemo
//
//  Created by zhaojh on 16/10/18.
//  Copyright © 2016年 szkl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject

@property(nonatomic,copy)NSString* pName;

@property(nonatomic,assign)double pHeight;

@end


@interface JMModel : NSObject

@property(nonatomic,copy)NSString* name;

@property(nonatomic,assign)NSInteger age;

@property(nonatomic,assign)BOOL sex;

@property(nonatomic,assign)float height;

@property(nonatomic,strong)Person* person;

@end


