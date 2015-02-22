//
//  DBAppDelegate.m
//  CocoaActivityCounter
//
//  Created by Daniel Beck on 29.07.2012.
//  Copyright (c) 2012 Daniel Beck. All rights reserved.
//

#import "DBAppDelegate.h"
#import <AppKit/NSEvent.h>

@implementation DBAppDelegate
@synthesize logView;
@synthesize toolbarStartButton;
@synthesize toolbarStopButton;
@synthesize keyPressCounterLabel;
@synthesize leftMouseCounterLabel;
@synthesize rightMouseCounterLabel;
@synthesize toolbarClearButton;
@synthesize loggingEnabled;

@synthesize keyPressCounter;
@synthesize leftMouseCounter;
@synthesize rightMouseCounter;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.loggingEnabled = NO;
    self.logDateFormatter = [[NSDateFormatter alloc] init];
    [self.logDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    self.keyPressCounter = [NSNumber numberWithInt:0];
    self.leftMouseCounter = [NSNumber numberWithInt:0];
    self.rightMouseCounter = [NSNumber numberWithInt:0];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)logMessageToLogView:(NSString*)message {
    [logView setString: [[logView string] stringByAppendingFormat:@"%@: %@\n", [self.logDateFormatter stringFromDate:[NSDate date]],  message]];
}

- (IBAction)stopButtonPressed:(id)sender {
    if (!self.loggingEnabled) {
        return;
    }
    self.loggingEnabled = false;
    [NSEvent removeMonitor:monitorLeftMouseDown];
    [NSEvent removeMonitor:monitorRightMouseDown];
    [NSEvent removeMonitor:monitorKeyDown];
}

- (IBAction)startButtonPressed:(id)sender {
    
    if (self.loggingEnabled) {
        return;
    }
	
	
	if (checkAccessibility()) {
		[self logMessageToLogView:@"Accessibility Enabled"];
	}
	else {
		[self logMessageToLogView:@"Accessibility Disabled"];
	}
	
    self.loggingEnabled = true;
    monitorLeftMouseDown = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^(NSEvent *evt) {
        [self logMessageToLogView:[NSString stringWithFormat:@"Left mouse down!"]];
        self.leftMouseCounter = [NSNumber numberWithInt:(1 + [self.leftMouseCounter intValue])];
    }];
    monitorRightMouseDown = [NSEvent addGlobalMonitorForEventsMatchingMask:NSRightMouseDownMask handler:^(NSEvent *evt) {
        [self logMessageToLogView:@"Right mouse down!"];
        self.rightMouseCounter = [NSNumber numberWithInt:(1 + [self.rightMouseCounter intValue])];
    }];
    monitorKeyDown = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *evt) {
        [self logMessageToLogView:[NSString stringWithFormat:@"Key down: %@ (key code %d)", [evt characters], [evt keyCode]]];
        self.keyPressCounter = [NSNumber numberWithInt:(1 + [self.keyPressCounter intValue])];
    }];
}

- (IBAction)clearButtonPressed:(id)sender {
    self.keyPressCounter = [NSNumber numberWithInt:0];
    self.leftMouseCounter = [NSNumber numberWithInt:0];
    self.rightMouseCounter = [NSNumber numberWithInt:0];
    [self.logView setString:@""];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem {
    if ([theItem isEqualTo:toolbarStartButton]) {
        return !self.loggingEnabled;
    }
    if ([theItem isEqualTo:toolbarStopButton]) {
        return self.loggingEnabled;
    }
    if ([theItem isEqualTo:toolbarClearButton]) {
        return !self.loggingEnabled;
    }
    return YES;
}


BOOL checkAccessibility()
{
	NSDictionary* opts = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
	return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)opts);
}

@end
