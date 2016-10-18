//
//  NSObject+JMArchive.h
//  OpenGL_Demo
//
//  Created by zhaojh on 16/10/17.
//  Copyright © 2016年 szkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JMArchive)

/** 归档 参数是归档的文件名*/
-(BOOL)jm_archive:(NSString*)pathName;

/**解档 参数是归档的文件名*/
+(id)jm_unArchive:(NSString*)pathName;


@end
