//
//  MenuViewController.m
//  fruit2048
//
//  Created by zhuang chaoxiao on 14-9-4.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"

@import GoogleMobileAds;

#define BACK_POS_X  20
#define BACK_POS_Y  20
#define BACK_HEIGHT  40
#define BACK_WIDTH   40


#define BASE_TAG  10086


@interface MenuViewController ()
{
    UIImageView * _imgViewSelected;
    
}
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self layoutSkinView];
    
    [self layoutInfoView];
    
    [self layoutAdvView];
    //
    
    {
        UIButton * btnBack = [[UIButton alloc]initWithFrame:CGRectMake(BACK_POS_X-10, BACK_POS_Y, BACK_WIDTH, BACK_HEIGHT)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnBack];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)layoutAdvView
{
    GADBannerView*  _bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeMediumRectangle origin:CGPointMake(10, 230)];
    
    _bannerView.adUnitID = @"a1527e3f3d6c7bc";//调用你的id
    
    _bannerView.rootViewController = self;
    
    [self.view addSubview:_bannerView];//添加bannerview到你的试图
    
    [_bannerView loadRequest:[GADRequest request]];

}

-(void)layoutInfoView
{
    /*
    CGRect rect;
    
    UIView * bgView;
    
    {
        rect = CGRectMake(5, 250, 310, 200);
        bgView = [[UIView alloc]initWithFrame:rect];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        bgView.userInteractionEnabled = YES;
        
        [self.view addSubview:bgView];
    }
    
    
    {
        rect = CGRectMake(0, 20, 310, 20);
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"QQ:479408690";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        [bgView addSubview:lab];
    }
     */

}

-(void)layoutSkinView
{
    
    CGRect rect;
    UIView * bgView;
    
    {
        rect = CGRectMake(5, 20, 310, 200);
        bgView = [[UIView alloc]initWithFrame:rect];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        bgView.userInteractionEnabled = YES;
        
        [self.view addSubview:bgView];
    }
    
    {
        rect = CGRectMake(50, 10, 80, 80);
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
        imgView.image = [UIImage imageNamed:@"2_0"];
        imgView.layer.cornerRadius = 20;
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.tag = BASE_TAG + 0;
        
        [bgView addSubview:imgView];
        
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClicked:)];
        [imgView addGestureRecognizer:g];
        
    }
    
    {
        rect = CGRectMake(190, 10, 80, 80);
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
        imgView.image = [UIImage imageNamed:@"2_1"];
        imgView.layer.cornerRadius = 20;
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.tag = BASE_TAG + 1;
        
        [bgView addSubview:imgView];
        
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClicked:)];
        [imgView addGestureRecognizer:g];
    }
    
    
    {
        rect = CGRectMake(50, 110, 80, 80);
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
        imgView.image = [UIImage imageNamed:@"2_2"];
        imgView.layer.cornerRadius = 20;
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.tag = BASE_TAG + 2;
        
        [bgView addSubview:imgView];
        
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClicked:)];
        [imgView addGestureRecognizer:g];
    }
    
    {
        rect = CGRectMake(190, 110, 80, 80);
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
        imgView.image = [UIImage imageNamed:@"2_3"];
        imgView.layer.cornerRadius = 20;
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.tag = BASE_TAG + 3;
        
        [bgView addSubview:imgView];
        
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClicked:)];
        [imgView addGestureRecognizer:g];
    }
    
    {
        rect = CGRectMake(90, 70, 40, 40);
        _imgViewSelected = [[UIImageView alloc]initWithFrame:rect];
        _imgViewSelected.image = [UIImage imageNamed:@"select"];
        _imgViewSelected.layer.cornerRadius = 20;
        _imgViewSelected.layer.masksToBounds = YES;
        _imgViewSelected.userInteractionEnabled = YES;
        _imgViewSelected.tag = BASE_TAG + 3;
        
        [bgView addSubview:_imgViewSelected];
        
        [self setSelectView:[(AppDelegate*)[[UIApplication sharedApplication] delegate] getSkin] ];
        
    }
    
}


-(void)setSelectView:(NSInteger)tag
{
    CGPoint pt;
    
    switch (tag)
    {
        case 0:
        {
            pt = CGPointMake(110, 70);
            
        }
            break;
            
        case 1:
        {
            pt = CGPointMake(250, 70);
        }
            break;
            
        case 2:
        {
            pt = CGPointMake(110, 170);
        }
            break;
            
        case 3:
        {
            pt = CGPointMake(250, 170);
        }
            break;
            
        default:
            
             pt = CGPointMake(110, 70);
            
            break;
    }
    
    _imgViewSelected.center = pt;
}

-(void)imgViewClicked:(UITapGestureRecognizer*)g
{
    UIImageView * imgView =(UIImageView*)g.view;
    
    int tag = imgView.tag - BASE_TAG;
    
    
    AppDelegate * appDel = [[UIApplication sharedApplication] delegate];
    
    [self setSelectView:tag];
    
    [appDel setSkin:tag];

    
    
}


-(void)btnBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
