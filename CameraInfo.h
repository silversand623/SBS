//
//  CameraInfo.h
//  SBS
//
//  Created by lyn on 15/6/26.
//  Copyright (c) 2015年 Tellyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraInfo : NSObject
@property (strong,nonatomic) NSString *ID;
@property (strong,nonatomic) NSString *IP;
@property (strong,nonatomic) NSString *Port;
@property (strong,nonatomic) NSString *videoAddress;
@property (strong,nonatomic) NSString *videoFirm;
@property (strong,nonatomic) NSString *videoKind;
@property (strong,nonatomic) NSString *videoUserName;
@property (strong,nonatomic) NSString *videoPassword;
@property (strong,nonatomic) NSString *videoProducer;
@end
