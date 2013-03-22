//
//  FlowJiaoZhunViewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-19.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//
#define TAG_ALERTVIEW_TOTAL 101
#define TAG_ALERTVIEW_DAY 102
#define TAG_ALERTVIEW_USED 103
#define TAG_ALERTVIEW_LOCATION 104
#import "FlowJiaoZhunViewController.h"
#import "TaoCanViewController.h"
#import "TCCarrierViewController.h"
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"
#import "StringUtil.h"
#import "TCUtils.h"
#import "DateUtils.h"
#import "REString.h"
@interface FlowJiaoZhunViewController ()
- (void) getDataFromServer;
-(void)loadData;
- (BOOL) checkInputValue:(NSString*)value tag:(NSInteger)tag;
- (void) save;
- (UITextField*) getTextFieldOfAlertView:(UIAlertView*)alertView;
@end

@implementation FlowJiaoZhunViewController
@synthesize taocanCountLabel;
@synthesize benyueCountLabel;
@synthesize yuejieCountLabel,yuejieDetailLabel,yuejieLabel;
@synthesize jingqueDetailLabel,jingqueLabel;
@synthesize liuliangCountLabel,liuliangDetailLabel,liuliangLabel;
@synthesize stateLabel;
@synthesize locationIcon;
@synthesize turnOnBtn;

@synthesize benyueBtn;
@synthesize yuejienBtn;
@synthesize jingqueBtn;
@synthesize liuliangBtn;
@synthesize taocanBtn;

@synthesize client;
@synthesize pickerData;
@synthesize controller;
-(void)dealloc
{
    self.controller=nil;
    self.pickerData=nil;
    if(pickerView)
        [pickerView release];
    pickerView=nil;
    [client cancel];
    [client release];
    client = nil;
    
    self.taocanCountLabel=nil;
    
    self.benyueCountLabel=nil;
    
    self.yuejieLabel=nil;
    self.yuejieDetailLabel=nil;
    self.yuejieCountLabel=nil;
    
    self.jingqueLabel=nil;
    self.jingqueDetailLabel=nil;
    
    self.liuliangCountLabel=nil;
    self.liuliangDetailLabel=nil;
    self.liuliangLabel=nil;
    
    self.turnOnBtn=nil;
    self.locationIcon=nil;
    self.stateLabel=nil;
    
    self.taocanBtn=nil;
    self.benyueBtn=nil;
    self.liuliangBtn=nil;
    self.jingqueBtn=nil;
    self.yuejienBtn=nil;
    
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
- (void) viewWillAppear:(BOOL)animated
{
    [self loadData];
    [super viewWillAppear:animated];
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate* appDelegate = [AppDelegate getAppDelegate];
    @synchronized (self) {
        if ( appDelegate.adjustSMSSend ) {
            appDelegate.adjustSMSSend = NO;
            [self performSelector:@selector(showMessage) withObject:NSLocalizedString(@"taocan.TCAdjustView.SMSSend.message", nil) afterDelay:0.5f];
        }
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    if ( dirty ) {
        NSString* total = [self.taocanCountLabel.text trim];
        if ( ![self checkInputValue:total tag:TAG_ALERTVIEW_TOTAL] ) return;
        
        NSString* used = [self.benyueCountLabel.text trim];
        if ( ![self checkInputValue:used tag:TAG_ALERTVIEW_USED] ) return;
        
        NSString* day = [self.yuejieCountLabel.text trim];
        if ( ![self checkInputValue:day tag:TAG_ALERTVIEW_DAY] ) return;
        
        [self save];
    }
 
        if ( client ) {
            [client cancel];
            [client release];
            client = nil;
        }
        
        
        [super viewWillDisappear:YES];
}
- (void) showMessage
{
    messageView.hidden = NO;
    for ( UIView* view in self.view.subviews ) {
        if ( view != messageView ) {
            CGPoint p = view.center;
            p.y += 28;
            view.center = p;
        }
    }
    
    [self performSelector:@selector(hiddenMessage) withObject:nil afterDelay:15.0];
}
- (void) hiddenMessage
{
    messageView.hidden = YES;
    for ( UIView* view in self.view.subviews ) {
        if ( view != messageView ) {
            CGPoint p = view.center;
            p.y -= 28;
            view.center = p;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerData = [NSArray arrayWithObjects:@"90%", @"80%", @"70%", @"60%",@"50%",@"40%",@"30%",@"20%", nil];
    pickerView = [[ButtonPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 250+44, 320, 250)];
   // NSLog(@"sdasdasdasdasdas%f",self.view.frame.size.height);
    pickerView.hidden = YES;
    pickerView.picker.delegate = self;
    pickerView.picker.dataSource = self;
    [self.view addSubview:pickerView];
    

    
    messageView = [[ProfileTipView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
    messageView.hidden = YES;
    [messageView setMessage:NSLocalizedString(@"taocan.TCAdjustView.SMSSend.message", nil) button:nil];
    [self.view addSubview:messageView];
    [messageView release];
    
    yuejieLabel.text  = NSLocalizedString(@"taocan.TCAdjustView.dayLabel.text", nil);
    [jingqueBtn setTitle:NSLocalizedString(@"taocan.TCAdjustView.queryButton.title", nil) forState:UIControlStateNormal];
    [taocanBtn setTitle:NSLocalizedString(@"taocan.TCAdjustView.totalLabel.text", nil) forState:UIControlStateNormal];
    [benyueBtn setTitle:NSLocalizedString(@"taocan.TCAdjustView.usedLabel.text", nil) forState:UIControlStateNormal];
    [taocanBtn setTitleColor:BgTextColor forState:UIControlStateHighlighted];
    [benyueBtn setTitleColor:BgTextColor forState:UIControlStateHighlighted];
    [self loadData];
    [self loadDingWei];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadDingWei
{
    BOOL locationEnabled = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
    BOOL opend = [[NSUserDefaults standardUserDefaults] boolForKey:UD_LOCATION_ENABLED];
    if ( locationEnabled && opend ) {
        locationFlag = NO;
        self.stateLabel.text=@"开";
        locationIcon.image = [UIImage imageNamed:@"location_purplearrow.png"];
        [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];
    }
    else {
        locationFlag = YES;
        self.stateLabel.text=@"关";
        [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];
        locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
    }

}
#pragma mark - UIPickerView Datasource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

        return [self.pickerData count];
}


- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   
        NSString* code = [self.pickerData objectAtIndex:row];
        return code;
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

        NSString* code = [self.pickerData objectAtIndex:row];
        self.liuliangCountLabel.text=code;

}

- (void) save
{
    if ( !dirty ) return;
    
    NSString* total = [self.taocanCountLabel.text trim];
    NSString* used = [self.benyueCountLabel.text trim];
    NSString* day = [self.yuejieCountLabel.text trim];
    time_t now;
    time( &now );
    UserSettings* user = [AppDelegate getAppDelegate].user;

    user.lastUpdate=[DateUtils stringWithDateFormat:now format:@"yyyy年MM月dd日"];

    
    long long bytes = [used floatValue] * 1024.0f * 1024.0f;
    [TCUtils saveTCUsed:bytes total:[total floatValue] day:[day intValue]];
    
    //发送页面刷新通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCChangedNotification object:nil];
    
    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] != NotReachable ) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [TwitterClient saveTaocanData:total used:[NSString stringWithFormat:@"%lld", bytes] day:day];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    dirty = NO;
}
- (void) locationSetting:(id)sender
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* desc = nil;
    if ( [device.systemVersion compare:@"6.0"] == NSOrderedAscending ) {
        desc = @"设置>定位服务";
    }
    else {
        desc = @"设置>隐私>位置";
    }
    
    if ( locationFlag ) {
        if ( ![CLLocationManager locationServicesEnabled] ) {
            [AppDelegate showAlert:[NSString stringWithFormat:@"您的设备未开启定位服务\n请在\"%@\"中打开定位服务！", desc]];
            locationFlag = YES;
            locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
            self.stateLabel.text=@"关";
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];

        }
        else if ( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized && [[NSUserDefaults standardUserDefaults] objectForKey:UD_LOCATION_ENABLED]) {
            //判断是否是第一次使用
            [AppDelegate showAlert:[NSString stringWithFormat:@"您现在禁止加速宝使用定位服务\n请在\"%@\"中打开加速宝的开关",desc]];
            locationFlag = YES;
            locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
            self.stateLabel.text=@"关";
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];

        }
        else {
            [[AppDelegate getAppDelegate] startLocationManager];
            [[NSUserDefaults standardUserDefaults] setBool:locationFlag forKey:UD_LOCATION_ENABLED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            locationIcon.image = [UIImage imageNamed:@"location_purplearrow.png"];
            self.stateLabel.text=@"开";
            locationFlag=NO;
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];

        }
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭精确流量监控将无法实时统计流量，可能造成流量统计不准确！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = TAG_ALERTVIEW_LOCATION;
        [alertView show];
        [alertView release];
    }
}

#pragma mark - tool methods


- (void) loadData
{
    [TCUtils readIfData:-1];
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    NSString* total = user.ctTotal;
    NSString* used = user.ctUsed;
    NSString* day = user.ctDay;
    
    if ( !total ) {
        //读取服务器的数值
        [self getDataFromServer];
        total = [NSString stringWithFormat:@"%d", TC_TOTAL];
        day = @"1";
    }
    
    if ( !used || used.length == 0 ) {
        used = @"0.0";
    }
    else {
        used = [NSString stringWithFormat:@"%.2f", [used longLongValue] / 1024.0f / 1024.0f];
    }
    
    self.yuejieCountLabel.text = day;
    self.taocanCountLabel.text = total;
    self.benyueCountLabel.text = used;
}


- (void) getDataFromServer
{
    if ( client ) return;
    
    if ( [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus] == NotReachable ) return;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetDataFromServer:obj:)];
    [client getTaocanData:nil used:nil day:nil];
}


- (void) didGetDataFromServer:(TwitterClient*)tc obj:(NSObject*)obj
{
    client = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ( tc.hasError ) {
        [AppDelegate showAlert:tc.errorDetail];
        return;
    }
    
    if ( !obj || ![obj isKindOfClass:[NSDictionary class]] ) return;
    
    NSDictionary* dic = (NSDictionary*)obj;
    
    NSString* day = nil;
    NSString* total = nil;
    NSString* used = nil;
    
    NSObject* oo = [dic objectForKey:@"dat"];
    if ( oo && oo != [NSNull null] ) {
        day = (NSString*) oo;
    }
    
    oo = [dic objectForKey:@"total"];
    if ( oo && oo != [NSNull null] ) {
        total = (NSString*) oo;
    }
    
    oo = [dic objectForKey:@"use"];
    if ( oo && oo != [NSNull null] ) {
        used = (NSString*) oo;
    }
    
    time_t lastUpdate = 0;
    oo = [dic objectForKey:@"lastUpdate"];
    if ( oo && oo != [NSNull null] ) {
        lastUpdate = [DateUtils timeWithDateFormat:(NSString*)oo format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    if ( day.length == 0 ) day = nil;
    if ( total.length == 0 ) total = nil;
    if ( used.length == 0 ) used = nil;
    
    UserSettings* user = [AppDelegate getAppDelegate].user;
    long long bytes = [user getTcUsed];
    
    float totalm = (total ? [total floatValue] : TC_TOTAL);
    int daym = ( day ? [day intValue] : 1 );
    
    time_t peroid[2];
    time_t now;
    time( &now );
    [TCUtils getPeriodOfTcMonth:peroid time:now];
    if ( used && used.length > 0 ) {
        if ( lastUpdate >= peroid[0] && lastUpdate <= peroid[1] && [used floatValue] > bytes ) {
            bytes = [used longLongValue];
        }
    }
    user.lastUpdate=[DateUtils stringWithDateFormat:lastUpdate format:@"yyyy年MM月dd日"];

    //判断是否修改过
    NSString* curTotal = user.ctTotal;
    NSString* curUsed = user.ctUsed;
    NSString* curDay = user.ctDay;
    
    if ( !curTotal || curTotal.length == 0 ) {
        self.taocanCountLabel.text = [NSString stringWithFloatTrim:totalm decimal:2];
        dirty = YES;
    }
    
    if ( !curDay || curDay.length == 0 ) {
        self.yuejieCountLabel.text = [NSString stringWithFormat:@"%d", daym];
        dirty = YES;
    }
    
    if ( !curUsed || curUsed.length == 0 ) {
        self.benyueCountLabel.text = [NSString stringWithFormat:@"%.2f", bytes / 1024.0f / 1024.0f];
        dirty = YES;
    }
}

- (void) openCarrierView
{
    TCCarrierViewController* tCCarrierViewController = [[TCCarrierViewController alloc] init];
    [[sysdelegate currentViewController].navigationController pushViewController:tCCarrierViewController animated:YES];
    [tCCarrierViewController release];
}

-(IBAction)jingqueBtnPress:(id)sender
{
    UserSettings* user = [AppDelegate getAppDelegate].user;
    if ( user.username && user.username.length > 0 ) {
        NetworkStatus status = [[AppDelegate getAppDelegate].networkReachablity currentReachabilityStatus];
        if ( (!user.areaCode || user.areaCode.length == 0) && status != NotReachable  ) {
            if ( client ) return;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            client = [[TwitterClient alloc] initWithTarget:self action:@selector(didGetCarrierInfo:obj:)];
            [client getCarrierInfo:user.username area:nil code:nil type:nil];
        }
        else {
            [self openCarrierView];
        }
    }
    else {
        [self openCarrierView];
    }

}
- (void) didGetCarrierInfo:(TwitterClient*)tc obj:(NSObject*)obj
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    client = nil;
    
    [TwitterClient parseCarrierInfo:obj];
    [self openCarrierView];
}

- (void) showInputAlertView:(NSString*)title value:(NSString*)value tag:(NSInteger)tag
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithFrame:CGRectMake(10, 20, 300, 100)];
    dialog.tag = tag;
    [dialog setDelegate:self];
    [dialog setTitle:title];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:NSLocalizedString(@"cancleName", nil)];
    [dialog addButtonWithTitle:NSLocalizedString(@"defineName", nil)];
    
    UITextField* nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [nameField setBackgroundColor:[UIColor whiteColor]];
    nameField.placeholder=value;//add 03-11
   // nameField.text = value;
    
    //nameField.keyboardType = UIKeyboardTypeNumberPad;
    [dialog addSubview:nameField];
    [nameField becomeFirstResponder];
    [dialog show];
    
    /*if ( !numberKeyboard ) {
     self.numberKeyboard = [NumberKeypadDecimalPoint keypadForTextField:nameField];
     }
     else {
     self.numberKeyboard.currentTextField = nameField;
     }*/
    
    [dialog release];
    [nameField release];
}

-(void)showPickerView
{
    pickerView.hidden = NO;
    [pickerView.picker reloadAllComponents];
    
//    if ( selectedCarrierCode && selectedCarrierCode.length > 0 && selectedCarrierType && selectedCarrierType.length > 0 ) {
//        NSString* c;
//        NSString* s = [NSString stringWithFormat:@"%@_%@", selectedCarrierCode, selectedCarrierType];
//        for (int i=0; i<[pickerData count]; i++) {
//            c = [pickerData objectAtIndex:i];
//            if ( [c compare:s] == NSOrderedSame ){
//                [pickerView.picker selectRow:i inComponent:0 animated:YES];
//                break;
//            }
//        }
//    }

}
-(IBAction)taocanBtnPress:(id)sender
{
    NSString* value = self.taocanCountLabel.text;
    [self showInputAlertView:NSLocalizedString(@"taocan.TCAdjustView.setPackageFlow", nil) value:value tag:TAG_ALERTVIEW_TOTAL];
}
-(IBAction)benyueBtnPress:(id)sender
{
    NSString* value = self.benyueCountLabel.text;
    [self showInputAlertView:NSLocalizedString(@"taocan.TCAdjustView.setUsedFlow", nil) value:value tag:TAG_ALERTVIEW_USED];
}
-(IBAction)yuejienBtnPress:(id)sender
{
    NSString* value = self.yuejieCountLabel.text;
    [self showInputAlertView:NSLocalizedString(@"taocan.TCAdjustView.setDay", nil) value:value tag:TAG_ALERTVIEW_DAY];
}

-(IBAction)turnBack:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
    TaoCanViewController*taoCanViewController=(TaoCanViewController*)self.controller;
    [taoCanViewController getDataTotalCount ];
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshNotification object:nil];//刷新界面

}
-(IBAction)liuliangBtnPress:(id)sender
{
    [self showPickerView];
}
-(IBAction)turnOnBtn:(id)sender
{
    [self locationSetting:sender];
}

#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == TAG_ALERTVIEW_LOCATION ) {
        if ( buttonIndex == 0 ) {
            locationFlag = NO;
            locationIcon.image = [UIImage imageNamed:@"location_purplearrow.png"];
            self.stateLabel.text=@"开";
            
           [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_open.png"] forState:UIControlStateNormal];

        }
        else {
            //关闭精确流量监控
            [[AppDelegate getAppDelegate] stopLocationManager];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_LOCATION_ENABLED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            locationIcon.image = [UIImage imageNamed:@"location_grayarrow.png"];
            self.stateLabel.text=@"关";
            locationFlag=YES;
            [self.turnOnBtn setBackgroundImage:[UIImage imageNamed:@"apn_bg_close.png"] forState:UIControlStateNormal];

        }
    }
    else {
        if ( buttonIndex == 0 ) return;
        
        UITextField* textField = [self getTextFieldOfAlertView:alertView];
        if ( !textField ) return;
        
        NSString* value = [textField.text trim];
        if ( value.length == 0 ) return;
        
        if ( ![self checkInputValue:value tag:alertView.tag] ) return;
        
        if ( alertView.tag == TAG_ALERTVIEW_TOTAL ) {
            self.taocanCountLabel.text = value;
            dirty = YES;
        }
        else if ( alertView.tag == TAG_ALERTVIEW_DAY ) {
            self.yuejieCountLabel.text = value;
            dirty = YES;
        }
        else if ( alertView.tag == TAG_ALERTVIEW_USED ) {
            self.benyueCountLabel.text = value;
            dirty = YES;
        }
    }
}
- (BOOL) checkInputValue:(NSString*)value tag:(NSInteger)tag
{
    value = [value trim];
    if ( !value || value.length == 0 ) {
        [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.valueLength", nil)];
        return NO;
    }
    
    if ( tag == TAG_ALERTVIEW_TOTAL ) {
        NSString* total = [value trim];
        if ( total.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.totalValueLength", nil)];
            return NO;
        }
        
        BOOL b = [total matches:@"^([0-9]{1,4}(\\.[0-9]{1,2})*)$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.totalValueMatch", nil)];
            return NO;
        }
        
    }
    else if ( tag == TAG_ALERTVIEW_USED ) {
        NSString* used = [value trim];
        if ( used.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.usedValueLength", nil)];
            return NO;
        }
        
        BOOL b = [used matches:@"^([0-9]{1,4}(\\.[0-9]{1,2})*)$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.usedValueMatch", nil)];
            return NO;
        }
    }
    else if ( tag == TAG_ALERTVIEW_DAY ) {
        NSString* day = [value trim];
        if ( day.length == 0 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayValueLength", nil)];
            return NO;
        }
        
        BOOL b = [day matches:@"^[0-9]{1,2}$" withSubstring:nil];
        if ( !b ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayValueMatch", nil)];
            return NO;
        }
        
        int d = [day intValue];
        if ( d <=0 || d > 31 ) {
            [AppDelegate showAlert:NSLocalizedString(@"taocan.TCAdjustView.checkInput.dayIntValue", nil)];
            return NO;
        }
    }
    
    return YES;
}


- (UITextField*) getTextFieldOfAlertView:(UIAlertView*)alertView
{
    if ( !alertView ) return nil;
    
    for ( UIView* v in [alertView subviews] ) {
        if ( [v isKindOfClass:[UITextField class]] ) return (UITextField*) v;
    }
    
    return nil;
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
