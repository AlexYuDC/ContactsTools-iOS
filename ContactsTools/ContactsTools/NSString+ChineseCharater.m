//
//  NSString+ChineseCharater.m
//  ContactsTools
//
//  Created by Alex Yu on 1/29/15.
//  Copyright (c) 2015 no. All rights reserved.
//

#import "NSString+ChineseCharater.h"

@implementation NSString (ChineseCharater)

- (BOOL)isAllChinesseCharactor
{
    for(int i=0; i< self.length; i++){
        unichar charactor = [self characterAtIndex:i];
        if(!( charactor >= 0x4e00 && charactor < 0x9fff))
        {
            return FALSE;
        }
    }
    
    return TRUE;
}

- (NSString *)getPinyin
{
    NSString *mutableString = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
    return mutableString;
}

- (NSString *)getPinyinWithoutBlankSpace
{
    NSString *mutableString = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
    mutableString = [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mutableString;
}

- (NSString *)getPinyinWithoutBlankSpaceEspeciallyForLastName
{
    NSString *mutableString = [[self replacePolyphoneOfLastName] mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
    mutableString = [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mutableString;
}

- (NSString *)replacePolyphoneOfLastName
{
    NSString *string;
    if ([self hasPrefix:@"曾"])
    {
        string = [NSString stringWithFormat:@"增%@", [self substringFromIndex:1]];
    }
    else if ([self hasPrefix:@"沈"])
    {
        string = [NSString stringWithFormat:@"审%@", [self substringFromIndex:1]];
    }
    else
    {
        string = self;
    }
    
    return string;
}

- (BOOL)isLikeAName
{
    if (self.length == 0) {
        return FALSE;
    }
    return !([self containsUnlikeNameString] || [self hasUnlikeLastNamePrefix] || [self isReiterativeLocution]);
}

- (BOOL)containsUnlikeNameString
{
    NSArray *unlikeNameStringArray =@[@"银行", @"联通", @"移动", @"电信", @"宽带", @"航空", @"外卖", @"快递", @"物业", @"置业", @"地产", @"热线",
                                      @"爸爸", @"妈妈", @"舅舅", @"姨妈", @"小姨", @"爷爷", @"奶奶", @"姥爷", @"姥姥", @"姥娘", @"叔叔", @"阿姨", @"姑姑", @"哥哥", @"妹妹", @"姑姑", @"姑姑", @"姑姑", @"老婆", @"老公", @"宝贝", @"亲爱的",
                                      @"经理", @"总监", @"医生", @"老师", @"教授"];
    for (NSString *unlikeNameString in unlikeNameStringArray) {
        if ([self containsString:unlikeNameString]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (BOOL)hasUnlikeLastNamePrefix
{
    NSArray *unlikeLastNameStringArray = @[@"小", @"大", @"老", @"二", @"阿"];
    for (NSString *unlikeNameString in unlikeLastNameStringArray) {
        if ([self hasPrefix:unlikeNameString]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (BOOL)isReiterativeLocution
{
    if (self.length == 2) {
        return [[self substringToIndex:1] isEqualToString:[self substringFromIndex:1]];
    }
    return FALSE;
}

@end
