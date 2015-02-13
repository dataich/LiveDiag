//
//  LDUtils.m
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/08/06.
//  Copyright (c) 2013 dataich.com. All rights reserved.
//

#import "LDUtils.h"

@implementation LDUtils

+ (BOOL)checkPaths {
    __block NSArray *commands = @[@"blockdiag", @"seqdiag", @"actdiag", @"nwdiag", @"rackdiag"];

    BOOL (^validatePaths)() = ^BOOL() {
        __block BOOL r;
        [commands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *path = [LDUtils pathTo:obj];
            r = (path != nil && ![path isEqualToString:@""]);
            *stop = !r;
        }];
        return r;
    };

    BOOL result = validatePaths();
    if (!result) {
        [commands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *path = [LDUtils pathTo:obj];
            if (path == nil || [path isEqualToString:@""]) {
                [LDUtils setPathWithCommand:obj];
            }
        }];
        result = validatePaths();
    }
    return result;
}

+ (NSString *)pathTo:(NSString *)command {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:[NSString stringWithFormat:@"path_%@", command]];
}

+ (NSString *)setPathWithCommand:(NSString *)command {
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];

    [task setStandardOutput:pipe];
    [task setCurrentDirectoryPath:[[NSBundle mainBundle].bundlePath stringByDeletingLastPathComponent]];
    [task setLaunchPath:@"/bin/bash"];

    NSString *run = [NSString stringWithFormat:@"which %@", command];
    NSArray *args = [NSArray arrayWithObjects:@"-l", @"-c", run, nil];
    [task setArguments:args];
    [task launch];
    [task waitUntilExit];

    if ([task terminationStatus] != 0) {
        // Exit if not exists.
        return nil;
    }

    NSData *data = pipe.fileHandleForReading.availableData;
    NSString *path = [NSString stringWithFormat:@"%s", data.bytes];
    NSArray *paths = [path componentsSeparatedByString:@"\n"];
    if (paths.count > 0) {
        path = paths.firstObject;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:path forKey:[NSString stringWithFormat:@"path_%@", command]];
    return path;
}

@end
