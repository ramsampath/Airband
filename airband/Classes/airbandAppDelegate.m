//
//  airbandAppDelegate.m
//  airband
//
//  Created by Scot Shinderman on 8/26/08.
//  Copyright Elliptic 2008. All rights reserved.
//

#import "airbandAppDelegate.h"
#import "ArtistViewController.h"
#import "AllSettingsController.h"
#import "SettingsController.h"
#import "PlaylistController.h"
#import "CloudController.h"
#import "NowPlayingController.h"



@implementation airbandAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize appdata_;

- (id) init
{
  if (self = [super init]) {
	appdata_ = [[[AppData alloc] init] retain];
  }

  return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{	
	[application setStatusBarStyle:UIBarStyleBlackOpaque animated:YES];	

	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
			
	//
	// intro screen
	//
	
	AllSettingsController *splash = [[AllSettingsController alloc] initWithNibName:@"Settings" bundle:nil];
	[window addSubview:splash.view];	
	[window makeKeyAndVisible];
}



-(void) startMainUI
{
	ArtistViewController *artistVC = [[ArtistViewController alloc] init];
	AllSettingsController *settingsVC = [[SettingsController	alloc] init];
    PlaylistController *playlistVC = [[PlaylistController alloc] init];
	CloudController *cloudVC = [[CloudController alloc] initWithNibName:@"CloudView" bundle:nil];
	
	artistVC.title = @"Artists";
	settingsVC.title = @"Settings";
	playlistVC.title = @"Playlists";
	cloudVC.title = @"Airbands";
    artistVC.tabBarItem.image = [UIImage imageNamed:@"icon_artists.png"];	
    settingsVC.tabBarItem.image = [UIImage imageNamed:@"icon_settings.png"];
    playlistVC.tabBarItem.image = [UIImage imageNamed:@"icon_playlists.png"];
    cloudVC.tabBarItem.image = [UIImage imageNamed:@"icon_airbands.png"];
	
	UINavigationController *artistsNC = [[UINavigationController alloc] initWithRootViewController:artistVC];
	UINavigationController *settingsNC= [[UINavigationController alloc] initWithRootViewController:settingsVC];		
	UINavigationController *playlistNC= [[UINavigationController alloc] initWithRootViewController:playlistVC];		
	artistsNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	artistsNC.navigationBarHidden = NO;
	settingsNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	settingsNC.navigationBarHidden = NO;
	playlistNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	tabBarController = [[UITabBarController alloc] init];	
    tabBarController.viewControllers = [NSArray arrayWithObjects:artistsNC, playlistNC, cloudVC,  settingsNC, nil];	
	
	[artistVC release];
	[playlistVC release];
	[cloudVC release];
	[settingsVC release];		
	
	// clean out child views.
	{
		NSArray *subz = [window subviews];
		UIView *s;
		for (s in subz) {
			[s removeFromSuperview];
		}
	}
	
	[window addSubview:tabBarController.view];	
	[window bringSubviewToFront:tabBarController.view];
}


/*
 Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
 Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)applicationWillResignActive:(UIApplication *)application
{
	//[appdata_ stop];
	//[appdata_ saveState];	
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	[appdata_ stop];
	[appdata_ saveState];
}


- (void)dealloc {
  [appdata_ release];
  [tabBarController release];
  [window release];
  [super dealloc];
}

@end

