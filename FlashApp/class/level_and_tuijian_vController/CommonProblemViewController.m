//
//  CommonProblemViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-25.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//

#import "CommonProblemViewController.h"
#import "FeedbackViewController.h"
#import "DetailCommonProblemViewController.h"
#import "HelpMMSViewController.h"

@interface CommonProblemViewController ()
@property(nonatomic,retain)IBOutlet UITableView *pTableView;
@property(nonatomic,retain)NSMutableArray *strs;
-(void)setExtraCellLineHidden: (UITableView *)tableView;
@end

@implementation CommonProblemViewController
@synthesize fankuiBtn;
//@synthesize webView;
@synthesize pTableView;
@synthesize strs;
-(void)dealloc
{
//    self.webView=nil;
    self.fankuiBtn=nil;
    self.pTableView=nil;
    self.strs=nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.strs=[[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UIImage* img=[UIImage imageNamed:@"opaque_small.png"];
//    img=[img stretchableImageWithLeftCapWidth:7 topCapHeight:8];
//    [self.fankuiBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    [self.strs addObject:@"★安装过其他压缩软件，如何正常使用加速宝?"];

    [self.strs addObject:@"★删除描述文件之后无法上网怎么办?"];

    [self.strs addObject:@"★无法发送彩信？"];

    [self.strs addObject:@"★如何卸载加速宝？"];

    [self.strs addObject:@"★iOS 6的用户移除加速宝的描述文件后,2G/3G状态下,图片质量受到影响怎么办?"];

    [self.strs addObject:@"★加速宝会压缩我上传的数据吗？"];


    [self.strs addObject:@"★加速宝如何保护我的隐私？"];

    [self.strs addObject:@"★加速宝如何处理加密数据？"];

    [self setExtraCellLineHidden:self.pTableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    [tableView setTableFooterView:view];
    [view release];
}




-(IBAction)turnBtnPress:(id)sender
{
    [[sysdelegate navController  ] popViewControllerAnimated:YES];
}
-(IBAction)fankuiBtnPress:(id)sender
{
    FeedbackViewController*feedbackViewController=[[[FeedbackViewController alloc]init] autorelease];
    [self.navigationController pushViewController:feedbackViewController animated:YES];

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


#pragma mark UITableView delegate Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.strs count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"cellIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 300, 15, 10, 14)];
        imageView.image = [UIImage imageNamed:@"left_arrow.png"];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 280, 20)];
        label.tag = 1020;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor=[UIColor colorWithRed:0.2313 green:0.2313 blue:0.2313 alpha:1.0];
        [cell.contentView addSubview:label];
        [label release];
    }
    
    UILabel *label=(UILabel *)[cell viewWithTag:1020];
    
    label.text=[self.strs objectAtIndex:[indexPath row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==2){
        HelpMMSViewController *mms=[[[HelpMMSViewController alloc] init] autorelease];
        [self.navigationController pushViewController:mms animated:YES];
    }
    else{
        DetailCommonProblemViewController *detailCommonProblem=[[[DetailCommonProblemViewController alloc] init] autorelease];
        detailCommonProblem.pDetailTpye=[indexPath row]+1;
        detailCommonProblem.proTitle=[self.strs objectAtIndex:[indexPath row]];
        [self.navigationController pushViewController:detailCommonProblem animated:YES];
    }
    
    
}


@end
