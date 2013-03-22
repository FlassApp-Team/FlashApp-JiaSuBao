//
//  IFDataLogViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IFDataLogViewController.h"
#import "DBConnection.h"
#import "Statement.h"
#import "StringUtil.h"
#import "DateUtils.h"
#import "IFData.h"

@interface IFDataLogViewController ()
- (void) loadData;
- (void) loadDataNames;
- (void) loadDataLogs;
@end

@implementation IFDataLogViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc
{
    [names release];
    [logDic release];
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    names = [[NSMutableArray alloc] init];
    logDic = [[NSMutableDictionary alloc] init];
    
    [self loadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [names release];
    names = nil;
    
    [logDic release];
    logDic = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [names count];
}


- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [names objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* name = [names objectAtIndex:section];
    NSArray* array = [logDic objectForKey:name];
    return [array count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIFont* font = [UIFont systemFontOfSize:10];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.tag = 101;
        label.font = font;
        [cell.contentView addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
        label.tag = 102;
        label.font = font;
        [cell.contentView addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 20)];
        label.tag = 103;
        label.font = font;
        [cell.contentView addSubview:label];
        [label release];

        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
        label.tag = 104;
        label.font = font;
        [cell.contentView addSubview:label];
        [label release];
    }
    
    NSString* name = [names objectAtIndex:indexPath.section];
    NSArray* array = [logDic objectForKey:name];
    
    int row = indexPath.row;
    IFData* data = [array objectAtIndex:row];
    long total = data.sendBytes + data.receiveBytes;
    
    IFData* prevData = nil;
    long prevTotal = 0;
    if ( row > 0 ) {
        prevData = [array objectAtIndex:row - 1];
        prevTotal = prevData.sendBytes + prevData.receiveBytes;
    }
    
    IFData* firstData = [array objectAtIndex:0];
    long firstTotal = firstData.sendBytes + firstData.receiveBytes;
    
    UILabel* label = (UILabel*) [cell.contentView viewWithTag:101];
    label.text = [NSString stringWithFormat:@"%@%ld(%@),%ld(%@),%ld(%@)",
                  NSLocalizedString(@"netflow.DataLogView.send", nil),
                  data.sendBytes, [NSString stringForByteNumber:data.sendBytes],
                  data.sendBytes - prevData.sendBytes,
                  [NSString stringForByteNumber:data.sendBytes - prevData.sendBytes],
                  data.sendBytes - firstData.sendBytes,
                  [NSString stringForByteNumber:data.sendBytes - firstData.sendBytes]];
    
    label = (UILabel*) [cell.contentView viewWithTag:102];
    label.text = [NSString stringWithFormat:@"%@%ld(%@),%ld(%@),%ld(%@)",
                  NSLocalizedString(@"netflow.DataLogView.receive", nil),
                  data.receiveBytes, [NSString stringForByteNumber:data.receiveBytes],
                  data.receiveBytes - prevData.receiveBytes,
                  [NSString stringForByteNumber:data.receiveBytes - prevData.receiveBytes],
                  data.receiveBytes - firstData.receiveBytes,
                  [NSString stringForByteNumber:data.receiveBytes - firstData.receiveBytes]
                  ];
    
    label = (UILabel*) [cell.contentView viewWithTag:103];
    label.text = [NSString stringWithFormat:@"%@%ld(%@),%ld(%@),%ld(%@)",
                  NSLocalizedString(@"netflow.DataLogView.sumScore", nil),
                  total, [NSString stringForByteNumber:total],
                  total - prevTotal,
                  [NSString stringForByteNumber:total - prevTotal],
                  total - firstTotal,
                  [NSString stringForByteNumber:total - firstTotal]
                  ];
    
    label = (UILabel*) [cell.contentView viewWithTag:104];
    label.text = [NSString stringWithFormat:@"lastchange:%@, create:%@",
                  [DateUtils stringWithDateFormat:data.lastchangeTime format:@"yyyy-MM-dd HH:mm"],
                  [DateUtils stringWithDateFormat:data.createTime format:@"yyyy-MM-dd HH:mm"]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark - load data

- (void) loadData
{
    [self loadDataNames];
    [self loadDataLogs];
}


- (void) loadDataNames
{
    [names removeAllObjects];
    
    char* sql = "select distinct if_name from stats_ifdata order by if_name";
    sqlite3* db = [DBConnection getDatabase];
    Statement* stmt = [[Statement alloc] initWithDB:db sql:sql];
    
    while ( [stmt step] == SQLITE_ROW ) {
        NSString* name = [stmt getString:0];
        [names addObject:name];
    }
    
    [stmt release];
}


- (void) loadDataLogs
{
    [logDic removeAllObjects];
    
    char* sql = "select if_name, send_bytes, receive_bytes, last_change_time, create_time from stats_ifdata order by if_name, last_change_time";
    sqlite3* db = [DBConnection getDatabase];
    Statement* stmt = [[Statement alloc] initWithDB:db sql:sql];
    
    while ( [stmt step] == SQLITE_ROW ) {
        NSString* name = [stmt getString:0];
        
        NSMutableArray* array = [logDic objectForKey:name];
        if ( !array ) {
            array = [NSMutableArray array];
            [logDic setObject:array forKey:name];
        }
        
        long sendBytes = [stmt getInt64:1];
        long receiveBytes = [stmt getInt64:2];
        time_t lastchangeTime = [stmt getInt64:3];
        time_t createTime = [stmt getInt64:4];
        
        IFData* data = [[IFData alloc] init];
        data.ifName = name;
        data.sendBytes = sendBytes;
        data.receiveBytes = receiveBytes;
        data.lastchangeTime = lastchangeTime;
        data.createTime = createTime;
        [array addObject:data];
        [data release];
    }
    
    [stmt release];
}

@end
