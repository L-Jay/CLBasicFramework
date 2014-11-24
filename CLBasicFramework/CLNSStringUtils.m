//
//  CLNSStringUtils.m
//  CLBasicFramework
#import <CommonCrypto/CommonDigest.h>
#import "CLBasicFramework.h"

@implementation NSString (Util)

#pragma mark - Expand Class Methods
+ (NSString *)intString:(int)value
{
    return [NSString stringWithFormat: @"%d", value];
}

+ (NSString *)floatString:(float)value
{
    return [NSString stringWithFormat:@"%f", value];
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


#pragma mark - Validate String
- (BOOL)validateiPhoneNum
{
    return [self validateMatchesString: @"^1[3|4|5|7|8|9][0-9]{9}$"];
}

- (BOOL)validateEmail
{
	return [self validateMatchesString: @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)validateURL
{
	return [self validateMatchesString: @"[a-zA-z]+://[^\\s]*"];
}

- (BOOL)validateMatchesString:(NSString *)matchStr
{
	NSPredicate *userTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchStr];
	return [userTest evaluateWithObject: self];
}

#pragma mark - String Size
- (CGSize)sizeWithFont:(UIFont *)font boundingRect:(CGSize)size
{
    if (DEVICE_ISIOS7) {
        NSDictionary *attributes = @{NSFontAttributeName:font};
        NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
        return [self boundingRectWithSize:size options:options attributes:attributes context:NULL].size;
    }
    
    return [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

@end
