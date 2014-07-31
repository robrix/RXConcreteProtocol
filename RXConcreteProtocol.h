
// RXConcreteProtocol.h Created by Rob Rix on 2009-10-03 Copyright 2009 Monochrome Industries

@import Foundation;

@interface RXConcreteProtocol : NSObject

/*!   An array of the names of the protocols implemented by the concrete protocol subclass.
      @note By default, this is all the protocols that the concrete protocol subclass implements,
            but subclasses can override it if they need to change that behaviour. */

+ (NSSet*) implementedProtocolNames;

+   (void) extendClass:(Class)klass;

@end