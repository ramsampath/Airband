//
//  airbandAppDelegate.m
//  airband
//
//  Created by Scot Shinderman on 8/26/08.
//  Copyright Elliptic 2008. All rights reserved.
//

#import "airbandAppDelegate.h"
#import "ArtistViewController.h"
#import "AlbumlistController.h"
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
    //AllSettingsController *splash = [AllSettingsController alloc];
	[window addSubview:splash.view];	
	[window makeKeyAndVisible];
}



-(void) startMainUI
{
	ArtistViewController  *artistVC   = [[ArtistViewController alloc] init];
	AllSettingsController *settingsVC = [[SettingsController   alloc] init];
    PlaylistController    *playlistVC = [[PlaylistController   alloc] init];
	AlbumlistController   *albumsVC   = [[AlbumlistController  alloc] init];
	
	artistVC.title   = @"Artists";
	settingsVC.title = @"Settings";
	playlistVC.title = @"Playlists";
	albumsVC.title   = @"Albums";
    artistVC.tabBarItem.image   = [UIImage imageNamed:@"icon_artists.png"];	
    settingsVC.tabBarItem.image = [UIImage imageNamed:@"icon_settings.png"];
    playlistVC.tabBarItem.image = [UIImage imageNamed:@"icon_playlists.png"];
    albumsVC.tabBarItem.image   = [UIImage imageNamed:@"icon_albums.png"];
	
	UINavigationController *artistsNC = [[UINavigationController alloc] initWithRootViewController:artistVC];
    UINavigationController *albumsNC  = [[UINavigationController alloc] initWithRootViewController:albumsVC];
	UINavigationController *settingsNC= [[UINavigationController alloc] initWithRootViewController:settingsVC];		
	UINavigationController *playlistNC= [[UINavigationController alloc] initWithRootViewController:playlistVC];
    
	artistsNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	artistsNC.navigationBarHidden = NO;
    albumsNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	albumsNC.navigationBarHidden = NO;
	settingsNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	settingsNC.navigationBarHidden = NO;
	playlistNC.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	
	tabBarController = [[UITabBarController alloc] init];	
    tabBarController.viewControllers = [NSArray arrayWithObjects:artistsNC, albumsNC, playlistNC, settingsNC, nil];	
	
	[artistVC   release];
	[playlistVC release];
	[albumsVC   release];
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

