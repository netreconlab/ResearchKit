/*
 Copyright (c) 2015, Apple Inc. All rights reserved.
 
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


#import "ORKPicker.h"

#import "ORKAgePicker.h"
#import "ORKDateTimePicker.h"
#import "ORKHeightPicker.h"
#import "ORKWeightPicker.h"
#import "ORKTimeIntervalPicker.h"
#import "ORKValuePicker.h"
#import "ORKMultipleValuePicker.h"

#import "ORKAnswerFormat.h"

@implementation ORKPicker : NSObject

/**
 Creates a picker appropriate to the type required by answerformat
 
 @param answerFormat   An ORKAnswerFormat object which specified the format of the result
 @param answer         A default answer (to set as the picker's current result), or nil if no answer specified.
 @param delegate       A delegate who conforms to ORKPickerDelegate
 
 @return The picker object
 */
+ (id<ORKPicker>)pickerWithAnswerFormat:(ORKAnswerFormat *)answerFormat answer:(id)answer delegate:(id<ORKPickerDelegate>) delegate {
    id<ORKPicker> picker = nil;
    
    if ([answer isKindOfClass:[ORKDontKnowAnswer class]]) {
        answer = nil;
    }
    
    if ([answerFormat isKindOfClass:[ORKValuePickerAnswerFormat class]]) {
        picker = [[ORKValuePicker alloc] initWithAnswerFormat:answerFormat answer:answer pickerDelegate:delegate];
    } else if ([answerFormat isKindOfClass:[ORKTimeIntervalAnswerFormat class]]) {
        picker = [[ORKTimeIntervalPicker alloc] initWithAnswerFormat:answerFormat answer:answer pickerDelegate:delegate];
    } else if ([answerFormat isKindOfClass:[ORKDateAnswerFormat class]] || [answerFormat isKindOfClass:[ORKTimeOfDayAnswerFormat class]]) {
        picker = [[ORKDateTimePicker alloc] initWithAnswerFormat:answerFormat answer:answer pickerDelegate:delegate];
    } else if ([answerFormat isKindOfClass:[ORKHeightAnswerFormat class]]) {
        picker = [[ORKHeightPicker alloc] initWithAnswerFormat:answerFormat answer:answer pickerDelegate:delegate];
    } else if ([answerFormat isKindOfClass:[ORKWeightAnswerFormat class]]) {
        picker = [[ORKWeightPicker alloc] initWithAnswerFormat:answerFormat answer:answer pickerDelegate:delegate];
    } else if ([answerFormat isKindOfClass:[ORKMultipleValuePickerAnswerFormat class]]) {
        picker = [[ORKMultipleValuePicker alloc] initWithAnswerFormat:answerFormat answer:answer pickerDelegate:delegate];
    } else if ([answerFormat isKindOfClass:[ORKAgeAnswerFormat class]]) {
        picker = [[ORKAgePicker alloc] initWithAnswerFormat:answerFormat answer:answer pickerDelegate:delegate];
    }
    
    NSAssert(picker, @"Cannot create picker for answer format %@", answerFormat);
    
    return picker;
}

@end
