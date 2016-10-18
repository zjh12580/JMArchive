//
//  NSObject+JMArchive.m
//  OpenGL_Demo
//
//  Created by zhaojh on 16/10/17.
//  Copyright © 2016年 szkl. All rights reserved.
//

#import "NSObject+JMArchive.h"
#import <objc/runtime.h>
#import <objc/message.h>

//#warning Assign类型的仅支持一下集中基础类型, Strong支持自定义model

#define KAssginAttributes [NSArray arrayWithObjects:@"int",@"NSInteger",@"float",@"BOOL",@"CGFloat",@"double", nil]


@implementation NSObject (JMArchive)

-(NSString*)getIvarType:(NSString*)ivarStr{
    
    if ([ivarStr isEqualToString:@"q"]) {
        return @"NSInteger";
    } else if ([ivarStr isEqualToString:@"d"]) {
        return @"double";
    } else if ([ivarStr isEqualToString:@"B"]) {
        return @"BOOL";
    } else if ([ivarStr isEqualToString:@"i"]) {
        return @"int";
    } else if ([ivarStr isEqualToString:@"f"]) {
        return @"float";
    }
    return @"";
}

-(void)encodeWithCoder: (NSCoder *)coder{
  
    unsigned int ivarCount;
    Ivar* ivars = class_copyIvarList([self class], &ivarCount);
    
    for (unsigned int i = 0; i < ivarCount; i ++) {
        
        const char* ivarCharStr = ivar_getName(ivars[i]);
        
        NSString* ivarStr = [NSString stringWithUTF8String:ivarCharStr];
        
        NSString* str = [ivarStr substringFromIndex:1];

        [coder encodeObject:[self valueForKey:str] forKey:str];
        
    }
}

- (id)initWithCoder: (NSCoder *) coder{

    unsigned int ivarCount;
    Ivar* ivars = class_copyIvarList([self class], &ivarCount);
    
    for (unsigned int i = 0; i < ivarCount; i ++) {
        
        const char* ivarCharStr = ivar_getName(ivars[i]);
        
        NSString* ivarStr = [NSString stringWithUTF8String:ivarCharStr];
        
        NSString* propety = [ivarStr substringFromIndex:1];
        NSString* setStr;
        if (propety.length == 1) {
             setStr = [NSString stringWithFormat:@"set%@:",[propety capitalizedString]];
        }else{
            
            NSString* firstStr = [[propety substringToIndex:1] uppercaseString];
            NSString* lastStr = [propety substringFromIndex:1];
            setStr = [NSString stringWithFormat:@"set%@%@:",firstStr,lastStr];
        }
        
        SEL sel = sel_registerName([setStr UTF8String]);
        
        NSString* ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivars[i])];
        NSString* type = [self getIvarType:ivarType];
        
        if ([KAssginAttributes containsObject:type]) {
           
            if ([type isEqualToString:@"int"] || [type isEqualToString:@"NSInteger"]) {
                
                 objc_msgSend(self, sel,[[coder decodeObjectForKey:propety] integerValue]);
            }else if ([type isEqualToString:@"BOOL"]){
            
                 objc_msgSend(self, sel,[[coder decodeObjectForKey:propety] boolValue]);
            }else if ([type isEqualToString:@"float"]){
                
                objc_msgSend(self, sel,[[coder decodeObjectForKey:propety] floatValue]);
            }else if ([type isEqualToString:@"double"]){
                
                objc_msgSend(self, sel,[[coder decodeObjectForKey:propety] doubleValue]);
            }
            
        }else{
              id per = [coder decodeObjectForKey:propety];
            
              [self setValue:per forKey:propety];
        }
    }

    
    return self;
}

+(NSString*)getPath:(NSString*)pathName{
    
    NSString *docuPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *filePath=[docuPath stringByAppendingPathComponent:pathName];
    return filePath;
}

-(BOOL)jm_archive:(NSString*)pathName{

   return [NSKeyedArchiver archiveRootObject:self toFile:[[self class] getPath:pathName]];
}

+(id)jm_unArchive:(NSString*)pathName{

  return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPath:pathName]];
}

@end
