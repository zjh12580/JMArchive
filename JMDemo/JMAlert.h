//
//  JMAlert.h
//  BusinessManager
//
//  Created by zhaojh on 16/7/26.
//  Copyright © 2016年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSettingModel;

@interface JMAlert : NSObject

+ (instancetype)share;

@property(nonatomic,strong) JMSettingModel* jm_Model;

@end

#pragma mark - 参数配置类

typedef void (^JMCustomLabel)(UILabel* label);
typedef void (^JMCustomBtn)(UIButton* button);
typedef void (^JMCustomBackView)(UIButton* view);
typedef void (^ClickAction)();
typedef JMSettingModel*(^ SettingString)(NSString* string);
typedef JMSettingModel*(^ SettingImagev)(UIImageView* imagev);
typedef JMSettingModel*(^ CustomLabel)(JMCustomLabel customLabelBlock);
typedef JMSettingModel*(^ CustomButton)(JMCustomBtn customBtnBlock);
typedef JMSettingModel*(^ CustomBackView)(JMCustomBackView customBackView);
typedef JMSettingModel*(^ TapAction)(ClickAction action);
typedef JMSettingModel*(^ ShowBlock)();

@interface JMSettingModel : NSObject

@property (nonatomic,copy,readonly) SettingString content;
@property (nonatomic,copy,readonly) SettingString title;
@property (nonatomic,copy,readonly) SettingString comfirmBtnName;
@property (nonatomic,copy,readonly) SettingString cancleBtnName;

@property (nonatomic,copy,readonly) CustomLabel    contentLabel;
@property (nonatomic,copy,readonly) CustomLabel    titleLabel;
@property (nonatomic,copy,readonly) CustomButton   comfirmBtn;
@property (nonatomic,copy,readonly) CustomButton   cancleBtn;
@property (nonatomic,copy,readonly) CustomBackView backView;

@property (nonatomic,copy,readonly) TapAction      comfirmAction;
@property (nonatomic,copy,readonly) TapAction      cancleAction;
@property (nonatomic,copy,readonly) ShowBlock      show;


@end

@interface JMAlertController : UIViewController
@property(nonatomic,strong) UIView* jm_alertView;
@property(nonatomic,strong) JMSettingModel* jm_Model;
@end




