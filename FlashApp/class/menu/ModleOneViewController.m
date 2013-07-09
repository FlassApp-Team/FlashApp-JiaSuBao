//
//  ModleOneViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "ModleOneViewController.h"
#import "DatastatsViewController.h"
#import "TCUtils.h"
#import "StatsMonthDAO.h"
#import "StringUtil.h"
@interface ModleOneViewController ()
-(void)loadData;
-(NSString*)initView:(float)count;
@end

@implementation ModleOneViewController
@synthesize jieshenBtn;
@synthesize countLabel;
@synthesize unitLabel;
-(void)dealloc
{
    self.unitLabel=nil;
    self.countLabel=nil;
    self.jieshenBtn=nil;
    [super dealloc];
}


-(void)nextContorller
{
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    UIView *view=(UIView*)[self.view viewWithTag:101];
    [view removeFromSuperview];
    DatastatsViewController*datastatsViewController=nil;
    if(iPhone5)
    {
        datastatsViewController=[[[DatastatsViewController alloc]initWithNibName:@"DatastatsViewController_iphon5" bundle:nil] autorelease];

    }
    else
    {
        
         datastatsViewController=[[[DatastatsViewController alloc]initWithNibName:@"DatastatsViewController" bundle:nil] autorelease];
    }
    [[sysdelegate navController  ] pushViewController:datastatsViewController animated:YES];

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
    jieshenBtn.controller=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:RefreshNotification object: nil];

    [self loadData];
    //self.countLabel.font = [UIFont fontWithName:@"CourierNewNumeric" size:44.0f];
    [AppDelegate setLabelFrame:self.countLabel label2:self.unitLabel];
    
    
//    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    
//    NSArray *fontNames;
//    
//    NSInteger indFamily, indFont;
//    
//    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
//        
//    {
//        
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        
//        fontNames = [[NSArray alloc] initWithArray:
//                     
//                     [UIFont fontNamesForFamilyName:
//                      
//                      [familyNames objectAtIndex:indFamily]]];
//        
//        for (indFont=0; indFont<[fontNames count]; ++indFont)
//            
//        {
//            
//            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
//            
//        }
//        
//        [fontNames release];
//        
//    }
//    
//    [familyNames release];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData
{
    time_t now;
    time(&now);
    time_t peroid[2];
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    long startTime=peroid[0];
    long endTime=peroid[1];
    StageStats *stageStas = [StatsMonthDAO statForPeriod:startTime endTime:endTime];
    float number = [NSString bytesNumberByUnit:stageStas.bytesBefore-stageStas.bytesAfter unit:@"MB"];
    
    NSString* item1Number = [self initView:number];
    self.countLabel.text=item1Number;
}

-(NSString*)initView:(float)count
{
    NSString *str=nil;
    self.unitLabel.text=@"MB";
    if(count/1000>1)
    {
        str=  [NSString stringWithFormat:@"%.2f",count/1024.0f];
        self.unitLabel.text=@"GB";
        
    }
    else
    {
        if(count/100>1)
        {
            str=  [NSString stringWithFormat:@"%.0f",count];
            
        }
        else
        {
            if(count/10>1)
            {
                str=  [NSString stringWithFormat:@"%.1f",count];
                
            }
            else
            {
                str=  [NSString stringWithFormat:@"%.2f",count];
                
            }
            
        }
        
    }
    return str;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
