//
//  LDPreferencesViewController.m
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/08/02.
//  Copyright (c) 2013 dataich.com. All rights reserved.
//

#import "LDPreferencesViewController.h"

@interface LDPreferencesViewController ()

@end

@implementation LDPreferencesViewController

- (IBAction)browse:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if(result == NSFileHandlingPanelOKButton) {
            NSString *path = [[panel URL] path];
            switch (sender.tag) {
                case 0:
                    self.textBlockdiag.stringValue = path;
                    break;
                case 1:
                    self.textSeqdiag.stringValue = path;
                    break;
                case 2:
                    self.textActdiag.stringValue = path;
                    break;
                case 3:
                    self.textNwdiag.stringValue = path;
                    break;
                default:
                    break;
            }
        }
    }];
}

@end
