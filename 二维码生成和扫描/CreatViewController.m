//
//  CreatViewController.m
//  二维码生成和扫描
//
//  Created by king on 14/12/31.
//  Copyright (c) 2014年 East. All rights reserved.
//

#import "CreatViewController.h"

@interface CreatViewController ()

@end

@implementation CreatViewController

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // 基本设置
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扫描";
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 25)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
      [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.creatStr.frame = CGRectMake(20, 70, self.view.frame.size.width-40, 25);
    [self.view addSubview:self.creatStr];
    
    [self addCodeView];
    
    [self addcodeLabel];
}

#pragma mark - private
- (UITextField *)creatStr
{
    if(_creatStr == nil){
        _creatStr = [[UITextField alloc]initWithFrame:CGRectZero];
        _creatStr.layer.borderWidth=1;
        _creatStr.layer.cornerRadius=5;
        _creatStr.layer.borderColor = [UIColor grayColor].CGColor;
        _creatStr.delegate=self;
        _creatStr.placeholder=@"想要生成二维码字符串";
    }
    return _creatStr;
}

-(void)addCodeView
{
    UIImageView *codeView = [[UIImageView alloc]init];
    codeView.frame = CGRectMake(self.view.frame.size.width*0.1, 100, self.view.frame.size.width*0.8, self.view.frame.size.width*0.8);
    [self.view addSubview:codeView];
    self.codeView = codeView;
    //codeView.layer.borderWidth = 1.0;
    [self creatCode];
    
}

- (void)addcodeLabel
{
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 105+self.view.frame.size.width*0.8, self.view.frame.size.width, 18)];
    //codeLabel.layer.borderWidth = 1.0;
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.text = @"请将二维码对准付款人设备摄像头";
    codeLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:codeLabel];
    
}

-(void)creatCode
{
    UIImage *imgs=[UIImage imageNamed:@"logo"];
    
    self.codeView.image = [QRCodeGenerator qrImageForString:_creatStr.text imageSize:360 Topimg:imgs];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(![_creatStr.text isEqualToString:@""] && _creatStr.text != nil){
        [self creatCode];
    }
}


#pragma mark - target action
-(void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
