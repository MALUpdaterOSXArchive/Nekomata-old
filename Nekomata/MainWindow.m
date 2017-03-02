//
//  MainWindow.m
//  Nekomata
//
//  Created by 桐間紗路 on 2017/02/28.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import "MainWindow.h"

@interface MainWindow ()
@property (strong, nonatomic) NSMutableArray *sourceListItems;
@end

@implementation MainWindow

-(id)init{
    self = [super initWithWindowNibName:@"MainWindow"];
    if(!self)
        return nil;
    return self;
}
- (void)awakeFromNib
{
    // Insert code here to initialize your application
    // Fix template images
    // There is a bug where template images are not made even if they are set in XCAssets
    NSArray *images = @[@"animeinfo", @"delete", @"Edit", @"Info", @"library", @"search", @"seasons"];
    NSImage * image;
    for (NSString *imagename in images){
        image = [NSImage imageNamed:imagename];
        [image setTemplate:YES];
    }
    
    self.sourceListItems = [[NSMutableArray alloc] init];
    
    //Library Group
    PXSourceListItem *libraryItem = [PXSourceListItem itemWithTitle:@"LIBRARY" identifier:@"library"];
    PXSourceListItem *animelistItem = [PXSourceListItem itemWithTitle:@"Anime List" identifier:@"animelist"];
    [animelistItem setIcon:[NSImage imageNamed:@"library"]];
     [libraryItem setChildren:[NSArray arrayWithObjects:animelistItem, nil]];
    // Discover Group
    PXSourceListItem *discoverItem = [PXSourceListItem itemWithTitle:@"DISCOVER" identifier:@"discover"];
    PXSourceListItem *searchItem = [PXSourceListItem itemWithTitle:@"Search" identifier:@"search"];
      [searchItem setIcon:[NSImage imageNamed:@"search"]];
    PXSourceListItem *titleinfoItem = [PXSourceListItem itemWithTitle:@"Title Info" identifier:@"titleinfo"];
    [titleinfoItem setIcon:[NSImage imageNamed:@"animeinfo"]];
    PXSourceListItem *seasonsItem = [PXSourceListItem itemWithTitle:@"Seasons" identifier:@"seasons"];
    [seasonsItem setIcon:[NSImage imageNamed:@"seasons"]];
 [discoverItem setChildren:[NSArray arrayWithObjects:searchItem, titleinfoItem,seasonsItem, nil]];
   
   // Populate Source List
    [self.sourceListItems addObject:libraryItem];
    [self.sourceListItems addObject:discoverItem];
    [sourceList reloadData];
    // Set Resizeing mask
    [_animeinfoview setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [_animelistview setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [_progressview setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [_searchview setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [_seasonview setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    self.window.titleVisibility = NSWindowTitleHidden;
    
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Set Mainview
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"selectedmainview"]){
        NSNumber *selected = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedmainview"];
        [sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex: [selected unsignedIntegerValue]]byExtendingSelection:false];
    }
    else{
         [sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:1]byExtendingSelection:false];
    }
    
}

-(void)setDelegate:(AppDelegate*) adelegate{
    appdel = adelegate;
}

- (void)windowWillClose:(NSNotification *)notification{
    [[NSApplication sharedApplication] terminate:0];
}
#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
    //Works the same way as the NSOutlineView data source: `nil` means a parent item
    if(item==nil) {
        return [self.sourceListItems count];
    }
    else {
        return [[item children] count];
    }
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
    //Works the same way as the NSOutlineView data source: `nil` means a parent item
    if(item==nil) {
        return [self.sourceListItems objectAtIndex:index];
    }
    else {
        return [[item children] objectAtIndex:index];
    }
}


- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
    return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
    [item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
    return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
    return !![(PXSourceListItem *)item badgeValue];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
    return [(PXSourceListItem *)item badgeValue].integerValue;
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
    return !![item icon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
    return [item icon];
}


#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
    if([[group identifier] isEqualToString:@"library"])
        return YES;
    else if([[group identifier] isEqualToString:@"discover"])
        return YES;
    return NO;
}
- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
    [self loadmainview];
}



#pragma mark -
#pragma mark Main View Control
-(void)loadmainview{
    NSRect mainviewframe = _mainview.frame;
    [_mainview addSubview:[NSView new]];
    long selectedrow = [sourceList selectedRow];
    NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    NSPoint origin = NSMakePoint(0, 0);
    if ([identifier isEqualToString:@"animelist"]){
            [_mainview replaceSubview:[_mainview.subviews objectAtIndex:0] with:_animelistview];
            _animelistview.frame = mainviewframe;
            [_animelistview setFrameOrigin:origin];
    }
    else if ([identifier isEqualToString:@"search"]){
            [_mainview replaceSubview:[_mainview.subviews objectAtIndex:0] with:_searchview];
            _searchview.frame = mainviewframe;
            [_searchview setFrameOrigin:origin];
    }
    else if ([identifier isEqualToString:@"titleinfo"]){
            [_mainview replaceSubview:[_mainview.subviews objectAtIndex:0] with:_animeinfoview];
            _animeinfoview.frame = mainviewframe;
            [_animeinfoview setFrameOrigin:origin];
    }
    else if ([identifier isEqualToString:@"seasons"]){
            [_mainview replaceSubview:[_mainview.subviews objectAtIndex:0] with:_seasonview];
            _seasonview.frame = mainviewframe;
            [_seasonview setFrameOrigin:origin];
    }
    // Save current view
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithLong:selectedrow] forKey:@"selectedmainview"];
    [self createToolbar];
}
-(void)createToolbar{
    NSArray *toolbaritems = [_toolbar items];
    // Remove Toolbar Items
    for (int i = 0; i < [toolbaritems count]; i++){
        [_toolbar removeItemAtIndex:0];
    }
    NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
    NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
    if ([identifier isEqualToString:@"animelist"]){
        [_toolbar insertItemWithItemIdentifier:@"editList" atIndex:0];
        [_toolbar insertItemWithItemIdentifier:@"DeleteTitle" atIndex:1];
        [_toolbar insertItemWithItemIdentifier:@"refresh" atIndex:2];
        [_toolbar insertItemWithItemIdentifier:@"ShareList" atIndex:3];
        [_toolbar insertItemWithItemIdentifier:@"NSToolbarFlexibleSpaceItem" atIndex:4];
        [_toolbar insertItemWithItemIdentifier:@"filter" atIndex:5];
    }
    else if ([identifier isEqualToString:@"search"]){
        [_toolbar insertItemWithItemIdentifier:@"AddTitleSearch" atIndex:0];
        [_toolbar insertItemWithItemIdentifier:@"NSToolbarFlexibleSpaceItem" atIndex:1];
        [_toolbar insertItemWithItemIdentifier:@"search" atIndex:2];
      
    }
    else if ([identifier isEqualToString:@"titleinfo"]){
        [_toolbar insertItemWithItemIdentifier:@"AddTitleInfo" atIndex:0];
        [_toolbar insertItemWithItemIdentifier:@"viewonmal" atIndex:1];
        [_toolbar insertItemWithItemIdentifier:@"ShareInfo" atIndex:2];
        
    }
    else if ([identifier isEqualToString:@"seasons"]){
       [_toolbar insertItemWithItemIdentifier:@"AddTitleSeason" atIndex:0];
        [_toolbar insertItemWithItemIdentifier:@"yearselect" atIndex:1];
        [_toolbar insertItemWithItemIdentifier:@"seasonselect" atIndex:2];
        [_toolbar insertItemWithItemIdentifier:@"refresh" atIndex:3];
    }
}
-(NSString *)getToken{
    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"Nekomata"];
    if (credential.accessToken){
        return credential.accessToken;
    }
    return nil;
    
}
// Search
- (IBAction)performsearch:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"https://anilist.co/api/anime/search/%@",[Utility urlEncodeString:searchtitlefield.stringValue]] parameters:@{@"access_token":[self getToken]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [self populatesearchtb:responseObject];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
   }
-(void)populatesearchtb:(NSArray*)json{
    NSMutableArray * a = [searcharraycontroller content];
    [a removeAllObjects];
    [searcharraycontroller addObjects:json];
    [searchtb reloadData];
    [searchtb deselectAll:self];
}
@end

