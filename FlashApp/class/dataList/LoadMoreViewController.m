//
//  LoadMoreViewController.m
//  FlashApp
//
//  Created by lidiansen on 13-3-5.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "LoadMoreViewController.h"
#import "UserAgentLockDAO.h"
#import "StringUtil.h"
#import "DatastatsDetailViewController.h"
#import "StatsMonthDAO.h"
@interface LoadMoreViewController ()

@property(nonatomic,retain)NSMutableArray *userAgentArray;
-(UITableViewCell*)saveLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell*)jiaSuLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation LoadMoreViewController
@synthesize startTime;
@synthesize endTime;
@synthesize currentStats;
@synthesize statsDetail;
@synthesize flag;
@synthesize myTableView;
@synthesize jiasuAgentArray;
@synthesize jieshengAgentArray;
@synthesize userAgentArray;
@synthesize titleLabel;
-(void)dealloc
{
    self.titleLabel=nil;
    self.jiasuAgentArray=nil;
    self.jieshengAgentArray=nil;
    self.userAgentArray=nil;
    self.myTableView=nil;
    self.statsDetail=nil;
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
-(void)reloadData
{
    if(!self.userAgentArray)
        self.userAgentArray=[[[NSMutableArray alloc]init] autorelease];
    else
        [self.userAgentArray removeAllObjects];
    self.currentStats = [StatsMonthDAO statForPeriod:self.currentStats.startTime endTime:self.currentStats.endTime];
    if ( currentStats.bytesBefore > 0 ) {
        NSArray* arr = [StatsMonthDAO userAgentStatsForPeriod:self.currentStats.startTime endTime:self.currentStats.endTime orderby:nil];
        NSArray* tempArr = [arr sortedArrayUsingSelector:@selector(compareByPercent:)];
        [self.userAgentArray addObjectsFromArray:tempArr];
    }
    

    if(!self.jiasuAgentArray)
    {
        self.jiasuAgentArray=[[[NSMutableArray alloc]init] autorelease];
        
    }
    else
    {
        [self.jiasuAgentArray removeAllObjects];
        
    }
    if(!self.jieshengAgentArray)
    {
        self.jieshengAgentArray=[[[NSMutableArray alloc]init] autorelease];
        
    }
    else
    {
        [self.jieshengAgentArray removeAllObjects];
        
    }
    
    for (int i=0;i<[self.userAgentArray count];i++)
    {
        StatsDetail *detail=[self.userAgentArray objectAtIndex:i];
        if(detail.before==detail.after)
        {
            [self.jiasuAgentArray addObject:detail];
        }
        else
        {
            [self.jieshengAgentArray addObject:detail];
        }
    }
    [self.myTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self reloadData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(flag==101)
    {
        self.titleLabel.text=@"节省流量";
    }
    else if(flag==102)
    {
        self.titleLabel.text=@"加速流量";
    }

    // Do any additional setup after loading the view from its nib.
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    if(flag==101)
    {
        cell= [self saveLiuLiang:tableView cellForRowAtIndexPath:indexPath];
    }
    else if(flag==102)
    {
        cell= [self jiaSuLiuLiang:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
    
}
-(UITableViewCell*)saveLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserAgentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //  cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
        //        UIColor* color=[UIColor blueColor];//cell选中后的效果
        //        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
        //        cell.selectedBackgroundView.backgroundColor=color;
        
    }
    
    for ( UIView* v in cell.contentView.subviews )
    {
        [v removeFromSuperview];
    }
    
    StatsDetail *detail=[self.jieshengAgentArray objectAtIndex:[indexPath row]];
    UserAgentLock*agentLock = [UserAgentLockDAO getUserAgentLock:detail.uaStr];
    UIView *bgImageView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 62)] autorelease];
    UIImage *image1=[UIImage imageNamed:@"jianbian.png"];
    bgImageView.backgroundColor=[UIColor colorWithPatternImage:image1] ;
    bgImageView.opaque=NO;
    [cell.contentView addSubview:bgImageView];
    
    UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
    lineImageView.frame=CGRectMake(0, 61, 320, 1);
    lineImageView.image=[UIImage imageNamed:@"henxian.png"];
    [cell.contentView addSubview:lineImageView];
    
    UIImage *image=nil;
    CGRect rect;
    if ( agentLock && agentLock.isLock )
    {
        image=[UIImage imageNamed:@"smalllock.png"];
        rect=CGRectMake(12, 22, 8, 10);
    }
    else
    {
        image=[UIImage imageNamed:@"graypoint.png"];
        rect=CGRectMake(15, 22, image.size.width/2, image.size.height/2);
        
    }
    UIImageView *imageView=[[[UIImageView alloc]initWithFrame:rect] autorelease];
    imageView.image=image;
    
    UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
    nameLabel.frame=CGRectMake(24, 14, 183, 21);
    nameLabel.textAlignment=UITextAlignmentLeft;
    nameLabel.textColor=[UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1.0];
    nameLabel.font=[UIFont systemFontOfSize:17.0];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.text=detail.userAgent;
    
    UILabel *detailLabel=[[[UILabel alloc]init] autorelease];
    detailLabel.frame=CGRectMake(24, 32, 183, 19);
    detailLabel.textAlignment=UITextAlignmentLeft;
    detailLabel.textColor=[UIColor colorWithRed:61.0/255 green:61.0/255 blue:61.0/255 alpha:1.0];
    detailLabel.font=[UIFont systemFontOfSize:11.0];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    NSString*beforeStr= [NSString stringForByteNumber:detail.before decimal:1];
    NSString*afterStr= [NSString stringForByteNumber:detail.after decimal:1];
    NSString *detailStr=[NSString stringWithFormat:@"%@%@%@%@",@"压缩前",beforeStr,@","@"压缩后",afterStr];
    detailLabel.text=detailStr;
    
    UILabel *jieshengLabel=[[[UILabel alloc]init] autorelease];
    jieshengLabel.frame=CGRectMake(190, 18, 105, 23);
    jieshengLabel.textAlignment=UITextAlignmentRight;
    jieshengLabel.textColor=[UIColor darkGrayColor];
    jieshengLabel.font=[UIFont systemFontOfSize:16.0];
    [jieshengLabel setBackgroundColor:[UIColor clearColor]];
    NSString *str1 = [NSString stringForByteNumber:(detail.before - detail.after) decimal:1];
    NSString *jieshengStr=[NSString stringWithFormat:@"%@%@",@"节省",str1];
    jieshengLabel.text=jieshengStr;
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:detailLabel];
    [cell.contentView addSubview:jieshengLabel];
    return cell;
    
    
}
-(UITableViewCell*)jiaSuLiuLiang:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"jiasuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryNone;
        //  cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
        //        UIColor* color=[UIColor blueColor];//cell选中后的效果
        //        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
        //        cell.selectedBackgroundView.backgroundColor=color;
        
    }
    
    for ( UIView* v in cell.contentView.subviews )
    {
        [v removeFromSuperview];
    }
    
    StatsDetail *detail=[self.jiasuAgentArray objectAtIndex:[indexPath row]];
    UserAgentLock*agentLock = [UserAgentLockDAO getUserAgentLock:detail.uaStr];
    //  UserAgentLockStatus lockStatus=[agentLock lockStatus];
    UIView *bgImageView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 62)] autorelease];
    UIImage *image1=[UIImage imageNamed:@"jianbian.png"];
    bgImageView.backgroundColor=[UIColor colorWithPatternImage:image1] ;
    bgImageView.opaque=NO;
    [cell.contentView addSubview:bgImageView];
    
    UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
    lineImageView.frame=CGRectMake(0, 61, 320, 1);
    lineImageView.image=[UIImage imageNamed:@"henxian.png"];
    [cell.contentView addSubview:lineImageView];
    
    UIImage *image=nil;
    CGRect rect;
    if ( agentLock && agentLock.isLock )
    {
        image=[UIImage imageNamed:@"smalllock.png"];
        rect=CGRectMake(12, 26, 8, 10);
    }
    else
    {
        image=[UIImage imageNamed:@"graypoint.png"];
        rect=CGRectMake(15, 26, image.size.width/2, image.size.height/2);
        
    }
    UIImageView *imageView=[[[UIImageView alloc]initWithFrame:rect] autorelease];
    imageView.image=image;
    
    
    UILabel *nameLabel=[[[UILabel alloc]init] autorelease];
    nameLabel.frame=CGRectMake(24, 18, 183, 21);
    nameLabel.textAlignment=UITextAlignmentLeft;
    nameLabel.textColor=[UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1.0];
    nameLabel.font=[UIFont systemFontOfSize:17.0];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.text=detail.userAgent;
    
    
    
    UILabel *jieshengLabel=[[[UILabel alloc]init] autorelease];
    jieshengLabel.frame=CGRectMake(205, 18, 105, 23);
    jieshengLabel.textAlignment=UITextAlignmentRight;
    jieshengLabel.textColor=[UIColor darkGrayColor];
    jieshengLabel.font=[UIFont systemFontOfSize:16.0];
    [jieshengLabel setBackgroundColor:[UIColor clearColor]];
    NSString *str1 = [NSString stringForByteNumber:detail.before  decimal:1];
    NSString *jieshengStr=[NSString stringWithFormat:@"%@%@",@"加速",str1];
    jieshengLabel.text=jieshengStr;
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:jieshengLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DatastatsDetailViewController*datastatsDetailViewController=[[[DatastatsDetailViewController alloc]init] autorelease];
    if(flag==101)
    {
        StatsDetail *detail=[self.jieshengAgentArray objectAtIndex:[indexPath row]];
        
        datastatsDetailViewController.statsDetail=detail;
    }
    else if(flag==102)
    {
        StatsDetail *detail=[self.jiasuAgentArray objectAtIndex:[indexPath row]];
        
        datastatsDetailViewController.statsDetail=detail;
    }
    datastatsDetailViewController.dataListController=self;
    datastatsDetailViewController.currentStats=self.currentStats;
    datastatsDetailViewController.startTime=self.currentStats.startTime;
    datastatsDetailViewController.endTime=self.currentStats.endTime;
    [[sysdelegate currentViewController].navigationController pushViewController:datastatsDetailViewController animated:YES];
    
    NSLog(@"indexPath====%d",[indexPath row]);
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(flag==101)
    {
        return indexPath;
        
    }
    else
        return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int tableCellCount;
    if(flag==101)
    {
        
        tableCellCount= [self.jieshengAgentArray count];
        
    }
    else if(flag==102)
    {
        tableCellCount= [self.jiasuAgentArray count];
    }
    
    return tableCellCount;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
}
-(IBAction)turnBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
