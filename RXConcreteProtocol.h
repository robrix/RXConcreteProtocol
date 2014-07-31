
// RXConcreteProtocol.h Created by Rob Rix on 2009-10-03 Copyright 2009 Monochrome Industries

@import Foundation;

@interface RXConcreteProtocol : NSObject

/// @return set with the names of the protocols implemented by this "concrete protocol" subclass.
/// @note By default, this is recursive, return ALL the protocols that the concrete protocol subclass implements, or claims conformance to. However, subclasses can override this method if they need to change the behaviour.
+ (NSSet*) implementedProtocolNames;

+   (void) extendClass:(Class)klass;

@end