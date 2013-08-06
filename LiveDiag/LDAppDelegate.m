//
//  LDAppDelegate.m
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/08/05.
//  Copyright (c) 2013年 dataich.com. All rights reserved.
//

#import "LDAppDelegate.h"
#import "LDUtils.h"

@implementation LDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //check path settings, any commands
    if([LDUtils pathTo:@"blockdiag"] == nil || [LDUtils pathTo:@"seqdiag"] == nil || [LDUtils pathTo:@"actdiag"] == nil || [LDUtils pathTo:@"nwdiag"] == nil || [LDUtils pathTo:@"rackdiag"] == nil) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Path Setting" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Please specify a path to blockdiag and the other."];
        if ([alert runModal] == NSAlertDefaultReturn) {
            LDAppDelegate *delegate = (LDAppDelegate *)[[NSApplication sharedApplication] delegate];
            [delegate showPreferences];
        }
    }
}

- (IBAction)showPreferences:(id)sender {
    [self showPreferences];
}

- (void)showPreferences {
    [NSApp runModalForWindow:self.windowPreferences];
    [self.windowPreferences orderOut:self];
//    [self.windowPreferences makeKeyAndOrderFront:self];
}

@end
