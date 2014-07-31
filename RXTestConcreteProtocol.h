
// RXTestConcreteProtocol.h  Created by Rob Rix on 2009-10-03 Copyright 2009 Monochrome Industries

#import "RXConcreteProtocol.h"

@protocol RXTestProtocol

+ (BOOL) classDoes;
- (BOOL) instanceDoes;

@property (copy,readonly) NSString *foo;

@end


@protocol RXRecursiveTestProtocol

- (void) zilch;

@end


@protocol RXTestProtocol2 <RXRecursiveTestProtocol>

- (int) oneHundred;

@optional

-(void) fishsticks;

@end


@interface RXTestConcreteProtocol : RXConcreteProtocol <RXTestProtocol, RXTestProtocol2>

@end