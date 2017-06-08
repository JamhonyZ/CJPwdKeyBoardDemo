//
//  CJPwdKeyBoardManager.m
//  XJCardPro
//
//  Created by 创建zzh on 2017/6/7.
//  Copyright © 2017年 cjzzh. All rights reserved.
//

#import "CJPwdKeyBoardManager.h"
#import "UIView+Frame.h"
#import "UIButton+EnlargeEdge.h"

#pragma mark --- 宏
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


#define KCJScreenWidth [UIScreen mainScreen].bounds.size.width
#define KCJScreenHeight [UIScreen mainScreen].bounds.size.height
#define KCJScreenBounds [UIScreen mainScreen].bounds

// 设置颜色 示例：UIColorHex(0x26A7E8)
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kFontSizeUse(num) [UIFont fontWithName:@"PingFangSC-Regular" size:num]

#pragma mark -- 键盘

@interface CJPwdKeyBoardManager ()

@property (nonatomic,strong)UIViewController *currentVC;
//键盘标题
@property (nonatomic, copy) NSString *pwdTitle;
//密码框数组
@property (nonatomic,strong)NSMutableArray *pswLabelArr;
//已输入密码长度
@property (nonatomic,assign)NSInteger lastCount;
//键盘持有者
@property (nonatomic, strong)UITextField *tfd;
//背景
@property (nonatomic, strong)UIView *maskBgView;
//密码框
@property (nonatomic, strong)UIView *keyBoardView;

@end

@implementation CJPwdKeyBoardManager

+(instancetype)shareInstance {
    static CJPwdKeyBoardManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CJPwdKeyBoardManager alloc] init];
    });
    return instance;
}

- (void)configKeyBoard:(UIViewController *)vc pwdTitle:(NSString *)pwdTitle{
    
    //初始化配置
    _lastCount = 0;
    
    _ifNeedAnimate = YES;
    
    _pwdTitle = pwdTitle;
    
    self.currentVC = vc;
    
    //创建
    [self creatView];

    [vc.view addSubview:self.tfd];
}


#pragma mark -- View
- (void)creatView {
    
    //每次进来确保 重新创建控件
    [self.keyBoardView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [self.keyBoardView removeFromSuperview];
    self.keyBoardView = nil;
    
    
    self.keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, _currentVC.view.bottom, _currentVC.view.size.width,  55+60+54)];
    self.keyBoardView.backgroundColor = UIColorHex(0xEBEBEB);
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"card_mng_close"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:UIColorHex(0xB4B4B4) forState:UIControlStateNormal];
    [closeBtn setEnlargeEdge:5];
    closeBtn.frame = CGRectMake(12, 22, 15, 15);
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.keyBoardView addSubview:closeBtn];
    
    
    //标题文本
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.keyBoardView.width-160, 55)];
    titleLabel.text = self.pwdTitle;
    titleLabel.textColor = UIColorHex(0x333333);
    titleLabel.font = kFontSizeUse(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.keyBoardView addSubview:titleLabel];
    
    
    //密码输入框背景
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, self.keyBoardView.width, 60+54)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.keyBoardView addSubview:bottomView];
    
    
    self.pswLabelArr = @[].mutableCopy;
    //创建密码框
    CGFloat kLrSpace = 12;  //两边间距
    CGFloat itemW = (self.keyBoardView.width-kLrSpace*2)/6;  //输入框每一格长度
    for (int i = 0; i<6; i++) {
        UILabel *label  = [UILabel new];
        label.font = kFontSizeUse(18);
        label.frame = CGRectMake(kLrSpace+i*itemW, 27, itemW, itemW);
        label.tag = 100+i;
        label.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:label];
        [label addSubview:[self getLineView:CGRectMake(label.width-1, 0, 1, label.height) color:nil]];
        if (i == 0) {
            [bottomView addSubview:[self getLineView:CGRectMake(label.left, label.top, 1, label.height) color:nil]];
            [bottomView addSubview:[self getLineView:CGRectMake(label.left, label.top, (KCJScreenWidth-2*kLrSpace), 1) color:nil]];
            [bottomView addSubview:[self getLineView:CGRectMake(label.left, label.bottom-1, (KCJScreenWidth-2*kLrSpace), 1) color:nil]];
        }
        [self.pswLabelArr addObject:label];
    }
}

- (UIView *)getLineView:(CGRect)frame color:(UIColor *)color{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = (color == nil ? [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:0.5]: color );
    return line;
}

- (void)setRightItemTitle:(NSString *)rightItemTitle {
    _rightItemTitle = rightItemTitle;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.keyBoardView.width-80, 0, 70, 55);
    [rightBtn setTitle:rightItemTitle forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFontSizeUse(14);
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(clickRightItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.keyBoardView addSubview:rightBtn];
}
- (void)configRightItem:(NSString *)rightItemTitle RightItemBlock:(RightItemBlock)rightItemBlock {
    self.rightItemTitle = rightItemTitle;
    self.rightItemBlock = [rightItemBlock copy];
}
#pragma mark -- tfNoti
- (void)didChangedEditing {
    
    if (_tfd.text.length == 6) {
        //开始验证支付密码
        [self configPsd:_tfd.text];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.verificationBlock) {
                self.verificationBlock(_tfd);
            }
        });
        return;
    }
    
    
    NSString *completeStr;
    if (_tfd.text.length>6) {
        //输入长度超过 6位(暂时不走这个判断)
        NSString *str0 = [_tfd.text substringToIndex:5];
        NSString *str1 = [_tfd.text substringFromIndex:_tfd.text.length-1];
        completeStr = [NSString stringWithFormat:@"%@%@",str0,str1];
    } else {
        completeStr = _tfd.text;
    }
    
    _tfd.text = completeStr;
    [self configPsd:_tfd.text];
}

- (void)didEditing {
    [self.maskBgView removeFromSuperview];
    self.tfd.inputAccessoryView = nil;
    self.tfd.text = @"";
    [self configPsd:_tfd.text];
}

#pragma mark -- Action
- (void)closeAction {
    [self hiddenKeyBoard];
}
- (void)clickRightItemAction {
    if (![_rightItemTitle isEqualToString:@""] && self.rightItemBlock) {
        self.rightItemBlock();
    }
}
- (void)showKeyBoard {
    
    self.tfd.inputAccessoryView = self.keyBoardView;
    [[UIApplication sharedApplication].delegate.window addSubview:self.maskBgView];
    [self.tfd becomeFirstResponder];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedEditing) name:UITextFieldTextDidChangeNotification object:_tfd];
}

- (void)hiddenKeyBoard {
    
    self.tfd.inputAccessoryView = nil;
    self.tfd.text = @"";
    [self configPsd:self.tfd.text];
    [self.maskBgView removeFromSuperview];
    self.maskBgView = nil;
    [self.tfd resignFirstResponder];
    
    if (self.closeBlock) {
        self.closeBlock();
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_tfd];
}


-(void)configPsd:(NSString *)text {
    
    if (text.length == 0) {
        _lastCount = 0;
        for (UILabel *lbl in self.pswLabelArr) {
            lbl.text = @"";
        }
        return;
    }
    
    NSMutableArray *psdNumArr = @[].mutableCopy;
    for (int i =0 ; i<text.length; i++) {
        [psdNumArr addObject:[text substringWithRange:NSMakeRange(i, 1)]];
    }
    
   NSLog(@"当前密码:%@",psdNumArr);
    
    NSTimeInterval deley = _ifNeedAnimate ? 0.3 : 0;
    
    for (int i = 0; i<psdNumArr.count; i++) {
        UILabel *lbl = self.pswLabelArr[i];
        
        //只有一个数
        if (i == 0 && psdNumArr.count == 1 && _lastCount == 0) {
            lbl.text = psdNumArr[i];
            [self performSelector:@selector(confitStarTitle:) withObject:lbl afterDelay:deley];
        } else {
            //连续输入
            if (i == text.length-1 && _lastCount<psdNumArr.count) {
                //末位 为 递增
                lbl.text = psdNumArr[i];
                [self performSelector:@selector(confitStarTitle:) withObject:lbl afterDelay:deley];
            } else {
                lbl.text = @"●";
            }
        }
    }
    
    //上一次长度
    _lastCount = psdNumArr.count;
    
    
    //未填写的密码键 输入空字符串
    for (NSUInteger i = psdNumArr.count; i<6; i++) {
        UILabel *lbl = self.pswLabelArr[i];
        lbl.text = @"";
    }
}
- (void)confitStarTitle:(UILabel *)lbl {
    lbl.text = @"●";
}
#pragma mark -- LazyLoad
- (UITextField *)tfd {
    if (!_tfd) {
        _tfd = [[UITextField alloc] initWithFrame:CGRectMake(0, -10,KCJScreenWidth, 10)];
        

        _tfd.keyboardType = UIKeyboardTypeNumberPad;
        
        _tfd.returnKeyType = UIReturnKeyDone;
        
        _tfd.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _tfd.secureTextEntry = YES;
    }
    return _tfd;
}
- (UIView *)maskBgView {
    if (!_maskBgView) {
        _maskBgView = [[UIView alloc] initWithFrame:KCJScreenBounds];
        _maskBgView.backgroundColor = [UIColor colorWithRed:149/255.0f green:149/255.0f blue:149/255.0f alpha:0.5];
        
    }
    return _maskBgView;
}
@end
