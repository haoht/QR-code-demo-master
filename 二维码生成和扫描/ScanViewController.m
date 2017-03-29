//
//  ScanViewController.m
//  二维码生成和扫描
//
//  Created by king on 14/12/31.
//  Copyright (c) 2014年 East. All rights reserved.
//

#import "ScanViewController.h"
#import "ZBarSDK.h"

#define SCANVIEW_EdgeTop 40.0

#define SCANVIEW_EdgeLeft 50.0

@interface ScanViewController ()<ZBarReaderViewDelegate>
{
    
    UIImageView *_QrCodeline;
    
    NSTimer *_timer;
    
    //设置扫描画面
    UIView *_scanView;
    
    ZBarReaderView *_readerView;
    
    NSString *symbolStr;
    
}

// 闪光灯按钮
@property (nonatomic,strong) UIButton *flashLight;

@end

@implementation ScanViewController

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_readerView start];
    
    [self createTimer];
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
    

    self.flashLight = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.flashLight];
    [self.flashLight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_off.png"] forState:UIControlStateNormal];
    [self.flashLight addTarget:self action:@selector(openLight) forControlEvents:UIControlEventTouchUpInside];
    
    
    //初始化扫描界面
    [self setScanView];
    
    if(!_readerView){
        
        _readerView= [[ZBarReaderView alloc]init];
        _readerView.frame =CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop+54, self.view.frame.size.width-2*SCANVIEW_EdgeLeft,self.view.frame.size.width-2*SCANVIEW_EdgeLeft);
        _readerView.tracksSymbols=NO;
        _readerView.readerDelegate =self;
        [_readerView addSubview:_scanView];
    }
    
    //关闭闪光灯
    _readerView.torchMode =0;
    
    [self.view addSubview:_readerView];
    
    [self drawAngle];
    
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0,_readerView.frame.size.height+50+64, self.view.frame.size.width,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont boldSystemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor blackColor];
    labIntroudction.text=@"请将摄像头对准收款人账户二维码";
    [self.view addSubview:labIntroudction];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_readerView.torchMode ==1) {
        
        _readerView.torchMode =0;
        [self.flashLight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_off.png"] forState:UIControlStateNormal];
        
    }
    
    [self stopTimer];
    
    [_readerView stop];
}

#pragma mark - private
// 画扫描区域四个角
-(void)drawAngle
{
    //上左
    UIImageView *topLeft = [[UIImageView alloc]init];
    topLeft.image = [UIImage imageNamed:@"scan_coremark01"];
    topLeft.frame = CGRectMake(SCANVIEW_EdgeLeft-2, SCANVIEW_EdgeTop-2+55, 22, 22);
    [self.view addSubview:topLeft];
    
    //下左
    UIImageView *bottomLeft = [[UIImageView alloc]init];
    bottomLeft.image = [UIImage imageNamed:@"scan_coremark04"];
    bottomLeft.frame = CGRectMake(SCANVIEW_EdgeLeft-2, self.view.frame.size.width-2*SCANVIEW_EdgeLeft+5+68, 22, 22);
    [self.view addSubview:bottomLeft];
    
    //上右
    UIImageView *topRight = [[UIImageView alloc]init];
    topRight.image = [UIImage imageNamed:@"scan_coremark02"];
    topRight.frame = CGRectMake(self.view.frame.size.width-SCANVIEW_EdgeLeft-20, SCANVIEW_EdgeTop-2+55, 22, 22);
    [self.view addSubview:topRight];
    
    //下右
    UIImageView *bottomRight = [[UIImageView alloc]init];
    bottomRight.image = [UIImage imageNamed:@"scan_coremark03"];
    bottomRight.frame = CGRectMake(self.view.frame.size.width-SCANVIEW_EdgeLeft-20, self.view.frame.size.width-2*SCANVIEW_EdgeLeft+5+68, 22, 22);
    [self.view addSubview:bottomRight];
}

//二维码的扫描区域
- (void)setScanView
{
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0,  self.view.frame.size.width-2*SCANVIEW_EdgeLeft,self.view.frame.size.width-SCANVIEW_EdgeLeft)];
    _scanView.backgroundColor=[UIColor clearColor];
    
    /******************中间扫描区域****************************/
    
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width-2*SCANVIEW_EdgeLeft,self.view.frame.size.width-SCANVIEW_EdgeLeft)];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView.layer.borderColor=[UIColor clearColor].CGColor;
    scanCropView.layer.borderWidth=2.0;
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    
    
    //画中间的基准线
    _QrCodeline = [[UIImageView alloc] initWithFrame:CGRectMake(0,-160, self.view.frame.size.width-2*SCANVIEW_EdgeLeft,(self.view.frame.size.width-2*SCANVIEW_EdgeLeft)/2)];
    _QrCodeline.image = [UIImage imageNamed:@"scan_line"];
    [_scanView addSubview:_QrCodeline];
}


- (void)createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}


- (void)stopTimer
{
    if ([_timer isValid] == YES) {
        
        [_timer invalidate];
        _timer =nil;
    }
}

#pragma mark - ZBarReaderViewDelegate
// 扫描结果
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    symbolStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    
    
    // zbar是日本人开发的，需要将默认的日文编码改为UTF8，否则扫描“坑爹”和“尼玛啊”等会出现乱码
    if ([symbolStr canBeConvertedToEncoding:NSShiftJISStringEncoding])
    {
        symbolStr = [NSString stringWithCString:[symbolStr cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    
    
    //判断是否包含 头"http:'
    NSString *regex =@"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([predicate evaluateWithObject:symbolStr]) {
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示"message:[NSString stringWithFormat:@"该链接可能存在风险\n%@",symbolStr] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"打开链接",nil];
        alertView.tag = 1001;
        [alertView show];
        return;
    }
    
    //如果不是链接 (即文字)
    else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示"message:[NSString stringWithFormat:@"扫描结果:\n%@",symbolStr] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        alertView.tag = 1002;
        [alertView show];
        return;
    }
}

#pragma mark - UIAlertViewDelegate
//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    int tag = (int)alertView.tag;
    
    if(tag == 1001){ //扫描结果:链接
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSURL *_URL = [NSURL URLWithString:symbolStr];
            [[UIApplication sharedApplication] openURL:_URL];
            
        }
    }
    
    if(tag == 1002){ //扫描结果:文字
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - target action
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 打开闪光灯
- (void)openLight
{
    if (_readerView.torchMode ==0) {
        
        _readerView.torchMode =1;
        [self.flashLight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_on.png"] forState:UIControlStateNormal];
        
    }else
    {
        _readerView.torchMode =0;
        [self.flashLight setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_off.png"] forState:UIControlStateNormal];
    }
}

//二维码的横线移动
- (void)moveUpAndDownLine
{
    CGFloat Y=_QrCodeline.frame.origin.y;
    
    if (self.view.frame.size.width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        _QrCodeline.frame=CGRectMake(0,-160, self.view.frame.size.width-2*SCANVIEW_EdgeLeft,(self.view.frame.size.width-2*SCANVIEW_EdgeLeft)/2);
        
    }else if(-160==Y){
        
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:2];
        
        _QrCodeline.frame=CGRectMake(0, self.view.frame.size.width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, self.view.frame.size.width-2*SCANVIEW_EdgeLeft,(self.view.frame.size.width-2*SCANVIEW_EdgeLeft)/2);
        
        [UIView commitAnimations];
    }
}

@end
