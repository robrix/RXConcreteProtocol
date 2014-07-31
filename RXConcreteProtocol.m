
// RXConcreteProtocol.m  Created by Rob Rix on 2009-10-03  Copyright 2009 Monochrome Industries

#import "RXConcreteProtocol.h"
#import <objc/runtime.h>

NSSet *    RXConcreteProtocolsNamesOfProtocols ( Protocol **, unsigned int );
void RXConcreteProtocolExtendClassWithProtocol ( Class, Class,   Protocol* );

@implementation RXConcreteProtocol

NSSet *RXConcreteProtocolsNamesOfProtocols(Protocol **protocols, unsigned int protocolCount) {

	NSMutableSet *protocolNames = NSMutableSet.set;

	for(unsigned int i = 0; i < protocolCount; i++) { unsigned int nestedProtocolCount = 0;

    Protocol         * protocol = protocols[i];
		Protocol ** nestedProtocols = protocol_copyProtocolList(protocol, &nestedProtocolCount);

    [protocolNames addObject:NSStringFromProtocol(protocol)];
		[protocolNames  unionSet:RXConcreteProtocolsNamesOfProtocols(nestedProtocols, nestedProtocolCount)];
		free(nestedProtocols);
	}
	return protocolNames;
}

+ (NSSet*) implementedProtocolNames {	unsigned int protocolCount = 0;

	Protocol **protocols = class_copyProtocolList([self class], &protocolCount);
	NSSet *protocolNames = RXConcreteProtocolsNamesOfProtocols(protocols, protocolCount);

  return free(protocols), protocolNames;
}

void RXConcreteProtocolExtendClassWithProtocol(Class self, Class targetClass, Protocol *protocol) {

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
		methodList.methods                             = protocol_copyMethodDescriptionList(protocol, methodList.required,
                                                                                                  methodList.instance,
                                                                                                 &methodList.count);
		for(unsigned int j = 0; j < methodList.count; j++) {

			struct objc_method_description methodDesc = methodList.methods[j];
			Method method = methodList.instance ? class_getInstanceMethod(self, methodDesc.name)
                                          :    class_getClassMethod(self, methodDesc.name);
			class_addMethod(methodList.instance ? targetClass
                                          : object_getClass(targetClass), methodDesc.name,
                                   method_getImplementation(method),      methodDesc.types); // this skips methods that already exist on the target class
		}
		free(methodList.methods);
	}
	class_addProtocol(targetClass, protocol);
}

+ (void) extendClass:(Class)targetClass {

	for(NSString *protocolName in self.implementedProtocolNames)
		RXConcreteProtocolExtendClassWithProtocol(self, targetClass, NSProtocolFromString(protocolName));
}

@end