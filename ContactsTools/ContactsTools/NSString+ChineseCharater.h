//
//  NSString+ChineseCharater.h
//  ContactsTools
//
//  Created by Alex Yu on 1/29/15.
//  Copyright (c) 2015 no. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ChineseCharater)

- (BOOL)isAllChinesseCharactor;

- (NSString *)getPinyin;
- (NSString *)getPinyinWithoutBlankSpace;
- (NSString *)getPinyinWithoutBlankSpaceEspeciallyForLastName;

- (BOOL)containsUnlikeNameString;
- (BOOL)hasUnlikeLastNamePrefix;
- (BOOL)isLikeAName;

@end
