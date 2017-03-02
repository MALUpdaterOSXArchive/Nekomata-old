//
//  LoginPref.m
//  Nekomata
//
//  Created by Nanoha Takamachi on 2014/10/18.
//  Copyright 2014 Atelier Shiori. All rights reserved.
//

#import "LoginPref.h"
#import "ClientConstants.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "MainWindow.h"


@implementation LoginPref
@synthesize loginpanel;

- (id)init
{
	return [super initWithNibName:@"LoginView" bundle:nil];
}
- (id)initwithAppDelegate:(AppDelegate *)adelegate{
    appdelegate = adelegate;
    return [super initWithNibName:@"LoginView" bundle:nil];
}
- (void)awakeFromNib
{
    // Set Logo
    [logo setImage:[NSApp applicationIconImage]];
    // Load Login State
    [self loadlogin];
}
-(void)loadView{
    [super loadView];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"LoginPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameUser];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Login", @"Toolbar item name for the Login preference pane");
}
#pragma mark Login Preferences Functions
-(void)loadlogin
{
    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"Nekomata"];
	// Load Username
	if (credential.accessToken) {
		[clearbut setEnabled: YES];
		[savebut setEnabled: NO];
        [loggedinview setHidden:NO];
        [loginview setHidden:YES];
        [self loaduserdetails];
	}
	else {
		//Disable Clearbut
		[clearbut setEnabled: NO];
		[savebut setEnabled: YES];
	}
}
-(IBAction)startlogin:(id)sender
{
    // Open Authorization Page to allow user to get the pin needed to finish the process
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://anilist.co/api/auth/authorize?grant_type=authorization_pin&client_id=%@&response_type=pin",kclient]]];
    [NSApp beginSheet:self.loginpanel
       modalForWindow:[[self view] window] modalDelegate:self
       didEndSelector:@selector(AuthPanelDidEnd:returnCode:contextInfo:)
          contextInfo:(void *)nil];

    
}
-(void)login:(NSString *)pin{
    NSURL *baseURL = [NSURL URLWithString:@"https://anilist.co/api/"];
    AFOAuth2Manager *OAuth2Manager =
    [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
                                    clientID:kclient
                                      secret:ksecretkey];
    [OAuth2Manager authenticateUsingOAuthWithURLString:@"auth/access_token" parameters:@{@"grant_type":@"authorization_pin", @"code":pin} success:^(AFOAuthCredential *credential) {
        NSLog(@"Token: %@", credential.accessToken);
        [Utility showsheetmessage:@"Login Successful" explaination: @"Login is successful." window:[[self view] window]];
        [AFOAuthCredential storeCredential:credential
                            withIdentifier:@"Nekomata"];
        [clearbut setEnabled: YES];
        [loggedinview setHidden:NO];
        [loginview setHidden:YES];
        [self refreshmainview];
        [self retrieveuserdetails];
    }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error: %@", error);
                                                   [Utility showsheetmessage:@"Nekomata was unable to log you in since the pin is invalid." explaination:@"Make sure you copied the pin correctly." window:[[self view] window]];
                                               }];
}
-(IBAction)registermal:(id)sender
{
	//Show AniList Registration Page
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://anilist.co/register"]];
}
-(IBAction) showgettingstartedpage:(id)sender
{
    //Show Getting Started help page
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/chikorita157/malupdaterosx-cocoa/wiki/Getting-Started"]];
}
-(IBAction)clearlogin:(id)sender
{
        // Set Up Prompt Message Window
        NSAlert * alert = [[NSAlert alloc] init] ;
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
        [alert setMessageText:@"Do you want to log out?"];
        [alert setInformativeText:@"Once you log out, you need to log back in before you can use this application."];
        // Set Message type to Warning
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert beginSheetModalForWindow:[[self view] window] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode== NSAlertFirstButtonReturn) {
            //Remove account from keychain
            [AFOAuthCredential deleteCredentialWithIdentifier:@"Nekomata"];
            //Disable Clearbut
            [clearbut setEnabled: NO];
            [savebut setEnabled: YES];
            [loggedinuser setStringValue:@""];
            [loggedinview setHidden:YES];
            [loginview setHidden:NO];
            // Refresh Mainview and remove userinfo
            [self refreshmainview];
            [Utility deleteFile:@"userinfo.json" appendpath:@""];
        }
        }];
}
/*
Pin Panel
 */
- (void)AuthPanelDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == 1) {
        [self login:[passwordinput stringValue]];
    }
    //Reset and Close
    [passwordinput setStringValue:@""];
    [invalidinput setHidden:YES];
    [self.loginpanel close];
}

-(IBAction)cancelreauthorization:(id)sender{
    [self.loginpanel orderOut:self];
    [NSApp endSheet:self.loginpanel returnCode:0];
    
}
-(IBAction)performreauthorization:(id)sender{
    if ([[passwordinput stringValue] length] == 0) {
        // No password, indicate it
        NSBeep();
        [invalidinput setHidden:NO];
    }
    else{
        [invalidinput setHidden:YES];
        [self.loginpanel orderOut:self];
        [NSApp endSheet:self.loginpanel returnCode:1];
    }
}

// Other
-(void)refreshmainview{
    MainWindow * mainwindowcontroller = [appdelegate getMainWindowController];
    [mainwindowcontroller loadmainview];
}
-(void)loaduserdetails{
    id details = [Utility loadJSON:@"userinfo.json" appendpath:@""];
    if (details){
        NSDate * retrievaldate = [[NSUserDefaults standardUserDefaults] valueForKey:@"userinforetrievaldate"];
        if ([retrievaldate timeIntervalSinceNow] < 0){
            // Refresh user info
            [self retrieveuserdetails];
        }
        else{
            // Load existing info
            [self prepareuserdetails:details];
        }
    }
    else{
        [self retrieveuserdetails];
    }
}
-(void)prepareuserdetails:(id)object{
    NSDictionary * d = object;
    if (d[@"display_name"] != [NSNull null]){
        loggedinuser.stringValue = d[@"display_name"];
    }
}
-(void)retrieveuserdetails{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://anilist.co/api/user" parameters:@{@"access_token":[Utility getToken]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [self prepareuserdetails:[Utility saveJSON:responseObject withFilename:@"userinfo.json" appendpath:@"" replace:true]];
        [self loaduserdetails];
        // Set retrevial date so the user info refreshes periodically
        NSDate *now = [NSDate date];
        NSDate * refresh = [now dateByAddingTimeInterval:60*60*12];
        [[NSUserDefaults standardUserDefaults] setObject:refresh forKey:@"userinforetrievaldate"];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error retrieving user information: %@", error);
    }];
}
@end
