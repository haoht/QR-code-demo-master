//
//  ViewController.m
//  二维码生成和扫描
//
//  Created by king on 14/12/30.
//  Copyright (c) 2014年 East. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"
#import "CreatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码扫描和生成";
    
    self.scanBtn.frame = CGRectMake((self.view.frame.size.width/2-100)/2, self.view.frame.size.height/2, 100, 40);
    [self.view addSubview:self.scanBtn];
    
    self.creatBtn.frame = CGRectMake(self.view.frame.size.width/2+(self.view.frame.size.width/2-100)/2, self.view.frame.size.height/2, 100, 40);
    [self.view addSubview:self.creatBtn];
}


- (UIButton *)scanBtn
{
    if(_scanBtn == nil){
        _scanBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _scanBtn.layer.borderWidth = 1;
        _scanBtn.layer.cornerRadius = 5;
        _scanBtn.layer.borderColor = [UIColor blueColor].CGColor;
        [_scanBtn addTarget:self action:@selector(scanOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _scanBtn;
}

- (UIButton *)creatBtn
{
    if(_creatBtn == nil){
        _creatBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_creatBtn setTitle:@"生成" forState:UIControlStateNormal];
        [_creatBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _creatBtn.layer.borderWidth = 1;
        _creatBtn.layer.cornerRadius = 5;
        _creatBtn.layer.borderColor = [UIColor blueColor].CGColor;
        [_creatBtn addTarget:self action:@selector(creatOnclick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _creatBtn;

}


-(void)scanOnclick
{
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:scanVC ] animated:YES completion:nil];
    
//    [self presentViewController:[UINavigationController alloc] initWithRootViewController:[[ScanViewController alloc]init]] animated:YES completion:nil];
}

-(void)creatOnclick
{
     CreatViewController *creatVC = [[CreatViewController alloc] init];
    
    [self.navigationController pushViewController:creatVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
