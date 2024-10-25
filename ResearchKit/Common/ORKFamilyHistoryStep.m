/*
 Copyright (c) 2023, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ORKFamilyHistoryStep.h"

#import "ORKAnswerFormat_Internal.h"
#import "ORKCollectionResult.h"
#import "ORKConditionStepConfiguration.h"
#import "ORKFormStep.h"
#import "ORKHelpers_Internal.h"
#import "ORKRelativeGroup.h"


@implementation ORKFamilyHistoryStep

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super initWithIdentifier:identifier];
    
    return self;
}

- (void)validateParameters {
    [super validateParameters];
    
    // validate that atleast one condition has been provided
    if (self.conditionStepConfiguration.conditions.count == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                               reason:@"At least one ORKHealthCondition must be added to the ORKConditionStepConfiguration object"
                                             userInfo:nil];
    }
    
    // validate that atleast one relative group has been provided
    if (self.relativeGroups.count == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"At least one ORKRelativeGroup must be provided"
                                     userInfo:nil];
    }
    
    // validate that the identifiers for each relative group is unique
    NSMutableSet *identifiers = [NSMutableSet new];
    for (ORKRelativeGroup *relativeGroup in self.relativeGroups) {
        if ([identifiers containsObject:relativeGroup.identifier]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"Each ORKRelativeGroup must have a unique identifier"
                                         userInfo:nil];
        } else {
            [identifiers addObject:relativeGroup.identifier];
        }
    }
    
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    ORK_ENCODE_OBJ(aCoder, conditionStepConfiguration);
    ORK_ENCODE_OBJ(aCoder, relativeGroups);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        ORK_DECODE_OBJ_CLASS(aDecoder, conditionStepConfiguration, ORKConditionStepConfiguration);
        ORK_DECODE_OBJ_ARRAY(aDecoder, relativeGroups, ORKRelativeGroup);
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ORKFamilyHistoryStep *step = [super copyWithZone:zone];
    step->_conditionStepConfiguration = [_conditionStepConfiguration copy];
    step->_relativeGroups = [_relativeGroups copy];
    
    return step;
}

- (BOOL)isEqual:(id)object {
    BOOL isParentSame = [super isEqual:object];
    
    __typeof(self) castObject = object;
    return (isParentSame && ORKEqualObjects(_conditionStepConfiguration, castObject->_conditionStepConfiguration)
            && ORKEqualObjects(_relativeGroups, castObject->_relativeGroups));
}

@end
