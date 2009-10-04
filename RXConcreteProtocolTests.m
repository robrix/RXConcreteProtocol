// RXConcreteProtocolTests.m
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "RXAssertions.h"
#import "RXConcreteProtocol.h"
#import "RXTestConcreteProtocol.h"
#import <objc/runtime.h>

@interface RXConcreteProtocolTests : SenTestCase
@end

@implementation RXConcreteProtocolTests

-(void)testDeclaresTheProtocolsThatItImplements {
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames].count, 2);
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames], ([NSArray arrayWithObjects: @"RXTestProtocol", @"RXTestProtocol2", nil]));
}

-(void)testAddsItsMethodsToClassesAtRuntime {
	Class testClass = objc_allocateClassPair([NSObject class], "RXConcreteProtocolTestsDynamicClass", 0);
	objc_registerClassPair(testClass);
	
	RXAssertFalse([testClass instancesRespondToSelector: @selector(isFoo)]);
	RXAssertFalse([testClass instancesRespondToSelector: @selector(bar)]);
	
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass instancesRespondToSelector: @selector(isFoo)]);
	RXAssert([testClass instancesRespondToSelector: @selector(bar)]);
	
	id instance = [[testClass alloc] init];
	RXAssertNotNil(instance);
	RXAssertFalse([instance isFoo]);
	RXAssertEquals([instance bar], 0);
	
	objc_disposeClassPair(testClass);
}

// doesn’t overwrite existing methods (unless asked to?)

// supports class methods

// copies properties

// doesn’t worry about missing optional methods

// makes the target class conform to the protocols

// doesn’t import recursive protocols, e.g. conforming to a protocol that conforms to NSObject doesn’t try to copy -description, -isEqual:, etc. in.

@end