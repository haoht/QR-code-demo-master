//
//  CreatViewController.h
//  二维码生成和扫描
//
//  Created by king on 14/12/31.
//  Copyright (c) 2014年 East. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeGenerator.h"

@interface CreatViewController : UIViewController<UITextFieldDelegate>


//输入框
@property (strong, nonatomic) UITextField *creatStr;
//二维码视图
@property (strong, nonatomic) UIImageView *codeView;
@end
