//
//  RecommendViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-24.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendDetailViewController.h"
#import "DeviceInfo.h"
#import "StringUtil.h"
#import "JSON.h"
#import "AppButton.h"
#import "BannerImageUtil.h"
#import "ASIDownloadCache.h"
#import "UpdataNumber.h"
#import "AppDetailsViewController.h"

@interface RecommendViewController ()
@property(nonatomic,retain)IBOutlet UIScrollView *topScrollView;
@property(nonatomic,retain)IBOutlet UIButton *freeBtn;
@property(nonatomic,retain)IBOutlet UIPageControl *pageControl;
@property(nonatomic,readonly)NSArray *catesArr;
@property(nonatomic,retain)NSMutableArray *bannerInfo;
@property(nonatomic,readonly)NSDictionary *appsDic;
@property(nonatomic,retain)NSMutableArray *appsArr;
@property(nonatomic,retain)NSMutableDictionary *images;
@property(nonatomic,assign)NSTimeInterval timestamp;
@property(nonatomic,retain)NSString *currentappsPage;

@property(nonatomic,retain)UpdataNumber *freenumberView;
@property(nonatomic,retain)UpdataNumber *gamenumberView;

@property(nonatomic)CGRect oriTableViewFrame;



-(void)startAPPSRequest:(NSString *)cateid Page:(NSString *)page;
-(void)startRequest;
-(void)startBannerRequest;
-(UIImage *)getImage:(NSString *)path StartX:(NSInteger)x StartY:(NSInteger)y;
-(void)setExtraCellLineHidden: (UITableView *)tableView;
-(void)initScrollView;
-(void)moveBottomView;
@end

@implementation RecommendViewController
@synthesize freenumberView;
@synthesize timestamp;
@synthesize explainBtn;
@synthesize btnBgImageView;
@synthesize titleLabel;
@synthesize topAppBtn;
@synthesize topGameBtn;
@synthesize myTableView;
@synthesize recommendDetailViewController;
@synthesize topScrollView;
@synthesize freeBtn;
@synthesize catesArr;
@synthesize bannerInfo;
@synthesize appsDic;
@synthesize appsArr;
@synthesize oriTableViewFrame;
@synthesize images;
@synthesize currentappsPage;
@synthesize pageControl;
@synthesize gamenumberView;
@synthesize requestArray;
-(void)dealloc
{
    //    self.imageDatas=nil;
    self.freenumberView=nil;
    self.gamenumberView=nil;
    self.myTableView=nil;
    self.topAppBtn=nil;
    self.topGameBtn=nil;
    self.titleLabel=nil;
    self.btnBgImageView=nil;
    self.explainBtn=nil;
    self.recommendDetailViewController=nil;
    self.topScrollView=nil;
    self.freeBtn=nil;
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
    [_scrollShowImage release];
    [_scrollShowBtn release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.appsArr=[[[NSMutableArray alloc] initWithCapacity:3] autorelease];
        self.images=[[[NSMutableDictionary alloc] initWithCapacity:3] autorelease];
    }
    return self;
}

-(IBAction)turnBrnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}

- (IBAction)scrollShowBtn:(id)sender
{
    [self moveBottomViewToo];
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
    self.topGameBtn.enabled=YES;
    self.topAppBtn.enabled=YES;
    self.freeBtn.enabled=NO;
    self.freenumberView.hidden=YES;
    
    [self.appsArr removeAllObjects];
    [self.myTableView reloadData];
    self.currentappsPage=@"0";
    [self startAPPSRequest:@"2" Page:@"0"];
    
}

-(IBAction)topGameBtnPress:(id)sender
{
    self.topGameBtn.enabled=NO;
    self.topAppBtn.enabled=YES;
    self.freeBtn.enabled=YES;
    [self.appsArr removeAllObjects];
    self.gamenumberView.hidden=YES;
    [self.myTableView reloadData];
    self.currentappsPage=@"0";
    [self startAPPSRequest:@"3" Page:@"0"];
    
}
-(IBAction)explainBtnPress:(id)sender
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self. requestArray=[[[NSMutableArray alloc]init] autorelease];
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
    self.oriTableViewFrame=self.myTableView.frame;
    float offsetY=self.topAppBtn.frame.origin.y-self.btnBgImageView.frame.origin.y;
    
    CGRect newFrame=CGRectMake(self.btnBgImageView.frame.origin.x, self.topScrollView.frame.origin.y, self.btnBgImageView.frame.size.width, self.btnBgImageView.frame.size.height);
    
    self.btnBgImageView.frame=newFrame;
    
    self.topAppBtn.frame=CGRectMake(self.topAppBtn.frame.origin.x, newFrame.origin.y+offsetY, self.topAppBtn.frame.size.width, self.topAppBtn.frame.size.height);
    self.topGameBtn.frame=CGRectMake(self.topGameBtn.frame.origin.x, newFrame.origin.y+offsetY, self.topGameBtn.frame.size.width+2, self.topGameBtn.frame.size.height); //加 2 是为了叫按钮填充满屏幕
    self.freeBtn.frame=CGRectMake(self.freeBtn.frame.origin.x, newFrame.origin.y+offsetY, self.freeBtn.frame.size.width, self.freeBtn.frame.size.height);
    
    self.myTableView.frame=CGRectMake(self.myTableView.frame.origin.x, newFrame.origin.y+newFrame.size.height, self.myTableView.frame.size.width, self.view.frame.size.height-newFrame.origin.y-newFrame.size.height);
    
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
    
    
    self.freenumberView=[UpdataNumber creatUpdataNumberView];
    self.freenumberView.frame=CGRectMake(self.freeBtn.frame.origin.x+self.freeBtn.frame.size.width-20, self.freeBtn.frame.origin.y, 20, 20);
    
    self.gamenumberView=[UpdataNumber creatUpdataNumberView];
    self.gamenumberView.frame=CGRectMake(self.topGameBtn.frame.origin.x+self.topGameBtn.frame.size.width-20, self.freeBtn.frame.origin.y, 20, 20);
    [self.freenumberView setHidden:YES];
    [self.gamenumberView setHidden:YES];
    [self.view addSubview:self.freenumberView];
    [self.view addSubview:self.gamenumberView];
    
    [self startAPPSRequest:@"1" Page:@"0"];
    
    // Do any additional setup after loading the view from its nib.
    
    [self setExtraCellLineHidden:self.myTableView];
    
    //删除BannerImageUtil的图片
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"BannerImageUtil"];
    
    //请求scrollView显示的图片
    [self startBannerRequest];
    
    NSMutableArray *arr=[BannerImageUtil  getBanners];
    self.bannerInfo=arr;
    if(![self.bannerInfo count])
    {
        return;
    }
    [self moveBottomView];
    for (int i=[arr count]-1; i>=0; i--)
    {
        UIImageView *imgv=(UIImageView *)[self.topScrollView viewWithTag:i+1];
        imgv.image=[UIImage imageWithData:[[arr objectAtIndex:i] objectForKey:@"imageData"]];
    }

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    self.imageDatas=[[[NSMutableArray alloc] initWithCapacity:3] autorelease];
//    ConnectionType type = [UIDevice connectionType];
    [self startRequest];
    
    scrollTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollViewAnimate) userInfo:nil repeats:YES];

}

-(void)viewWillDisappear:(BOOL)animated{
    for(int i=0;i<[self.requestArray count];i++)
    {
        ASIHTTPRequest*request=[self.requestArray objectAtIndex:i];
        [request clearDelegatesAndCancel];
    }
    [self.requestArray removeAllObjects];
    if (scrollTimer)
        [scrollTimer invalidate];
}

-(void)viewDidUnload
{
    [self setScrollShowImage:nil];
    [self setScrollShowBtn:nil];
    [super viewDidUnload];
    if (scrollTimer)
        [scrollTimer invalidate];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    [tableView setTableFooterView:view];
    [view release];
}




-(UIImage *)getImage:(NSString *)path StartX:(NSInteger)x StartY:(NSInteger)y{
    UIImage *img=[UIImage imageNamed:path];
    img=[img stretchableImageWithLeftCapWidth:x topCapHeight:y];
    return img;
}


-(void)moveBottomView{
    
    pdSanJiao = YES;
    
    CGRect newFrame=CGRectMake(self.btnBgImageView.frame.origin.x, self.topScrollView.frame.origin.y+self.topScrollView.frame.size.height, self.btnBgImageView.frame.size.width, self.btnBgImageView.frame.size.height);
    
    NSLog(@"newFrame = %f,%f，%f,%f",self.btnBgImageView.frame.origin.x,self.oriTableViewFrame.origin.y-self.topScrollView.frame.size.height,self.btnBgImageView.frame.size.width,self.btnBgImageView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.btnBgImageView.frame=newFrame;
        
        self.topAppBtn.frame=CGRectMake(self.topAppBtn.frame.origin.x, self.oriTableViewFrame.origin.y-self.topAppBtn.frame.size.height, self.topAppBtn.frame.size.width, self.topAppBtn.frame.size.height);
        self.topGameBtn.frame=CGRectMake(self.topGameBtn.frame.origin.x, self.oriTableViewFrame.origin.y-self.topGameBtn.frame.size.height, self.topGameBtn.frame.size.width, self.topGameBtn.frame.size.height);
        self.freeBtn.frame=CGRectMake(self.freeBtn.frame.origin.x, self.oriTableViewFrame.origin.y-self.freeBtn.frame.size.height, self.freeBtn.frame.size.width, self.freeBtn.frame.size.height);
        self.freenumberView.frame=CGRectMake(self.freeBtn.frame.origin.x+self.freeBtn.frame.size.width-20, self.oriTableViewFrame.origin.y-self.freeBtn.frame.size.height, 20, 20);
        self.gamenumberView.frame=CGRectMake(self.topGameBtn.frame.origin.x+self.topGameBtn.frame.size.width-20, self.oriTableViewFrame.origin.y-self.freeBtn.frame.size.height, 20, 20);
        self.myTableView.frame=CGRectMake(0, self.oriTableViewFrame.origin.y, self.oriTableViewFrame.size.width, self.view.frame.size.height-self.oriTableViewFrame.origin.y);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(moveBottomViewToo) withObject:self afterDelay:10.0f];
    }];
    
        [self initScrollView];
}

-(void)moveBottomViewToo
{
    
    //第一次广告位弹上来的时候出现可以点击出现或者消失的按钮
    self.scrollShowBtn.hidden = NO;
    self.scrollShowImage.hidden = NO;
    
    CGRect newRect = CGRectMake(self.topScrollView.frame.origin.x, self.topScrollView.frame.origin.y, self.btnBgImageView.frame.size.width, self.btnBgImageView.frame.size.height);
    
    if (pdSanJiao) {
        
        //如果是横三角就是NO , 如果是倒三角就是YES；
        pdSanJiao = NO;
        
        //先改变右上角 按钮上图片的样式
        self.scrollShowImage.image = [UIImage imageNamed:@"hengsanjiao.png"];
        
        //将scrollView隐藏.改变页面上其他控件的位置其实就是
        [UIView animateWithDuration:0.5 animations:^{
            self.btnBgImageView.frame = newRect;
            self.topAppBtn.frame = CGRectMake(self.topAppBtn.frame.origin.x, self.btnBgImageView.frame.origin.y, self.topAppBtn.frame.size.width, self.topAppBtn.frame.size.height);
            self.topGameBtn.frame=CGRectMake(self.topGameBtn.frame.origin.x, self.btnBgImageView.frame.origin.y, self.topGameBtn.frame.size.width, self.topGameBtn.frame.size.height);
            self.freeBtn.frame=CGRectMake(self.freeBtn.frame.origin.x, self.btnBgImageView.frame.origin.y, self.freeBtn.frame.size.width, self.freeBtn.frame.size.height);
            self.freenumberView.frame=CGRectMake(self.freeBtn.frame.origin.x+self.freeBtn.frame.size.width-20, self.btnBgImageView.frame.origin.y, 20, 20);
            self.gamenumberView.frame=CGRectMake(self.topGameBtn.frame.origin.x+self.topGameBtn.frame.size.width-20, self.btnBgImageView.frame.origin.y, 20, 20);
            self.myTableView.frame=CGRectMake(0, self.btnBgImageView.frame.origin.y+self.btnBgImageView.frame.size.height, self.oriTableViewFrame.size.width, self.view.frame.size.height-self.btnBgImageView.frame.origin.y-self.btnBgImageView.frame.size.height);
            
        } completion:^(BOOL finished) {

        }];
        
    }else{
        
        //如果是横三角就是NO , 如果是倒三角就是YES；
        pdSanJiao = YES;
        
        //先改变右上角 按钮上图片的样式
        self.scrollShowImage.image = [UIImage imageNamed:@"daosanjiao.png"];
    
        //显示ScrollView
        //将scrollView隐藏
        [UIView animateWithDuration:0.5 animations:^{
            
            self.topAppBtn.frame=CGRectMake(self.topAppBtn.frame.origin.x, self.oriTableViewFrame.origin.y-self.topAppBtn.frame.size.height, self.topAppBtn.frame.size.width, self.topAppBtn.frame.size.height);
            self.topGameBtn.frame=CGRectMake(self.topGameBtn.frame.origin.x, self.oriTableViewFrame.origin.y-self.topGameBtn.frame.size.height, self.topGameBtn.frame.size.width, self.topGameBtn.frame.size.height);
            self.freeBtn.frame=CGRectMake(self.freeBtn.frame.origin.x, self.oriTableViewFrame.origin.y-self.freeBtn.frame.size.height, self.freeBtn.frame.size.width, self.freeBtn.frame.size.height);
            self.freenumberView.frame=CGRectMake(self.freeBtn.frame.origin.x+self.freeBtn.frame.size.width-20, self.oriTableViewFrame.origin.y-self.freeBtn.frame.size.height, 20, 20);
            self.gamenumberView.frame=CGRectMake(self.topGameBtn.frame.origin.x+self.topGameBtn.frame.size.width-20, self.oriTableViewFrame.origin.y-self.freeBtn.frame.size.height, 20, 20);
            self.myTableView.frame=CGRectMake(0, self.oriTableViewFrame.origin.y, self.oriTableViewFrame.size.width, self.view.frame.size.height-self.oriTableViewFrame.origin.y);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
}

-(void)initScrollView
{
    for(UIView *view in [self.topScrollView subviews])
    {
        [view removeFromSuperview];
    }
    for (int i=[self.bannerInfo count]-1;i>=0;i--)
    {
        
        UIImageView *imgv3=[[[UIImageView alloc] initWithFrame:CGRectMake(320*(i), 0, 320, 130)] autorelease];
        imgv3.tag=i+1;
        [self.topScrollView addSubview:imgv3];
        
    }
    currentPageForPage=0;
    self.topScrollView.contentSize=CGSizeMake(320*[self.bannerInfo count], self.topScrollView.frame.size.height);
    self.pageControl. numberOfPages=[self.bannerInfo count];
    self.pageControl.currentPage=currentPageForPage;
    
}

#pragma mark  ASIHTTP Method

-(void)startAPPSRequest:(NSString *)cateid Page:(NSString *)page{
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString *str=[NSString stringWithFormat:@"http://apps.flashapp.cn/api/rcapp/apps?deviceId=%@&platform=%@&cateid=%@&pageNo=%@",device.deviceId,[device.platform encodeAsURIComponent],cateid,page];
    NSLog(@"str=====%@",str);
    NSURL *url=[NSURL URLWithString:str];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    //request.userAgentString=@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0";
    
    request.timeOutSeconds=60;
    request.delegate=self;
    [request startAsynchronous];
    [self.requestArray addObject:request];
}

//请求scrollView显示的图片
-(void)startBannerRequest{
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    NSString *str=[NSString stringWithFormat:@"http://apps.flashapp.cn/api/rcapp/banner?deviceId=%@&platform=%@&cp=%d",device.deviceId,[device.platform encodeAsURIComponent],[BannerImageUtil getTimeStamp]];
    NSLog(@"str=====%@",str);
    
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

-(void)startImageRequestWithUrl:(NSString *)url FinishMethod:(SEL)sel{
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"banner------url=======%@",url);
    request.timeOutSeconds=40;
    request.delegate=self;
    [request setDidFinishSelector:sel];
    [request startAsynchronous];
    [self.requestArray addObject:request];
    
}

-(void)setCates{
//    NSLog(@"TTTTTTTTTTTTTT%@",[[self.catesArr objectAtIndex:0] objectForKey:@"name"] );
    [self.topAppBtn setTitle:[[self.catesArr objectAtIndex:0] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.freeBtn setTitle:[[self.catesArr objectAtIndex:1] objectForKey:@"name"] forState:UIControlStateNormal];
    [self.topGameBtn setTitle:[[self.catesArr objectAtIndex:2] objectForKey:@"name"] forState:UIControlStateNormal];
    if([[[self.catesArr objectAtIndex:1] objectForKey:@"new"] intValue]>0){
        self.freenumberView.hidden=NO;
        NSLog(@"free update number count%@",[[self.catesArr objectAtIndex:1] objectForKey:@"new"] );
        self.freenumberView.numLabel.text=[[[self.catesArr objectAtIndex:1] objectForKey:@"new"] stringValue];
    }
    if([[[self.catesArr objectAtIndex:2] objectForKey:@"new"] intValue]>0){
        self.gamenumberView.hidden=NO;
        NSLog(@"game update number count%@",[[[self.catesArr objectAtIndex:1] objectForKey:@"new"] stringValue]);
        
        self.gamenumberView.numLabel.text=[[[self.catesArr objectAtIndex:2] objectForKey:@"new"] stringValue];
    }
    
    
}

-(void)setBannerImg{
    
    scrollTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scrollViewAnimate) userInfo:nil repeats:YES];
    
    // [self startImageRequestWithUrl:[[self.bannerInfo objectAtIndex:2] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg3:)];
    [self startImageRequestWithUrl:[[self.bannerInfo lastObject] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg:)];
    
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
    //    switch (pageNum) {
    //        case 0:{
    //            self.pageControl.currentPage=1;
    //            CGRect rect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
    //            [self.topScrollView scrollRectToVisible:rect animated:YES];
    //        }
    //            break;
    //        case 1:{
    //            self.pageControl.currentPage=2;
    //            CGRect rect=CGRectMake(2*viewSize.width, 0, viewSize.width, viewSize.height);
    //            [self.topScrollView scrollRectToVisible:rect animated:YES];
    //        }
    //            break;
    //        case 2:{
    //            CGRect rect=CGRectMake(0, 0, viewSize.width, viewSize.height);
    //            [self.topScrollView scrollRectToVisible:rect animated:NO];
    //            self.pageControl.currentPage=0;
    //        }
    //            break;
    //
    //        default:
    //            break;
    //    }
}

-(void)pressBanner{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[self.bannerInfo objectAtIndex:self.pageControl.currentPage] objectForKey:@"link"]]];
}



-(void)reloadApps{
    [currentCateID release];
    currentCateID=[[self.appsDic objectForKey:@"cateid"] retain];
    [self.appsArr addObjectsFromArray:[self.appsDic objectForKey:@"apps"]];
    self.currentappsPage=[self.appsDic objectForKey:@"page"];
   // NSLog(@"sasdasdasdsadadasdasd%d",[self.appsArr count]);
    [self.myTableView reloadData];
    moring=NO;
}

//-(void)changeBannerImg1:(ASIHTTPRequest *)request{
//    UIImageView *imgv=(UIImageView *)[self.topScrollView viewWithTag:1];
//    imgv.image=[UIImage imageWithData:[request responseData]];
//    NSLog(@"imgv.image======%@",imgv.image);
//    [[BannerImageUtil getBannerUtil] saveBannerWithImage1:[request responseData] Link:[[self.bannerInfo objectAtIndex:0] objectForKey:@"link"]];
//}
//
//-(void)changeBannerImg2:(ASIHTTPRequest *)request{
//    UIImageView *imgv=(UIImageView *)[self.topScrollView viewWithTag:2];
//    imgv.image=[UIImage imageWithData:[request responseData]];
//    NSLog(@"imgv.image======%@",imgv.image);
//    [[BannerImageUtil getBannerUtil] saveBannerWithImage1:[request responseData] Link:[[self.bannerInfo objectAtIndex:1] objectForKey:@"link"]];
//    [self startImageRequestWithUrl:[[self.bannerInfo objectAtIndex:0] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg1:)];
//}
//
//-(void)changeBannerImg3:(ASIHTTPRequest *)request{
//    UIImageView *imgv=(UIImageView *)[self.topScrollView viewWithTag:3];
//    imgv.image=[UIImage imageWithData:[request responseData]];
//    NSLog(@"imgv.image======%@",imgv.image);
//    [[BannerImageUtil getBannerUtil] saveBannerWithImage1:[request responseData] Link:[[self.bannerInfo objectAtIndex:2] objectForKey:@"link"]];
//    [self startImageRequestWithUrl:[[self.bannerInfo objectAtIndex:1] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg2:)];
//}

-(void)changeBannerImg:(ASIHTTPRequest *)request
{
    UIImageView *imgv=(UIImageView *)[self.topScrollView viewWithTag:currentCount];
    imgv.image=[UIImage imageWithData:[request responseData]];
//    NSLog(@"imgv.image======%@",imgv);
    if(currentCount-1<0||!imgv)
    {
        currentCount--;
        return;
    }
    [[BannerImageUtil getBannerUtil] saveBannerWithImage1:[request responseData] Link:[[self.bannerInfo objectAtIndex:currentCount-1] objectForKey:@"link"]];
    if(currentCount-2<0)
    {
        currentCount--;
        return;
    }
    [self startImageRequestWithUrl:[[self.bannerInfo objectAtIndex:currentCount-2] objectForKey:@"pic"] FinishMethod:@selector(changeBannerImg:)];
    currentCount--;
}


#pragma mark - asiRequestDelegate
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
        
        NSLog(@"bannerInfobannerInfobannerI===%@",bannerInfo);
        
        if(self.bannerInfo){
            [self moveBottomView];
            [self setBannerImg];
        }
        
        self.timestamp=[[response objectForKey:@"cp"] integerValue];
        [BannerImageUtil saveTimeStamp:self.timestamp];
    }
    if([requestUrl rangeOfString:@"rcapp/apps"].length){
        [appsDic release];
        appsDic=[response retain];
        
//        NSLog(@"appDic =%@",appsDic);
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

#pragma mark - tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.appsArr count])
        return [self.appsArr count]+1;
    else
        return  [self.appsArr count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
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
        UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.tag=110;
        button1.frame=CGRectMake(23, 12, 274, 52);
        [button1 addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        button1.enabled=YES;
        [button1 setTitleColor:BgTextColor forState:UIControlStateNormal];
        [[button1 titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [button1 setTitle:@"点击加载更多" forState:UIControlStateNormal   ];
        UIImage*image=[UIImage imageNamed:@"loadmore.png"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
        [button1 setBackgroundImage:image forState:UIControlStateNormal];
        [cell.contentView addSubview:button1];
        return cell;

    }
    else
    {
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor=[UIColor grayColor];
            
            for(int i=0;i<5;i++)
            {
                starImageView[i]=[[[UIImageView alloc]initWithFrame:CGRectMake(75+i*17, 31, 17, 17)] autorelease];
                starImageView[i].tag=200+i;
                [cell.contentView addSubview:starImageView[i]];
                
            }
            UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 62, 62)] autorelease];
            imageView.tag=100;
            
            UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
            nameLabel.frame=CGRectMake(76, 8, 140, 21);
            nameLabel.tag=101;
            nameLabel.textAlignment=UITextAlignmentLeft;
            nameLabel.textColor=[UIColor darkGrayColor];
            nameLabel.font=[UIFont systemFontOfSize:17.0];
            // nameLabel.text=[self.dataArray objectAtIndex:[indexPath row]];
            
            UILabel *detailLabel=[[[UILabel alloc]init] autorelease];
            detailLabel.frame=CGRectMake(76, 48, 180, 21);
            detailLabel.tag=102;
            detailLabel.textAlignment=UITextAlignmentLeft;
            detailLabel.textColor=[UIColor darkGrayColor];
            detailLabel.font=[UIFont systemFontOfSize:12.0];
            
            UILabel *sizeLabel=[[[UILabel alloc]init] autorelease];
            sizeLabel.frame=CGRectMake(173, 29, 63, 21);
            sizeLabel.tag=103;
            sizeLabel.textAlignment=UITextAlignmentRight;
            sizeLabel.textColor=[UIColor darkGrayColor];
            sizeLabel.font=[UIFont systemFontOfSize:12.0];
            sizeLabel.text=@"流量充足请放心使用";
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
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
            [cell.contentView addSubview:detailLabel];
            [cell.contentView addSubview:sizeLabel];
            
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
            // NSLog(@"icon url=======%@",[dic objectForKey:@"icon"]);
            ASIHTTPRequest *asiRequest=[ASIHTTPRequest requestWithURL:url];
            //[asiRequest setDownloadCache:[ASIDownloadCache sharedCache]];
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
        [button setTitle:@"安装" forState:UIControlStateNormal];
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ([appsArr count]))
        return;
    NSDictionary *dic=[self.appsArr objectAtIndex: [indexPath row]];
    
    if(iPhone5)
    {
        self.recommendDetailViewController=[[[RecommendDetailViewController alloc]initWithNibName:@"RecommendDetailViewController_iphone5" bundle:nil] autorelease];
    }
    else
    {
        
        self.recommendDetailViewController=[[[RecommendDetailViewController alloc]initWithNibName:@"RecommendDetailViewController" bundle:nil] autorelease];
    }
    
    self.recommendDetailViewController.appName=[dic objectForKey:@"apname"];
    self.recommendDetailViewController.appDescibe=[dic objectForKey:@"apdesc"];
    self.recommendDetailViewController.appSize=[dic objectForKey:@"fsize"];
    self.recommendDetailViewController.appIcon=[UIImage imageWithData:[self.images objectForKey:[dic objectForKey:@"icon"]]];
    self.recommendDetailViewController.linkUrl=[dic objectForKey:@"link"];
    self.recommendDetailViewController.appStar=[[dic objectForKey:@"star"] integerValue];
    [self.view addSubview:recommendDetailViewController.view];
    
//    AppDetailsViewController *appDetail = [[AppDetailsViewController alloc] init];
//    appDetail.appImages = [UIImage imageWithData:[self.images objectForKey:[dic objectForKey:@"icon"]]];
//    appDetail.appDic = [dic mutableCopy];
//    [self.navigationController pushViewController:appDetail animated:YES];
//    [appDetail release];
//    [dic release];

    
}

-(void)loadMore:(id)sender
{
    UIButton *button=(UIButton*)sender;
    button.enabled=NO;
    if(!moring&&[self.appsArr count]>=[self.appsArr count]-1){
        
        moring=YES;
        
        [self startAPPSRequest:currentCateID Page:self.currentappsPage];
        
        
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(!moring&&[indexPath row]>=[self.appsArr count]-1){
//        moring=YES;
//        [self startAPPSRequest:currentCateID Page:self.currentappsPage];
//    }
//}

-(void)getImageByRequest:(ASIHTTPRequest *)request{
    [self.images setObject:[request responseData] forKey:[request.url absoluteString]];
    [self.myTableView reloadData];
}


-(void)lockButtonPress:(id)sender
{
    AppButton *button=(AppButton*)sender;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:button.linkUrl]];
    
    //    self.recommendDetailViewController=[[[RecommendDetailViewController alloc]init] autorelease];
    //    self.recommendDetailViewController.appName=button.appName;
    //    self.recommendDetailViewController.appDescibe=button.appDescibe;
    //    self.recommendDetailViewController.appSize=button.appSize;
    //    self.recommendDetailViewController.appIcon=[UIImage imageWithData:[self.images objectForKey:button.appIcon]];
    //    self.recommendDetailViewController.linkUrl=button.linkUrl;
    //    self.recommendDetailViewController.appStar=button.appStar;
    //    [self.view addSubview:recommendDetailViewController.view];
    
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
