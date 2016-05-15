//
//  CameraRoll.h
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FlashRuntimeExtensions.h"

@interface CameraRoll : NSObject{
     FREContext context;
}
-(void) sendCameraRoll:(NSString *)attachmentsData;

-(void)setContext:(FREContext)ctx;

@end
