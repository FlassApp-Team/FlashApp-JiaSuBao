//
//  StringUtil.h
//  TwitterFon
//
//  Created by kaz on 7/20/08.
//  Copyright 2008 naan studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (NSStringUtils)
- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;
- (NSString*) trim;
+ (NSString*)localizedString:(NSString*)key;
+ (NSString*)base64encode:(NSString*)str;
- (NSString*) encodeToPercentEscapeString;
- (NSString*) decodeFromPercentEscapeString;
- (NSString*) md5HexDigest;

- (BOOL) checkPhone;
- (BOOL) checkAlphaAndNumber;
- (NSDate*) parseDateWithFormat:(NSString*)format;
+ (NSString*) stringWithRandomNum:(NSInteger)bit;
+ (NSString*) stringForByteNumber:(long)bytes;
+ (NSArray*) bytesAndUnitString:(long)bytes;
+ (NSString*) stringForByteNumber:(long)bytes decimal:(int)d;
+ (NSArray*) bytesAndUnitString:(long)bytes decimal:(int)d;
+ (float) bytesNumberByUnit:(long)bytes unit:(NSString*)unit;
+ (NSString*) stringWithFloatTrim:(float)f decimal:(int)point;

@end


