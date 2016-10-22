//
//  MovieCell.h
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/22/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgMovie;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;

@property (nonatomic,strong) NSString* movieID;
@property (nonatomic,strong) NSString* poster;

@end
