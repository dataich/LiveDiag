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
    NSString *path = [userDefaults stringForKey:[NSString stringWithFormat:@"path_%@", command]];
    if (path == nil || [path isEqualTo:@""]) {
        path = [LDUtils setPathWithCommand:command];
    }
    return path;
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

    NSData *data = pipe.fileHandleForReading.availableData;
    NSString *path = [NSString stringWithFormat:@"%s", data.bytes];
    path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:path forKey:[NSString stringWithFormat:@"path_%@", command]];
    return path;
}

@end
