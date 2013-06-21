//
//  TaoCanModleViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "TaoCanModleViewController.h"
#import "TaoCanViewController.h"
#import "FlowJiaoZhunViewController.h"
@interface TaoCanModleViewController ()
-(void)loadData;
@end

@implementation TaoCanModleViewController
@synthesize tcCountLabel;
@synthesize tcUseLabel;
@synthesize taocanBtn;
@synthesize tcUnitLabel;
@synthesize messageLabel;
-(void)dealloc
{
    self.messageLabel=nil;
    self.tcUnitLabel=nil;
    self.tcUseLabel=nil;
    self.tcCountLabel=nil;
    self.taocanBtn=nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.taocanBtn.controller=self;
  //  self.tcCountLabel.font = [UIFont fontWithName:@"count" size:44.0];

    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:RefreshNotification object: nil];

    // Do any additional setup after loading the view from its nib.
}

-(void)loadData
{
    NSString *str=nil;
    UserSettings* user = [AppDelegate getAppDelegate].user;
    float totalm=[user.ctTotal floatValue]; //套餐全部流量
    long  long byte=[user.ctUsed longLongValue]; //用户已使用流量
    float count=totalm- byte / 1024.0f / 1024.0f;
 
    self.tcUnitLabel.text=@"MB";
    if(totalm==0)
    {
        self.tcUseLabel.text=[NSString stringWithFormat:@"流量已用%d%@",0,@"%"];
        self.tcCountLabel.text=@"0.00";
        [self.messageLabel setHidden:NO];
        [self.tcCountLabel setHidden:YES];
        [self.tcUseLabel setHidden:YES];
        [self.tcUnitLabel setHidden:YES];
        
    }
    else
    {
        [self.messageLabel setHidden:YES];
        [self.tcCountLabel setHidden:NO];
        [self.tcUseLabel setHidden:NO];
        [self.tcUnitLabel setHidden:NO];
        if(count/1000>1||count/1000<-1)
        {
            str=  [NSString stringWithFormat:@"%.2f",(totalm- byte / 1024.0f / 1024.0f)/1024.0f];
            self.tcUnitLabel.text=@"GB";
            
        }
        else
        {
            if(count/100>1||count/100<-1)
            {
                str=  [NSString stringWithFormat:@"%.0f",totalm- byte / 1024.0f / 1024.0f];
                
            }
            else
            {
                if(count/10>1||count/10<-1)
                {
                    str=  [NSString stringWithFormat:@"%.1f",totalm- byte / 1024.0f / 1024.0f];
                    
                }
                else
                {
                    str=  [NSString stringWithFormat:@"%.2f",totalm- byte / 1024.0f / 1024.0f];
                    
                }
                
            }
            
        }

        float persent= byte / 1024.0f / 1024.0f/totalm*100;
        if(persent>=1)
        {
            self.tcUseLabel.text=[NSString stringWithFormat:@"流量已用%.0f%@",persent,@"%"];
            
        }
        else
        {
            self.tcUseLabel.text=[NSString stringWithFormat:@"流量已用%.2f%@",persent,@"%"];
        }
        

    }
   
    self.tcCountLabel.text=str;
    [AppDelegate setLabelFrame:self.tcCountLabel label2:self.tcUnitLabel];


}
-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    float totalm=[user.ctTotal floatValue];
    if(totalm)
    {
        TaoCanViewController*taoCanViewController=[[TaoCanViewController alloc]init];
        [[sysdelegate navController  ] pushViewController:taoCanViewController animated:YES];
        [taoCanViewController release];
    }
    else
    {
        FlowJiaoZhunViewController*flowJiaoZhunViewController=[[FlowJiaoZhunViewController alloc]init];
        [[sysdelegate navController  ] pushViewController:flowJiaoZhunViewController animated:YES];
        [flowJiaoZhunViewController release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
