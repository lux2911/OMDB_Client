//
//  Movie.h
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/21/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic,strong) NSString* Title;
@property (nonatomic,strong) NSString* Year;
@property (nonatomic,strong) NSString* imdbID;
@property (nonatomic,strong) NSString* Poster;

@end
