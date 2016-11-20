//
//  ViewController.h
//  WebView
//
//  Created by Mr_Tang on 15/12/31.
//  Copyright © 2015年 Mr_Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface ViewController : UIViewController<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UIWebView *_webView;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}
@property (nonatomic, copy) NSString *theLatitude;
@property (nonatomic, copy) NSString *theLongitude;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, assign) NSString *city_id;
@end

