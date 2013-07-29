//
//  LDDocument.m
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/07/29.
//  Copyright (c) 2013 dataich.com. All rights reserved.
//

#import "LDDocument.h"
#import <GHMarkdownParser/GHMarkdownParser.h>

@implementation LDDocument

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"LDDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    self.textView.font = [NSFont userFixedPitchFontOfSize:14];

	NSURL *fileURL = [self fileURL];
	if (!fileURL) {
		return;
	}

	NSString *markdown = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:fileURL] encoding:NSUTF8StringEncoding];
	if (!markdown) {
		return;
	}

	[self.textView setString:markdown];
    [self textViewContentToWebView];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSString *markdown = [self.textView string];
	NSData *data = [markdown dataUsingEncoding:NSUTF8StringEncoding];
	return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    if (outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return TRUE;
}

- (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)printSettings error:(NSError *__autoreleasing *)outError
{
    NSView *view = [[[self.webView mainFrame] frameView] documentView];
    NSPrintOperation *operation = [NSPrintOperation printOperationWithView:view printInfo:[self printInfo]];
    return operation;
}

-(void)textDidChange:(NSNotification *)notification
{
    [self textViewContentToWebView];
}

-(void)textViewContentToWebView
{
    NSString *markDown = [self.textView.textStorage string];

    //loop for parts of diag
    NSError *error;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"^\\{.*?^\\}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionAnchorsMatchLines error:&error];
    NSArray *matches;
    while ([matches = [re matchesInString:markDown options:0 range:NSMakeRange(0, markDown.length)] count] > 0) {
        NSTextCheckingResult *match = matches[0];

        NSString *diag = [markDown substringWithRange:match.range];
        diag = [diag stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]; //convert " to ' for parse diag

        // task to execute blockdiag
        NSTask *echo = [[NSTask alloc] init];
        [echo setLaunchPath:@"/bin/sh"];

        //don't want to use image cache, so create filename by arc4random
        __block __strong NSString *outPath = [NSString stringWithFormat:@"%@%u.png", NSTemporaryDirectory(), arc4random()];

        [echo setArguments:@[@"-c", [NSString stringWithFormat:@"echo \"%@\" | /usr/local/pythonbrew/pythons/Python-2.7.2/bin/blockdiag -o %@ /dev/stdin", diag, outPath]]];

        [echo launch];

        int pid = echo.processIdentifier;

        // temporarily, convert diag part to <img id='{process identifier}'>
        NSString *imgTag = [NSString stringWithFormat:@"<img id='%d'>", pid];
        markDown = [markDown stringByReplacingCharactersInRange:match.range withString:imgTag];

        __block __weak LDDocument *weakSelf = self;
        // after task terminated, add 'src' attribute to <img> using jQuery
        // to pinpoint a <img>, use process identifier
        echo.terminationHandler = ^(NSTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *script = [NSString stringWithFormat:@"$('#%d').attr('src', 'file://%@');", pid, outPath];
                [weakSelf.webView stringByEvaluatingJavaScriptFromString:script];
            });
        };
    };
    
    NSString *html = markDown.flavoredHTMLStringFromMarkdown;
    html = [NSString stringWithFormat:NSLocalizedString(@"%@%@base.html", nil), html];

    // at this time, <img> has no 'src' attribute
    [[self.webView mainFrame] loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

@end
