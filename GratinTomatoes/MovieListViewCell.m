//
//  MovieListViewCell.m
//  GratinTomatoes
//
//  Created by Eric Socolofsky on 3/15/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "MovieListViewCell.h"


@implementation MovieListViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.titleLabel.font = [UIFont fontWithName:@"Aller-Bold" size:20];
	self.synopsisLabel.font = [UIFont fontWithName:@"Aller-Light" size:13];
	self.castLabel.font = [UIFont fontWithName:@"Aller-LightItalic" size:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) testMethod
{
	NSLog(@"testing");
}

@end
