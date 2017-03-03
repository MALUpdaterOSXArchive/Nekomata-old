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
    // Title Info
    int selectedid;
}
//Anime List View
@property (strong) IBOutlet NSArrayController *animelistarraycontroller;
@property (strong) IBOutlet NSTableView *animelisttb;
@property (strong) IBOutlet NSButton *watchingfilter;
@property (strong) IBOutlet NSButton *completedfilter;
@property (strong) IBOutlet NSButton *onholdfilter;
@property (strong) IBOutlet NSButton *droppedfilter;
@property (strong) IBOutlet NSButton *plantowatchfilter;
@property (strong) IBOutlet NSSearchField *animelistfilter;

//Search View
@property (strong) IBOutlet NSToolbar *toolbar;
@property (strong) IBOutlet NSView *mainview;
@property (nonatomic, assign) AppDelegate *app;
@property (strong) IBOutlet NSVisualEffectView *animeinfoview;
@property (strong) IBOutlet NSView *animelistview;
@property (strong) IBOutlet NSVisualEffectView *progressview;
@property (strong) IBOutlet NSView *searchview;
@property (strong) IBOutlet NSView *seasonview;
@property (strong) IBOutlet NSVisualEffectView *notloggedinview;
// Info View
@property (strong) IBOutlet NSProgressIndicator *progressindicator;
@property (strong) IBOutlet NSView *noinfoview;
@property (strong) IBOutlet NSTextField *infoviewtitle;
@property (strong) IBOutlet NSTextField *infoviewalttitles;
@property (strong) IBOutlet NSTextView *infoviewdetailstextview;
@property (strong) IBOutlet NSTextView *infoviewsynopsistextview;
@property (strong) IBOutlet NSImageView *infoviewposterimage;


//Public Methods
-(void)setDelegate:(AppDelegate*) adelegate;
- (IBAction)performlogin:(id)sender;
- (IBAction)PerformAddTitle:(id)sender;
- (IBAction)sharetitle:(id)sender;
-(void)loadmainview;
-(void)setAppearence;

//Anime List View
- (IBAction)refreshlist:(id)sender;
- (IBAction)animelistdoubleclick:(id)sender;
-(void)clearlist;
- (IBAction)filterperform:(id)sender;
//Search View
- (IBAction)performsearch:(id)sender;
- (IBAction)searchtbdoubleclick:(id)sender;
// Info View
- (IBAction)viewonanilist:(id)sender;

@end
