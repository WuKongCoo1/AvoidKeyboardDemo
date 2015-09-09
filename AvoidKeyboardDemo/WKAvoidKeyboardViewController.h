//
//  WKAvoidKeyboardViewController.h
//  AvoidKeyboardDemo
//
//  Created by 吴珂 on 15/9/9.
//  Copyright (c) 2015年 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKAvoidKeyboardViewController : UIViewController

@property (nonatomic, strong) UITextField *editTextField;
@property (nonatomic, strong) UITextView *editTextView;

- (void)hideKeyboard:(NSNotification *)noti;
- (void)showKeyboard:(NSNotification *)noti;
- (void)searchTextViewWithView:(UIView *)view;

@end
