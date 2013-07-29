//
//  NSString+Count.m
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/07/30.
//  Copyright (c) 2013年 dataich.com. All rights reserved.
//

#import "NSString+Count.h"

@implementation NSString (Count)

- (NSUInteger)countOfString:(NSString *)search {
    NSUInteger count = [self length] - [[self stringByReplacingOccurrencesOfString:search withString:@""] length];
    return count / [search length];
}

@end
