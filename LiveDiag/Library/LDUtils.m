//
//  LDUtils.m
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/08/06.
//  Copyright (c) 2013 dataich.com. All rights reserved.
//

#import "LDUtils.h"

@implementation LDUtils

+ (NSString *)pathTo:(NSString *)command {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:[NSString stringWithFormat:@"path_%@", command]];
}

@end
