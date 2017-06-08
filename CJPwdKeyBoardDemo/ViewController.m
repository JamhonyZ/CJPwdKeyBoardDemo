//
//  ViewController.m
//  CJPwdKeyBoardDemo
//
//  Created by 创建zzh on 2017/6/8.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "ViewController.h"
#import "CJPwdKeyBoardManager.h"
@interface ViewController ()

@property (nonatomic, strong)UILabel *pwdLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试密码输入";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(50, 128, 50, 50);
    showBtn.backgroundColor = [UIColor redColor];
    [showBtn setTitle:@"弹出" forState:UIControlStateNormal];
    showBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [showBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showKeyBoardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    
    

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.view.frame.size.width-50-50, 128, 50, 50);
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn setTitle:@"收起" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeKeyBoardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    
    _pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 128, self.view.frame.size.width-240, 30)];
    _pwdLabel.backgroundColor = [UIColor whiteColor];
    _pwdLabel.layer.borderColor = [UIColor grayColor].CGColor;
    _pwdLabel.layer.borderWidth = 1;
    _pwdLabel.font = [UIFont systemFontOfSize:18];
    _pwdLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_pwdLabel];
    
    //注册
    [[CJPwdKeyBoardManager shareInstance] configKeyBoard:self pwdTitle:@"测试输入密码"];
    __weak typeof(self) weakSelf = self;
    [CJPwdKeyBoardManager shareInstance].verificationBlock = ^(UITextField *tfd){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.pwdLabel.text = tfd.text;
    };
    
/*
    [CJPwdKeyBoardManager shareInstance].ifNeedAnimate = NO;
    [[CJPwdKeyBoardManager shareInstance] configRightItem:@"忘记密码" RightItemBlock:^{
        NSLog(@"忘记密码");
    }];
*/
}

- (void)showKeyBoardAction {
    [[CJPwdKeyBoardManager shareInstance] showKeyBoard];
}
- (void)closeKeyBoardAction {
    [[CJPwdKeyBoardManager shareInstance] closeBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
