//
//  LoginSuccessViewController.h
//  LockoutDemo
//
//  Created by Jessie.W on 17/1/9.
//  Copyright © 2017年 Jessie.W. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginType){
    LoginTypeTouchID = 1,
    LoginTypeGesture
};

@interface LoginSuccessViewController : UIViewController

@property (assign, nonatomic) LoginType loginType;
@end
