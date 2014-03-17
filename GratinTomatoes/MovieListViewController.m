//
//  MovieListViewController.m
//  GratinTomatoes
//
//  Created by Eric Socolofsky on 3/15/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieDetailViewController.h"
#import "MovieListViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieModel.h"
#import "ZAActivityBar.h"
#import "TSMessage.h"

@interface MovieListViewController ()

@end

@implementation MovieListViewController
{
	NSArray *movieListData;
	NSMutableArray *movieModels;
	int currPage;
	BOOL initialError;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// init ivars
	movieModels = [NSMutableArray array];
	currPage = 1;
//	initialError = YES;
	
	// Set back button on NavigationController
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Movies" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	
	// Pull to refresh
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	refreshControl.tintColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:1];
	[refreshControl addTarget:self action:@selector(reloadMovieList) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = refreshControl;
	
	// Assign MovieListViewCell as the UITableViewCell subclass to use in this table view
	UINib *cellNib = [UINib nibWithNibName:@"MovieListViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"MovieListViewCell"];
	
	// Hide tableView until data loaded.
	self.tableView.hidden = YES;
	
	[self loadMovieListForPage:currPage];
	
}

- (void)loadMovieListForPage:(int)pageNum
{
	
	// Show loading notification
	[ZAActivityBar showWithStatus:@"Loading movies from Rotten Tomatoes..."];
	
	// build API request URL
	NSString *apiKey = @"apikey=s9jt5e3aa4dcfneu7sx2yhug";
	NSString *page = [NSString stringWithFormat:@"page=%d", pageNum];
	NSString *perPage = [NSString stringWithFormat:@"page_limit=%d", 20];
	NSString *query = [[NSArray arrayWithObjects:apiKey, page, perPage, nil] componentsJoinedByString:@"&"];
	NSString *url = [NSString stringWithFormat:@"%@?%@", self.baseUrl, query];
	NSLog(@"requesting:%@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if (connectionError) {
			[TSMessage showNotificationWithTitle:@"Network Error" subtitle:@"Please check your connection. Pull down to reload movies." type:TSMessageNotificationTypeWarningGrey];
			self.tableView.hidden = NO;
			return;
		}
		
		id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		
		// Test error state
		if (initialError) {
			object = [NSArray array];
			initialError = NO;
		}
		
		if ([object isKindOfClass:[NSDictionary class]]) {
			movieListData = ((NSDictionary *)object)[@"movies"];
			
			for (NSDictionary *movieData in movieListData) {
				[movieModels addObject:[self createMovieModelFromData:movieData]];
			}
		} else {
			[ZAActivityBar showErrorWithStatus:@"Something went wrong. Please pull down to reload movies."];
			self.tableView.hidden = NO;
			return;
		}
		
		// Remove loading notification
		[ZAActivityBar showSuccessWithStatus:@"Movies loaded."];
		
		// Reveal tableView and populate.
		[self.tableView reloadData];
		[self.refreshControl endRefreshing];
		self.tableView.hidden = NO;
	}];
}

- (MovieModel *)createMovieModelFromData:(NSDictionary *)movieData
{
	MovieModel *movieModel = [[MovieModel alloc] init];
	
	movieModel.title = movieData[@"title"];
	movieModel.synopsis = movieData[@"synopsis"];
	movieModel.posterThumbUrl = ((NSDictionary *)movieData[@"posters"])[@"detailed"];
	movieModel.posterUrl = ((NSDictionary *)movieData[@"posters"])[@"original"];
	
	NSArray *castListData = movieData[@"abridged_cast"];
	NSMutableArray *castNames = [NSMutableArray array];
	for (NSDictionary *castData in castListData) {
		[castNames addObject:castData[@"name"]];
	}
	movieModel.cast = [castNames componentsJoinedByString:@", "];
	
	return movieModel;
}

- (void) reloadMovieList {
	NSLog(@"reloading...");
	[self loadMovieListForPage:currPage];
	[self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
    MovieListViewCell *cell = (MovieListViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"MovieListViewCell" forIndexPath:indexPath];
	if (!movieListData) { return cell; }
	
	
	// SUNDAY:
	// pass MovieModel to MovieDetailViewController on tap
	// also: load image only once, and store as MovieModel.poster(Thumb)Image (in createMovieModelFromData:movieData)
	// should also pass MovieModel to each MovieListViewCell and let that subview populate itself.
	
	
	MovieModel *movieModel = [movieModels objectAtIndex:[indexPath row]];
	
	cell.titleLabel.text = movieModel.title;
	cell.synopsisLabel.text = movieModel.synopsis;
	cell.castLabel.text = movieModel.cast;
	
	// TODO: move the image loading logic into MovieModel,
	// and set the image only if !cell.posterImage (tho maybe it always is when dequeuing a new cell?)
	// http://stackoverflow.com/questions/17730138/uiimageviewafnetworking-setimagewithurl-with-animation
	[cell.posterImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:movieModel.posterThumbUrl]]
			  placeholderImage:nil//[UIImage imageNamed:@"placeholder-avatar"]
					   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
						   cell.posterImage.alpha = 0.0;
						   cell.posterImage.image = image;
						   [UIView animateWithDuration:0.35
											animations:^{
												cell.posterImage.alpha = 1.0;
											}];
					   }
					   failure:NULL];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MovieDetailViewController *movieDetailViewController = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil movieModel:[movieModels objectAtIndex:[indexPath row]]];

	// Push the view controller.
	[self.navigationController pushViewController:movieDetailViewController animated:YES];
}

@end
