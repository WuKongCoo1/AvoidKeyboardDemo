//
//  WKAvoidKeyboardViewController.m
//  AvoidKeyboardDemo
//
//  Created by 吴珂 on 15/9/9.
//  Copyright (c) 2015年 MyCompany. All rights reserved.
//

#import "WKAvoidKeyboardViewController.h"

#define GetOSVersion [[UIDevice currentDevice].systemVersion floatValue]

#define GetTransformDistance(Distance) (GetOSVersion < 7.1 ? Distance / 2 : Distance)

@interface WKAvoidKeyboardViewController ()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation WKAvoidKeyboardViewController

- (void)searchTextViewWithView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        if ([subview isKindOfClass:[UITextView class]]) {
            ((UITextView *)subview).delegate = self;
        }
        if ([subview isKindOfClass:[UITextField class]]) {
            ((UITextField *)subview).delegate = self;
        }
        [self searchTextViewWithView:subview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self searchTextViewWithView:self.view];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘躲避
- (void)showKeyboard:(NSNotification *)noti
{
    
    self.view.transform = CGAffineTransformIdentity;
    UIView *editView = _editTextView ? _editTextView : _editTextField;
    
    CGRect tfRect = [editView.superview convertRect:editView.frame toView:self.view];
    NSValue *value = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    NSLog(@"%@", value);
    CGRect keyBoardF = [value CGRectValue];
    
    CGFloat animationTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat _editMaxY = CGRectGetMaxY(tfRect);
    CGFloat _keyBoardMinY = CGRectGetMinY(keyBoardF);
    NSLog(@"%f %f", _editMaxY, _keyBoardMinY);
    if (_keyBoardMinY < _editMaxY) {
        CGFloat moveDistance = _editMaxY - _keyBoardMinY;
        [UIView animateWithDuration:animationTime animations:^{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -moveDistance);
        }];
        
    }
}

- (void)hideKeyboard:(NSNotification *)noti
{
    //    NSLog(@"%@", noti);
    self.view.transform = CGAffineTransformIdentity;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _editTextField = textField;
    _editTextView = nil;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _editTextView = textView;
    _editTextField = nil;
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
