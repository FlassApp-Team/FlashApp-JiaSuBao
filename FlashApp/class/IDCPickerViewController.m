//
//  IDCPickerViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <sys/timeb.h>
#import "IDCPickerViewController.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "StringUtil.h"
#import "WangSuViewController.h"
#define TAG_NAMELABEL 101
#define TAG_SPEEDLABEL 102
#define TAG_INDICATOR 103
#define TAG_SELECTRADIO 104
#define TAG_LINEIMAGE 105

@interface IDCPickerViewController ()
- (long long) currentTime;
@end

@implementation IDCPickerViewController
@synthesize controller;


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [idcArray release];
    idcArray = nil;
    
    [idcOrderArray release];
    idcOrderArray = nil;
    
    [items release];
    items = nil;
    
    [children release];
    children = nil;
    [speedDic release];
    speedDic = nil;
    
    if ( queue ) {
        [queue cancelAllOperations];
        [queue release];
        queue = nil;
    }
}

- (void) dealloc
{
    [idcArray release];
    [speedDic release];
    [idcOrderArray release];
    [items release];
    [children release];
    self.controller=nil;
    if ( queue ) {
        [queue cancelAllOperations];
        [queue release];
    }
    
    [super dealloc];
}

#pragma mark - init & destroy

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
 //   IDCInfo* idc = [idcArray objectAtIndex:selectedRow];

    self.tableView.scrollEnabled=NO;
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"saveName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClick:)] autorelease];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    //初始化变量
    children = [[NSMutableArray array]retain];
    selectedRow = 0;
    
    [self loadData]; //加载速度

    UserSettings* user = [AppDelegate getAppDelegate].user;
    WangSuViewController *wangSuViewController=(WangSuViewController*)controller;
    //    IDCInfo *info=(IDCInfo*)[user.idcArray objectAtIndex:0];
    wangSuViewController.jiFangName.text=user.idcName;
    //NSLog(@"3333333333333333333%@",user.idcName);
    //  [self ping];
}


#pragma mark - load Data

- (void) loadData
{
    if ( !idcOrderArray ) {
        [idcOrderArray release];
        idcOrderArray = [[NSMutableDictionary alloc] init];
    }
    
    [idcOrderArray removeAllObjects];
    items = [[NSMutableArray array]retain];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] != NotReachable ) {
        if ( client ) return;
        client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetIDCList:obj:)];
        [client getIDCList];
    }
    else {
        NSString* s = user.idcList;
        if ( s ) {
            idcArray = [[user idcArray] retain];
        }
    }
}

- (void) didGetIDCList:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    
    if ( tc.hasError ) return;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* s = [obj JSONRepresentation]; //是吧字典还原成 json字符串
    user.idcList = s;
    [UserSettings saveUserSettings:user];
    
    idcArray = [[user idcArray] retain];  // 程序走到这一步就会返回服务器的机房信息 idcObject
    
    //    IDCInfo *info=(IDCInfo*)[user.idcArray objectAtIndex:0];
    
        
    [self ping];
    
    // [self.tableView reloadData];
}

- (void) ping
{
    items = nil;
    [items release];
    items = [[NSMutableArray array]retain];
    
    children = nil;
    [children release];
    children = [[NSMutableArray array]retain];
    
    [self initSpeedDic];
    
    [self.tableView reloadData];
    
    if ( !queue ) {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
    }
    else {
        [queue cancelAllOperations];
    }
    
    idcCount = 0;
    
    if ( !idcOrderArray ) {
        [idcOrderArray release];
        idcOrderArray = [[NSMutableDictionary alloc] init];
    }
    
    [idcOrderArray removeAllObjects];
    
    
    for ( IDCInfo* idc in idcArray ) {
        
        NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(connectToHost:) object:idc];
        [queue addOperation:operation];
        
        
        NSMutableArray *more = [NSMutableArray array];
        [more addObject:idc];
        
        // [idcOrderArray addObject:idc]; //机房算出速度后，放进新数组中
        [idcOrderArray setObject:idc forKey:idc.code];
        
        //单个加载数据
        [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:YES];
        
    }
    
}


- (void) initSpeedDic
{
    if ( !speedDic ) {
        speedDic = [[NSMutableDictionary alloc] init];
    }
    
    [speedDic removeAllObjects];
    for ( IDCInfo* info in idcArray ) {
        [speedDic setObject:[NSNumber numberWithInt:-1] forKey:info.code];
    }
}

#pragma mark - network speed methods


- (void) connectToHost:(IDCInfo*)idc
{
    
    long long totalTime = 0;
    int totalLen = 0;
    
    for ( int i=0; i<3; i++ ) {
        long long time1 = [self currentTime];
        NSString* s = [TFConnection httpGet:idc.host port:80 location:@"/speed.txt"];
        long long time2 = [self currentTime];
        
        if ( time2 > time1 && s ) {
            totalTime += (time2 - time1);
            totalLen += s.length;
        }
    }
    
    float speed = 0;
    if ( totalTime > 0 ) {
        speed = 1000.0f * totalLen / totalTime;
    }
    
    idc.speed = speed;
    [speedDic setObject:[NSNumber numberWithInt:(int)speed] forKey:idc.code];
    NSLog(@"test %@ OK, speed:%f", idc.name, speed);
    idcCount ++;
    [idcOrderArray setObject:idc forKey:idc.code];
    
    [self sortTable];

}

/*
 机房数据都加载完成后，进行按照速度的降序排序
 */
-(void) sortTable
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"speed" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortedArray = [idcOrderArray allValues];;
    
    [idcArray release];
    idcArray = nil;
    idcArray = [[sortedArray sortedArrayUsingDescriptors:sortDescriptors]retain];
    
    //[sortedArray release];
    [sortDescriptors release];
    [sorter release];
    
    children = nil;
    [children release];
    children = [[NSMutableArray array]retain];
    
    selectedRow = 0;
    
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:YES];
}


- (long long) currentTime
{
    struct timeb t;
    ftime( &t );
    return (long long)1000 * t.time + t.millitm;
}


//添加数据到列表:
-(void) appendTableWith:(NSMutableArray *)data
{
    
    [self.tableView beginUpdates];
    for (int i=0;i<[data count];i++) {
        [items addObject:[data objectAtIndex:i]];
    }
    
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[items indexOfObject:[data objectAtIndex:ind]] inSection:0];
        
        [insertIndexPaths addObject:newPath];
    }
    if(insertIndexPaths.count > 0){
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
    
}

/*
 点击单选按钮，触发该动作
 */
-(void)checkboxClick:(id)sender
{
    NSInteger tag1 =[(UIButton *)sender tag];
    selectedRow = tag1;
    
    
    for ( UIButton * each in children ){
        if(each.tag == tag1){
            each.selected = YES;
        }else{
            each.selected = NO;
        }
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int count = [items count];
    return  count ;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"idcCell"];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idcCell"] autorelease];
        
        UIView *bgImageView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 62)] autorelease];
        UIImage *image1=[UIImage imageNamed:@"jianbian.png"];
        bgImageView.backgroundColor=[UIColor colorWithPatternImage:image1] ;
        bgImageView.opaque=NO;
        [cell.contentView addSubview:bgImageView];
        
        UIImageView *lineImageView=[[[UIImageView alloc]init] autorelease];
        lineImageView.frame=CGRectMake(0, 61, 320, 1);
        lineImageView.tag=TAG_LINEIMAGE;
        [cell.contentView addSubview:lineImageView];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 22, 29, 20)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = TAG_SPEEDLABEL;
        imageView.hidden = YES;
        [cell.contentView addSubview:imageView];
        [imageView release];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 15, 31, 34)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = TAG_INDICATOR;
        imageView.hidden = YES;
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 12, 150, 30)];
        nameLabel.textColor = BgTextColor;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.tag = TAG_NAMELABEL;
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel* nameDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 31, 217, 21)];
        nameDetailLabel.textColor = [UIColor darkGrayColor];
        nameDetailLabel.backgroundColor = [UIColor clearColor];
        nameDetailLabel.font = [UIFont systemFontOfSize:10];
        nameDetailLabel.tag = TAG_NAMELABEL+6;
        [cell.contentView addSubview:nameDetailLabel];
        [nameDetailLabel release];
        
        

        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom]; //单选框按钮
    checkbox.frame=CGRectMake(0,0,320,62);
    [checkbox setImage:[UIImage imageNamed:@"no_select_point.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"select_point.png"] forState:UIControlStateSelected];
    [checkbox setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -273)];
    
    checkbox.tag = [indexPath row]+1000;
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:checkbox];
    UILabel* nameLabel = (UILabel*) [cell.contentView viewWithTag:TAG_NAMELABEL];
    UILabel* detailLabel = (UILabel*) [cell.contentView viewWithTag:TAG_NAMELABEL+6];
    UIImageView* speedImage = (UIImageView*) [cell.contentView viewWithTag:TAG_SPEEDLABEL];
    UIButton* selectButton = (UIButton*)[cell.contentView viewWithTag:[indexPath row]+1000];
    UIImageView* lineImageView = (UIImageView*) [cell.contentView viewWithTag:TAG_LINEIMAGE];
    lineImageView.image=[UIImage imageNamed:@"henxian.png"];

    selectButton.selected = NO;
    UIImageView* indicatorImage = (UIImageView*) [cell.contentView viewWithTag:TAG_INDICATOR];
    NSInteger rowNum = indexPath.row;
    selectButton.tag = rowNum;
    IDCInfo* idc = [idcArray objectAtIndex:rowNum];
    detailLabel.text=idc.desc;
    if(selectButton){
        [children addObject:selectButton];
    }
    nameLabel.text = idc.name;
    
    NSNumber* number = [speedDic objectForKey:idc.code];
    if ( number && number.intValue >= 0 ) {
         UIImage *image = [UIImage imageNamed:@"signal-4.png"];
        int speedNumber = [number intValue];
        if(speedNumber < 1000){
            image = [UIImage imageNamed:@"signal-3.png"];
        }
        speedImage.image = image;
        speedImage.hidden = NO;
        indicatorImage.hidden = YES;
    }
    else if ( number && number.intValue == -1 ) {
        UIImage *image = [UIImage imageNamed:@"signal-load.png"];
        indicatorImage.image = image;
        indicatorImage.hidden = NO;
        speedImage.hidden = YES;
    }
    else {
        speedImage.hidden = YES;
        speedImage.hidden = YES;
    }
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    
    if ( [idc.host compare:user.idcServer] == NSOrderedSame ) {
        
        selectedRow = rowNum;
        selectButton.selected = YES;
        
        WangSuViewController *wangSuViewController=(WangSuViewController*)controller;
        //更改 当前- 机房名字
        wangSuViewController.jiFangName.text=user.idcName;

    }
    else {
        selectButton.selected = NO;
    }
    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    IDCInfo* idc = [idcArray objectAtIndex:indexPath.row];
    //    UserSettings* user = [AppDelegate getAppDelegate].user;
    //    if ( [idc.host compare:user.idcServer] == NSOrderedSame ) return;
    //
    //    selectedRow = indexPath.row;
    //    NSString* message = [NSString stringWithFormat:@"您是否将上网代理更换到“%@”?", idc.name];
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"确定", nil];
    //    [alertView show];
    //    [alertView release];
}

/*
 点击保存后触发该动作
 */
-(void)saveButtonClick:(id)sender
{
    
    
    IDCInfo* idc = [idcArray objectAtIndex:selectedRow];
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( [idc.host compare:user.idcServer] == NSOrderedSame ) return;
    
    NSString* message = [NSString stringWithFormat:@"%@“%@”?", NSLocalizedString(@"set.IDCView.saveButton.message",nil),idc.name];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"promptName", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"giveUpName", nil) otherButtonTitles:NSLocalizedString(@"defineName", nil), nil];
    [alertView show];
    [alertView release];
}


- (void) refreshTable
{

    [self.tableView reloadData];
}




#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ( cell ) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if ( buttonIndex == 1 ) {
        NSArray* cells = [self.tableView visibleCells];
        for ( UITableViewCell* c in cells ) {
            c.accessoryType = UITableViewCellAccessoryNone;
        }
                
        //刷新访问数据
        [TwitterClient getStatsData];
    
        //开始安装profile
        IDCInfo* idc = [idcArray objectAtIndex:selectedRow];
        if ( idc ) {
            [AppDelegate installProfile:@"current" idc:idc.code];
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
