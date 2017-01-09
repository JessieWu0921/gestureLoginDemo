//
//  ViewController.m
//  LockoutDemo
//
//  Created by Jessie.W on 17/1/9.
//  Copyright © 2017年 Jessie.W. All rights reserved.
//

#import "ViewController.h"
#import "LoginSuccessViewController.h"
#import "GestureLoginViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *touchIDLoginBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - methods
- (void)loginWithTouchId {
    LAContext *context = [LAContext new];
    NSError *err = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err]) {
        if (err) {
            //
        } else {
//            UIAlertController *alert = [[UIAlertController alloc] init];
//            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"" style:<#(UIAlertActionStyle)#> handler:<#^(UIAlertAction * _Nonnull action)handler#>];
            
            __weak typeof(self) weakSelf = self;
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"TouchID Test" reply:^(BOOL success, NSError * _Nullable error) {
                __strong typeof(self) strongSelf = weakSelf;
                if (success) {
                    NSLog(@"collecte touchId biometrics success.");
                    UIViewController *VC = [strongSelf storyboardViewController:@"Main" viewControllerName:NSStringFromClass([LoginSuccessViewController class])];
                    [strongSelf.navigationController pushViewController:VC animated:YES];
                } else {
                    if (error) {
                        //
                    }
                }
                strongSelf.touchIDLoginBtn.enabled = YES;
            }];
        }
    } else {
        NSLog(@"your device cannot support touchId.");
    }
}

- (UIViewController *)storyboardViewController:(NSString *)storyBoardName viewControllerName:(NSString *)name{
    UIViewController *viewcontroller = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    viewcontroller = [storyboard instantiateViewControllerWithIdentifier:name];
    return viewcontroller;
}

#pragma mark - actions & events
- (IBAction)unlockWithTouchId:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    [self loginWithTouchId];
}
- (IBAction)unlockWithGesture:(id)sender {
    UIViewController * VC = [self storyboardViewController:@"Main" viewControllerName:NSStringFromClass([GestureLoginViewController class])];
    
    [self.navigationController pushViewController:VC animated:YES];
}
@end
