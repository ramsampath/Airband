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
	// Add the tab bar controller's current view as a subview of the window
	// [window addSubview:tabBarController.view];

	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		
	ArtistViewController *artistVC = [[ArtistViewController alloc] initWithNibName:@"ArtistsView" bundle:nil];
	AllSettingsController *settingsVC = [AllSettingsController	alloc];
	NowPlayingController *nowplayingVC = [[NowPlayingController alloc] initWithNibName:@"NowPlaying" bundle:nil];
	PlaylistController *playlistVC = [[PlaylistController alloc] initWithNibName:@"PlayList" bundle:nil];
	CloudController *cloudVC = [[CloudController alloc] initWithNibName:@"CloudView" bundle:nil];
	
	
	artistVC.title = @"Artists";
	artistVC.tabBarItem.image = [UIImage imageNamed:@"spiky.png"];	
	//
	settingsVC.title = @"Settings";
	settingsVC.tabBarItem.image = [UIImage imageNamed:@"gears.png"];
	//
	nowplayingVC.title = @"Audio stream";
	nowplayingVC.tabBarItem.image = [UIImage imageNamed:@"headphones.png"];
	//
	playlistVC.title = @"Playlists";
	playlistVC.tabBarItem.image = [UIImage imageNamed:@"playlist.png"];
	//
	cloudVC.title = @"Airbands";
	cloudVC.tabBarItem.image = [UIImage imageNamed:@"cloud.png"];
	
	
	UINavigationController *artistsNC = [[UINavigationController alloc] initWithRootViewController:artistVC];
	UINavigationController *settingsNC= [[UINavigationController alloc] initWithRootViewController:settingsVC];		
	UINavigationController *playlistNC= [[UINavigationController alloc] initWithRootViewController:playlistVC];		
	tabBarController = [[UITabBarController alloc] init];	
	tabBarController.viewControllers = [NSArray arrayWithObjects:artistsNC, playlistNC, cloudVC, nowplayingVC, settingsNC, nil];	
	
	artistsNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	artistsNC.navigationBarHidden = NO;
	settingsNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	settingsNC.navigationBarHidden = NO;
	playlistNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	[nowplayingVC release];
	[artistVC release];
	[playlistVC release];
	[cloudVC release];
	[settingsVC release];
	
	[window addSubview:tabBarController.view];
	//[window addSubview:navigationController.view];
	[window makeKeyAndVisible];

	// log in ...
	AppData *app = [AppData get];
	if( ![app login] )
	  {
		// go to settings screen.
		  tabBarController.selectedIndex = 3;
	  }
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

