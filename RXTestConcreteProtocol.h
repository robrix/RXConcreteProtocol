// RXTestConcreteProtocol.h
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import "RXConcreteProtocol.h"

@protocol RXTestProtocol
-(BOOL)isFoo;
@end

@interface RXTestConcreteProtocol : RXConcreteProtocol <RXTestProtocol>
@end