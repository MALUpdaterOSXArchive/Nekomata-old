//
//  MainWindow.h
//  Nekomata
//
//  Created by 桐間紗路 on 2017/02/28.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PXSourceList/PXSourceList.h>
#import <AFNetworking/AFNetworking.h>
#import "AFOAuth2Manager.h"
#import "Utility.h"

@class AppDelegate;

@interface MainWindow : NSWindowController < PXSourceListDataSource, PXSourceListDelegate>{
    IBOutlet NSWindow *w;
    IBOutlet PXSourceList *sourceList;
    AppDelegate *appdel;
    IBOutlet NSSearchField *searchtitlefield;
    IBOutlet NSArrayController *searcharraycontroller;
    IBOutlet NSTableView *searchtb;
}
@property (strong) IBOutlet NSToolbar *toolbar;
@property (strong) IBOutlet NSView *mainview;
@property (nonatomic, assign) AppDelegate *app;
@property (strong) IBOutlet NSVisualEffectView *animeinfoview;
@property (strong) IBOutlet NSView *animelistview;
@property (strong) IBOutlet NSVisualEffectView *progressview;
@property (strong) IBOutlet NSView *searchview;
@property (strong) IBOutlet NSView *seasonview;
-(void)setDelegate:(AppDelegate*) adelegate;
- (IBAction)performsearch:(id)sender;
@end
