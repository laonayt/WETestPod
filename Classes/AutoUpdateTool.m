//
//  AutoUpdateTool.m
//  ZhiKeTong
//
//  Created by WE on 2018/8/15.
//  Copyright © 2018年 zonekey. All rights reserved.
//

#import "AutoUpdateTool.h"

static NSString *VersionCheck = @"http://120.77.253.101:8091/wisdom/app/findSysAppVersion";

@implementation AutoUpdateTool

+ (instancetype)shareTool {
    static dispatch_once_t onceToken;
    static AutoUpdateTool *tool;
    dispatch_once(&onceToken, ^{
        tool = [[AutoUpdateTool alloc] init];
    });
    return tool;
}

- (void)checkAutoUpdate {
    NSString *version = [HelpTool AppVersion];
    WS(weakSelf)
    [[NetWorkTool shareTool] postWithURL:VersionCheck parameters:@{@"appcode" : @"ZKT_iOS",@"orders" : @"1"} success:^(NSArray *respondeData) {
        NSDictionary *dic = respondeData.firstObject;
        
        if ([dic[@"num"] compare:version options:NSNumericSearch] ==NSOrderedDescending){
            NSLog(@"版本更新");
            [weakSelf showAlertWith:dic[@"num"]];
        }
    } failure:^(NSError *respondeError) {
        
    }];
}

- (void)showAlertWith:(NSString *)num {
    NSString *title = [NSString stringWithFormat:@"发现新版本:%@",num];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"是否更新？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/zonekeyRD/zonekey_pubproject/master/iOS_ZhikeTong.plist"];
        
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }];
    [alert addAction:cancle];
    [alert addAction:sure];
    [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
