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
	
#ifdef OBJC_NO_GC
	objc_disposeClassPair(testClass);
#endif
	testClass = Nil;
}


-(void)testDeclaresTheProtocolsThatItImplements {
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames].count, 3);
	RXAssertEquals([RXTestConcreteProtocol implementedProtocolNames], ([NSSet setWithObjects: @"RXTestProtocol", @"RXTestProtocol2", @"RXRecursiveTestProtocol", nil]));
}

-(void)testExtendsClassesWithMethodsFromProtocols {
	RXAssertFalse([testClass respondsToSelector: @selector(canFoo)]);
	RXAssertFalse([testClass instancesRespondToSelector: @selector(isFoo)]);
	RXAssertFalse([testClass instancesRespondToSelector: @selector(bar)]);
	
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass respondsToSelector: @selector(canFoo)]);
	RXAssert([testClass instancesRespondToSelector: @selector(isFoo)]);
	RXAssert([testClass instancesRespondToSelector: @selector(foo)]);
	RXAssert([testClass instancesRespondToSelector: @selector(bar)]);
	
	RXAssertNotNil(testClassInstance);
	RXAssert([testClass canFoo]);
	RXAssertFalse([testClassInstance isFoo]);
	RXAssertEquals([testClassInstance foo], @"foo");
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

-(void)testExtendedClassesAreConformedToItsProtocols {
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass conformsToProtocol: @protocol(RXTestProtocol)]);
	RXAssert([testClass conformsToProtocol: @protocol(RXTestProtocol2)]);
}

-(void)testExtendingAClassAddsProtocolsRecursively {
	[RXTestConcreteProtocol extendClass: testClass];
	
	RXAssert([testClass instancesRespondToSelector: @selector(quux)]);
	RXAssert([testClass conformsToProtocol: @protocol(RXRecursiveTestProtocol)]);
}

-(void)testExtendingAClassOverridesMethodsDefinedOnItsSuperclass {
	Class testSubclass = objc_allocateClassPair(testClass, "Subclass of testClass", 0);
	objc_registerClassPair(testSubclass);
	
	Method bar = class_getInstanceMethod([RXTestConcreteProtocol class], @selector(bar));
	RXAssert(class_addMethod(testClass, @selector(bar), (IMP)RXConcreteProtocolTestsImplementationFixture, method_getTypeEncoding(bar))); // add the “bar” method
	RXAssert([testClass instancesRespondToSelector: @selector(bar)]);
	
	[RXTestConcreteProtocol extendClass: testSubclass];
	
	RXAssert([testSubclass instancesRespondToSelector: @selector(bar)]);
	
	id testSubclassInstance = [[testSubclass alloc] init];
	
	RXAssertEquals([testSubclassInstance bar], 0);
	
	[testSubclassInstance release];
	testSubclassInstance = nil;
	
#ifdef OBJC_NO_GC
	objc_disposeClassPair(testSubclass);
#endif
	testSubclass = Nil;
}

@end