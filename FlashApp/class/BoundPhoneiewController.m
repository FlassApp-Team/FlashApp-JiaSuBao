//
//  boundPhoneiewController.m
//  FlashApp
//
//  Created by lidiansen on 12-12-26.
//  Copyright (c) 2012年 lidiansen. All rights reserved.
//


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#import "BoundPhoneiewController.h"
#define TextColor [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1.0 ]
@interface BoundPhoneiewController ()

@end

@implementation BoundPhoneiewController
@synthesize bottomImageView;
@synthesize changeDoneField;
@synthesize bgView;
@synthesize bgImageView;
@synthesize cancleBtn;
@synthesize sureBtn;
-(void)dealloc
{
    self.cancleBtn=nil;
    self.sureBtn=nil;
    self.bgImageView=nil;
    self.bgView=nil;
    self.changeDoneField=nil;
    self.bottomImageView=nil;
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
-(void)viewWillAppear:(BOOL)animated
{
    self.bgView.frame=rect;
    [super viewWillAppear:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UIImage* okBgImage=[UIImage imageNamed:@"ok_bg.png"];
    okBgImage=[okBgImage stretchableImageWithLeftCapWidth:9 topCapHeight:2];
    [self.sureBtn setBackgroundImage:okBgImage forState:UIControlStateHighlighted];
    
    UIImage* cancleBgImage=[UIImage imageNamed:@"cancle_bg.png"];
    cancleBgImage=[cancleBgImage stretchableImageWithLeftCapWidth:1 topCapHeight:1 ];
    [self.cancleBtn setBackgroundImage:cancleBgImage forState:UIControlStateHighlighted];
    
    [self.sureBtn setTitleColor:TextColor forState:UIControlStateHighlighted];
    [self.cancleBtn setTitleColor:TextColor forState:UIControlStateHighlighted];
    
    UIImage *image1=[UIImage imageNamed:@"baikuang_shadow.png"];
    image1=[image1 stretchableImageWithLeftCapWidth:image1.size.width/2 topCapHeight:image1.size.height/2];
    self.bgImageView.image=image1;
    
    self.changeDoneField.delegate=self;
    rect=self.bgView.frame;
    UIImage *image=[UIImage imageNamed:@"feedback_text_bg.png"];
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    
    self.bottomImageView.image=image;
    [self.changeDoneField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.changeDoneField setButtonIcon:ButtonIconKeyboard];
    //[self.changeDoneField setButtonText:@"完成"];

    if(IOS_VERSION<5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    [AppDelegate exChangeOut:self.bgView dur:0.6];
    
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        NSInteger offset =self.bgView.frame.size.height-keyboardBounds.origin.y+64.0;
        CGRect listFrame = CGRectMake(0, -offset, self.bgView.frame.size.width,self.bgView.frame.size.height);
        NSLog(@"offset is %d",offset);
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动事件，将各视图设置最终要达到的状态
        
        self.bgView.frame=listFrame;
        
        [UIView commitAnimations];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.bgView.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)textFiledDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
-(IBAction)canclebtnPress:(id)sender
{
    [self.view removeFromSuperview];
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
