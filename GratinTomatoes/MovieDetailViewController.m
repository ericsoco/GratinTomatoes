//
//  MovieDetailViewController.m
//  GratinTomatoes
//
//  Created by Eric Socolofsky on 3/15/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieModel.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;

@end

@implementation MovieDetailViewController
{
	MovieModel *movieModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil movieModel:(MovieModel *)model
{
	self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	movieModel = model;
	
	// Set navigation controller title and right button
	self.title = movieModel.title;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed)];
	self.navigationItem.rightBarButtonItem = rightButton;
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
	// AFTER DINNER: have to store MovieModel locally and populate in viewWillAppear, not in initializer.
	// (or maybe in viewDidLoad?)
	// Fill 'er up
	self.synopsisLabel.text = movieModel.synopsis;
	self.castLabel.text = movieModel.cast;
	
	// http://stackoverflow.com/questions/17730138/uiimageviewafnetworking-setimagewithurl-with-animation
	[self.posterImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:movieModel.posterUrl]]
							placeholderImage:nil//[UIImage imageNamed:@"placeholder-avatar"]
									 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
										 self.posterImage.alpha = 0.0;
										 self.posterImage.image = image;
										 [UIView animateWithDuration:0.35
														  animations:^{
															  self.posterImage.alpha = 1.0;
														  }];
									 }
									 failure:NULL];
}

- (void) closePressed {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
