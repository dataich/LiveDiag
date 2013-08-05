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
@property (weak) IBOutlet NSUserDefaultsController *defaultsController;

- (IBAction)browse:(NSButton *)sender;

@end
