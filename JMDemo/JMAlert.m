//
//  JMAlert.m
//  BusinessManager
//
//  Created by zhaojh on 16/7/26.
//  Copyright © 2016年 cmcc. All rights reserved.
//

#import "JMAlert.h"
#import "UIColor+Hex.h"
#import <objc/runtime.h>

#define ALERTVIEW_WIDTH  290
#define TOP_SPACE     7
#define SENDER_TOP_SPACE 5
#define TITLE_HEIGHT  25
#define SENDER_HEIGHT 40
#define CONTENT_SPACE 10
#define HexColor(str)      [UIColor colorWithHexString:str]

@interface JMAlert ()

@property(nonatomic,strong) JMAlertController* jm_alertVC;

@end

@implementation JMAlert

+ (instancetype)share{
    static JMAlert *alert = nil;
    if (alert == nil) {
        alert = [[self allocWithZone:nil] init];
    }
    return alert;
}

-(JMSettingModel *)jm_Model{
    
    if (!_jm_Model) {
        
        _jm_Model = [[JMSettingModel alloc]init];
    }
    return _jm_Model;
}

-(void)jm_show{
    
    [self presentViewController:self.jm_alertVC];
    
}
-(void)jm_hiden{
    
    __weak typeof(self) weakSelf = self;
    [self.jm_alertVC dismissViewControllerAnimated:YES completion:^{
        
        weakSelf.jm_alertVC.jm_alertView = nil;
        weakSelf.jm_alertVC = nil;
    }];
    
}

-(void)presentViewController:(JMAlertController*)vc{
    
    UIViewController* currectVC = [self getCurrectController];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [currectVC presentViewController:vc animated:NO completion:^{
            
            vc.jm_alertView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
            vc.jm_alertView.alpha = 0.0;
            [vc.view setBackgroundColor:[UIColor clearColor]];
            vc.jm_alertView.hidden = NO;
            [UIView animateWithDuration:.25 animations:^{
                [vc.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
                vc.jm_alertView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                vc.jm_alertView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        currectVC.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        [currectVC.view.window.rootViewController presentViewController:vc animated:NO completion:^{
            vc.jm_alertView.transform = CGAffineTransformMakeScale(.1f, .1f);
            vc.jm_alertView.hidden = NO;
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.3f];
            vc.jm_alertView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
            vc.jm_alertView.alpha = 1.0;
            [UIView commitAnimations];
        }];
    }
}

- (UIViewController *)getCurrectController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}
-(JMAlertController *)jm_alertVC{
    
    if (!_jm_alertVC) {
        _jm_alertVC = [[JMAlertController alloc]init];
        _jm_alertVC.jm_Model = _jm_Model;
    }
    return _jm_alertVC;
}
-(void)dealloc{
    
    _jm_Model = nil;
    _jm_alertVC = nil;
}
@end

@interface JMSettingModel ()

@property(nonatomic,copy) NSString* jm_content;
@property(nonatomic,copy) NSString* jm_title;
@property(nonatomic,copy) NSString* jm_comfirmBtnName;
@property(nonatomic,copy) NSString* jm_cancleBtnName;

@property(nonatomic,copy) JMCustomBtn jm_comfirmBtnBlock;
@property(nonatomic,copy) JMCustomBtn jm_cancleBtnBlock;
@property(nonatomic,copy) JMCustomLabel jm_titleLabelBlock;
@property(nonatomic,copy) JMCustomLabel jm_ContentLabelBlock;
@property(nonatomic,copy) JMCustomLabel jm_backViewBloick;

@property(nonatomic,copy) ClickAction jm_comfirmAction;
@property(nonatomic,copy) ClickAction jm_cancleAction;

@end

@implementation JMSettingModel

-(SettingString)content{
    __weak typeof(self) weakSelf = self;
    return ^(NSString* content){
        
        _jm_content = content;
        
        return weakSelf;
    };
}

-(SettingString)title{
    __weak typeof(self) weakSelf = self;
    return ^(NSString* title){
        
        _jm_title = title;
        
        return weakSelf;
    };
}

-(SettingString)comfirmBtnName{
    __weak typeof(self) weakSelf = self;
    return ^(NSString* comfirmBtnName){
        
        _jm_comfirmBtnName = comfirmBtnName;
        
        return weakSelf;
    };
}

-(SettingString)cancleBtnName{
    __weak typeof(self) weakSelf = self;
    return ^(NSString* cancleBtnName){
        
        _jm_cancleBtnName = cancleBtnName;
        
        return weakSelf;
    };
}

-(CustomButton)comfirmBtn{
    __weak typeof(self) weakSelf = self;
    return ^(void(^JMCustomBtn)(UIButton* comfirmBtn)){
        
        _jm_comfirmBtnBlock = JMCustomBtn;
        
        return weakSelf;
    };
}

-(CustomButton)cancleBtn{
    __weak typeof(self) weakSelf = self;
    return ^(void(^JMCustomBtn)(UIButton* cancleBtn)){
        
        _jm_cancleBtnBlock = JMCustomBtn;
        
        return weakSelf;
    };
}

-(CustomLabel)contentLabel{
    __weak typeof(self) weakSelf = self;
    return ^(void(^JMCustomLabel)(UILabel* contentLabel)){
        
        _jm_ContentLabelBlock = JMCustomLabel;
        
        return weakSelf;
    };
}

-(CustomLabel)titleLabel{
    __weak typeof(self) weakSelf = self;
    return ^(void(^JMCustomLabel)(UILabel* titleLabel)){
        
        _jm_titleLabelBlock = JMCustomLabel;
        
        return weakSelf;
    };
}

-(CustomBackView)backView{
    __weak typeof(self) weakSelf = self;
    return ^(void(^JMCustomBackView)(UIView* view)){
        
        _jm_backViewBloick = JMCustomBackView;
        
        return weakSelf;
    };
}

-(TapAction)comfirmAction{
    __weak typeof(self) weakSelf = self;
    return ^(ClickAction action){
        
        _jm_comfirmAction = action;
        
        return weakSelf;
    };
}
-(TapAction)cancleAction{
    __weak typeof(self) weakSelf = self;
    return ^(ClickAction action){
        
        _jm_cancleAction = action;
        
        return weakSelf;
    };
}
-(ShowBlock)show{
    __weak typeof(self) weakSelf = self;
    return ^{
        [[JMAlert share] jm_show];
        return weakSelf;
    };
}

@end



@interface JMAlertController ()
@property(nonatomic,assign) CGFloat contentHeight;
@property(nonatomic,assign) CGFloat maxHeight;
@property(nonatomic,strong) UILabel* titleLabel;
@property(nonatomic,strong) UILabel* contentLabel;
@property(nonatomic,strong) UIButton* comfirmBtn;
@property(nonatomic,strong) UIButton* cancleBtn;
@end

@implementation JMAlertController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   //拦截事件
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self settingSubViews];
    
    self.jm_alertView.frame = CGRectMake(0, 0, ALERTVIEW_WIDTH, self.maxHeight);
    
    self.jm_alertView.center = self.view.center;
    
    [self.view addSubview:self.jm_alertView];
    
}

-(void)settingSubViews{
    //title
    if (self.jm_Model.jm_title) {
        
        self.titleLabel = [self getTitleLabel:self.jm_Model.jm_title];
        
        if (self.jm_Model.jm_titleLabelBlock) {
            
            self.jm_Model.jm_titleLabelBlock(self.titleLabel);
        }
    }else if (self.jm_Model.jm_titleLabelBlock){
        
        self.titleLabel = [self getTitleLabel:nil];
        self.jm_Model.jm_titleLabelBlock(self.titleLabel);
    }
    //content
    if (self.jm_Model.jm_content) {
        
        self.contentLabel = [self getContentLabel:self.jm_Model.jm_content];
        
        if (self.jm_Model.jm_ContentLabelBlock) {
            
            self.jm_Model.jm_ContentLabelBlock( self.contentLabel );
        }
    }else if (self.jm_Model.jm_ContentLabelBlock){
        
        self.contentLabel = [self getContentLabel:nil];
        self.jm_Model.jm_ContentLabelBlock(self.contentLabel);
    }
    //sender
    if (self.jm_Model.jm_comfirmBtnName) {
        
        self.comfirmBtn = [self getSender:YES name:self.jm_Model.jm_comfirmBtnName];
        
        if (self.jm_Model.jm_comfirmBtnBlock) {
            
            self.jm_Model.jm_comfirmBtnBlock( self.comfirmBtn);
        }
    }else if (self.jm_Model.jm_comfirmBtnBlock){
        
        self.comfirmBtn = [self getSender:YES name:nil];
        self.jm_Model.jm_comfirmBtnBlock(self.comfirmBtn);
    }
    
    if (self.jm_Model.jm_cancleBtnName) {
        
        self.cancleBtn = [self getSender:NO name:self.jm_Model.jm_cancleBtnName];
        
        if (self.jm_Model.jm_cancleBtnBlock) {
            
            self.jm_Model.jm_cancleBtnBlock( self.cancleBtn);
        }
    }else if (self.jm_Model.jm_cancleBtnBlock){
        
        self.cancleBtn = [self getSender:NO name:nil];
        self.jm_Model.jm_cancleBtnBlock(self.cancleBtn);
    }
    //sender layout
    if (self.comfirmBtn) {
        
        if (self.cancleBtn) {
            
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame)+ SENDER_TOP_SPACE + 1, ALERTVIEW_WIDTH/2, SENDER_HEIGHT);
            self.comfirmBtn.frame = CGRectMake(ALERTVIEW_WIDTH/2, self.cancleBtn.frame.origin.y, ALERTVIEW_WIDTH/2, SENDER_HEIGHT);
            self.maxHeight = CGRectGetMaxY(self.comfirmBtn.frame);
            [self.jm_alertView addSubview:self.cancleBtn];
            [self.jm_alertView addSubview:self.comfirmBtn];
        }else{
            self.comfirmBtn.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame)+ SENDER_TOP_SPACE+1, ALERTVIEW_WIDTH, SENDER_HEIGHT);
            self.maxHeight = CGRectGetMaxY(self.comfirmBtn.frame);
            [self.jm_alertView addSubview:self.comfirmBtn];
        }
    }else{
        if (self.cancleBtn) {
            
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame)+ SENDER_TOP_SPACE+1, ALERTVIEW_WIDTH, SENDER_HEIGHT);
            self.maxHeight = CGRectGetMaxY(self.cancleBtn.frame);
            [self.jm_alertView addSubview:self.cancleBtn];
        }else{
            
            self.maxHeight = CGRectGetMaxY(self.contentLabel.frame);
        }
    }
}

-(UILabel*)getTitleLabel:(NSString*)title{
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TOP_SPACE, ALERTVIEW_WIDTH, TITLE_HEIGHT)];
    titleLabel.text = title.length > 0? title:@"提示";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = 1;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.jm_alertView addSubview:titleLabel];
    
    return titleLabel;
}
-(UILabel*)getContentLabel:(NSString*)content{
    
    if (content.length == 0) {
        content = @"\n";
    }
    NSMutableParagraphStyle *paragrap = [[NSMutableParagraphStyle alloc]init];
    paragrap.lineBreakMode = NSLineBreakByWordWrapping;
    paragrap.lineSpacing = 5;
    NSDictionary* attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                NSForegroundColorAttributeName:[UIColor blackColor],
                                NSParagraphStyleAttributeName: paragrap
                                };
    
    self.contentHeight = [[content stringByAppendingString:@""] boundingRectWithSize:CGSizeMake(ALERTVIEW_WIDTH - CONTENT_SPACE*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
    
    CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
    if (!self.titleLabel) {
        y = TOP_SPACE + 3;
    }
    UILabel* contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CONTENT_SPACE, y , ALERTVIEW_WIDTH - CONTENT_SPACE*2, self.contentHeight)];
    contentLabel.text = content.length > 0? content:@"";
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.textAlignment = 1;
    contentLabel.numberOfLines = 0;
    contentLabel.backgroundColor = [UIColor clearColor];
    [self.jm_alertView addSubview:contentLabel];
    
    return contentLabel;
}
-(UIButton*)getSender:(BOOL)isComfirm name:(NSString*)btnName{
    
    UIButton* sender = [UIButton buttonWithType:UIButtonTypeCustom];
    [sender setTitle:btnName == nil ? @"": btnName forState:UIControlStateNormal];
    [sender setTitleColor:isComfirm==YES? HexColor(@"#3399FF"):HexColor(@"#CC3333") forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    [sender addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    [sender.layer setBorderWidth:0.5f];
    
    [sender.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor];
    [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sender setBackgroundImage:[self getImageWithColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2f]] forState:UIControlStateHighlighted];
    sender.tag = isComfirm == YES? 98 : 99;
    
    return sender;
}
- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)senderClick:(UIButton*)sender{
    
    if (sender.tag == 98 && self.jm_Model.jm_comfirmAction) {
        
        self.jm_Model.jm_comfirmAction();
        
    }else if (self.jm_Model.jm_cancleAction) {
        
        self.jm_Model.jm_cancleAction();
    }
    [[JMAlert share] jm_hiden];
}

-(UIView *)jm_alertView{
    
    if (!_jm_alertView) {
        
        _jm_alertView = [[UIView alloc]initWithFrame:CGRectZero];
        _jm_alertView.backgroundColor = [UIColor colorWithWhite:1 alpha:.96];
        _jm_alertView.layer.cornerRadius = 10;
        _jm_alertView.clipsToBounds = YES;
        _jm_alertView.hidden = YES;
    }
    return _jm_alertView;
}

-(void)dealloc{
    
    _jm_alertView = nil;
}

@end


