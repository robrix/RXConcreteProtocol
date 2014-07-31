// RXConcreteProtocolTests.m
// Created by Rob Rix on 2009-1000-03
// Copyright 2009 Monochrome Industries

@import AppKit;
@import ObjectiveC;

#import <XCTest/XCTest.h>
#import "RXAssertions.h"
#import "RXConcreteProtocol.h"
#import "RXTestConcreteProtocol.h"

@interface RXConcreteProtocolTests : XCTestCase { Class testClass; id testClassInstance; } @end

@implementation RXConcreteProtocolTests

-(void)testDeclaresTheProtocolsThatItImplements {
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames].count, 3);
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames], ([NSSet setWithObjects: @"RXTestProtocol", @"RXTestProtocol2", @"RXRecursiveTestProtocol", nil]));
}

-(void)testExtendsClassesWithMethodsFromProtocols {
	RXAssertFalse([testClass         respondsToSelector: @selector(instanceDoes) ]);
	RXAssertFalse([testClass instancesRespondToSelector: @selector(classDoes)    ]);
	RXAssertFalse([testClass instancesRespondToSelector: @selector(oneHundred)   ]);
	
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass         respondsToSelector: @selector(classDoes) ]);
	RXAssert([testClass instancesRespondToSelector: @selector(instanceDoes)  ]);
	RXAssert([testClass instancesRespondToSelector: @selector(foo)    ]);
	RXAssert([testClass instancesRespondToSelector: @selector(oneHundred)    ]);
	
	RXAssertNotNil(testClassInstance);
	RXAssert([testClass classDoes]);
	RXAssert([testClassInstance instanceDoes]);
	RXAssertEquals([testClassInstance foo], @"foo");
	RXAssertEquals([testClassInstance oneHundred], 100);
}

int RXConcreteProtocolTestsImplementationFixture(id self, SEL _cmd) {
	return 100;
}

-(void)testExtendingAClassDoesNotOverwriteExistingMethods {

	Method oneHundred = class_getInstanceMethod([RXTestConcreteProtocol class], @selector(oneHundred));

	RXAssert(class_addMethod(testClass, @selector(oneHundred),
          (IMP)RXConcreteProtocolTestsImplementationFixture, method_getTypeEncoding(oneHundred))); // add the “oneHundred” method
	RXAssert([testClass instancesRespondToSelector: @selector(oneHundred)]);
	
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssertEquals([testClassInstance oneHundred], 100);
}

-(void)testExtendedClassesAreConformedToItsProtocols {

	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass conformsToProtocol: @protocol(RXTestProtocol)]);
	RXAssert([testClass conformsToProtocol: @protocol(RXTestProtocol2)]);
}

-(void)testExtendingAClassAddsProtocolsRecursively {
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass instancesRespondToSelector: @selector(zilch)]);
	RXAssert([testClass conformsToProtocol: @protocol(RXRecursiveTestProtocol)]);
}

-(void)testExtendingAClassOverridesMethodsDefinedOnItsSuperclass {
	Class testSubclass = objc_allocateClassPair(testClass, "Subclass of testClass", 0);
	objc_registerClassPair(testSubclass);
	
	Method oneHundred = class_getInstanceMethod([RXTestConcreteProtocol class], @selector(oneHundred));
	RXAssert(class_addMethod(testClass, @selector(oneHundred), (IMP)RXConcreteProtocolTestsImplementationFixture, method_getTypeEncoding(oneHundred))); // add the “oneHundred” method
	RXAssert([testClass instancesRespondToSelector: @selector(oneHundred)]);
	
	[RXTestConcreteProtocol extendClass: testSubclass];
	
	RXAssert([testSubclass instancesRespondToSelector: @selector(oneHundred)]);
	
	id testSubclassInstance = [[testSubclass alloc] init];
	
	RXAssertEquals([testSubclassInstance oneHundred], 100);
	
//	[testSubclassInstance release];
	testSubclassInstance = nil;
	
#ifdef OBJC_NO_GC
	objc_disposeClassPair(testSubclass);
#endif
	testSubclass = Nil;
}

-(void)testStaticallyTypedVariablesWithConformanceDeclarationsDoNotCauseCompilerWarnings {
	// for purposes of easier verification, treat warnings as errors when compiling this
	[RXTestConcreteProtocol extendClass: testClass];
	NSObject<RXTestProtocol> *staticallyTypedInstance = [[testClass alloc] init]; // the class is given as NSObject because the compiler doesn’t know about testClass
	RXAssertEquals(staticallyTypedInstance.foo, @"foo");
//	[staticallyTypedInstance release];
}

-(void)setUp {

	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString *testClassName = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
	testClass = objc_allocateClassPair([NSObject class], [testClassName UTF8String], 0);
	CFRelease(uuid);
	objc_registerClassPair(testClass);
	testClassInstance = testClass.new;
}

-(void)tearDown { testClassInstance = nil; testClass = Nil; }

@end
