//
//  DetailViewController.m
//  flashapp
//
//  Created by 朱广涛 on 13-4-25.
//  Copyright (c) 2013年 Home. All rights reserved.
//

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AppDelegate.h"
#import "DeviceInfo.h"
#import "StringUtil.h"
#import "NSString+SBJson.h"
#import "DetailViewController.h"
#import "AppDetailClass.h"
#import "ASIHttpRequest.h"

#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]

@interface DetailViewController ()


@property (nonatomic ,retain) AppDetailClass *appDetail;


@end

@implementation DetailViewController
@synthesize detailTableView;
@synthesize headView;
@synthesize appIconImgView;
@synthesize appNameLabel;
@synthesize gotuAnzhuang;
@synthesize liyouView;
@synthesize liyouImgView;
@synthesize liyouLabel;
@synthesize endPicBtnView;
@synthesize picSizeLabel;
@synthesize miaoshuTitleView;
@synthesize showPicView;
@synthesize showPicScrollView;
@synthesize showPicBtn;
@synthesize appDetail;
@synthesize appImgDic;

static BOOL showAppPic = NO;

-(void)dealloc
{
    [detailTableView release];
    [appIconImgView release];
    [appNameLabel release];
    [liyouImgView release];
    [picSizeLabel release];
    [headView release];
    [liyouView release];
    [miaoshuTitleView release];
    [endPicBtnView release];
    [liyouLabel release];
    [showPicView release];
    [showPicScrollView release];
    [showPicBtn release];

    [gotuAnzhuang release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDetailTableView:nil];
    [self setAppIconImgView:nil];
    [self setAppNameLabel:nil];
    [self setLiyouImgView:nil];
    [self setPicSizeLabel:nil];
    [self setHeadView:nil];
    [self setLiyouView:nil];
    [self setMiaoshuTitleView:nil];
    [self setEndPicBtnView:nil];
    [self setLiyouLabel:nil];
    [self setShowPicView:nil];
    [self setShowPicScrollView:nil];
    [self setShowPicBtn:nil];
    [self setGotuAnzhuang:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        appDetail = [AppDetailClass getAppDetailClass];
        
        self.appImgDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"应用详情";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 32);
    [btn setBackgroundImage:[UIImage imageNamed:@"barButton_bg.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"appBackBtn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    detailTableView.tableHeaderView = headView;
       
    detailTableView.dataSource = self;
    detailTableView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![appDetail.oprice isEqualToString:@"0.00000"]) {
        [gotuAnzhuang setTitle:[NSString stringWithFormat:@"￥%.2f",[appDetail.oprice floatValue]] forState:UIControlStateNormal];
    }else{
        [gotuAnzhuang setTitle:@"免费" forState:UIControlStateNormal];
    }
    
    //网络请求数据
    [self requestDetailWithAppId:appDetail.apid];
    
    //先判断表格有几个cell
    hasrkm = [appDetail.rkm length]?YES:NO;
    haspics = [appDetail.picslen length]?YES:NO;
    
    //添加星星
    for (int i = 0 ; i < 5 ; i++) {
        UIImageView *starImg =[[ UIImageView alloc] init];
        starImg.tag = 110 +i ;
        starImg.frame = CGRectMake(65+(15*i), 38, 15, 15);
        [headView addSubview:starImg];
        [starImg release];
    }
    int quan =appDetail.star / 2;
    int ban = appDetail.star % 2;
    for (int i = 0 ; i<quan ; i++) {
        UIImageView *quanImg = (UIImageView *)[headView viewWithTag:110+i];
        quanImg.image = [UIImage imageNamed:@"recommend_all_star.png"];
    }
    
    UIImageView *banImage = (UIImageView *)[headView viewWithTag:110+quan];
    banImage.image = [UIImage imageNamed:@"recommend_half_star.png"];
    
    for (int i = quan + ban ; i < 5; i++) {
        UIImageView *wuImage = (UIImageView *)[headView viewWithTag:110+quan+ban];
        wuImage.image = [UIImage imageNamed:@"recommend_none_star.png"];
    }
    
    //设置 head 里面app图标的值
    NSData *data = [appImgDic objectForKey:appDetail.icon];
    if (data) {
        appIconImgView.image = [UIImage imageWithData:data];
    }else{
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:appDetail.icon]];
        request.delegate = self;
        [request setDidFinishSelector:@selector(appIconShow:)];
        [request startAsynchronous];
    }
    appNameLabel.text = appDetail.apname;
    
    //设置图片大小
    picSizeLabel.text = appDetail.picslen;
    
    //设置推荐理由
    liyouLabel.text = appDetail.rkm;

}

#pragma mark -- button method
-(IBAction)close
{
    showAppPic = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoAnzhuangBtn:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appDetail.link]];
}

- (IBAction)shouAppPicBtn:(id)sender
{
    showAppPic = YES;
    for (int i = 0 ; i < [appDetail.pics count]; i++) {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[appDetail.pics objectAtIndex:i]]];
        request.tag = i;
        [request setCompletionBlock:^{
            UIImageView *img = (UIImageView *)[showPicScrollView.superview viewWithTag:109+request.tag];
            UIActivityIndicatorView *act = (UIActivityIndicatorView *)[showPicScrollView.superview viewWithTag:209+request.tag];
            [act stopAnimating];
            act.hidden = YES;
            img.image = [UIImage imageWithData:[request responseData]];
        }];
        
        ;

        [request startAsynchronous];
    }
    
    [detailTableView reloadData];
    
}

#pragma mark -- request delegate method

-(void)appIconShow:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    appIconImgView.image = [UIImage imageWithData:data];
}

#pragma mark -- self method
//请求数据 url
-(void)requestDetailWithAppId:(NSString *)apid
{
    DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSString *src = [NSString stringWithFormat:@"%.0f_%.0f",rect.size.width,rect.size.height];
    
    CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = tni.subscriberCellularProvider;
    [tni release];
    
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/app?deviceId=%@&apid=%@&platform=%@&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,apid,[device.platform encodeAsURIComponent],APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],src,carrier?carrier.mobileNetworkCode:@"",carrier?carrier.mobileCountryCode:@"",version,CHANNEL,API_VER];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    
    [request setCompletionBlock:^{
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
        appDetail.apdesc =  [result objectForKey:@"apdesc"];
        if ([appDetail.apdesc isEqualToString:@""]) {
            appDetail.apdesc = @"本应用暂无应用描述！";
        }
//        appDetail.pics = [NSMutableArray arrayWithArray:[result objectForKey:@"pics"]];
        
        appDetail.pics = [NSArray arrayWithObjects:@"http://a270.phobos.apple.com/us/r1000/079/Purple/v4/cd/84/d4/cd84d4c7-5d3e-df59-811d-759fb6ea999a/mzl.rzaasbmu.75x75-65.png",@"http://a915.phobos.apple.com/us/r1000/089/Purple/f4/c1/22/mzm.cybvekpd.75x75-65.png",@"http://a915.phobos.apple.com/us/r1000/089/Purple/f4/c1/22/mzm.cybvekpd.75x75-65.png",@"http://a270.phobos.apple.com/us/r1000/079/Purple/v4/cd/84/d4/cd84d4c7-5d3e-df59-811d-759fb6ea999a/mzl.rzaasbmu.75x75-65.png",@"http://a294.phobos.apple.com/us/r1000/071/Purple2/v4/b2/58/0c/b2580c7c-75c5-a305-6957-35d546839872/mzl.nuiuwhsb.75x75-65.png", nil];
        
        //设置Label的高度
        fontHeight = [self heightForString:appDetail.apdesc fontSize:14 andWidth:300];
        //激活button
        showPicBtn.enabled = YES;
        
        //初始化scrollView
        [self initPicScrollView];
        
        [detailTableView reloadData];
    }];
    [request setFailedBlock:^{
        NSError *error  =[request error] ;
        NSLog(@"request tag is %d ,errer is %@:",request.tag,[error userInfo]);
        
    }];
    [request startAsynchronous];
}
//初始化showPicScrollView scrollView width = 97 height = 150 ；
-(void)initPicScrollView
{
    for (int i = 0 ;  i < [appDetail.pics count]; i++) {
        UIView *picView = [[UIView alloc] initWithFrame:CGRectMake(97*i, 0, 97, 150)];
        UIImageView *imgView =[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 95, 148)];
        imgView.tag = 109 + i ;
        [picView addSubview:imgView];
        [imgView release];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.tag = 209 + i;
        activity.hidden = NO;
        activity.center = CGPointMake(97/2, picView.center.y);
        [activity startAnimating];
        [picView addSubview:activity];
        [activity release];
        
        [showPicScrollView addSubview:picView];
        [picView release];
    }
//    NSLog(@"scrollView = %.0f , %.0f , %.0f , %.0f",showPicScrollView.frame.origin.x,showPicScrollView.frame.origin.y,showPicScrollView.frame.size.width,showPicScrollView.frame.size.height);

    int x = (showPicView.frame.size.width - 97*[appDetail.pics count]) / 2;
    int y = showPicView.frame.origin.y;
    CGSize size = CGSizeMake(97*[appDetail.pics count], 150);
    if (x > 0) {
        showPicScrollView.frame = CGRectMake(x, y, size.width, size.height);
    }
    showPicScrollView.contentSize = size;
}

//计算label 的高度 ， 也要用到cell上
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

//返回推荐理由cell
-(UITableViewCell *)returnTuiJianCellWithIden:(NSString *)idenfition andTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPach
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfition];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfition];
        cell.userInteractionEnabled = NO;
    }
    [cell.contentView addSubview:liyouView];
    return cell;
}

//点击显示图片的按钮 的 cell
-(UITableViewCell *)returnShowPicBtnCellWithIden:(NSString *)idenfition andTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPach
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfition];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfition];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView addSubview:endPicBtnView];
    return cell;
}

-(UITableViewCell *)returnShowPicScrollCellWithIden:(NSString *)idenfition andTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPach
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfition];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfition];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:showPicScrollView];
    }
    return cell;
}

//返回应用描述cell
-(UITableViewCell *)returnMiaoShuTitleCellWithIden:(NSString *)idenfition andTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPach
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfition];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfition];
        cell.userInteractionEnabled = NO;
    }
    [cell.contentView addSubview:miaoshuTitleView];
    return cell;
}

//返回应用详细cell
-(UITableViewCell *)returnXiangXiCellWithIden:(NSString *)idenfition andTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPach
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfition];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfition];
        cell.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 1010;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0 ;
        label.lineBreakMode = UILineBreakModeCharacterWrap;
        [cell.contentView addSubview:label];
        [label release];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(10, 10, 20, 20);
        activity.tag = 1100;
        [cell.contentView addSubview:activity];
        [activity release];
    }
    //赋值
    UILabel *xiangxiStr = (UILabel *)[cell.contentView viewWithTag:1010];
    xiangxiStr.frame = CGRectMake(10, 5, 300, fontHeight);
    UIActivityIndicatorView *act = (UIActivityIndicatorView *)[cell.contentView viewWithTag:1100];
    
    if (appDetail.apdesc.length == 0) {
        [act startAnimating];
    }else{
        [act stopAnimating];
        act.hidden = YES;
        xiangxiStr.text = appDetail.apdesc;
    }
        
    return cell;
}

#pragma mark -- TableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!hasrkm && !haspics) {
        return 2;
    }else if(!hasrkm || !haspics){
        return 3;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *liyouIdenf =  @"liyoucell";
    static NSString *jietubtnIdenf = @"jietubtncell";
    static NSString *appPicIdenf = @"apppiccell";
    static NSString *miaoshuIdenf =  @"miaoshucell";
    static NSString *xiangxiIdenf = @"xiangxicell";
    
    if (!hasrkm && !haspics) {
        switch (indexPath.row) {
            case 0:{
                
                return [self returnMiaoShuTitleCellWithIden:miaoshuIdenf andTable:tableView atIndexPath:indexPath];
                
                break;
            }
            case 1:{
                
                return [self returnXiangXiCellWithIden:xiangxiIdenf andTable:tableView atIndexPath:indexPath];
                
                break;
            }
            default:
                break;
        }
        
    }else if(!hasrkm || !haspics){
        if (haspics) {
            switch (indexPath.row) {
                case 0:
                    
                    if (showAppPic) {
                        return [self returnShowPicScrollCellWithIden:appPicIdenf andTable:tableView atIndexPath:indexPath];
                    }else{
                        return [self returnShowPicBtnCellWithIden:jietubtnIdenf andTable:tableView atIndexPath:indexPath];
                    }
                    
                    break;
                case 1:
                    
                    return [self returnMiaoShuTitleCellWithIden:miaoshuIdenf andTable:tableView atIndexPath:indexPath];
                    
                    break;
                case 2:
                    
                    return [self returnXiangXiCellWithIden:xiangxiIdenf andTable:tableView atIndexPath:indexPath];
                    
                    break;
                default:
                    break;
            }
        }else if (hasrkm){
            switch (indexPath.row) {
                case 0:
                    
                    return [self returnTuiJianCellWithIden:liyouIdenf andTable:tableView atIndexPath:indexPath];
                    
                    break;
                case 1:
                    
                    return [self returnMiaoShuTitleCellWithIden:miaoshuIdenf andTable:tableView atIndexPath:indexPath];
                    
                    break;
                case 2:{
                    
                    return [self returnXiangXiCellWithIden:xiangxiIdenf andTable:tableView atIndexPath:indexPath];
                    
                    break;
                }
                default:
                    break;
            }
        }
    }else{
        switch (indexPath.row) {
            case 0:
                
                return [self returnTuiJianCellWithIden:liyouIdenf andTable:tableView atIndexPath:indexPath];
                
                break;
            case 1:
                if (showAppPic) {
                    return [self returnShowPicScrollCellWithIden:appPicIdenf andTable:tableView atIndexPath:indexPath];
                }else{
                    return [self returnShowPicBtnCellWithIden:jietubtnIdenf andTable:tableView atIndexPath:indexPath];
                }
                
                break;
            case 2:
                
                return [self returnMiaoShuTitleCellWithIden:miaoshuIdenf andTable:tableView atIndexPath:indexPath];
                
                break;
            case 3:
                return [self returnXiangXiCellWithIden:xiangxiIdenf andTable:tableView atIndexPath:indexPath];
                break;
                
            default:
                break;
        }
    }
    return nil;
}

#pragma mark -- TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!hasrkm && !haspics) {
        switch (indexPath.row) {
            case 0:
                return miaoshuTitleView.frame.size.height;
                break;
            case 1:
                return fontHeight + 10 ; //加10 是加上label离cell 上面的呢 10个像素
                break;
            default:
                return 0;
                break;
        }
    }else if(!hasrkm || !haspics){
        if (haspics) {
            switch (indexPath.row) {
                case 0:
                    if (showAppPic) {
                        return 155;
                    }else{
                        return 60;
                    }
                    break;
                case 1:
                    return 30;
                    break;
                case 2:
                    return fontHeight+10;
                    break;
                default:
                    return 0;
                    break;
            }
        }else if (hasrkm){
            switch (indexPath.row) {
                case 0:
                    return 45;
                    break;
                case 1:
                    return 30;
                    break;
                case 2:
                    return fontHeight+10;
                    break;
                default:
                    return 0;
                    break;
            }
        }
    }else{
        switch (indexPath.row) {
            case 0:
                return 45;
                break;
            case 1:
                if (showAppPic) {
                    return 155;
                }else{
                    return 60;
                }
                break;
            case 2:
                return 30;
                break;
            case 3:
                return fontHeight +10;
                break;
            default:
                return 0;
                break;
        }
    }
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
