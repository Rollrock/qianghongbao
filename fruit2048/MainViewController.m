//
//  MainViewController.m
//  My2048
//
//  Created by zhuang chaoxiao on 14-5-21.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "MainViewController.h"
#import "GameView.h"
#import <iAd/iAd.h>
#import "AppsViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"

#define SHOW_ADV_YEAR  2014
#define SHOW_ADV_MONTH  9
#define SHOW_ADV_DAY   29


//banner   ca-app-pub-3058205099381432/8946954347
//插屏      ca-app-pub-3058205099381432/1423687549

@import GoogleMobileAds;


@interface MainViewController ()<GADInterstitialDelegate>
{
    GADBannerView *_bannerView;
    GameView * _gameView;
    
    BOOL _canShowAdv;
}

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showADV
{
    self.interstitial = nil;
    
    self.interstitial = [self createAndLoadInterstitial];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _gameView = [[GameView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:_gameView];
    
    [self laytouADVView];
    
     self.interstitial = [self createAndLoadInterstitial];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showADV) name:@"SHOWADV" object:nil];
    
    //菜单
    {
        CGRect rect = CGRectMake(100, 80, 60, 30);
        UIButton * btn = [[UIButton alloc]initWithFrame:rect];
        [btn setTitle:@"抢红包" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = [UIColor orangeColor];
        btn.hidden = YES;
        
        [self.view addSubview:btn];
        
        [btn addTarget:self action:@selector(menuClicken) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //应用推荐
    {
        
        CGRect rect = CGRectMake(165, 80, 60, 30);
        UIButton * btn = [[UIButton alloc]initWithFrame:rect];
        [btn setTitle:@"来三" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = [UIColor orangeColor];
        btn.hidden = YES;
        
        [self.view addSubview:btn];
        
        
        //[btn addTarget:self action:@selector(showAppClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    
    //领取红包
    {
        
        CGRect rect = CGRectMake(165, 30, 80, 30);
        UIButton * btn = [[UIButton alloc]initWithFrame:rect];
        [btn setTitle:@"领取红包" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = [UIColor orangeColor];
        
        [self.view addSubview:btn];
    
        
        [btn addTarget:self action:@selector(getCharge) forControlEvents:UIControlEventTouchUpInside];
        
    }

    
    // 给我打分
    {
        
        CGRect rect = CGRectMake(165, 80, 80, 30);
        UIButton * btn = [[UIButton alloc]initWithFrame:rect];
        [btn setTitle:@"给我打分" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = [UIColor orangeColor];
        btn.hidden = YES;
        
        [self.view addSubview:btn];
        
        [btn addTarget:self action:@selector(Evalute) forControlEvents:UIControlEventTouchUpInside];
        
    }

}


-(void)getCharge
{
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"%@" , currentLanguage);
    
    NSString * strTitle = nil;
    NSString * okTitle = nil;
    
    if( [currentLanguage isEqualToString:@"zh-Hans-CN"] || [currentLanguage isEqualToString:@"zh-Hans"] )
    {
        strTitle = @"您目前的金额还未达到最低领取金额，如果想继续领取，请先我们好评吧~~~";
        okTitle = @"去好评";
    }
    else
    {
        strTitle = @"您的金额未达到最低领取额度！";
        okTitle = @"知道了";
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您目前的金额还未达到最低领取金额，如果想继续领取，请先我们好评吧~~~" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if( [okTitle isEqualToString:@"去好评"] )
        {
            NSString *str =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"1136096408"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        else
        {
            self.interstitial = nil;
            
            self.interstitial = [self createAndLoadInterstitial];
        }
        
        
    }];
    
    UIAlertAction * noAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.interstitial = nil;
        
        self.interstitial = [self createAndLoadInterstitial];
        
    }];
    
    [alert addAction:okAction];
    [alert addAction:noAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



-(void)Evalute
{
    NSString *str =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"884886468"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)menuClicken
{
    MenuViewController * vc = [[MenuViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)showAppClicked
{
    AppsViewController * vc = [[AppsViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    
    vc = nil;
}



-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * app = [[UIApplication sharedApplication] delegate];
    
    if( [app getSkinChange] )
    {
        [_gameView refreshGameSkin];
        //
        [app setSkinChange:NO];
    }
}

-(void)laytouADVView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    NSLog(@"rect height:%f",rect.size.height);
    
    GADBannerView * bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeLargeBanner origin:CGPointMake((rect.size.width-kGADAdSizeLargeBanner.size.width)/2, rect.size.height - kGADAdSizeLargeBanner.size.height-10)];//
    
    bannerView.adUnitID = @"ca-app-pub-3058205099381432/8946954347";
    bannerView.rootViewController = self;
    
    GADRequest * req = [GADRequest request];
    //req.testDevices = @[ @"2440bd529647afc62d632f9d424f0679" ];
    
    [bannerView loadRequest:req];
    
    [self.view addSubview:bannerView];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3058205099381432/1423687549"];
    interstitial.delegate = self;
    GADRequest * req = [GADRequest request];
    //req.testDevices = @[ @"2440bd529647afc62d632f9d424f0679" ];
    [interstitial loadRequest:req];
    return interstitial;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}


@end
