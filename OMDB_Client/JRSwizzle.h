// JRSwizzle.h semver:1.0
//   Copyright (c) 2007-2011 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/MIT
//   https://github.com/rentzsch/jrswizzle

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "ViewController.h"

/*
@protocol SwizzProtocol <JSExport>

//-(instancetype)initWithOrigMethod:(SEL)origMethod swizzMethod:(SEL)swizzMethod andClass:(Class)aClass;

+ (BOOL)jr_swizzleMethod:(SEL*)origSel_ withMethod:(SEL*)altSel_;

@property (nonatomic) SEL origMethod;
@property (nonatomic) SEL swizzMethod;
@property (nonatomic) Class swizzClass;

@end
*/

@interface NSObject (JRSwizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jr_swizzleMethod:(SEL*)origSel_ withMethod:(SEL*)altSel_;

+(void)test;

@end
