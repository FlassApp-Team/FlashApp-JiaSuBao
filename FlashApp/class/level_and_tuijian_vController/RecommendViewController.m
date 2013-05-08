//
//  RecommendViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-24.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AppDelegate.h"
#import "RecommendViewController.h"
#import "DeviceInfo.h"
#import "StringUtil.h"
#import "JSON.h"
#import "AppButton.h"
#import "BannerImageUtil.h"
#import "ASIDownloadCache.h"
#import "UpdataNumber.h"
#import "AppDetailClass.h"
#import "DetailViewController.h"

@interface RecommendViewController ()

@property(nonatomic,readonly)NSArray *catesArr;
@property(nonatomic,retain)NSMutableArray *bannerInfo;
@property(nonatomic,readonly)NSDictionary *appsDic;
@property(nonatomic,retain)NSMutableArray *appsArr;
@property(nonatomic,retain)NSMutableDictionary *images;
@property(nonatomic,assign)NSTimeInterval timestamp;
@property(nonatomic,retain)NSString *currentappsPage;

@property (nonatomic ,retain)NSMutableArray *bannerImageArr;


-(void)startAPPSRequest:(NSString *)cateid Page:(NSString *)page;
-(void)startRequest;
-(void)startBannerRequest;
-(UIImage *)getImage:(NSString *)path StartX:(NSInteger)x StartY:(NSInteger)y;
-(void)setExtraCellLineHidden: (UITableView *)tableView;
-(void)initScrollView;
-(void)moveBottomView;
@end

@implementation RecommendViewController
@synthesize timestamp;
@synthesize explainBtn;
@synthesize titleLabel;
@synthesize topAppBtn;
@synthesize topGameBtn;
@synthesize myTableView;
@synthesize headView;
@synthesize scrollActivity;
@synthesize sectionView;
@synthesize recommendDetailViewController;
@synthesize topScrollView;
@synthesize freeBtn;
@synthesize xianMianRedDian;
@synthesize gamesRedDian;
@synthesize catesArr;
@synthesize bannerInfo;
@synthesize appsDic;
@synthesize appsArr;
@synthesize images;
@synthesize currentappsPage;
@synthesize pageControl;
@synthesize requestArray;
@synthesize bannerImageArr;

-(void)dealloc
{
    //    self.imageDatas=nil;
    self.myTableView=nil;
    self.topAppBtn=nil;
    self.topGameBtn=nil;
    self.titleLabel=nil;
    self.explainBtn=nil;
    self.recommendDetailViewController=nil;
    self.topScrollView=nil;
    self.freeBtn=nil;
    [self.bannerImageArr release];
    if(catesArr)
        [catesArr release];
    if(bannerInfo)
        self.bannerInfo=nil;
    if(appsDic)
        [appsDic release];
    if(appsArr)
        [appsArr release];
    self.appsArr=nil;
    self.images=nil;
    self.currentappsPage=nil;
    self.pageControl=nil;
    [sectionView release];
    [headView release];
    [scrollActivity release];
    [xianMianRedDian release];
    [gamesRedDian release];
    [super dealloc];
}

-(void)viewDidUnload
{
    [self setSectionView:nil];
    [self setHeadView:nil];
    [self setScrollActivity:nil];
    [self setXianMianRedDian:nil];
    [self setGamesRedDian:nil];
    [super viewDidUnload];
    if (scrollTimer){
        [scrollTimer invalidate];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self. requestArray=[[[NSMutableArray alloc]initWithCapacity:3] autorelease];
        self.appsArr=[[[NSMutableArray alloc] initWithCapacity:3] autorelease];
        self.images=[[[NSMutableDictionary alloc] initWithCapacity:3] autorelease];
        self.bannerImageArr = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer*tapGestures=[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressBanner)] autorelease];
    tapGestures.delegate=self;
    [self.topScrollView addGestureRecognizer:tapGestures];
    
    UIImage* img=[UIImage imageNamed:@"opaque_small.png"];
    img=[img stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [self.explainBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.topAppBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.topGameBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.topAppBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.topGameBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    //设置按钮被选中或者没有被选中时候的一个样式
    [self.topAppBtn setBackgroundImage:[self getImage:@"leftnormal" StartX:7 StartY:37] forState:UIControlStateNormal];
    [self.freeBtn setBackgroundImage:[self getImage:@"middlenormal" StartX:5 StartY:36] forState:UIControlStateNormal];
    [self.topGameBtn setBackgroundImage:[self getImage:@"rightnormal" StartX:3 StartY:36] forState:UIControlStateNormal];
    
    [self.topAppBtn setBackgroundImage:[self getImage:@"leftpress" StartX:7 StartY:37] forState:UIControlStateHighlighted];
    [self.freeBtn setBackgroundImage:[self getImage:@"middlepress" StartX:5 StartY:36] forState:UIControlStateHighlighted];
    [self.topGameBtn setBackgroundImage:[self getImage:@"rightpress" StartX:3 StartY:36] forState:UIControlStateHighlighted];
    
    [self.topAppBtn setBackgroundImage:[self getImage:@"leftpress" StartX:7 StartY:37] forState:UIControlStateDisabled];
    [self.freeBtn setBackgroundImage:[self getImage:@"middlepress" StartX:5 StartY:36] forState:UIControlStateDisabled];
    [self.topGameBtn setBackgroundImage:[self getImage:@"rightpress" StartX:3 StartY:36] forState:UIControlStateDisabled];
    
    self.myTableView.tableHeaderView = headView;
    
    self.headView.userInteractionEnabled = NO;
        
    [self startAPPSRequest:@"1" Page:@"0"];
    
    self.topScrollView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [scrollActivity startAnimating];
    //删除BannerImageUtil的图片
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"BannerImageUtil"];
    //请求scrollView显示的图片
    if ([bannerImageArr count] ==0 ) {
        [self startBannerRequest];
    }
    
    /** yincangtuijian
    if ([[NSUserDefaults standardUserDefaults] boolForKey:XSMF_APP]) {
        
        xianMianRedDian.hidden = NO;
        
    }else{
        
        xianMianRedDian.hidden = YES;
        
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:RMYX_APP]) {
        
        gamesRedDian.hidden  = NO ;

    }else{
        
        gamesRedDian.hidden = YES;
    }
     **/
}

-(void)viewWillDisappear:(BOOL)animated{
    for(int i=0;i<[self.requestArray count];i++)
    {
        ASIHTTPRequest*request=[self.requestArray objectAtIndex:i];
        [request clearDelegatesAndCancel];
    }
    [self.requestArray removeAllObjects];

}

#pragma mark -- self method
-(UIImage *)getImage:(NSString *)path StartX:(NSInteger)x StartY:(NSInteger)y{
    UIImage *img=[UIImage imageNamed:path];
    img=[img stretchableImageWithLeftCapWidth:x topCapHeight:y];
    return img;
}

-(void)initScrollView
{
    for(UIView *view in [self.topScrollView subviews])
    {
        [view removeFromSuperview];
    }
    for (int i = [self.bannerInfo count]-1;i >= 0; i--)
    {
        UIImageView *imgv3=[[[UIImageView alloc] initWithFrame:CGRectMake(320*(i), 0, 320, 130)] autorelease];
        imgv3.tag=i+1;
        [self.topScrollView addSubview:imgv3];
    }
}

-(void)setBannerImg
{
    [self startImageRequestWithUrl:[[self.bannerInfo lastObject] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg:)];
}

-(void)reloadApps{
    [currentCateID release];
    currentCateID=[[self.appsDic objectForKey:@"cateid"] retain];
    [self.appsArr addObjectsFromArray:[self.appsDic objectForKey:@"apps"]];
    self.currentappsPage=[self.appsDic objectForKey:@"page"];
    [self.myTableView reloadData];
}

-(void)scrollViewAnimate{
    CGSize viewSize=self.topScrollView.frame.size;
    
    if(currentPageForPage>[self.bannerInfo count])
    {
        currentPageForPage=0;
        self.pageControl.currentPage=currentPageForPage;
        CGRect rect=CGRectMake(viewSize.width*currentPageForPage, 0, viewSize.width, viewSize.height);
        [self.topScrollView scrollRectToVisible:rect animated:NO];
    }
    else
    {
        self.pageControl.currentPage=currentPageForPage;
        CGRect rect=CGRectMake(viewSize.width*currentPageForPage, 0, viewSize.width, viewSize.height);
        [self.topScrollView scrollRectToVisible:rect animated:YES];
    }
    currentPageForPage++;
}

-(void)setCates{
    [self.topAppBtn setTitle:[[self.catesArr objectAtIndex:0] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.freeBtn setTitle:[[self.catesArr objectAtIndex:1] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.topGameBtn setTitle:[[self.catesArr objectAtIndex:2] objectForKey:@"name"] forState:UIControlStateNormal];
}

#pragma mark -- request Method

-(void)getImageByRequest:(ASIHTTPRequest *)request{
    [self.images setObject:[request responseData] forKey:[request.url absoluteString]];
    [self.myTableView reloadData];
}


-(void)startAPPSRequest:(NSString *)cateid Page:(NSString *)page{
    DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSString *src =[NSString stringWithFormat:@"%.0f_%.0f",rect.size.width,rect.size.height];
    //获得Sim卡运行商
    CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = tni.subscriberCellularProvider;
    [tni release];
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/apps?deviceId=%@&platform=%@&cateid=%@&pageNo=%@&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,[device.platform encodeAsURIComponent],cateid,page,APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],src,carrier ? carrier.mobileNetworkCode : @"",carrier ? carrier.mobileCountryCode : @"",version,CHANNEL,API_VER];
    
    NSURL *url=[NSURL URLWithString:str];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    request.timeOutSeconds=60;
    request.delegate=self;
    [request startAsynchronous];
    [self.requestArray addObject:request];
}

//请求scrollView显示的图片
-(void)startBannerRequest{
    DeviceInfo *device = [DeviceInfo deviceInfoWithLocalDevice];
    //获得Sim卡运行商
    CTTelephonyNetworkInfo* tni = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier* carrier = tni.subscriberCellularProvider;
    [tni release];
    //获得版本信息
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    //获得屏幕尺寸 width * height
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSString *scr =[NSString stringWithFormat:@"%.0f*%.0f",rect.size.width,rect.size.height];
    
    NSString *str = [NSString stringWithFormat:@"http://apps.flashapp.cn/api/vapp/banner?deviceId=%@&platform=%@&cpi=%d&appid=%d&osversion=%@&dwname=%@&scr=%@&mnc=%@&mcc=%@&vr=%@&chl=%@&ver=%@",device.deviceId,[device.platform encodeAsURIComponent],[BannerImageUtil getTimeStamp] ,APP_ID,[device.version encodeAsURIComponent],[device.hardware encodeAsURIComponent],scr,carrier?carrier.mobileNetworkCode:@"",carrier?carrier.mobileCountryCode:@"",version,CHANNEL,API_VER ];    
    NSURL *url=[NSURL URLWithString:str];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    
    request.delegate=self;
    [request startAsynchronous];
    [self.requestArray addObject:request];
}

-(void)startRequest{
    Reachability* reachable = [Reachability reachabilityWithHostName:P_HOST];
    if ( [reachable currentReachabilityStatus] == NotReachable ) {
        [AppDelegate showAlert:@"网络连接异常,请链接网络"];
        return;
    }
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString *str=[NSString stringWithFormat:@"http://apps.flashapp.cn/api/rcapp/cates?deviceId=%@&platform=%@",device.deviceId,[device.platform encodeAsURIComponent]];
    NSLog(@"str=====%@",str);
    
    NSURL *url=[NSURL URLWithString:str];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    
    request.delegate=self;
    [request startAsynchronous];
    [self.requestArray addObject:request];
    
}

-(void)startImageRequestWithUrl:(NSString *)url FinishMethod:(SEL)sel
{
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"banner------url=======%@",url);
    request.timeOutSeconds=40;
    request.delegate=self;
    [request setDidFinishSelector:sel];
    [request startAsynchronous];
//    [self.requestArray addObject:request];
}

-(void)changeBannerImg:(ASIHTTPRequest *)request
{
    UIImageView *imgv=(UIImageView *)[self.topScrollView viewWithTag:currentCount];
    imgv.image=[UIImage imageWithData:[request responseData]];
    [bannerImageArr addObject:[request responseData]];
    if(currentCount-1<0||!imgv)
    {
//        currentCount--;
        return;
    }
    [[BannerImageUtil getBanerImageUtil] saveBannerWithImage1:[request responseData] Link:[[self.bannerInfo objectAtIndex:currentCount-1] objectForKey:@"link"]];
    if(currentCount-2<0)
    {
        scrollTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewAnimate) userInfo:nil repeats:YES];
        
        self.headView.userInteractionEnabled = YES;
        
        [scrollActivity stopAnimating];
        scrollActivity.hidden =YES;
        
        currentPageForPage=0;
        self.topScrollView.contentSize=CGSizeMake(320*[self.bannerInfo count], self.topScrollView.frame.size.height);
        self.pageControl.hidden =NO;
        self.pageControl. numberOfPages=[self.bannerInfo count];
        self.pageControl.currentPage=currentPageForPage;
        
        currentCount--;
        return;
    }
    [self startImageRequestWithUrl:[[self.bannerInfo objectAtIndex:currentCount-2] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg:)];
    currentCount--;
}

#pragma mark -- button pressed
-(void)pressBanner{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[self.bannerInfo objectAtIndex:self.pageControl.currentPage] objectForKey:@"link"]]];
}

-(IBAction)turnBrnPress:(id)sender
{
    if (self.showNewsAppAnimation != nil) {
        BOOL xianmian = [[NSUserDefaults standardUserDefaults] boolForKey:XSMF_APP];
        BOOL games = [[NSUserDefaults standardUserDefaults] boolForKey:RMYX_APP];
        if (xianmian ||games) {
            self.showNewsAppAnimation(YES);
        }else{
            self.showNewsAppAnimation(NO);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)topAppBtnPress:(id)sender
{
    self.topGameBtn.enabled=YES;
    self.topAppBtn.enabled=NO;
    self.freeBtn.enabled=YES;
    [self.appsArr removeAllObjects];
    [self.myTableView reloadData];
    self.currentappsPage=@"0";
    [self startAPPSRequest:@"1" Page:@"0"];
    
}

-(IBAction)freeBtnPress:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setDouble:NO forKey:XSMF_APP];
    
    self.topGameBtn.enabled=YES;
    self.topAppBtn.enabled=YES;
    self.freeBtn.enabled=NO;
    self.xianMianRedDian.hidden=YES;
    
    [self.appsArr removeAllObjects];
    [self.myTableView reloadData];
    self.currentappsPage=@"0";
    [self startAPPSRequest:@"2" Page:@"0"];
    
}

-(IBAction)topGameBtnPress:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setDouble:NO forKey:RMYX_APP];
    
    self.topGameBtn.enabled=NO;
    self.topAppBtn.enabled=YES;
    self.freeBtn.enabled=YES;
    [self.appsArr removeAllObjects];
    self.gamesRedDian.hidden=YES;
    [self.myTableView reloadData];
    self.currentappsPage=@"0";
    [self startAPPSRequest:@"3" Page:@"0"];
    
}

-(void)loadMore:(id)sender
{
    UIButton *button=(UIButton*)sender;
    button.enabled=NO;
    [button setTitle:@"正在加载请稍后..." forState:UIControlStateDisabled];
    if([self.appsArr count]>=[self.appsArr count]-1){
        [self startAPPSRequest:currentCateID Page:self.currentappsPage];
    }
}


-(void)lockButtonPress:(id)sender
{
    AppButton *button=(AppButton*)sender;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:button.linkUrl]];
    
}


-(IBAction)explainBtnPress:(id)sender
{
    
}

#pragma mark -- ASIHttpRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    id response=[[request responseString] JSONValue];
    
    NSString *requestUrl=[request.url absoluteString];
    if([requestUrl rangeOfString:@"cates"].length){
        [catesArr release];
        
        catesArr=[response retain];
        [self setCates];
    }
    if([requestUrl rangeOfString:@"banner"].length){
        self.bannerInfo=[response objectForKey:@"banner"];
        currentCount= [self.bannerInfo count];
        if(self.bannerInfo){
            [self initScrollView];
            [self setBannerImg];
        }
        self.timestamp=[[response objectForKey:@"cp"] integerValue];
        [BannerImageUtil saveTimeStamp:self.timestamp];
    }
    if([requestUrl rangeOfString:@"vapp/apps"].length){
        [appsDic release];
        appsDic=[response retain];
        [self reloadApps];
    }
    
  //  NSLog(@"request,responseString=====%@",[request responseString]);
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"[request error]=====%@",[request error]);
    // [AppDelegate showAlert:@"网络异常"];
    //    UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:nil message:@"检查网络后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
    //    [alert show];
}

#pragma mark - UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.appsArr count])
        return [self.appsArr count]+1;
    else
        return  [self.appsArr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MoreCellId = @"moreCell";
    static NSString *CellIdentifier = @"jiasuCell";
    UIImageView *starImageView[5];
    if([indexPath row] == ([appsArr count]))
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MoreCellId] autorelease];
        }
        
        for(UIView *subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
        
        //添加cell后面的线
        UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_tab_xian.png"]];
        lineView.frame = CGRectMake(0, 75, 320, 1);
        [cell.contentView addSubview:lineView];
        [lineView release];
        
        UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.tag=110;
        button1.frame=CGRectMake(23, 12, 274, 52);
        [button1 addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setTitleColor:BgTextColor forState:UIControlStateNormal];
        [[button1 titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        button1.enabled=YES;
        [button1 setTitle:@"点击加载更多..." forState:UIControlStateNormal ];
        [button1 setTitle:@"正在加载请稍后..." forState:UIControlStateDisabled];
        UIImage*image=[UIImage imageNamed:@"loadmore.png"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
        [button1 setBackgroundImage:image forState:UIControlStateNormal];
        [cell.contentView addSubview:button1];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor=[UIColor grayColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            //添加cell后面的线
            UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_tab_xian.png"]];
            lineView.frame = CGRectMake(0, 64, 320, 1);
            [cell.contentView addSubview:lineView];
            [lineView release];
            
            for(int i=0;i<5;i++)
            {
                starImageView[i]=[[[UIImageView alloc]initWithFrame:CGRectMake(65+i*17, 38, 15, 15)] autorelease];
                starImageView[i].tag=200+i;
                [cell.contentView addSubview:starImageView[i]];
            }
            UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 55, 55)] autorelease];
            imageView.tag=100;
            
            UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
            nameLabel.frame=CGRectMake(65, 10, 150, 25);
            nameLabel.tag=101;
            nameLabel.textAlignment=UITextAlignmentLeft;
            nameLabel.textColor=[UIColor darkGrayColor];
            nameLabel.font=[UIFont systemFontOfSize:17.0];
            
            AppButton*button=[AppButton buttonWithType:UIButtonTypeCustom];
            button.tag=105;
            button.frame=CGRectMake(254, 18, 59, 30);
            [button addTarget:self action:@selector(lockButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"recommend_btn_bg.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[button titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
            [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
            [[button titleLabel]setShadowOffset:CGSizeMake(0, -1)];
            
            [cell.contentView addSubview:button];
            [cell.contentView addSubview:imageView];
            [cell.contentView addSubview:nameLabel];
            
        }
        NSDictionary *dic=[self.appsArr objectAtIndex: [indexPath row]];
        
        UIImageView *imageview=(UIImageView *)[cell.contentView viewWithTag:100];
        
        NSData *image=[self.images objectForKey:[dic objectForKey:@"icon"]];
        if(image)
            imageview.image = [UIImage imageWithData:image];
        else{
            UIImage *image=[UIImage imageNamed:@"tuijian_loading.png"];
            imageview.image=image;
            NSURL *url=[NSURL URLWithString:[dic objectForKey:@"icon"]];
            ASIHTTPRequest *asiRequest=[ASIHTTPRequest requestWithURL:url];
            asiRequest.timeOutSeconds=30;
            [asiRequest setDidFinishSelector:@selector(getImageByRequest:)];
            [asiRequest setDelegate:self];
            [asiRequest startAsynchronous];
            [self.requestArray addObject:asiRequest];
        }
        UILabel *nameLabel=(UILabel*)[cell.contentView viewWithTag:101];
        nameLabel.text=[dic objectForKey:@"apname"];
        
        UILabel *detailLabel=(UILabel*)[cell.contentView viewWithTag:102];
        detailLabel.text=[dic objectForKey:@"apdesc"];
        
        UILabel *sizeLabel=(UILabel*)[cell.contentView viewWithTag:103];
        sizeLabel.text=[dic objectForKey:@"fsize"];
        
        AppButton *button=(AppButton*)[cell.contentView viewWithTag:105];
        button.linkUrl=[dic objectForKey:@"link"];
        button.appName=[dic objectForKey:@"apname"];
        button.appIcon=[dic objectForKey:@"icon"];
        button.appSize=[dic objectForKey:@"fsize"];
        button.appStar=[[dic objectForKey:@"star"] integerValue];
        button.appDescibe=[dic objectForKey:@"apdesc"];
        [button setTitle:@"免费" forState:UIControlStateNormal];
        if (![[dic objectForKey:@"oprice"] isEqualToString:@"0.00000"]) {
            [button setTitle:[NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"oprice"] floatValue]] forState:UIControlStateNormal];
        }
        
        NSInteger stars=[[dic objectForKey:@"star"] integerValue]/2;
        NSInteger halfstars=[[dic objectForKey:@"star"] integerValue]%2;
        for(int i=0;i<stars;i++)
        {
            starImageView[i]=(UIImageView*)[cell.contentView viewWithTag:200+i];
            starImageView[i].image=[UIImage imageNamed:@"recommend_all_star.png"];
        }
        if(halfstars){
            starImageView[stars]=(UIImageView*)[cell.contentView viewWithTag:200+stars];
            starImageView[stars].image=[UIImage imageNamed:@"recommend_half_star.png"];
        }
        for(int i=halfstars+stars;i<5;i++)
        {
            starImageView[i]=(UIImageView*)[cell.contentView viewWithTag:200+i];
            starImageView[i].image=[UIImage imageNamed:@"recommend_none_star.png"];
        }
        
        return cell;
    }
}

#pragma mark -- UITableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ([appsArr count]))
        return;
    
    /**yincangtuijian
    NSDictionary *dic=[self.appsArr objectAtIndex: [indexPath row]];
    AppDetailClass *detailClass = [AppDetailClass getAppDetailClass];
    detailClass.apid = [dic objectForKey:@"apid"];
    detailClass.apname = [dic objectForKey:@"apname"];
    detailClass.apdesc = @"";
    //    detailClass.rkm = [dic objectForKey:@"rkm"];
    detailClass.rkm = @"我是推荐理由哦";
    //    detailClass.picslen = [dic objectForKey:@"picslen"];
    detailClass.picslen = @"(3.5MB)";
    detailClass.star = [[dic objectForKey:@"star"] integerValue];
    detailClass.fsize = [dic objectForKey:@"fsize"];
    detailClass.icon = [dic objectForKey:@"icon"];
    detailClass.link = [dic objectForKey:@"link"];
    detailClass.oprice = [dic objectForKey:@"oprice"];
    detailClass.cprice = [dic objectForKey:@"cprice"];
    detailClass.limFree = [dic objectForKey:@"limfree"];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.appImgDic = self.images;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
     **/
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([appsArr count] == indexPath.row) {
        return nil;
    }
    return indexPath;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section == 0 ) {
        
        return 38;
    }
    return 0;
}
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  sectionView;
}

#pragma mark -- scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.topScrollView.frame.size.width;
    int page = floor((self.topScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    currentPageForPage += page;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
