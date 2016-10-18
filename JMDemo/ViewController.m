//
//  ViewController.m
//  JMDemo
//
//  Created by zhaojh on 16/10/18.
//  Copyright © 2016年 szkl. All rights reserved.
//

#import "ViewController.h"
#import "JMAlert.h"
#import "NSObject+JMArchive.h"
#import "JMModel.h"

@interface ViewController ()
{
    JMModel* model;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [[JMModel alloc]init];
    model.name = @"heheda";
    model.age = 19;
    model.height = 3.14;
    model.sex = YES;
    
    Person* p = [[Person alloc]init];
    p.pName = @"abc";
    p.pHeight = .618;
    
    model.person = p;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (![model jm_archive:@"model_path"]) {
        
        [JMAlert share].jm_Model
        .title(@"提示")
        .content(@"归档失败!")
        .comfirmBtnName(@"确认");
        
    }else{
        
        JMModel* model2 = [JMModel jm_unArchive:@"model_path"];
        if (!model2) {
            
            [JMAlert share].jm_Model
            .title(@"提示")
            .content(@"解档失败!")
            .cancleBtnName(@"取消").comfirmBtnName(@"确认");
        }else{
            
            [JMAlert share].jm_Model
            .title(@"提示")
            .content(@"友情提示,接档成功!友情提示,接档成功!友情提示,接档成功!")
            .comfirmBtnName(@"OK")
            .cancleBtnName(@"Cancle")
            .comfirmAction(^{
                
                NSLog(@"确认Action....");
            })
            .cancleAction(^{
                NSLog(@"取消Action....");
            }).show();
        }
        
    }

}


@end
