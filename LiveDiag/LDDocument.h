//
//  LDDocument.h
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/07/29.
//  Copyright (c) 2013 dataich.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "LDPreferencesViewController.h"

@interface LDDocument : NSDocument <NSTextViewDelegate>
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet WebView *webView;
@property (strong) LDPreferencesViewController *preferencesController;

@end
