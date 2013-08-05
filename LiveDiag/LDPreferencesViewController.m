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

/**
 * save user preferences to NSUserDefaultsController
 * I bind NSTextField to NSUserDefaultsController on xib, but it's saved only when the field loses focus...
 * Provisionally I create 'save' action which sent from 'OK' button.
 */
- (IBAction)save:(id)sender {
    [self setValueToDefauls:self.textBlockdiag.stringValue forKeyPath:@"values.path_blockdiag"];
    [self setValueToDefauls:self.textSeqdiag.stringValue forKeyPath:@"values.path_seqdiag"];
    [self setValueToDefauls:self.textActdiag.stringValue forKeyPath:@"values.path_actdiag"];
    [self setValueToDefauls:self.textNwdiag.stringValue forKeyPath:@"values.path_nwdiag"];
    [self setValueToDefauls:self.textRackdiag.stringValue forKeyPath:@"values.path_rackdiag"];

    [self.windowPreferences close];
}

- (void)setValueToDefauls:(NSString *)value forKeyPath:(NSString *)forKeyPath{
    if(value == nil || [value isEqualToString:@""]) {
        [self.defaultsController setValue:nil forKeyPath:forKeyPath];
    } else {
        [self.defaultsController setValue:value forKeyPath:forKeyPath];
    }
}

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
                case 4:
                    self.textRackdiag.stringValue = path;
                    break;
                default:
                    break;
            }
        }
    }];
}

@end
