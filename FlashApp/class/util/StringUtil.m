//
//  StringUtil.m
//  TwitterFon
//
//  Created by kaz on 7/20/08.
//  Copyright 2008 naan studio. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "StringUtil.h"
#import "REString.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; 
static const NSString* charactersToLeaveUnescaped = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

@implementation NSString (NSStringUtils)
//？？
- (NSString*)encodeAsURIComponent
{
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if ( ('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}


- (NSString*) md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}


- (NSString*) encodeToPercentEscapeString
{
    return (NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) self,
                                            (CFStringRef) charactersToLeaveUnescaped,
                                            NULL,
                                            kCFStringEncodingUTF8);
}


- (NSString*) decodeFromPercentEscapeString
{
    return (NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (CFStringRef) self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
}

+ (NSString*)base64encode:(NSString*)str 
{
    if ([str length] == 0)
        return @"";

    const char *source = [str UTF8String];
    int strlength  = strlen(source);
    
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;

    NSUInteger length = 0;
    NSUInteger i = 0;

    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

- (NSString*)escapeHTML
{
	NSMutableString* s = [NSMutableString string];
	
	int start = 0;
	int len = [self length];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString*)unescapeHTML
{
	NSMutableString* s = [NSMutableString string];
	NSMutableString* target = [[self mutableCopy] autorelease];
	NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}

+ (NSString*)localizedString:(NSString*)key
{
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];
}


- (NSString*) trim
{
	NSMutableString* s = [self mutableCopy];
	CFStringTrimWhitespace((CFMutableStringRef)s);
	NSString* result = [s copy];
	[s release];
	return [result autorelease];
}


- (BOOL) checkPhone
{
    BOOL result = NO;
    /*result = [self matches:@"^13[0-9]{9}$" withSubstring:nil];
    if ( result ) return YES;
    
    result = [self matches:@"^15[0-35-9][0-9]{8}$" withSubstring:nil];
    if ( result ) return YES;

    result = [self matches:@"^18[05-9][0-9]{8}$" withSubstring:nil];
    if ( result ) return YES;*/
    
    result = [self matches:@"^[0-9]{11}$" withSubstring:nil];
    if ( result ) return YES;

    return NO;
}


- (BOOL) checkAlphaAndNumber
{
    BOOL result = NO;
    result = [self matches:@"^[0-9|a-z|A-Z]*$" withSubstring:nil];
    if ( result ) return YES;
    else return NO;
}


- (NSDate*) parseDateWithFormat:(NSString*)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:self];
    [formatter release];
    return date;
}


+ (NSString*) stringWithRandomNum:(NSInteger)bit
{
    NSMutableString* s = [NSMutableString string];
    for ( int i=0; i<bit; i++ ) {
        int randNum = arc4random() % 10;
        [s appendString:[NSString stringWithFormat:@"%d", randNum]];
    }
    
    return s;
}


+ (NSArray*) bytesAndUnitString:(long)bytes decimal:(int)d
{
    NSString* bytesNumber;
    NSString* unit;
    
    NSString* format = [NSString stringWithFormat:@"%%.%df", d];
    
    if ( bytes < 1024 ) {
        bytesNumber = [NSString stringWithFormat:@"%ld", bytes];
        unit = @"B";
    }
    else if ( bytes < 1024 * 1024 ) {
        bytesNumber = [NSString stringWithFormat:format, bytes / 1024.0f];
        unit = @"KB";
    }
    else if ( bytes < 1024 * 1024 * 1024 ) {
        bytesNumber = [NSString stringWithFormat:format, bytes / (1024.0f * 1024.0f)];
        unit = @"MB";
    }
    else {
        bytesNumber = [NSString stringWithFormat:format, bytes / (1024.0f * 1024.0f * 1024.0f)];
        unit = @"GB";
    }

    return [NSArray arrayWithObjects:bytesNumber, unit, nil];
}


+ (float) bytesNumberByUnit:(long)bytes unit:(NSString*)unit
{
    float r = 0;
    if ( [@"B" compare:unit] == NSOrderedSame ) {
        r = bytes;
    }
    else if ( [@"KB" compare:unit] == NSOrderedSame ) {
        r = bytes / 1024.0;
    }
    else if ( [@"MB" compare:unit] == NSOrderedSame ) {
        r = bytes / (1024.0 * 1024.0);
    }
    else if ( [@"GB" compare:unit] == NSOrderedSame ) {
        r = bytes / (1024.0 * 1024.0 * 1024.0);
    }
    return r;
}


+ (NSArray*) bytesAndUnitString:(long)bytes
{
    return [NSString bytesAndUnitString:bytes decimal:2];
}


+ (NSString*) stringForByteNumber:(long)bytes decimal:(int)d
{
    NSArray* array = [NSString bytesAndUnitString:bytes decimal:d];
    return [NSString stringWithFormat:@"%@%@", [array objectAtIndex:0], [array objectAtIndex:1]];
}


+ (NSString*) stringForByteNumber:(long)bytes
{
    return [NSString stringForByteNumber:bytes decimal:2];
}


+ (NSString*) stringWithFloatTrim:(float)f decimal:(int)point
{
    if ( ceil(f) == f ) {
        return [NSString stringWithFormat:@"%.0f", f];
    }
    else {
        NSString* format = [NSString stringWithFormat:@"%%.%df", point];
        return [NSString stringWithFormat:format, f];
    }
}


@end



