//
//  DESCrypter.h
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESCrypter : NSObject

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

@end
