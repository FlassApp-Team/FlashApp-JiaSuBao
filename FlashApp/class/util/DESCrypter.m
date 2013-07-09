//
//  DESCrypter.m
//  flashapp
//
//  Created by Qi Zhao on 12-8-26.
//  Copyright (c) 2012年 Home. All rights reserved.
//
#import <CommonCrypto/CommonCryptor.h>
#import "DESCrypter.h"
#import "NSData-Base64.h"

@implementation DESCrypter

static Byte iv[] = {1,2,3,4,5,6,7,8};

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSUInteger buffer2Length;
    
    Byte buffer2[81920];
    memset(buffer2, 0, 81920);

    NSRange range;
    range.length = plainText.length;
    range.location = 0;
    
    [plainText getBytes:buffer2 maxLength:81920 usedLength:&buffer2Length encoding:NSUTF8StringEncoding options:0 range:range remainingRange:NULL];
    NSLog(@"input length=%d", buffer2Length);
    
    unsigned char buffer[81920];
    memset(buffer, 0, 81920);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          //0,
                                          [key UTF8String], kCCKeySize3DES,
                                          iv,
                                          buffer2, buffer2Length,
                                          buffer, 81920,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:numBytesEncrypted];
        NSLog(@"data=%d, length=%ld", data.length, numBytesEncrypted);
        ciphertext = [data base64Encoding];
    }
    
    while ( [ciphertext rangeOfString:@" "].location != NSNotFound ) {
        ciphertext = [ciphertext stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return ciphertext;
}



@end
