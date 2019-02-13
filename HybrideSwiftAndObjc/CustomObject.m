//
//  CustomObject.m
//  HybrideSwiftAndObjc
//
//  Created by zgpeace on 2019/2/12.
//  Copyright © 2019 zgpeace. All rights reserved.
//

#import "CustomObject.h"
#import "HybrideSwiftAndObjc-Swift.h"

@implementation CustomObject

- (void)someMethod {
    NSLog(@"SomeMethod Run");
}

- (void)objcCallSwift {
    MySwiftObject *myOb = [MySwiftObject new];
    NSLog(@"MyOb.someProperty: %@", myOb.someProperty);
    myOb.someProperty = @"Hello World";
    NSLog(@"MyOb.someProperty: %@", myOb.someProperty);
    
    // xcode10 expands the external arg here
    NSString * retString = [myOb someFunctionWithSomeArg:@"Arg"];
    
    NSLog(@"RetString: %@", retString);
}

@end
