//
//  LDAppDelegate.h
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/08/05.
//  Copyright (c) 2013年 dataich.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDAppDelegate : NSObject <NSApplicationDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *windowPreferences;

- (IBAction)showPreferences:(id)sender;
- (void)showPreferences;

@end
