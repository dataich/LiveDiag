//
//  LDPreferencesViewController.h
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/08/02.
//  Copyright (c) 2013 dataich.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LDPreferencesViewController : NSViewController

@property (weak) IBOutlet NSTextField *textBlockdiag;
@property (weak) IBOutlet NSTextField *textSeqdiag;
@property (weak) IBOutlet NSTextField *textActdiag;
@property (weak) IBOutlet NSTextField *textNwdiag;
@property (weak) IBOutlet NSTextField *textRackdiag;
@property (weak) IBOutlet NSUserDefaultsController *defaultsController;
@property (unsafe_unretained) IBOutlet NSWindow *windowPreferences;

- (IBAction)browse:(NSButton *)sender;
- (IBAction)save:(id)sender;

@end
