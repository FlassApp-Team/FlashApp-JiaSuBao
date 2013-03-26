//
//  SetingViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-21.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define BGimageViewOfSet      -20
#define TAG_PROFILE_SWITCH 200
#define TAG_PROFILE_TEXT 201
#define TAG_ALERT_PROFILE 300

#define TAG_TONGZHI_LABEL 401
#import "SetingViewController.h"
#import "UserInfoViewController.h"
#import "FeedbackViewController.h"
#import "APNViewController.h"
#import "CommonProblemViewController.h"
#import "UpdateViewController.h"
#import "BoundPhoneiewController.h"
#import "AccountNumberViewController.h"
#import "StarViewController.h"
#import "AboutFlashViewController.h"
#import "VPNHelpViewController.h"
@interface SetingViewController ()

@end

@implementation SetingViewController
@synthesize userInfoViewController;
@synthesize fanKuiBtn;
@synthesize dataArray;
@synthesize updateViewController;
@synthesize bgView;
@synthesize setTableView;
@synthesize boundPhoneiewController;
@synthesize bigImageView;
@synthesize compressionServer;
-(void)dealloc
{
    self.bigImageView=nil;
    self.setTableView=nil;
    self.dataArray=nil;
    self.fanKuiBtn=nil;
    self.userInfoViewController=nil;
    
    
    self.updateViewController=nil;
    self.boundPhoneiewController=nil;
    self.bgView=nil;
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
    NSUserDefaults*userDefault=[NSUserDefaults standardUserDefaults];
    BOOL tongZhiFlag=[userDefault boolForKey:@"tongZhiFlag"];
    if(!tongZhiFlag)
        tongZhiFlag=TRUE;
    [userDefault setBool:tongZhiFlag forKey:@"tongZhiFlag"];
    
    
    
    
    self.setTableView.separatorColor=[UIColor clearColor];
    [self.setTableView setShowsVerticalScrollIndicator:NO];
    [AppDelegate labelShadow:self.fanKuiBtn.titleLabel];
    

    self.bigImageView.frame = CGRectMake(0, BGimageViewOfSet, 320, 270);
    
    
    UIImage* img=[UIImage imageNamed:@"opaque_small.png"];
    img=[img stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [self.fanKuiBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    
    self.dataArray=[[[NSMutableArray alloc]initWithObjects:@"压缩服务",@"APN校准",@"通知",@"新手上路",@"常见问题",@"软件评分",@"检测更新",@"关于加速宝", nil]autorelease];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self.scrollView setContentOffset:CGPointMake(0.0, 0.0)];
}
-(IBAction)fankuiBtnPress:(id)sender
{
    FeedbackViewController*feedbackViewController=[[[FeedbackViewController alloc]init] autorelease];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}
-(IBAction)turnBrnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}

-(IBAction)apnBtnPresss:(id)sender
{

}
-(IBAction)questionBtnPress:(id)sender
{

}
-(IBAction)updateBtnPress:(id)sender
{

 
}

-(void)refresh
{
    UITableViewCell* cell = [self. setTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ( !cell ) return;
    
    UIButton * button = (UIButton*) [cell.contentView viewWithTag:TAG_PROFILE_SWITCH];
    UILabel * label = (UILabel*) [cell.contentView viewWithTag:TAG_PROFILE_TEXT];

    UserSettings* user = [AppDelegate getAppDelegate].user;
    ConnectionType type = [UIDevice connectionType];
    if ( user.proxyFlag == INSTALL_FLAG_NO||type==WIFI ) 
    {
        self.compressionServer=YES;
        label.text=@"关";
        [button setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];
    }
    else {
        self.compressionServer=NO;
        label.text=@"开";
        [button setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];
    }

}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserAgentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
//        UIColor* color=[UIColor blueColor];//cell选中后的效果
//        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
//        cell.selectedBackgroundView.backgroundColor=color;
        
    }
    for ( UIView* v in cell.contentView.subviews )
    {
        [v removeFromSuperview];
    }
   // NSLog(@"AAAAAAAAAA%@",cell.contentView.subviews);
    if([indexPath row]==3)
    {
        UIView *bgImageView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
        bgImageView.backgroundColor=[UIColor colorWithRed:248.0/255 green:245.0/255 blue:242.0/255 alpha:1.0] ;
        [cell.contentView addSubview:bgImageView];

        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        lineImageView.frame=CGRectMake(0, 10, 320, 1);
        lineImageView.image=[UIImage imageNamed:@"henxian.png"];
        [cell.contentView addSubview:lineImageView];

    }
    else
    {
        UIView *bgImageView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, cell.frame.size.height)] autorelease];
        bgImageView.backgroundColor=[UIColor whiteColor] ;
        [cell.contentView addSubview:bgImageView];
        
        
        if([indexPath row]==0)
        {
            cell.textLabel. textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text=@"  压缩服务";
            
            
            UserSettings* user = [AppDelegate getAppDelegate].user;
     
            //        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
            //        lineImageView.frame=CGRectMake(0, -2, 320, 1);
            //        lineImageView.image=[UIImage imageNamed:@"henxian.png"];
            //        [cell.contentView addSubview:lineImageView];
            
            UIButton *turnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            turnBtn.tag=TAG_PROFILE_SWITCH;
            turnBtn.frame=CGRectMake(269, 14, 45, 18);//259 92 48 1
            [turnBtn addTarget:self action:@selector(turnServeBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *turnLabe=[[[UILabel alloc]init] autorelease];
            turnLabe.frame=CGRectMake(240, 11, 25, 21);
            turnLabe.tag= TAG_PROFILE_TEXT;

            turnLabe.textAlignment=UITextAlignmentLeft;
            turnLabe.textColor=[UIColor darkGrayColor];
            turnLabe.font=[UIFont systemFontOfSize:17.0];
            [turnLabe setBackgroundColor:[UIColor clearColor]];
            ConnectionType type = [UIDevice connectionType];
            if ( user.proxyFlag == INSTALL_FLAG_NO||type==WIFI ) {
               // cell.textLabel.text = NSLocalizedString(@"set.service.status.closed", nil);
               //switcher.on = NO;
                self.compressionServer=YES;
                turnLabe.text=@"关";
                [turnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];


            }
            else {
               // cell.textLabel.text = NSLocalizedString(@"set.service.status.opened", nil);
               // switcher.on = YES;
                self.compressionServer=NO;
                  turnLabe.text=@"开";
                [turnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];

            }
          
            
            [cell.contentView addSubview:turnBtn];
            [cell.contentView addSubview:turnLabe];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;

        }
        if([indexPath row]==1)
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel. textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            if ([CHANNEL compare:@"appstore"] == NSOrderedSame) {
                cell.textLabel.text = @"  VPN设置";
            }
            else{
                cell.textLabel.text=@"  APN校准";
            }
        }
        if([indexPath row]==2)
        {
            
            cell.textLabel. textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text=@"  通知";
            
            UILabel *turnLabe=[[[UILabel alloc]init] autorelease];
            turnLabe.tag=TAG_TONGZHI_LABEL;
            turnLabe.frame=CGRectMake(240, 11, 25, 21);
            turnLabe.textAlignment=UITextAlignmentLeft;
            turnLabe.textColor=[UIColor darkGrayColor];
            turnLabe.font=[UIFont systemFontOfSize:17.0];
            [turnLabe setBackgroundColor:[UIColor clearColor]];
            
            
            UIButton *turnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            turnBtn.frame=CGRectMake(269, 14, 45, 18);//259 92 48 1
            NSUserDefaults*userDefault=[NSUserDefaults standardUserDefaults];
            BOOL tongZhiFlag=[userDefault boolForKey:@"tongZhiFlag"];

            if(!tongZhiFlag)
            {
              [turnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];
                
                turnLabe.text=@"关";
                
            }
            else
            {
                [turnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];
                turnLabe.text=@"开";
            }

            [turnBtn addTarget:self action:@selector(turnMessageBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:turnBtn];
            [cell.contentView addSubview:turnLabe];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if([indexPath row]==4)
        {
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel. textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text=@"  常见问题";
            
        }
        
        if([indexPath row]==5)
        {
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel. textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text=@"  软件评分";
            
        }
        
        if([indexPath row]==6)
        {
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel. textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text=@"  检测更新";
            
        }
        
        if([indexPath row]==7)
        {
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel. textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:17.0];
            cell.textLabel.text=@"  关于加速宝";
            
        }
        
        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        lineImageView.frame=CGRectMake(0, cell.frame.size.height-1, 320, 1);
        lineImageView.image=[UIImage imageNamed:@"henxian.png"];
        [cell.contentView addSubview:lineImageView];

    }
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath row]==1)
    {
        if ([CHANNEL compare:@"appstore"] == NSOrderedSame) {
            VPNHelpViewController *vpnHelp = [[VPNHelpViewController alloc] init];
            [self.navigationController pushViewController:vpnHelp animated:YES];
            [vpnHelp release];
        }
        else{
            APNViewController*apnJiaoZhunViewController=[[APNViewController alloc]init];
            [self.navigationController pushViewController:apnJiaoZhunViewController animated:YES];
            [apnJiaoZhunViewController release];
        }
    }
    if([indexPath row]==4)
    {

         CommonProblemViewController*commonProblemViewController=[[[CommonProblemViewController alloc]init] autorelease];
        [self.navigationController pushViewController:commonProblemViewController animated:YES];
    }
    if([indexPath row]==5)
    {
        NSString *url=@"https://itunes.apple.com/cn/app/jia-su-bao/id606803214?ls=1&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

    }
    if([indexPath row]==6)
    {
        if(self.updateViewController!=nil)
        {
            self.updateViewController=nil;
        }
        self.updateViewController=[[[UpdateViewController alloc]init] autorelease];
        [self.view addSubview:self.updateViewController.view];
    }
    if([indexPath row]==7)
    {
        AboutFlashViewController*aboutFlashViewController=[[[AboutFlashViewController alloc]init] autorelease];
        [[sysdelegate navController  ] pushViewController:aboutFlashViewController animated:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row]==0||[indexPath row]==2)
    {
        return nil;
    }
    return indexPath;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ( section == 0 ) {
        
        return 160;
    }
    return 0;
}
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [self userView:tableView viewForHeaderInSection:section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 8;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [indexPath row] == 3 )
    {
        return 10;
    }
    return 44;
}

#pragma mark - tool methods

- (void) installProfile
{
    [AppDelegate installProfile:@"current"];
}


- (void) removeProfile
{
    [AppDelegate uninstallProfile:@"current"];
}

-(void)turnServeBtnPress:(id)sender
{
    if ( self.compressionServer ) {
        ConnectionType type = [UIDevice connectionType];
        if(type==WIFI)
        {
            [AppDelegate showAlert:@"wifi下加速宝服务暂停,请先开启移动网络."];
        }
        else
        {
            [self installProfile];
        }
    }
    else {
      //  profileSwitcher = switcher;
        NSString *promptText = NSLocalizedString(@"promptName", nil);
        NSString *cancelText = NSLocalizedString(@"cancleName", nil);
        NSString *defineText = NSLocalizedString(@"defineName", nil);
        NSString *messageText = NSLocalizedString(@"set.service.close.prompt", nil);
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:promptText message:messageText delegate:self cancelButtonTitle:cancelText otherButtonTitles:defineText, nil];
        [alertView show];
        [alertView release];
        alertView.tag = TAG_ALERT_PROFILE;
        
    }
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) {
        [self removeProfile];
    }
    else {
        NSLog(@"服务关闭或者取消");
//        if ( profileSwitcher ) {
//            profileSwitcher.on = YES;
//        }
    }
}

-(void)turnMessageBtnPress:(UIButton*)button
{
    UITableViewCell* cell = [self. setTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UILabel*label=(UILabel*)[cell.contentView viewWithTag:TAG_TONGZHI_LABEL];
    NSUserDefaults*userDefault=[NSUserDefaults standardUserDefaults];
    BOOL tongZhiFlag=[userDefault boolForKey:@"tongZhiFlag"];
    if(!tongZhiFlag)
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
        [button setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];
        label.text=@"开";
        tongZhiFlag=TRUE;
        [userDefault setBool:tongZhiFlag forKey:@"tongZhiFlag"];

    }
    else
    {
        [[UIApplication sharedApplication]unregisterForRemoteNotifications];
        
        [button setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];
        label.text=@"关";
        tongZhiFlag=FALSE;
        [userDefault setBool:tongZhiFlag forKey:@"tongZhiFlag"];
    }
//    if([[UIApplication sharedApplication] enabledRemoteNotificationTypes]==UIRemoteNotificationTypeNone)
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
//        [button setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];
//        label.text=@"开";
//      }
//    else
//    {
//        [[UIApplication sharedApplication]unregisterForRemoteNotifications];
//
//        [button setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];
//        label.text=@"关";
//    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIImageView*imageView=(UIImageView*)[self.bgView viewWithTag:5001];
    if(scrollView.contentOffset.y<0)
    {
        [imageView setHidden:YES];
    }
    else if(scrollView.contentOffset.y>0)
    {
        [imageView setHidden:NO];
    }
    float factorY = scrollView.contentOffset.y / scrollView.contentSize.height;
    // NSLog(@"factor====%f",factorX);
    CGRect frame = self.bigImageView.frame;
  // NSLog(@"AAAAAAAAA%f",scrollView.contentOffset.y);
    frame.origin.y =-factorY * 90+BGimageViewOfSet;
    self.bigImageView.frame = frame;

}
-(UIView*)userView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        if(self.bgView==nil)
        {
            self.bgView= [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 104)] autorelease];
            [self.bgView setBackgroundColor:[UIColor clearColor]];
            self.bgView.clipsToBounds=YES;

            
//            UIButton *detailButton=[UIButton buttonWithType:UIButtonTypeCustom];
//            detailButton.frame=CGRectMake(248, 79, 70, 15);//259 92 48 1
//            [detailButton setTitle:@"绑定手机" forState:UIControlStateNormal];
//            [detailButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
//            [detailButton addTarget:self action:@selector(boundlePhoneBtnPress) forControlEvents:UIControlEventTouchUpInside];
//            [AppDelegate labelShadow:detailButton.titleLabel];
//            
//            UIImageView *lineImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(259, 92, 48, 1)] autorelease];
//            lineImageView.image=[UIImage imageNamed:@"henxian.png"];
//            
            UIImageView *imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(0,BGimageViewOfSet, 320, 270)] autorelease];
            imageView.image=[UIImage imageNamed:@"set_bg.jpg"];
            imageView.tag=5001;
            
            [self.bgView addSubview:imageView];
            if(self.userInfoViewController!=nil)
            {
                self.userInfoViewController=nil;
                //self.userInfoViewController.view.transform=CGAffineTransformMakeScale(0.5, 0.5);
            }
            self.userInfoViewController=[[[UserInfoViewController alloc]init] autorelease];
            

            [self.bgView addSubview:self.userInfoViewController.view];
            self.userInfoViewController.view.frame=CGRectMake(7, 25, 319, 67);
            [self.userInfoViewController.feibiLineImageView setHidden:YES];
           // [self.bgView addSubview:detailButton];
      //      [self.bgView addSubview:lineImageView];

        }
    
        return self.bgView;
    }

    return nil;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
