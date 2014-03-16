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

@interface MovieListViewController ()

@end

@implementation MovieListViewController
{
	NSArray *movieListData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Assign MovieListViewCell as the UITableViewCell subclass to use in this table view
	UINib *cellNib = [UINib nibWithNibName:@"MovieListViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"MovieListViewCell"];
	
	// Hide tableView until data loaded.
	self.tableView.hidden = YES;
	
	
	[self loadMovieListForPage:1];
	
}

- (void)loadMovieListForPage:(int)pageNum
{
	// build API request URL
	NSString *baseUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json";
	NSString *apiKey = @"apikey=s9jt5e3aa4dcfneu7sx2yhug";
	NSString *page = [NSString stringWithFormat:@"page=%d", pageNum];
	NSString *perPage = [NSString stringWithFormat:@"page_limit=%d", 20];
	NSString *query = [[NSArray arrayWithObjects:apiKey, page, perPage, nil] componentsJoinedByString:@"&"];
	NSString *url = [NSString stringWithFormat:@"%@?%@", baseUrl, query];
	NSLog(@"requesting:%@", url);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//		NSLog(@"%@", object);
		if ([object isKindOfClass:[NSDictionary class]]) {
			movieListData = ((NSDictionary *)object)[@"movies"];
//			NSLog(@"Received movies: %@", movieListData);
//			NSArray *keys = [movieListData allKeys];
//			NSLog(@"allKeys:%@", keys);
		} else {
			// TODO: handle error
		}
		
		// Reveal tableView and populate.
		[self.tableView reloadData];
		self.tableView.hidden = NO;
	}];
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
	
	// TODO: move this stuff to MovieModel, instantiated and populated in loadMovieForListPage:pageNum
	NSDictionary *movieData = [movieListData objectAtIndex:[indexPath row]];
	
	NSString *title = movieData[@"title"];
	NSString *synopsis = movieData[@"synopsis"];
	NSString *posterUrl = ((NSDictionary *)movieData[@"posters"])[@"detailed"];
	
	NSArray *castListData = movieData[@"abridged_cast"];
	NSMutableArray *castNames = [NSMutableArray array];
	for (NSDictionary *castData in castListData) {
		[castNames addObject:castData[@"name"]];
	}
	NSString *cast = [castNames componentsJoinedByString:@", "];

	cell.titleLabel.text = title;
	cell.synopsisLabel.text = synopsis;
	cell.castLabel.text = cast;
	[cell.posterImage setImageWithURL:[NSURL URLWithString:posterUrl]]; //placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
	
    
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
    // Navigation logic may go here, for example:
    // Create the next view controller.
    MovieDetailViewController *movieDetailViewController = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:movieDetailViewController animated:YES];
}

@end
