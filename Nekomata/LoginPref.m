//
//  LoginPref.m
//  Nekomata
//
//  Created by Nanoha Takamachi on 2014/10/18.
//  Copyright 2014 Atelier Shiori. All rights reserved.
//

#import "LoginPref.h"
#import "Base64Category.h"
#import "ClientConstants.h"
#import "AppDelegate.h"

#import "EasyNSURLConnection.h"
#import "Utility.h"


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
-(void)loadView{
    [super loadView];
    // Set Logo
    [logo setImage:[NSApp applicationIconImage]];
    // Load Login State
	[self loadlogin];
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
        //[loggedinuser setStringValue:[MALEngine getusername]];
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
       didEndSelector:@selector(reAuthPanelDidEnd:returnCode:contextInfo:)
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
        //[loggedinuser setStringValue:username];
        [loggedinview setHidden:NO];
        [loginview setHidden:YES];

        
    }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error: %@", error);
                                                   [Utility showsheetmessage:@"Nekomata was unable to log you in since the pin is invalid." explaination:@"Make sure you copied the pin correctly." window:[[self view] window]];
                                               }];
    /*if ([request getStatusCode] == 200 && error == nil) {
        //Login successful
        [Utility showsheetmessage:@"Login Successful" explaination: @"Login is successful." window:[[self view] window]];
		// Store account in login keychain
        //[MALEngine storeaccount:[fieldusername stringValue] password:[fieldpassword stringValue]];
        [clearbut setEnabled: YES];
        [loggedinuser setStringValue:username];
        [loggedinview setHidden:NO];
        [loginview setHidden:YES];
    }
    else{
        if (error.code == NSURLErrorNotConnectedToInternet) {
            [Utility showsheetmessage:@"Nekomata was unable to log you in since you are not connected to the internet" explaination:@"Check your internet connection and try again." window:[[self view] window]];
            [savebut setEnabled: YES];
            [savebut setKeyEquivalent:@"\r"];
        }
        else{
            //Login Failed, show error message
            [Utility showsheetmessage:@"Nekomata was unable to log you in since you don't have the correct username and/or password." explaination:@"Check your username and password and try logging in again. If you recently changed your password, enter your new password and try again." window:[[self view] window]];
            [savebut setEnabled: YES];
            [savebut setKeyEquivalent:@"\r"];
        }    
     }*/

}
-(IBAction)registermal:(id)sender
{
	//Show MAL Registration Page
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
        [alert setInformativeText:@"Once you logged out, you need to log back in before you can use this application."];
        // Set Message type to Warning
        [alert setAlertStyle:NSAlertStyleWarning];
        if ([alert runModal]== NSAlertFirstButtonReturn) {
            //Remove account from keychain
            [AFOAuthCredential retrieveCredentialWithIdentifier:@"Nekomata"];
            //Disable Clearbut
            [clearbut setEnabled: NO];
            [savebut setEnabled: YES];
            [loggedinuser setStringValue:@""];
            [loggedinview setHidden:YES];
            [loginview setHidden:NO];
        }
}
/*
Pin Panel
 */
- (void)reAuthPanelDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
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
@end
