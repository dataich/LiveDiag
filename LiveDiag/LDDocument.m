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
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

-(void)textDidChange:(NSNotification *)notification {
    NSString *markDown = [self.textView.textStorage string];

    NSString *html = markDown.flavoredHTMLStringFromMarkdown;
    html = [NSString stringWithFormat:NSLocalizedString(@"%@%@base.html", nil), html];

    [[self.webView mainFrame] loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}


@end
