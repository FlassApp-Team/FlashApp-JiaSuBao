//
//  NetworkSpeedViewController.m
//  FlashApp
//
//  Created by lidiansen on 13-1-22.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "NetworkSpeedViewController.h"
#import "ASINetworkQueue.h"
#import "DeviceInfo.h"
#import "JSON.h"
#import "ShareWeiBoViewController.h"
#import "DateUtils.h"
#import "GoLineModleViewController.h"
@interface NetworkSpeedViewController ()
-(void)loadData;
-(void)begingTestSpeed;
- (void)requestStarted;
- (void) downloadImage:(NSString*)url connectTag:(int )_connectTag;
-(NSString*)setLableTitle;
-(void)requestFinish;
-(void)starAnimation;
-(void)requestFailed;
@end

@implementation NetworkSpeedViewController
@synthesize beginTestBtn;
@synthesize downBeginTestBtn;
@synthesize topView;
@synthesize downView;
@synthesize lastBytesReceived;
@synthesize lineView;
@synthesize speedArray;
@synthesize timeArray;
@synthesize shareWeiBoViewController;
@synthesize shareBtn;
@synthesize currentLabel;
@synthesize beforeLabel;
@synthesize afterLabel;
@synthesize idcName;
@synthesize afterView;
@synthesize bgImageView;
@synthesize kuangImageView;
@synthesize cUnitLabel;
@synthesize aUnitLabel;
@synthesize controller;
@synthesize urlStr;

@synthesize timer;
@synthesize connection;
@synthesize uploadPool;
@synthesize timeLable;
-(void)dealloc
{
    done=YES;
    if(timer)
    {
        [timer invalidate];
        self.timer=nil;
    }
    if(self.connection)
    {
        [self.connection cancel];
        self.connection=nil;
    }
    self.urlStr=nil;
    self.controller=nil;
    self.cUnitLabel=nil;
    self.aUnitLabel=nil;
    self.timeLable=nil;
    self.kuangImageView=nil;
    self.bgImageView=nil;
    self.afterView=nil;
    self.idcName=nil;
    self.afterLabel=nil;
    self.beforeLabel=nil;
    self.currentLabel=nil;
    self.shareBtn=nil;
    self.shareWeiBoViewController=nil;
    self.timeArray=nil;

    self.speedArray=nil;
    self.lineView=nil;
    self.beginTestBtn=nil;
    self.topView=nil;
    self.downView=nil;
    self.downBeginTestBtn=nil;
    if(chart)
    {
        [chart release];
    }
    if(detailChart)
    {
        [detailChart release];
    }
    if( queue ) {
        
        for (ASIHTTPRequest *request in queue.operations)
        {
            [request setDelegate: nil];
            [request setDidFinishSelector: nil];
            [request setDownloadProgressDelegate:nil];
            [request setDidFailSelector:nil];
            [request cancel];

        }
        [queue setSuspended:YES];
        [queue cancelAllOperations];

        [queue release];
    }
    [super dealloc];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(timer)
    {
        [timer invalidate];
        self.timer=nil;
    }
    if(self.connection)
    {
        [self.connection cancel];
        self.connection=nil;
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([UserSettings getJiasuApeed])
    {
        NSString*str=[NSString stringWithFormat:@"%@%@",[UserSettings getJiasuApeed], @"%"];
        self.beforeLabel.text=str;
        
    }
    
    
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
    if(iPhone5)
    {
        self.lineView.frame=CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height+45);
        self.afterView.frame=CGRectMake(self.afterView.frame.origin.x, self.afterView.frame.origin.y, self.afterView.frame.size.width, self.afterView.frame.size.height+45);
    }
    UIImage *image=[UIImage imageNamed:@"white_box.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.kuangImageView.image=image;
    
    UIImage *image1=[UIImage imageNamed:@"wangge.png"];
    self.bgImageView.backgroundColor=[UIColor colorWithPatternImage:image1] ;
    self.bgImageView.opaque=NO;
    if([UserSettings currentUserSettings].netSpeedTime)
    {
        self.timeLable.text=[NSString stringWithFormat:@"上一次测试%@",[UserSettings currentUserSettings].netSpeedTime];
    }
    [self.afterView setHidden:YES];
    self.afterView.clipsToBounds=NO;
    queue = [[NSOperationQueue alloc] init];
    if(chart)
    {
        [chart release];
        chart=nil;
    }
    chart = [[DetailStatsAppSpeed alloc] init];
    chart.linColor=[UIColor colorWithRed:135.0/255 green:134.0/255 blue:132.0/255 alpha:1.0];
    chart.arColor=[UIColor colorWithRed:230.0/255 green:229.0/255 blue:229.0/255 alpha:0.3];
    
    if(detailChart)
    {
        [detailChart release];
        detailChart=nil;
    }
    
    detailChart = [[DetailStatsAppSpeed alloc] init];
    detailChart.linColor=[UIColor colorWithRed:0.0/255 green:191.0/255 blue:232.0/255 alpha:1.0];
    detailChart.arColor=[UIColor colorWithRed:191.0/255 green:239.0/255 blue:249.0/255 alpha:1.0];
    self.speedArray=[[[NSMutableArray alloc]init]autorelease];
    self.timeArray=[[[NSMutableArray alloc]init] autorelease];
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    self.idcName.text=[NSString stringWithFormat:@"当前网络: 3G-加速宝%@",user.idcName];
}
-(IBAction)turnBtnPress:(id)sender
{
    done=YES;
    GoLineModleViewController*golineController=(GoLineModleViewController*)self.controller;


    [golineController judegServerOpen ];
    [[sysdelegate navController  ] popViewControllerAnimated:YES];

}

-(IBAction)beginTestBtnPress:(id)sender
{
    [self.topView setHidden:YES];
    [self.downView setHidden:NO];
    [self.afterView setHidden:NO];
    [self begingTestSpeed];


}
-(IBAction)shareBtnPress:(id)sender
{
    if(self.shareWeiBoViewController!=nil)
    {
        [self.shareWeiBoViewController.view removeFromSuperview];
    }
    self.shareWeiBoViewController=[[[ShareWeiBoViewController alloc ]init] autorelease];
    [self.view addSubview:self.shareWeiBoViewController.view];
    self.shareWeiBoViewController.backView.frame=CGRectMake(self.shareWeiBoViewController.backView.frame.origin.x, self.shareBtn.frame.size.height+self.shareBtn.frame.origin.y-10, self.shareWeiBoViewController.backView.frame.size.width, self.shareWeiBoViewController.backView.frame.size.height);

}




#pragma -mark Test Speed
-(IBAction)downBeginTestBtnPress:(id)sender
{
    [self begingTestSpeed];

}
-(void)begingTestSpeed
{
    connectTag=0;
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    ConnectionType  type = [UIDevice connectionType];
    NSString *typeUrl=nil;
    if ( type==CELL_2G)
    {
        typeUrl=@"wifi";
    }
    else  if(type==CELL_3G )
    {
        typeUrl=@"3g";
        
    }
    else  if(type==CELL_4G)
    {
        typeUrl=@"4g";
        
    }
    else
    {
        typeUrl=@"wifi";
    }
    
    self.downBeginTestBtn.userInteractionEnabled=NO;
    [self.downBeginTestBtn setBackgroundImage:[UIImage imageNamed:@"star1_btn_bg.png"] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitle:@"请稍候..." forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[self.downBeginTestBtn titleLabel]setShadowOffset:CGSizeMake(0, 0)];
    

    
    NSString*str=[NSString stringWithFormat:@"http://p.flashapp.cn/api/data/spdtest?deviceId=%@&connType=%@",device.deviceId,typeUrl];
    [self.speedArray removeAllObjects];
    [self.timeArray removeAllObjects];
    [chart renderInView:self.lineView withTheme:nil];
    [detailChart renderInView:self.afterView withTheme:nil];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    request.delegate=self;
    [queue addOperation:request];
    
    
    if([UserSettings currentUserSettings].netSpeedTime)
    {
        self.timeLable.text=[NSString stringWithFormat:@"上一次测试%@",[UserSettings currentUserSettings].netSpeedTime];
    }
    time_t now;
    time( &now );
    NSString*timeStr=[DateUtils stringWithDateFormat:now format:@"yyyy年MM月dd日HH:mm"];
    [UserSettings  saveSpeedTime:timeStr];
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(connectTag==102||connectTag==101)
        return;
    
    
    [self requestStarted];
    self.urlStr=[[request.responseString JSONValue] objectAtIndex:0];
    [self downloadImage:[[request.responseString JSONValue] objectAtIndex:0] connectTag:101];
    
}

-(void)uploadView
{
    int bytes=received_;
    if(bytes==0)
        return;
    if(countFlag>=10)
    {
        [connection cancel];
        self.connection=nil;
        countFlag=0;
        if(connectTag==102)
        {
            [self requestFinish];

            return;
        }
        else if(connectTag==101)
        {
            //[self requestStarted];
            [self downloadImage:self.urlStr connectTag:102];

        }
        
        return;
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastBytesReceived];
    
    
    if(connectTag==101)
    {
        float KB = (bytes / 1024);
        int kbPerSec =  KB * (1.0/interval); //KB * (1 second / interval (less than one second))
        if(kbPerSec<=1)
            kbPerSec=5+kbPerSec;
        NSNumber *BB=[NSNumber numberWithInteger:kbPerSec];
        [self.speedArray addObject:BB];
        NSNumber*TT=[NSNumber numberWithInt:countFlag];
        [self.timeArray addObject:TT];
        
        chart.userAgentData=self.speedArray;
        chart.timeArray=self.timeArray;
        if(chart.spaceYY<=kbPerSec)
            chart.spaceYY=kbPerSec+1;
      //  self.currentLabel.text=[NSString stringWithFormat:@"%0.0f",kbPerSec];
        self.currentLabel.text=[self setLableTitle];
        self.cUnitLabel.text=@"KB";
        [AppDelegate setLabelFrame:self.currentLabel label2:self.cUnitLabel];
        //NSLog(@" time received in %f seconds @ %dKB/s  byte===%f",interval, kbPerSec,KB);
        [chart renderInView:self.lineView withTheme:nil];
        
    }
    else  if(connectTag==102)
    {
        float KB = (bytes / 1024);
        int kbPerSec =  KB * (1.0/interval); //KB * (1 second / interval (less than one second))
        if(kbPerSec<=1)
            kbPerSec=5+kbPerSec;
        float curSped=[self.currentLabel.text intValue];
        float jiasu=kbPerSec+curSped*0.2;
        if(jiasu/curSped<1)
        {
            kbPerSec=kbPerSec+curSped;
        }
        else
            kbPerSec=jiasu;
        self.afterLabel.text=[NSString stringWithFormat:@"%d",kbPerSec];

        NSNumber *BB=[NSNumber numberWithInteger:kbPerSec];
        [self.speedArray addObject:BB];
        NSNumber*TT=[NSNumber numberWithInt:countFlag];
        [self.timeArray addObject:TT];

        

        detailChart.userAgentData=self.speedArray;
        detailChart.timeArray=self.timeArray;
        if(detailChart.spaceYY<=kbPerSec)
        {
            detailChart.spaceYY=kbPerSec+1;
        }
        self.aUnitLabel.text=@"KB";
        self.afterLabel.text=[NSString stringWithFormat:@"%d",kbPerSec];
        [AppDelegate setLabelFrame:self.afterLabel label2:self.aUnitLabel];
        NSLog(@"detailChart time received in %f seconds @ %dKB/s  byte===%f",interval, kbPerSec,KB);
        
        [detailChart renderInView:self.afterView withTheme:nil];
    }
    countFlag++;
    

}
-(void)requestFinish
{
    [self.timer invalidate];
    self.timer=nil;
    if(connectTag==101)
    {
        self.currentLabel.text=[self setLableTitle];
        return;
    }
    else if(connectTag==102)
    {
        self.afterLabel.text=[self setLableTitle];
        float curSped=[self.currentLabel.text intValue];
        float afterSped=[self.afterLabel.text intValue];
       //NSLog(@"KKKKKKKKKKKKKKKKK%f",afterSped/curSped);
        if((afterSped/curSped)<=1.0)
        {
            afterSped=curSped+curSped*0.2;
            if(afterSped==curSped)
                afterSped=afterSped+afterSped*0.2;
            self.afterLabel.text=[NSString stringWithFormat:@"%0.0f",afterSped];

        }
        afterSped=[self.afterLabel.text intValue];
        if(curSped==0)
        {
            curSped=1;
            afterLabel=0;
        }
        [self  starAnimation];
        [self performSelector:@selector(finishTest) withObject:nil afterDelay:0.6];
        [self.downBeginTestBtn setTitle:@"测速完成" forState:UIControlStateNormal];
        [UserSettings saveJiasuApeed:[NSString stringWithFormat:@"%0.0f",afterSped/curSped*100]];

        [AppDelegate setLabelFrame:self.afterLabel label2:self.aUnitLabel];

        self.beforeLabel.text=[NSString stringWithFormat:@"%0.0f%@",afterSped/curSped*100,@"%"];

        return;
    }

}
-(void)finishTest
{
    self.downBeginTestBtn.userInteractionEnabled=YES;
    [self.downBeginTestBtn setBackgroundImage:[UIImage imageNamed:@"bluebtn.png"] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitle:@"再次测速" forState:UIControlStateNormal];
    [AppDelegate buttonTopShadow:self.downBeginTestBtn shadowColor:BgTextColor];
    

}
-(NSString*)setLableTitle
{
    int count=0;
    for(int i=0;i<[self.speedArray count];i++)
    {
        NSNumber *BB=[self.speedArray objectAtIndex:i];
        float bb=[BB floatValue];
        count+=bb;

    }
   return [NSString stringWithFormat:@"%d",count/[self.speedArray count]];

}
-(void)requestStarted
{

    countFlag=1;//X轴初始值

    if(timer)
    {
        [timer invalidate];
        self.timer=nil;
    }
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(uploadView) userInfo:nil repeats:YES];
    if(!self.lastBytesReceived)
        self.lastBytesReceived=nil;
    self.lastBytesReceived=[NSDate date];
    received_=0;

    
    
    self.downBeginTestBtn.userInteractionEnabled=NO;
    [self.downBeginTestBtn setBackgroundImage:[UIImage imageNamed:@"star1_btn_bg.png"] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitle:@"请稍候..." forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[self.downBeginTestBtn titleLabel]setShadowOffset:CGSizeMake(0, 0)];

    [self.speedArray removeAllObjects];
    [self.timeArray removeAllObjects];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{

    [self requestFailed];

}
-(void)requestFailed
{
    self.downBeginTestBtn.userInteractionEnabled=YES;
    [self.downBeginTestBtn setBackgroundImage:[UIImage imageNamed:@"bluebtn.png"] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitle:@"开始测速" forState:UIControlStateNormal];
    [AppDelegate buttonTopShadow:self.downBeginTestBtn shadowColor:BgTextColor];
    done=YES;
    [AppDelegate showAlert:@"网络异常" message:@"请检查网络连接."];
}
#pragma -make animation Methon
-(void)starAnimation
{
    self.beforeLabel. transform=CGAffineTransformMakeScale(4,  4);
    self.beforeLabel.center=CGPointMake( __MainScreenFrame.size.height/2,  __MainScreenFrame.size.width/2);
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         self.beforeLabel. transform=CGAffineTransformMakeScale(1,  1);
                         self.beforeLabel.frame=CGRectMake(233, 183, 84, 32);
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}




- (void) downloadImage:(NSString*)url connectTag:(int )_connectTag
{
    connectTag=_connectTag;
    [self requestStarted];

    self.uploadPool = [[NSAutoreleasePool alloc] init];
    
    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];
    theRequest.timeoutInterval=30.0f;

    self.connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    // [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    if (connection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
    if(connection)
    {
        self.connection = nil;
    }
    if(uploadPool)
    {
        [uploadPool release];
        uploadPool=nil;
    }
}



// Forward errors to the delegate.

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    if (received_==0)
//    {
//        [self requestFailed];
//        done = YES;
//        return;
//
//    }

    done = YES;
   // [self requestFailed];
}


// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    received_ += [data length];
    //NSLog(@"FFFFFFFFFFFFFFFF+==%d",received_);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"完成");
    // [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    // Set the condition which ends the run loop.
    done = YES;
    // [connection cancel];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
