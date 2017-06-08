# CJPwdKeyBoardDemo
简易支付密码键盘
纯代码布局，简易实现6位交易密码的输入。
使用步骤：

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
    [[CJPwdKeyBoardManager shareInstance] showKeyBoard];
    [[CJPwdKeyBoardManager shareInstance] closeBlock];
    */
  

