//
//  UsedLogViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UsedLogViewController.h"
#import "DBConnection.h"
#import "Statement.h"
#import "UserdLog.h"
#import "StringUtil.h"
#import "DateUtils.h"

@interface UsedLogViewController ()
-(void)loadData;
@end

@implementation UsedLogViewController

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
    [records release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    records = [[NSMutableArray alloc] init];
    [self loadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [records release];
    records = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [records count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.tag = 101;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
        label.tag = 102;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 20)];
        label.tag = 103;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
        [label release];

        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
        label.tag = 104;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
        [label release];

        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 20)];
        label.tag = 105;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
        [label release];
    }

    UserdLog* log = [records objectAtIndex:indexPath.row];
    UILabel* label = (UILabel*) [cell.contentView viewWithTag:101];
    label.text = [NSString stringWithFormat:@"%@:%ld(%@),%@:%ld(%@)", 
                  NSLocalizedString(@"netflow.DataLogView.send", nil),
                  log.sendBytes, [NSString stringForByteNumber:log.sendBytes],
                  NSLocalizedString(@"netflow.DataLogView.receive", nil),
                  log.receiveBytes, [NSString stringForByteNumber:log.receiveBytes]];
    
    label = (UILabel*) [cell.contentView viewWithTag:102];
    label.text = [NSString stringWithFormat:@"%@:%ld(%@),%@:%ld(%@)", 
                   NSLocalizedString(@"netflow.DataLogView.sumScore", nil),
                  log.totalBytes, [NSString stringForByteNumber:log.totalBytes],
                  NSLocalizedString(@"netflow.usedLogView.increase", nil),
                  log.deltaBytes, [NSString stringForByteNumber:log.deltaBytes]];

    label = (UILabel*) [cell.contentView viewWithTag:103];
    label.text = [NSString stringWithFormat:@"%@:%ld(%@),%@:%d", 
                  NSLocalizedString(@"netflow.usedLogView.used", nil),
                  log.tcUsed, [NSString stringForByteNumber:log.tcUsed],
                   NSLocalizedString(@"netflow.usedLogView.settleAccount.date", nil),
                  log.tcDay];
    
    label = (UILabel*) [cell.contentView viewWithTag:104];
    label.text = [NSString stringWithFormat:@"%@:%@,%@%@",
                  NSLocalizedString(@"netflow.usedLogView.modifyTime", nil),
                  [DateUtils stringWithDateFormat:log.lastChangedTime format:@"yyyy-MM-dd HH:mm"],
                  NSLocalizedString(@"netflow.usedLogView.createTime", nil),
                  [DateUtils stringWithDateFormat:log.createTime format:@"yyyy-MM-dd HH:mm"]];
    
    label = (UILabel*) [cell.contentView viewWithTag:105];
    label.text = log.desc;
    
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
    char* sql = "select id, send_bytes, receive_bytes, total, delta, last_change_time, create_time, tc_day, tc_used, type, desc from stats_netflow order by id";
    sqlite3* db = [DBConnection getDatabase];
    Statement* stmt = [[Statement alloc] initWithDB:db sql:sql];
    
    [records removeAllObjects];
    
    UserdLog* log = nil;
    while ( [stmt step] == SQLITE_ROW ) {
        log = [[UserdLog alloc] init];
        log.myId = [stmt getInt32:0];
        log.sendBytes = [stmt getInt64:1];
        log.receiveBytes = [stmt getInt64:2];
        log.totalBytes = [stmt getInt64:3];
        log.deltaBytes = [stmt getInt64:4];
        log.lastChangedTime = [stmt getInt64:5];
        log.createTime = [stmt getInt64:6];
        log.tcDay = [stmt getInt32:7];
        log.tcUsed = [stmt getInt64:8];
        log.type = [stmt getInt32:9];
        log.desc = [stmt getString:10];
        [records addObject:log];
        [log release];
    }
    
    [stmt release];
}

@end
