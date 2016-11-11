//
//  ViewController.h
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/21/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SwizzProtocol <JSExport>

//-(instancetype)initWithOrigMethod:(SEL)origMethod swizzMethod:(SEL)swizzMethod andClass:(Class)aClass;

+(void)test;

//@property (nonatomic) SEL origMethod;
//@property (nonatomic) SEL swizzMethod;
//@property (nonatomic) Class swizzClass;

@end


@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>


//+(void)test;

@end

