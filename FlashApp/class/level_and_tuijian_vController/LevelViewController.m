//
//  LevelViewController.m
//  FlashApp
//
//  Created by 七 叶 on 13-1-29.
//  Copyright (c) 2013年 lidiansen. All rights reserved.
//

#import "LevelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LevelCell.h"


static BOOL nibRegisted;
@interface LevelViewController ()


@property(nonatomic,retain)IBOutlet UITableView *pTableView;
@property(nonatomic,retain)IBOutlet UIImageView *pBottomBG;
//@property(nonatomic,retain)IBOutlet UITableViewCell *levelTableViewCell;
@property(nonatomic,retain)NSArray *levelTexts;
@property(nonatomic,retain)IBOutlet UILabel *nextLevelRemainDay;
@property(nonatomic,retain)IBOutlet UILabel *nextLevelText;

@property(nonatomic,retain)IBOutlet UIImageView *currentLevelImageView;
@property(nonatomic,retain)IBOutlet UIImageView *nextLevelImageView;
@property(nonatomic,retain)IBOutlet UIImageView *userHeadImageView;
@property(nonatomic,retain)IBOutlet UIImageView *currentLevelIcon;

@property(nonatomic,retain)IBOutlet UILabel *currentLevelDescribe;
@property(nonatomic,retain)IBOutlet UILabel *userNameLabel;

@end

@implementation LevelViewController
@synthesize pBottomBG;
@synthesize pTableView;
//@synthesize levelTableViewCell;
@synthesize levelTexts;
@synthesize nextLevelRemainDay;
@synthesize nextLevelText;
@synthesize currentLevelImageView;
@synthesize nextLevelImageView;
@synthesize currentLevelDescribe;
@synthesize userNameLabel;
@synthesize userHeadImageView;
@synthesize currentLevelIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidUnload{
    [super viewDidUnload];
    self.pBottomBG=nil;
    self.pTableView=nil;
//    self.levelTableViewCell=nil;
    self.levelTexts=nil;
    self.nextLevelRemainDay=nil;
    self.nextLevelText=nil;
    self.nextLevelImageView=nil;
    self.currentLevelImageView=nil;
    self.currentLevelDescribe=nil;
    self.userNameLabel=nil;
    self.userHeadImageView=nil;
    self.currentLevelIcon=nil;
    
}
- (void)viewDidLoad
{
    nibRegisted=NO;
    [super viewDidLoad];
    self.pTableView.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    self.levelTexts=[NSArray arrayWithObjects:@"自行车驾驶证",@"摩托车驾驶证",@"货车驾驶证",@"客车驾驶证",@"轿车驾驶证",@"高铁驾驶证",@"飞机驾驶证", nil];
    UserSettings *user=[UserSettings currentUserSettings];
    
    NSInteger remainDays=user.lvxpmax-user.lvxpcur;
    
    self.userNameLabel.text=user.nickname;
    
    CGSize titlesize=[self.userNameLabel.text sizeWithFont:self.userNameLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, self.userNameLabel.frame.size.height) lineBreakMode:UILineBreakModeCharacterWrap];
   // NSLog(@"titlesize=======%f",titlesize.width);
    if(titlesize.width>self.userNameLabel.frame.size.width){
        self.userNameLabel.frame=CGRectMake(self.userNameLabel.frame.origin.x, self.userNameLabel.frame.origin.y, titlesize.width, titlesize.height);
    }
    self.currentLevelIcon.frame=CGRectMake(self.userNameLabel.frame.origin.x+titlesize.width, self.currentLevelIcon.frame.origin.y, self.currentLevelIcon.frame.size.width, self.currentLevelIcon.frame.size.height);
    
    self.nextLevelRemainDay.text=[NSString stringWithFormat:@"还需要%d天升级到",remainDays];
    
    self.userHeadImageView.image=[UIImage imageWithData:user.headImageData];
    self.userHeadImageView.layer.masksToBounds=YES;
    self.userHeadImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.userHeadImageView.layer.borderWidth=3;
    self.userHeadImageView.layer.cornerRadius=6;
        int currentStage=user.level/3;
        int currentmedal=user.level%3;
    
    NSString *medalDescribe=nil ;
    NSString *nextMedalDescribe=nil;
    
    switch (currentmedal) {
        case 0:
            
            if(user.level<=0){
                medalDescribe=@"铜牌";
                self.currentLevelImageView.image=[UIImage imageNamed:@"medal_tong"];
            }
            else{
                medalDescribe=@"铜牌";
                self.currentLevelImageView.image=[UIImage imageNamed:@"medal_tong"];
            }
            if(user.level<21)
                self.nextLevelImageView.image=[UIImage imageNamed:@"medal_yin"];
            nextMedalDescribe=@"银牌";
            break;
        case 1:
            medalDescribe=@"银牌";
            self.currentLevelImageView.image=[UIImage imageNamed:@"medal_yin"];
            self.nextLevelImageView.image=[UIImage imageNamed:@"medal_jin"];
            nextMedalDescribe=@"金牌";
            break;
        case 2:
            medalDescribe=@"金牌";
            self.currentLevelImageView.image=[UIImage imageNamed:@"medal_jin"];
            self.nextLevelImageView.image=[UIImage imageNamed:@"medal_tong"];
            nextMedalDescribe=@"铜牌";
            break;
            
        default:
            break;
    }
        if(currentStage<=0){
            self.currentLevelDescribe.text=[NSString stringWithFormat:@"%@自行车驾驶证",medalDescribe];
            self.currentLevelIcon.image=[UIImage imageNamed:@"level_icon1"];
            
        }
        else if(currentStage<=1){
            self.currentLevelDescribe.text=[NSString stringWithFormat:@"%@摩托车驾驶证",medalDescribe];
            self.currentLevelIcon.image=[UIImage imageNamed:@"level_icon2"];
        }
        else if(currentStage<=2){
            self.currentLevelDescribe.text=[NSString stringWithFormat:@"%@货车驾驶证",medalDescribe];
            self.currentLevelIcon.image=[UIImage imageNamed:@"level_icon3"];
        }
        else if(currentStage<=3){
            self.currentLevelDescribe.text=[NSString stringWithFormat:@"%@客车驾驶证",medalDescribe];
            self.currentLevelIcon.image=[UIImage imageNamed:@"level_icon4"];
        }
        else if(currentStage<=4){
            self.currentLevelDescribe.text=[NSString stringWithFormat:@"%@轿车驾驶证",medalDescribe];
            self.currentLevelIcon.image=[UIImage imageNamed:@"level_icon5"];
        }
        else if(currentStage<=5){
            self.currentLevelDescribe.text=[NSString stringWithFormat:@"%@高铁驾驶证",medalDescribe];
            self.currentLevelIcon.image=[UIImage imageNamed:@"level_icon6"];
        }
        else if(currentStage<=6){
            self.currentLevelDescribe.text=[NSString stringWithFormat:@"%@飞机驾驶证",medalDescribe];
            self.currentLevelIcon.image=[UIImage imageNamed:@"level_icon7"];
        }
    if(currentmedal==2)
    {
        currentStage=currentStage+1;
        if(currentStage>=[self.levelTexts count])
        {
            nextMedalDescribe=@"";
            self.nextLevelRemainDay.text=@"金牌飞机驾驶证";
            self.nextLevelImageView.image=[UIImage imageNamed:@"medal_jin"];

        }
        else
        {
            nextMedalDescribe=[nextMedalDescribe stringByAppendingString:[self.levelTexts objectAtIndex:currentStage]];

        }

    }
    else
    {
        nextMedalDescribe=[nextMedalDescribe stringByAppendingString:[self.levelTexts objectAtIndex:currentStage]];

    }
    
    self.nextLevelText.text=nextMedalDescribe;
    
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.levelTexts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LevelCell"];
    
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LevelViewController"
//                                                     owner:nil
//                                                   options:nil];
//        NSLog(@"nib======%@",nib);
//        cell = [nib objectAtIndex:1];
////        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.levelTableViewCell];
////        cell = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
//    }
    if(cell==nil){
        NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"LevelCell" owner:nil options:nil];
        cell=(LevelCell *)[arr objectAtIndex:0];
    }
    
    
//    if (!nibRegisted) {
//        UINib *nib = [UINib nibWithNibName:@"LevelCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:@"LevelCell"];
//        nibRegisted = YES;
//    }
//    LevelCell *cell = (LevelCell *)[tableView dequeueReusableCellWithIdentifier:@"LevelCell"];
    
    UIImageView *levelImage=(UIImageView *)[cell viewWithTag:1];
    levelImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"level_image%d",[indexPath row]+1]];
    UILabel *levelText=(UILabel *)[cell viewWithTag:2];
    levelText.text=[self.levelTexts objectAtIndex:[indexPath row]];
    UIImageView *jinImage=(UIImageView *)[cell viewWithTag:3];
    UIImageView *yinImage=(UIImageView *)[cell viewWithTag:4];
    UIImageView *tongImage=(UIImageView *)[cell viewWithTag:5];
    UserSettings *user=[UserSettings currentUserSettings];
    int currentmedal=user.level%3;
    // add 03-12
    int level=user.level/3;
    if(level==[indexPath row])
    {
        if(user.level<=0){
            jinImage.image=[UIImage imageNamed:@"medal_"];
            yinImage.image=[UIImage imageNamed:@"medal_"];
            tongImage.image=[UIImage imageNamed:@"medal_tong"];
        }
        else if(currentmedal==1){
            jinImage.image=[UIImage imageNamed:@"medal_"];
            yinImage.image=[UIImage imageNamed:@"medal_yin"];
            tongImage.image=[UIImage imageNamed:@"medal_tong"];
        }
        else if(currentmedal==0){
            jinImage.image=[UIImage imageNamed:@"medal_"];
            yinImage.image=[UIImage imageNamed:@"medal_"];
            tongImage.image=[UIImage imageNamed:@"medal_tong"];
        }
        else{
            jinImage.image=[UIImage imageNamed:@"medal_jin"];
            yinImage.image=[UIImage imageNamed:@"medal_yin"];
            tongImage.image=[UIImage imageNamed:@"medal_tong"];
        }
    }
    else if(level<[indexPath row])
    {
       jinImage.image=[UIImage imageNamed:@"medal_"];
       yinImage.image=[UIImage imageNamed:@"medal_"];
       tongImage.image=[UIImage imageNamed:@"medal_"];
    }
    else if(level>[indexPath row])
    {
        jinImage.image=[UIImage imageNamed:@"medal_jin"];
        yinImage.image=[UIImage imageNamed:@"medal_yin"];
        tongImage.image=[UIImage imageNamed:@"medal_tong"];
    }
    //end
    return cell;
}

@end
