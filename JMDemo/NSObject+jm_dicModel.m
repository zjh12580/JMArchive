//
//  NSObject+jm_dicModel.m
//  JMDemo
//
//  Created by zhaojh on 16/10/18.
//  Copyright © 2016年 szkl. All rights reserved.
//

#import "NSObject+jm_dicModel.h"
#import <objc/runtime.h>

@implementation NSObject (jm_dicModel)

+(instancetype)objectWithDic:(NSDictionary*)pramsDic{
    
    id objc = [[self alloc]init];
    
    unsigned int ivarCount;
    Ivar* ivarList = class_copyIvarList(self, &ivarCount);
    
    for (unsigned int i = 0; i < ivarCount; i ++) {
        
        Ivar ivar = ivarList[i];
        
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // @\"User\" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        // 获取key
        NSString *key = [ivarName substringFromIndex:1];
        
        // 去字典中查找对应value
        // key:user  value:NSDictionary
        
        id value = pramsDic[key];
        
        // 二级转换:判断下value是否是字典,如果是,字典转换层对应的模型
        // 并且是自定义对象才需要转换
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            // 字典转换成模型 userDict => User模型
            // 转换成哪个模型
            
            // 获取类
            Class modelClass = NSClassFromString(ivarType);
            
            value = [modelClass objectWithDic:value];
        }
        
        // 给模型中属性赋值
        if (value) {
            [objc setValue:value forKey:key];
        }
        
    }
    
    
    return objc;
}


@end
