// RXConcreteProtocolTests.m
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "RXAssertions.h"
#import "RXConcreteProtocol.h"
#import "RXTestConcreteProtocol.h"

@interface RXConcreteProtocolTests : SenTestCase
@end

@implementation RXConcreteProtocolTests

-(void)testDeclaresTheProtocolsThatItImplements {
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames].count, 1);
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames], [NSArray arrayWithObject: @"RXTestProtocol"]);
}

// -(void)testAddsItsMethodsToClassesAtRuntime {
// 	// - check that the class doesn’t have the methods first
// 	// - ask the concrete protocol to add the methods to the class
// 	// - check that the methods exist on the class afterwards
// }

// doesn’t overwrite existing methods (unless asked to?)

// doesn’t import recursive protocols, e.g. conforming to a protocol that conforms to NSObject doesn’t try to copy -description, -isEqual:, etc. in.

@end