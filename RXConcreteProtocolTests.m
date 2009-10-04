// RXConcreteProtocolTests.m
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "RXAssertions.h"
#import "RXConcreteProtocol.h"
#import "RXTestConcreteProtocol.h"
#import <objc/runtime.h>

@interface RXConcreteProtocolTests : SenTestCase {
	Class testClass;
	id testClassInstance;
}
@end

@implementation RXConcreteProtocolTests

-(void)setUp {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString *testClassName = (NSString *)CFUUIDCreateString(NULL, uuid);
	testClass = objc_allocateClassPair([NSObject class], [testClassName UTF8String], 0);
	CFRelease(uuid);
	[testClassName release];
	objc_registerClassPair(testClass);
	
	testClassInstance = [[testClass alloc] init];
}

-(void)tearDown {
	[testClassInstance release];
	testClassInstance = nil;
	
	objc_disposeClassPair(testClass);
	testClass = Nil;
}


-(void)testDeclaresTheProtocolsThatItImplements {
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames].count, 2);
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames], ([NSArray arrayWithObjects: @"RXTestProtocol", @"RXTestProtocol2", nil]));
}

-(void)testExtendsClassesWithTheMethodsInItsProtocols {
	RXAssertFalse([testClass instancesRespondToSelector: @selector(isFoo)]);
	RXAssertFalse([testClass instancesRespondToSelector: @selector(bar)]);
	
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass instancesRespondToSelector: @selector(isFoo)]);
	RXAssert([testClass instancesRespondToSelector: @selector(bar)]);
	
	RXAssertNotNil(testClassInstance);
	RXAssertFalse([testClassInstance isFoo]);
	RXAssertEquals([testClassInstance bar], 0);
}

int RXConcreteProtocolTestsImplementationFixture(id self, SEL _cmd) {
	return 1;
}

-(void)testExtendingAClassDoesNotOverwriteExistingMethods {
	Method bar = class_getInstanceMethod([RXTestConcreteProtocol class], @selector(bar));
	RXAssert(class_addMethod(testClass, @selector(bar), (IMP)RXConcreteProtocolTestsImplementationFixture, method_getTypeEncoding(bar))); // add the “bar” method
	RXAssert([testClass instancesRespondToSelector: @selector(bar)]);
	
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssertEquals([testClassInstance bar], 1);
}

// overrides methods implemented in a superclass of the extended class

// supports class methods

// copies properties

// doesn’t worry about missing optional methods

// makes the target class conform to the protocols

// doesn’t import recursive protocols, e.g. conforming to a protocol that conforms to NSObject doesn’t try to copy -description, -isEqual:, etc. in.

@end