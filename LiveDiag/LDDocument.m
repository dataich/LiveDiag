//
//  LDDocument.m
//  LiveDiag
//
//  Created by Taichiro Yoshida on 2013/07/29.
//  Copyright (c) 2013 dataich.com. All rights reserved.
//

#import "LDDocument.h"
#import "LDAppDelegate.h"
#import "LDUtils.h"
#import "NSString+Count.h"
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
    self.textView.font = [NSFont userFixedPitchFontOfSize:12];
    
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
    NSURL *currentDirectory;
    if(self.fileURL ) {
        currentDirectory = [self.fileURL URLByDeletingLastPathComponent];
    } else {
        currentDirectory = [NSURL URLWithString:NSTemporaryDirectory()];
    }

    if([markDown countOfString:@"{"] == [markDown countOfString:@"}"]) {
        //loop for parts of diag
        NSError *error;
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"^(blockdiag|seqdiag|actdiag|nwdiag|rackdiag|)(\\s|)\\{.*?^\\}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionAnchorsMatchLines error:&error];
        NSArray *matches;
        int count = 0;
        while ([matches = [re matchesInString:markDown options:0 range:NSMakeRange(0, markDown.length)]
                count] > 0) {

            NSTextCheckingResult *match = matches[0];

            NSString *diag = [markDown substringWithRange:match.range];
            diag = [diag stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]; //convert " to ' for parse diag

            // task to execute blockdiag
            NSTask *echo = [[NSTask alloc] init];
            [echo setLaunchPath:@"/bin/bash"];

            NSString *command = [markDown substringWithRange:[match rangeAtIndex:1]];
            NSLog(@"%@", command);
            if(!command || [command isEqualToString:@""]) {
                command = @"blockdiag";
            }
            command = [LDUtils pathTo:command];

            NSString *directory = [NSString stringWithFormat:@"%@/diagrams", currentDirectory.path];

            NSFileManager *fileManager = [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:directory]) {
                [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            //don't want to use image cache, so create filename by arc4random
            count = count + 1;
            NSString *outPath = [NSString stringWithFormat:@"%@/%04d.svg", directory, count];

            [echo setArguments:@[@"-c", [NSString stringWithFormat:@"echo \"%@\" | %@ -Tsvg -o %@ /dev/stdin", diag, command, outPath]]];

            [echo launch];

            int pid = echo.processIdentifier;

            // temporarily, convert diag part to <img id='{process identifier}' prepareSrc='{file path}'>
            NSString *imgTag = [NSString stringWithFormat:@"<img id='%d' prepareSrc='%@'>", pid, outPath];
            markDown = [markDown stringByReplacingCharactersInRange:match.range withString:imgTag];

            __block __weak LDDocument *weakSelf = self;
            // after task terminated, add 'src' attribute to <img> from 'prapareSrc' attribute using jQuery
            // to pinpoint a <img>, use process identifier
            echo.terminationHandler = ^(NSTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *script = [NSString stringWithFormat:@"$('#%d').attr('src', $('#%d').attr('prepareSrc'));", pid, pid];
                        [weakSelf.webView stringByEvaluatingJavaScriptFromString:script];
                    });
            };
        };
    }

    NSString *externalFilePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]];
    NSString *html = markDown.flavoredHTMLStringFromMarkdown;
    html = [NSString stringWithFormat:NSLocalizedString(@"%@%@%@base.html", nil),
            externalFilePath,
            externalFilePath,
            html];

    // at this time, <img> has no 'src' attribute
    [[self.webView mainFrame] loadHTMLString:html baseURL:currentDirectory];
}

@end
