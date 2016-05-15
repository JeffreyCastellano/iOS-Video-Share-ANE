//
//  Instagram.h
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface Instagram : NSObject{
    FREContext context;
}

-(void) sendInstagram:(NSString *)attachmentsData;

-(void)setContext:(FREContext)ctx;
@end