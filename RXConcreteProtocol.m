// RXConcreteProtocol.m
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import "RXConcreteProtocol.h"
#import <objc/runtime.h>

@implementation RXConcreteProtocol

/*
OBJC_EXPORT BOOL protocol_conformsToProtocol(Protocol *proto, Protocol *other)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT BOOL protocol_isEqual(Protocol *proto, Protocol *other)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT const char *protocol_getName(Protocol *p)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT struct objc_method_description protocol_getMethodDescription(Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT struct objc_method_description *protocol_copyMethodDescriptionList(Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT objc_property_t protocol_getProperty(Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT objc_property_t *protocol_copyPropertyList(Protocol *proto, unsigned int *outCount)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT Protocol **protocol_copyProtocolList(Protocol *proto, unsigned int *outCount)
     AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;

*/

+(NSArray *)implementedProtocolNames {
	unsigned int protocolCount = 0;
	Protocol **protocols = class_copyProtocolList([self class], &protocolCount);
	NSMutableArray *implementedProtocolNames = [NSMutableArray array];
	
	for(unsigned int i = 0; i < protocolCount; i++) {
		Protocol *protocol = protocols[i];
		[implementedProtocolNames addObject: NSStringFromProtocol(protocol)];
	}
	
	return implementedProtocolNames;
}

@end