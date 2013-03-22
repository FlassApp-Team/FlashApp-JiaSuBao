//
//  DetailCommonProblemViewController.m
//  FlashApp
//
//  Created by 七 叶 on 13-1-29.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "DetailCommonProblemViewController.h"
#import "FeedbackViewController.h"

#import "LevelViewController.h"

@interface DetailCommonProblemViewController ()

@property(nonatomic,retain)IBOutlet UIButton *fankuiBtn;

@property(nonatomic,retain)IBOutlet UILabel *pTitle;
@property(nonatomic,retain)IBOutlet UITextView *pdetail;

@property(nonatomic,retain)IBOutlet UIImageView *textBG;

@property(nonatomic,retain)IBOutlet UILabel *contactLabel;


@end

@implementation DetailCommonProblemViewController
@synthesize textBG;
@synthesize fankuiBtn;
@synthesize pDetailTpye;
@synthesize proTitle;
@synthesize pdetail;
@synthesize pTitle;
@synthesize contactLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)turnBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)fankuiBtnPress:(id)sender
{
    FeedbackViewController*feedbackViewController=[[[FeedbackViewController alloc]init] autorelease];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    
    
//    CGSize labelSize = [self.proTitle sizeWithFont:[UIFont boldSystemFontOfSize:18.0f]
//                        
//                       constrainedToSize:CGSizeMake(280, 100) 
//                        
//                           lineBreakMode:UILineBreakModeCharacterWrap];   // str是要显示的字符串
//    self.pTitle.text = self.proTitle;
//    self.pTitle.frame=CGRectMake(12, 55, labelSize.width, labelSize.height);    
//    self.pTitle.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
        
    
    UIImage* img=[UIImage imageNamed:@"opaque_small.png"];
    img=[img stretchableImageWithLeftCapWidth:7 topCapHeight:8];
    [self.fankuiBtn setBackgroundImage:img forState:UIControlStateNormal];
    
   self.pTitle.text =self.proTitle;
    
   // NSLog(@"self.proTitle======%@",self.proTitle);
    switch (self.pDetailTpye) {
        case 1:
            self.pdetail.text=@"iPhone用户如果以前安装过其他的流量压缩软件，需要移除以前应用的描述文件才能正常使用加速宝。\n具体方法为进入手机的「设置 > 通用 > 描述文件」，然后移除其他流量压缩软件的描述文件。";
            break;
        case 2:
            self.pdetail.text=@"如果您的手机在删除「描述文件」后，出现无法上网的情况。请您检查网络设置中的 APN 设置是否正确。\nAPN 设置位于：\n设置 > 通用 > 网络 > 蜂窝数据网络 > 蜂窝数据\n联通用户 APN 为 3gnet\n移动用户 APN 为 cmnet";
            break;
        case 3:
            self.pdetail.text=@"无法发送彩信";
            break;
        case 4:
            self.pdetail.text=@"iPhone版本进入手机的「设置 > 通用 > 描述文件」，然后移除加速宝的描述文件，再将应用删除即可。";
            break;
        case 5:
            self.pdetail.text=@"请您打开系统[设置]页面，点击[通用]—[还原]—[还原网络设置]即可解决。";
            break;
        case 6:
            self.pdetail.text=@"不会。\n为了保证用户上传内容的完整性，且不影响上传用途，本软件不压缩上传的内容。";
            break;

        case 7:
            self.pdetail.text=@"加速宝不保存用户访问的任何内容，绝对不会泄漏任何用户信息。";
            break;
        case 8:
            self.pdetail.text=@"加速宝不会对加密数据做任何的处理，而是直接将其转发至目标服务器。而且，加密的数据加速宝不会去阅读及保存。";
            break;
            
        default:
            break;
    }
    
    if(self.pdetail.contentSize.height>self.pdetail.frame.size.height){
        
        float offset2=self.pdetail.contentSize.height-self.pdetail.frame.size.height;
        
        
        self.pdetail.frame=CGRectMake(self.pdetail.frame.origin.x, self.pdetail.frame.origin.y, self.pdetail.frame.size.width, self.pdetail.contentSize.height);
        
        
        self.textBG.frame=CGRectMake(self.textBG.frame.origin.x, self.textBG.frame.origin.y, self.textBG.frame.size.width, self.textBG.frame.size.height+offset2);
        
        
        self.contactLabel.frame=CGRectMake(self.contactLabel.frame.origin.x, self.contactLabel.frame.origin.y+offset2, self.contactLabel.frame.size.width, self.contactLabel.frame.size.height);
        
    }

    switch (self.pDetailTpye) {

        case 1:
            self.pTitle.text=@"★安装过其他压缩软件，如何正常使\n    用加速宝?";
            self.pTitle.frame=CGRectMake(12, 55, 308, 43);
            self.pdetail.frame=CGRectMake(self.pdetail.frame.origin.x, self.pdetail.frame.origin.y+18, self.pdetail.frame.size.width, self.pdetail.contentSize.height);
            self.textBG.frame=CGRectMake(self.textBG.frame.origin.x, self.textBG.frame.origin.y+18, self.textBG.frame.size.width, self.textBG.frame.size.height);
            self.contactLabel.frame=CGRectMake(self.contactLabel.frame.origin.x, self.contactLabel.frame.origin.y+18, self.contactLabel.frame.size.width, self.contactLabel.frame.size.height);
            break;
        case 5:
            self.pTitle.text=@"★iOS 6的用户移除加速宝的描述文\n    件后,2G/3G状态下,图片质量受到\n    影响怎么办?";
            self.pTitle.frame=CGRectMake(12, 55, 308, 61);
            self.textBG.frame=CGRectMake(self.textBG.frame.origin.x, self.pTitle.frame.origin.y+self.pTitle.frame.size.height, self.textBG.frame.size.width, self.textBG.frame.size.height);
            
            self.pdetail.frame=CGRectMake(self.pdetail.frame.origin.x, self.textBG.frame.origin.y+25, self.pdetail.frame.size.width, self.pdetail.contentSize.height);
            
            self.contactLabel.frame=CGRectMake(self.contactLabel.frame.origin.x, self.textBG.frame.origin.y+self.textBG.frame.size.height+ 2, self.contactLabel.frame.size.width, self.contactLabel.frame.size.height);
            break;

        default:
            self.pTitle.frame=CGRectMake(12, 55, 308, 26);
            self.pdetail.frame=CGRectMake(self.pdetail.frame.origin.x, self.pdetail.frame.origin.y, self.pdetail.frame.size.width, self.pdetail.contentSize.height);
            self.textBG.frame=CGRectMake(self.textBG.frame.origin.x, self.textBG.frame.origin.y, self.textBG.frame.size.width, self.textBG.frame.size.height);
            break;
    }
    UIImage *image=[UIImage imageNamed:@"try12.png"];
    image=[image stretchableImageWithLeftCapWidth:34 topCapHeight:13];
    self.textBG.image=image;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)select:(id)sender{
    LevelViewController *level=[[[LevelViewController alloc] init] autorelease];
    [self.navigationController pushViewController:level animated:YES];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.textBG=nil;
    self.fankuiBtn=nil;
    self.proTitle=nil;
    self.pTitle=nil;
    self.pdetail=nil;
    self.contactLabel=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
