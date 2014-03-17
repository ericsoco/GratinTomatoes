//
//  MovieModel.h
//  GratinTomatoes
//
//  Created by Eric Socolofsky on 3/16/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *cast;
@property (strong, nonatomic) NSString *posterThumbUrl;
@property (strong, nonatomic) UIImage *posterThumbImage;
@property (strong, nonatomic) NSString *posterUrl;
@property (strong, nonatomic) UIImage *posterImage;

@end
