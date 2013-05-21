//
//  ImageCompressViewController.m
//  FlashApp
//
//  Created by 朱广涛 on 13-5-13.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "ImageCompressViewController.h"
#import "UserSettings.h"
#import "ASIHTTPRequest.h"
#import "TwitterClient.h"
#import "NSString+SBJSON.h"
#import "MBProgressHUD.h"
//用于在图片上轻扫时判断距离
#define HORIZ_SWIPE_DRAG_MIN    100
#define VERT_SWIPE_DRAG_MIN     50

@interface ImageCompressViewController ()

@end

@implementation ImageCompressViewController

- (void)dealloc {
    [_compressImgView release];
    [_changeGrayLine release];
    [_changeBlueLine release];
    [_btnBgView release];
    [_noCompressBtn release];
    [_imgHeightBtn release];
    [_imgMiddleBtn release];
    [_imgLowBtn release];
    [_saveBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCompressImgView:nil];
    [self setChangeGrayLine:nil];
    [self setChangeBlueLine:nil];
    [self setBtnBgView:nil];
    [self setNoCompressBtn:nil];
    [self setImgHeightBtn:nil];
    [self setImgMiddleBtn:nil];
    [self setImgLowBtn:nil];
    [self setSaveBtn:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserSettings *user = [AppDelegate getAppDelegate].user;
    picLevel =  user.pictureQsLevel;
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToLeft)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.compressImgView addGestureRecognizer:leftGesture];
    [leftGesture release];
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToRight)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.compressImgView addGestureRecognizer:rightGesture];
    [rightGesture release];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (picLevel == PIC_ZL_NOCOMPRESS) {
        [self buttonPressed:self.noCompressBtn];
    }else if (picLevel == PIC_ZL_HIGH){
        [self buttonPressed:self.imgHeightBtn];
    }else if (picLevel == PIC_ZL_MIDDLE){
        [self buttonPressed:self.imgMiddleBtn];
    }else if (picLevel == PIC_ZL_LOW){
        [self buttonPressed:self.imgLowBtn];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveToRight
{
    
    if (sel_btn_tag == 4 ) {
        sel_btn_tag = 1;
    }else if (sel_btn_tag == 3){
        sel_btn_tag =3;
    }else{
        sel_btn_tag ++;
    }
    UIButton *btn = (UIButton *)[self.btnBgView viewWithTag:sel_btn_tag];
    [self buttonPressed:btn];
    
}

- (void)moveToLeft
{
    if (sel_btn_tag == 1 ) {
        sel_btn_tag = 4;
    }else if (sel_btn_tag == 4){
        sel_btn_tag = 4;
    }else{
        sel_btn_tag -- ;
    }
    UIButton *btn = (UIButton *)[self.btnBgView viewWithTag:sel_btn_tag];
    [self buttonPressed:btn];
}

-(IBAction)buttonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    
    sel_btn_tag = tag;
    
    UserSettings *user = [AppDelegate getAppDelegate].user;
    
    switch (tag) {
        case 0:
            //返回按钮
            if (user.pictureQsLevel != picLevel) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未保存，确定不保存修改吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = CAN_SAVE;
                [alert show];
                [alert release];
            }else{
                picLevel = user.pictureQsLevel;
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case 1:
            //压缩质量高按钮
            self.compressImgView.image = [UIImage imageNamed:@"image_gaozhiliang.png"];
            picLevel = PIC_ZL_HIGH;
            qs = 2;
            break;
        case 2:
            //压缩质量中按钮
            self.compressImgView.image = [UIImage imageNamed:@"image_zhongzhiliang.png"];
            picLevel = PIC_ZL_MIDDLE;
            qs = 1;
            break;
        case 3:
            //压缩质量低按钮
            self.compressImgView.image = [UIImage imageNamed:@"image_dizhiliang.png"];
            picLevel = PIC_ZL_LOW;
            qs = 0 ;
            break;
        case 4:
            //不压缩按钮
            self.compressImgView.image = [UIImage imageNamed:@"image_noc.png"];
            picLevel = PIC_ZL_NOCOMPRESS;
            qs = 3;
            break;
        default:
            break;
    }
    [self changeBtnEnable:btn];
}

- (IBAction)saveBtnPressed:(id)sender
{
    Reachability *reach = [Reachability reachabilityWithHostName:P_HOST];
    if ([reach currentReachabilityStatus] == NotReachable) {
        [AppDelegate showAlert:@"网络链接异常，请查看网络。"];
        return;
    }
    
    MBProgressHUD *mbhud = [[MBProgressHUD alloc] initWithView:self.view];
    mbhud.mode = MBProgressHUDModeText;
    mbhud.labelText = @"正在设置，请稍后...";
    [mbhud show:YES];
    [self.view addSubview:mbhud];
    [mbhud release];
    
    UserSettings *user = [AppDelegate getAppDelegate].user;
    NSString *url = [NSString stringWithFormat:@"%@/%@.json?misc=%d&host=%@&port=%d",
                     API_BASE, API_SETTING_IMAGE_QUALITY, qs,
                     user.proxyServer, user.proxyPort];
    url = [TwitterClient composeURLVerifyCode:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeOutSeconds:10];
    [request setCompletionBlock:^{

        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
        if ([[dic objectForKey:@"code"]intValue] == 200) {
            //图片质量改变请求服务器成功后做操作
            user.pictureQsLevel = picLevel;
            [UserSettings savePictureQsLevel:picLevel];
            [self setSaveBtnStatus];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            mbhud.labelText = @"设置成功";
            [self performSelector:@selector(hiddenHUB:) withObject:mbhud afterDelay:1];
        }else{
            mbhud.labelText = @"~~(>_<)~~出错了，请重试！";
            [self performSelector:@selector(hiddenHUB:) withObject:mbhud afterDelay:1];
        }
    }];
    [request setFailedBlock:^{
        mbhud.labelText = @"~~(>_<)~~出错了，请重试！";
        [self performSelector:@selector(hiddenHUB:) withObject:mbhud afterDelay:1];
    }];
    [request startAsynchronous];
}

- (void)hiddenHUB:(MBProgressHUD *)mbhud
{
    [mbhud hide:YES];
}

//设置按钮状态
- (void)changeBtnEnable:(UIButton *) selBtn
{
    CGFloat selBtnX;
    CGRect rect = self.changeBlueLine.frame;
    for (int i = 1 ;  i <=4 ; i++) {
        UIButton *btn = (UIButton *)[self.btnBgView viewWithTag:i];
        if (btn.tag == selBtn.tag) {
            btn.enabled = NO;
            selBtnX = btn.frame.origin.x;
            [UIView animateWithDuration:0.2 animations:^{
                self.changeBlueLine.frame = CGRectMake(selBtnX, rect.origin.y, rect.size.width, rect.size.height);
            }];
        }else{
            btn.enabled = YES;
        }
    }
    [self setSaveBtnStatus];
}

- (void)setSaveBtnStatus
{
    //设置保存按钮的状态
    UserSettings *user = [AppDelegate getAppDelegate].user;
    if (user.pictureQsLevel == picLevel) {
        self.saveBtn.enabled = NO;
    }else{
        self.saveBtn.enabled = YES;
    }
}

#pragma mark -- Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CAN_SAVE) {
        if (buttonIndex==1) {
            UserSettings *user = [UserSettings currentUserSettings];
            picLevel = user.pictureQsLevel;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -- View Touch method
/**
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    starPoint = [touch locationInView:self.compressImgView];
//    NSLog(@"starPoint is %f",starPoint.x);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    endPoint = [touch locationInView:self.compressImgView];
//    NSLog(@"starPoint is %f",endPoint.x);

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    CGPoint endPoint = [touch locationInView:self.compressImgView];
//    CGPoint endPoint = [touch previousLocationInView:self.compressImgView];
    NSLog(@"starPoint.x - endPoint.x = %.0f",starPoint.x - endPoint.x);
    NSLog(@"starPoint.y - endPoint.y = %.0f",starPoint.y - endPoint.y);
    if (fabs(starPoint.x - endPoint.x)>= HORIZ_SWIPE_DRAG_MIN && fabs(starPoint.y - endPoint.y) <= VERT_SWIPE_DRAG_MIN) {
        if (starPoint.x > endPoint.x) { //向左滑动屏幕
            NSLog(@"1121212121212121211");
        }else{ //向右滑动
            
        }
    }
}
 */

@end
