//
//  DBAppDelegate.h
//  CocoaActivityCounter
//
//  Created by Daniel Beck on 29.07.2012.
//  Copyright (c) 2012 Daniel Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static id monitorLeftMouseDown;
static id monitorRightMouseDown;
static id monitorKeyDown;

@interface DBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextView *logView;

@property (weak) IBOutlet NSToolbarItem *toolbarStartButton;
@property (weak) IBOutlet NSToolbarItem *toolbarStopButton;
@property (weak) IBOutlet NSToolbarItem *toolbarClearButton;

@property (weak) IBOutlet NSTextField *keyPressCounterLabel;
@property (weak) IBOutlet NSTextField *leftMouseCounterLabel;
@property (weak) IBOutlet NSTextField *rightMouseCounterLabel;

@property (readwrite) NSDateFormatter *logDateFormatter;

@property (readwrite) NSNumber *keyPressCounter;
@property (readwrite) NSNumber *leftMouseCounter;
@property (readwrite) NSNumber *rightMouseCounter;

@property (readwrite) BOOL loggingEnabled;

- (IBAction)stopButtonPressed:(id)sender;
- (IBAction)startButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

- (void)logMessageToLogView:(NSString*)message;

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem;

@end
