//
//  IFDataViewController.m
//  flashapp
//
//  Created by 李 电森 on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IFDataViewController.h"
#import "IFDataService.h"
#import "StringUtil.h"
#import "DateUtils.h"


@interface IFDataViewController ()
- (void) loadData;
@end

@implementation IFDataViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    ifDataDic = [[NSMutableDictionary alloc] init]; 
    ifNames = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"refleshName", nil) style:UIBarButtonItemStylePlain target:self action:@selector(refresh)] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [ifDataDic release];
    [ifNames release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - load data


- (void) loadData1
{
    [ifNames removeAllObjects];
    [ifDataDic removeAllObjects];
    
    NSDictionary* dic = [IFDataService readInterfacesNetFlow];
    
    [ifDataDic setDictionary:dic];
    [ifNames setArray:[ifDataDic allKeys]];
}

- (void) loadData
{
    [ifNames removeAllObjects];
    [ifDataDic removeAllObjects];
    
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return ;
    }

    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        /*if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;*/
        
        if (ifa->ifa_data == 0)
            continue;
        
        char* s = ifa->ifa_name;
        NSString* name = [NSString stringWithFormat:@"%s", s];
        NSMutableArray* array = [ifDataDic objectForKey:name];

        if ( !array ) {
            array = [NSMutableArray arrayWithCapacity:0];
            [ifDataDic setObject:array forKey:name];
            [ifNames addObject:name];
        }
        
        struct if_data *if_data = (struct if_data *)ifa->ifa_data;
        struct IF_DATA_TIMEVAL if_lastchange = if_data->ifi_lastchange;
        NSString* lastchange = [DateUtils stringWithDateFormat:if_lastchange.tv_sec format:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dataDesc = [NSString stringWithFormat:@"receive %@, send %@, lastchange %@", 
                              [NSString stringForByteNumber:if_data->ifi_ibytes decimal:2], 
                              [NSString stringForByteNumber:if_data->ifi_obytes decimal:2],
                              lastchange];
        [array addObject:dataDesc];
    }
    freeifaddrs(ifa_list);
}


- (void) refresh
{
    [self loadData];
    [self.tableView reloadData];
}

- (void) close
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ifDataDic count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* name = [ifNames objectAtIndex:section];
    NSArray* array = [ifDataDic objectForKey:name];
    return [array count];
    //return 1;
}


- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [ifNames objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.numberOfLines = 5;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString* name = [ifNames objectAtIndex:section];
    NSArray* array = [ifDataDic objectForKey:name];
    NSString* value = [array objectAtIndex:row];
    cell.textLabel.text = value;
    
    return cell;
}

@end
