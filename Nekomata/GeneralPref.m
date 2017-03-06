//
//  GeneralPref.m
//  Nekomata
//
//  Created by 桐間紗路 on 2017/03/01.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import "GeneralPref.h"
#import "MainWindow.h"
@interface GeneralPref ()

@end

@implementation GeneralPref
- (id)init
{
    return [super initWithNibName:@"GeneralPref" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}
- (IBAction)changeappearence:(id)sender {
    [mainwindowcontroller setAppearence];
}
-(void)setMainWindowController:(MainWindow*)mw{
    mainwindowcontroller = mw;
}

- (IBAction)performtoggletimer:(id)sender {
    NSNumber * autorefreshlist = [[NSUserDefaults standardUserDefaults] valueForKey:@"refreshautomatically"];
    if (autorefreshlist.boolValue){
        [mainwindowcontroller startTimer];
    }
    else{
        [mainwindowcontroller stopTimer];
    }
}
@end
