//
//  LoginPref.h
//  MAL Updater OS X
//
//  Created by Nanoha Takamachi on 2014/10/18.
//  Copyright 2014 Atelier Shiori. All rights reserved. Code licensed under New BSD License
//

#import <Cocoa/Cocoa.h>
#import "Preferences.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import "AFOAuth2Manager.h"

@interface LoginPref : NSViewController <MASPreferencesViewController> {
    IBOutlet NSImageView * logo;
	//Login Preferences
	IBOutlet NSButton * savebut;
	IBOutlet NSButton * clearbut;
    IBOutlet NSTextField * loggedinuser;
    AppDelegate* appdelegate;
    IBOutlet NSView * loginview;
    IBOutlet NSView * loggedinview;
    //Reauthorize Panel
    __unsafe_unretained NSWindow *loginpanel;
    IBOutlet NSTextField * passwordinput;
    IBOutlet NSImageView * invalidinput;
}
@property (assign) IBOutlet NSWindow *loginpanel;
- (id)initwithAppDelegate:(AppDelegate *)adelegate;
-(IBAction)startlogin:(id)sender;
-(IBAction)clearlogin:(id)sender;
-(IBAction)registermal:(id)sender;
-(void)login:(NSString *)username password:(NSString *)password;
-(void)loadlogin;
@end
