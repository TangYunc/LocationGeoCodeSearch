//
//  ViewController.m
//  WebView
//
//  Created by Mr_Tang on 15/12/31.
//  Copyright © 2015年 Mr_Tang. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+BaseNavigationItemButton.h"
#import "UIColor+HQ8902.h"

@interface ViewController ()
{
    bool isGeoSearch;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.isBackItem = YES;
    /*
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:@"http://baidu.com"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 5;
    config.allowsCellularAccess = NO;
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *dataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSString *string = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
            [_webView loadHTMLString:string baseURL:nil];
        }

    }];
    [dataTask resume];
   */
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 100, 80);
    [btn setTitle:@"a" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:222/255.0 green:40/255.0 blue:24/255.0 alpha:1]];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor colorWithHexString:@"dd2727"];
    btn.layer.borderColor = [UIColor colorWithHexString:@"dd2727"].CGColor;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    _locService.delegate = self;
    [_locService startUserLocationService];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    
    _locService.delegate = nil;
    [_locService stopUserLocationService];
    _geocodesearch.delegate = nil; // 不用时，置nil
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.theLatitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.theLongitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    ///geo搜索服务 (将经纬度转化为地址,城市等信息,被称为反向地理编码)
    [self onClickReverseGeocode];
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        //这里打印出反向地理编码的结果,包括城市,地址等信息
        self.province = result.addressDetail.province;
        self.city = result.addressDetail.city;
        self.county = result.addressDetail.district;
        
        NSLog(@"测试结果 %@  %@ %@ %@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.address);
        BMKOfflineMap * _offlineMap = [[BMKOfflineMap alloc] init];
        NSArray* records = [_offlineMap searchCity:result.addressDetail.city];
        //        BMKOLSearchRecord* oneRecord = [records objectAtIndex:0];
        //城市编码如:北京为131
        //        self.city_id = [NSString stringWithFormat:@"%d",oneRecord.cityID];
    }
}

-(void)onClickReverseGeocode
{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (self.theLatitude != nil && self.theLongitude != nil) {
        pt = (CLLocationCoordinate2D){[self.theLatitude floatValue], [self.theLongitude floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
- (void)btnAction:(UIButton *)btn{

    NSLog(@"点击了安宁");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}

@end
