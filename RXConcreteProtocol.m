// RXConcreteProtocol.m
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import "RXConcreteProtocol.h"
#import <objc/runtime.h>

@implementation RXConcreteProtocol

+(NSArray *)implementedProtocolNames {
	unsigned int protocolCount = 0;
	Protocol **protocols = class_copyProtocolList([self class], &protocolCount);
	NSMutableArray *implementedProtocolNames = [NSMutableArray array];
	
	for(unsigned int i = 0; i < protocolCount; i++) {
		Protocol *protocol = protocols[i];
		[implementedProtocolNames addObject: NSStringFromProtocol(protocol)];
	}
	
	free(protocols);
	
	return implementedProtocolNames;
}


+(void)extendClass:(Class)targetClass {
	for(NSString *protocolName in [self implementedProtocolNames]) {
		Protocol *protocol = NSProtocolFromString(protocolName);
		
		struct RXConcreteProtocolMethodList {
			unsigned int count;
			struct objc_method_description *methods;
			BOOL required;
			BOOL instance;
		} methodLists[4] = {
			{0, NULL, NO, NO},
			{0, NULL, YES, NO},
			{0, NULL, NO, YES},
			{0, NULL, YES, YES}
		};
		
		for(uint8_t i = 0; i < 4; i++) {
			struct RXConcreteProtocolMethodList methodList = methodLists[i];
			methodList.methods = protocol_copyMethodDescriptionList(protocol, methodList.required, methodList.instance, &methodList.count);
			for(unsigned int j = 0; j < methodList.count; j++) {
				struct objc_method_description methodDescription = methodList.methods[j];
				Method method = methodList.instance? class_getInstanceMethod(self, methodDescription.name) : class_getClassMethod(self, methodDescription.name);
				class_addMethod(methodList.instance? targetClass : object_getClass(targetClass), methodDescription.name, method_getImplementation(method), methodDescription.types); // this skips methods that already exist on the receiver
			}
			free(methodList.methods);
		}
		
		class_addProtocol(targetClass, protocol);
	}
}

@end