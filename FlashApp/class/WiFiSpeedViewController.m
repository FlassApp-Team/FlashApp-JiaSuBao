//
//  WiFiSpeedViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-20.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "WiFiSpeedViewController.h"
#import "ShareWeiBoViewController.h"
#import "ASIHTTPRequest.h"
#import "DeviceInfo.h"
#import "JSON.h"
#import "DateUtils.h"
@interface WiFiSpeedViewController ()
-(void)begingTestSpeed;
-(void)requestFinish;
-(void)requestStarted;
- (void) downloadImage:(NSString*)url;
-(void)requestFailed;
-(NSString*)setLableTitle;
-(void)starAnimation;
@end

@implementation WiFiSpeedViewController
@synthesize shareWeiBoViewController;
@synthesize currentSpeedLabel;
@synthesize currentUnitLabel;
@synthesize averageSpeedLabel;
@synthesize averageUnitLabel;
@synthesize beginTestBtn;
@synthesize topView;
@synthesize downView;
@synthesize topMessageLabel;
@synthesize downMessageLabel;
@synthesize downBeginTestBtn;
@synthesize lineView;
@synthesize wanggeImageView;
@synthesize kuangImageView;
@synthesize uploadPool;
@synthesize connection;
@synthesize timer;
@synthesize timeArray;
@synthesize speedArray;
@synthesize lastBytesReceived;
@synthesize shareBtn;

-(void)dealloc
{
    self.wanggeImageView=nil;
    self.lastBytesReceived=nil;
    self.kuangImageView=nil;
    self.lineView=nil;
    self.timeArray=nil;
    self.speedArray=nil;
    if(uploadPool)
    {
        [uploadPool release];
        self.uploadPool = nil;
    }

   
    if(chart)
    {
        [chart release];
        chart=nil;
    }
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
    self.downBeginTestBtn=nil;
    self.topMessageLabel=nil;
    self.downMessageLabel=nil;
    self.downView=nil;
    self.topView=nil;
    self.currentSpeedLabel=nil;
    self.currentUnitLabel=nil;
    self.averageUnitLabel=nil;
    self.averageSpeedLabel=nil;
    self.beginTestBtn=nil;
    self.shareBtn=nil;
    self.shareWeiBoViewController=nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(IBAction)turnBack:(id)sender
{
    done = YES;
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}
-(IBAction)beginTestBtnPress:(id)sender
{
    [self.topView setHidden:YES];
    [self.downView setHidden:NO];
    [self.lineView setHidden:NO];
    [self begingTestSpeed];

}
-(IBAction)downBeginTestBtnPress:(id)sender
{
    [self begingTestSpeed];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(iPhone5)
    {
        self.lineView.frame=CGRectMake(self.lineView.frame.origin.x, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }
    
    self.lineView.clipsToBounds=NO;
    [self.topView setHidden:NO];
    [self.downView setHidden:YES];
    [AppDelegate setLabelFrame:self.currentSpeedLabel label2:self.currentUnitLabel];
    [AppDelegate setLabelFrame:self.averageSpeedLabel label2:self.averageUnitLabel];

    received_=0;
    

    self.speedArray=[[[NSMutableArray alloc]init]autorelease];
    self.timeArray=[[[NSMutableArray alloc]init] autorelease];
    [self.lineView setHidden:YES];
    
    UIImage *image=[UIImage imageNamed:@"white_box.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.kuangImageView.image=image;
    
    UIImage *image1=[UIImage imageNamed:@"wangge.png"];
    self.wanggeImageView.backgroundColor=[UIColor colorWithPatternImage:image1] ;
    self.wanggeImageView.opaque=NO;
    if([UserSettings currentUserSettings].netSpeedTime)
    {
        self.downMessageLabel.text=[NSString stringWithFormat:@"上一次测试%@",[UserSettings currentUserSettings].netSpeedTime];
    }

    
}
-(void)begingTestSpeed
{
    DeviceInfo* device = [DeviceInfo deviceInfoWithLocalDevice];
    ConnectionType  type = [UIDevice connectionType];
    NSString *typeUrl=nil;
    if ( type==CELL_2G)
    {
        typeUrl=@"2g";
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
    NSString*urlStr=[NSString stringWithFormat:@"http://p.flashapp.cn/api/data/spdtest?deviceId=%@&connType=%@",device.deviceId,typeUrl];
    [self.speedArray removeAllObjects];
    [self.timeArray removeAllObjects];
   // [chart renderInView:self.lineView withTheme:nil];
    self.downBeginTestBtn.userInteractionEnabled=NO;
    [self.downBeginTestBtn setBackgroundImage:[UIImage imageNamed:@"star1_btn_bg.png"] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitle:@"请稍候..." forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[self.downBeginTestBtn titleLabel]setShadowOffset:CGSizeMake(0, 0)];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate=self;
    [request  startAsynchronous];
    time_t now;
    time( &now );
    NSString*timeStr=[DateUtils stringWithDateFormat:now format:@"yyyy年MM月dd日HH:mm"];
    [UserSettings  saveSpeedTime:timeStr];
}
-(void)uploadView
{


    int bytes=received_;
    if(bytes==0)
        return;
    if(countFlag>=10)
    {
        countFlag=0;
        [self requestFinish];
        [connection cancel];
        [self.timer invalidate];
        self.timer=nil;
        return;
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastBytesReceived];
    
    float KB = (bytes / 1024);
    float kbPerSec =  KB * (1.0/interval); //KB * (1 second / interval (less than one second))
    NSNumber *BB=[NSNumber numberWithInteger:kbPerSec];
    [self.speedArray addObject:BB];
    NSNumber*TT=[NSNumber numberWithInt:countFlag];
    [self.timeArray addObject:TT];
    
    chart.userAgentData=self.speedArray;
    chart.timeArray=self.timeArray;
    chart.spaceYY=(kbPerSec+30)*2;
    self.currentSpeedLabel.text=[NSString stringWithFormat:@"%0.0f",kbPerSec];
    self.currentUnitLabel.text=@"KB";
    [AppDelegate setLabelFrame:self.currentSpeedLabel label2:self.currentUnitLabel];
    NSLog(@" time received in %f seconds @ %0.01fKB/s  byte===%f",interval, kbPerSec,KB);
    [chart renderInView:self.lineView withTheme:nil];

    countFlag++;

}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [self requestStarted];
    [self downloadImage:[[request.responseString JSONValue] objectAtIndex:0]];   
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
    
    [AppDelegate showAlert:@"测速失败,请重新测试"];

}
-(void)requestFinish
{
    self. averageSpeedLabel.text=[self setLableTitle];
    self.averageUnitLabel.text=@"KB";
    [AppDelegate setLabelFrame:self.averageSpeedLabel label2:self.averageUnitLabel];
    [self  starAnimation];
    [self performSelector:@selector(finishTest) withObject:nil afterDelay:0.6];


    
}
-(void)finishTest
{
    self.downBeginTestBtn.userInteractionEnabled=YES;
    [self.downBeginTestBtn setBackgroundImage:[UIImage imageNamed:@"bluebtn.png"] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downBeginTestBtn setTitle:@"再次测速" forState:UIControlStateNormal];
    [AppDelegate buttonTopShadow:self.downBeginTestBtn shadowColor:BgTextColor];
    return;
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
    if(chart)
    {
        [chart release];
        chart=nil;
    }
    chart = [[DetailStatsAppSpeed alloc] init];
    chart.linColor=[UIColor colorWithRed:0.0/255 green:191.0/255 blue:232.0/255 alpha:1.0];
    chart.arColor=[UIColor colorWithRed:191.0/255 green:239.0/255 blue:249.0/255 alpha:1.0];
    
    
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
    countFlag=1;//X轴初始值
    [self.speedArray removeAllObjects];
    [self.timeArray removeAllObjects];
}


#pragma -make animation Methon
-(void)starAnimation
{
    self.averageSpeedLabel. transform=CGAffineTransformMakeScale(4,  4);
    self.averageSpeedLabel.center=CGPointMake( __MainScreenFrame.size.height/2,  __MainScreenFrame.size.width/2);
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         self.averageSpeedLabel. transform=CGAffineTransformMakeScale(1,  1);
                         self.averageSpeedLabel.frame=CGRectMake(233, 183, 58, 32);
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

- (void) downloadImage:(NSString*)url{
    self.uploadPool = [[NSAutoreleasePool alloc] init];

    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setValue:@"flashapp/1.0 speedit CFNetwork/548.1.4 Darwin/11.0.0" forHTTPHeaderField:@"User-Agent"];

    theRequest.timeoutInterval=30.0f;
    self.connection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
    // [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
     if (connection != nil) {
         do {
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
      } while (!done);
     }

        self.connection = nil;
        [uploadPool release];
        self.uploadPool = nil;
}



// Forward errors to the delegate.

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    done = YES;
   // [self requestFailed];
}


// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
     received_ += [data length];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"完成");
    // [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    // Set the condition which ends the run loop.
    done = YES;
   // [connection cancel];
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
