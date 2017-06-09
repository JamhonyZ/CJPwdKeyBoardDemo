//
//  CJPwdKeyBoardManager.h
//  XJCardPro
//
//  Created by 创建zzh on 2017/6/7.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*****
 *    使用示例：（控制器使用）
 *      [[CJPwdKeyBoardManager shareInstance] configKeyBoard:self.view pwdTitle:@"输入服务密码"];
        @weakify(self);
        [CJPwdKeyBoardManager shareInstance].verificationBlock = ^(UITextField *tfd){
         @strongify(self);
         self.pwdText = tfd.text;
         [self startLoadData];
       };
 
        [[CJPwdKeyBoardManager shareInstance] hiddenKeyBoard];
        [[CJPwdKeyBoardManager shareInstance] showKeyBoard];
 *
 *
 *
 **/

typedef void(^RightItemBlock)();

@interface CJPwdKeyBoardManager : NSObject

//单例创建
+(instancetype)shareInstance;

#pragma mark -- StepOne
/**
 *  配置键盘
 *  vc.view
 *  标题
 */

- (void)configKeyBoard:(UIView *)currentView pwdTitle:(NSString *)pwdTitle;

- (void)configRightItem:(NSString *)rightItemTitle RightItemBlock:(RightItemBlock)rightItemBlock;

#pragma mark -- StepTwo
//收起键盘
@property (nonatomic, copy) void(^closeBlock)();

//开始验证
@property (nonatomic, copy) void(^verificationBlock)(UITextField *tfd);

//点击右侧按钮
@property (nonatomic, copy) RightItemBlock rightItemBlock;

#pragma mark -- 可配置
//是否需要密码输入渐变圆点（默认为YES）
@property (nonatomic, assign)BOOL ifNeedAnimate;

//是否需要键盘右上角 控件
@property (nonatomic, copy)NSString *rightItemTitle;

#pragma mark -- 公开方法
//隐藏键盘
- (void)hiddenKeyBoard;

//显示键盘
- (void)showKeyBoard;



@end
