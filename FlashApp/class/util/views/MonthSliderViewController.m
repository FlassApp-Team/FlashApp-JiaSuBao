//
//  MonthSliderViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-18.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define MonthNumber 50
#import "MonthSliderViewController.h"
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#import "TCUtils.h"
@interface MonthSliderViewController ()

@end

@implementation MonthSliderViewController
@synthesize superScrollView;
@synthesize startTime;
@synthesize endTime;
@synthesize scrollview;
@synthesize monthArray;
@synthesize currentStats;
-(void)dealloc
{
    self.superScrollView=nil;
    self.monthArray=nil;
    self.scrollview=nil;
    self.currentStats=nil;
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
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    
    currentPage= -1;
    
    self.monthArray=[[[NSMutableArray alloc]init]autorelease];
    self.view.clipsToBounds=NO;
    self.scrollview.pagingEnabled=YES;
    self.scrollview.scrollEnabled=NO;
    self.scrollview.delegate=self;
    self.scrollview.clipsToBounds=NO;
    [self.scrollview setShowsHorizontalScrollIndicator:NO];
    [self.scrollview setShowsVerticalScrollIndicator:NO];
    
    //  [self initscrollview];
    
    
}

- (void)loadScrollViewWithPage:(int)page  _StageStats:(StageStats*) StatsTime
{
    // NSLog(@"self.asdasdasdasdasdasda%@",StatsTime);
    
    if (page < 0)
        return;
    if (page >= MonthNumber)
        return;
    if(!StatsTime)
        return;
    UILabel *label;
    UIButton *button;
    label=[[[UILabel alloc]init]autorelease];
    label.frame=CGRectMake(35+self.scrollview.bounds.size.width*page, 11, 173, 37);
    label.textAlignment=UITextAlignmentLeft;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:32.0];
    NSString *str = [TCUtils monthDescForStartTime:StatsTime.startTime endTime:StatsTime.endTime];
    label.text=str;
    label.tag=2000+page;
    label.alpha=0.5;
    [AppDelegate labelShadow:label];
    
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(8+self.scrollview.bounds.size.width*page, 11, 22, 38);
    button.tag=2000+page+1000;
    button.alpha=0.0;
    [button setImage:[UIImage imageNamed:@"left_triangle.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    if(page==0)
    {
        label.alpha=1.0;
        button.alpha=1.0;
    }
    
    [self.scrollview  addSubview:button];
    [self.scrollview  addSubview:label];
    currentPage++;
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width * (page+1), self.scrollview.frame.size.height);
}

-(void)leftBtnPress:(UIButton*)button
{
    int cha=self.scrollview.contentOffset.x;
    int cha1=self.scrollview.frame.size.width;
    int cha2=cha/cha1;
    
    //    // NSLog(@"AAAAAAAAAAA%d",cha2);
    if(cha2>=currentPage)
    {
        return;
    }
    [self.scrollview setContentOffset:CGPointMake(self.scrollview.frame.size.width*(cha2+1), 0) animated:YES];
    [self.superScrollView setContentOffset:CGPointMake(self.superScrollView.frame.size.width*(cha2+1), 0) animated:YES];
    
    // [self bgViewAnimation:sliderView alpha:1.0];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int cha=self.scrollview.contentOffset.x;
    int cha1=self.scrollview.frame.size.width;
    int cha2=cha%cha1;
    
    float labelX =cha2/(self.scrollview.frame.size.width-35)*0.5+0.5;
    float buttonX =cha2/(self.scrollview.frame.size.width-14)*1;
    
    UILabel *label=(UILabel*)[self.scrollview viewWithTag:2001+ cha/cha1];
    UIButton *button=(UIButton*)[self.scrollview viewWithTag:cha/cha1+3001];
    label.alpha=labelX;
    button.alpha=buttonX;
    
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
