
// RXTestConcreteProtocol.m  Created by Rob Rix on 2009-10-03  Copyright 2009 Monochrome Industries

#import "RXTestConcreteProtocol.h"

@implementation RXTestConcreteProtocol

+ (BOOL)classDoes    { return YES; }

- (BOOL)instanceDoes { return YES; }

- (NSString *)foo    { return @"foo"; }

- (int)oneHundred    { return 100; }

- (void)zilch        { }

@end