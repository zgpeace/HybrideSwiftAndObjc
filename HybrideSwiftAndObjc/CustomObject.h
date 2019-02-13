//
//  CustomObject.h
//  HybrideSwiftAndObjc
//
//  Created by zgpeace on 2019/2/12.
//  Copyright © 2019 zgpeace. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomObject : NSObject

@property (strong, nonatomic) id someProperty;

- (void)someMethod;
- (void)objcCallSwift;

@end

NS_ASSUME_NONNULL_END
