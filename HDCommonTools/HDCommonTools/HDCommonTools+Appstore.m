//
//  HDCommonTools+Appstore.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/16.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+Appstore.h"

@implementation HDCommonTools (Appstore)

- (void)openAppStoreWithAppleID:(NSString *)appleID withType:(HDJumpStoreType)jumpStoreType {
    switch (jumpStoreType) {
        case kHDJumpStoreTypeInAppStore:{
            NSString* urlStr =[NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",appleID];
            [[HDCommonTools sharedHDCommonTools] applicationOpenURL:[NSURL URLWithString:urlStr]];
        }
            break;
        case kHDJumpStoreTypeInApp:{
            if (@available(iOS 10.3, *)) {
                SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
                storeProductVC.delegate = self;
                [storeProductVC loadProductWithParameters:[NSDictionary dictionaryWithObjectsAndKeys:appleID,SKStoreProductParameterITunesItemIdentifier, nil] completionBlock:^(BOOL result, NSError * _Nullable error) {
                    if (result) {
                        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:storeProductVC animated:YES completion:nil];
                    } else {
                        NSLog(@"%@",error);
                    }
                }];
            } else {
                NSLog(@"Less than 10.3 version does not support opening the Appstore preview page within app");
            }
        }
            break;
        case kHDJumpStoreTypeAuto:{
            if (@available(iOS 10.3, *)) {
                SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
                storeProductVC.delegate = self;
                [storeProductVC loadProductWithParameters:[NSDictionary dictionaryWithObjectsAndKeys:appleID,SKStoreProductParameterITunesItemIdentifier, nil] completionBlock:^(BOOL result, NSError * _Nullable error) {
                    if (result) {
                        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:storeProductVC animated:YES completion:nil];
                    } else {
                        NSLog(@"%@",error);
                    }
                }];
            } else {
                NSString* urlStr =[NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",appleID];
                [[HDCommonTools sharedHDCommonTools] applicationOpenURL:[NSURL URLWithString:urlStr]];
            }
        }
            break;
    }
}

- (void)giveScoreWithAppleID:(NSString *)appleID withType:(HDScoreType)scoreType {
    switch (scoreType) {
        case kHDScoreTypeInAppStore:{
            NSString* urlStr =[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=%@",appleID];
            [[HDCommonTools sharedHDCommonTools] applicationOpenURL:[NSURL URLWithString:urlStr]];
        }
            break;
        case kHDScoreTypeInApp:{
            if (@available(iOS 10.3, *)) {
                [SKStoreReviewController requestReview];
            } else {
                NSLog(@"Less than 10.3 version does not support the app open score");
            }
        }
            break;
        case kHDScoreTypeAuto:{
            if (@available(iOS 10.3, *)) {
                [SKStoreReviewController requestReview];
            } else {
                NSString* urlStr =[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appleID];
                [[HDCommonTools sharedHDCommonTools] applicationOpenURL:[NSURL URLWithString:urlStr]];
            }
        }
            break;
    }
}

- (void)giveScoreAutoTypeWithAppleID:(NSString *)appleID withHasRequestTime:(NSUInteger)hasRequestTime withTotalTimeLimit:(NSUInteger)totalTimeLimit {
    if (@available(iOS 10.3, *)) {
        if (hasRequestTime < totalTimeLimit && hasRequestTime < 3) {
            [SKStoreReviewController requestReview];
        } else {
            [self giveScoreWithAppleID:appleID withType:kHDScoreTypeInAppStore];
        }
    } else {
        [self giveScoreWithAppleID:appleID withType:kHDScoreTypeInAppStore];
    }
}

#pragma mark -
#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
