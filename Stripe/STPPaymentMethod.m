//
//  STPPaymentMethod.m
//  Stripe
//
//  Created by Yuki Tokuhiro on 3/5/19.
//  Copyright © 2019 Stripe, Inc. All rights reserved.
//

#import "STPPaymentMethod.h"

#import "NSDictionary+Stripe.h"
#import "STPPaymentMethodBillingDetails.h"
#import "STPPaymentMethodCard.h"

@interface STPPaymentMethod ()

@property (nonatomic, copy, nullable, readwrite) NSString *stripeId;
@property (nonatomic, strong, nullable, readwrite) NSDate *created;
@property (nonatomic, readwrite) BOOL liveMode;
@property (nonatomic, copy, nullable, readwrite) NSString *type;
@property (nonatomic, strong, nullable, readwrite) STPPaymentMethodBillingDetails *billingDetails;
@property (nonatomic, strong, nullable, readwrite) STPPaymentMethodCard *card;
@property (nonatomic, copy, nullable, readwrite) NSString *customerId;
@property (nonatomic, copy, nullable, readwrite) NSDictionary<NSString*, NSString *> *metadata;
@property (nonatomic, copy, nonnull, readwrite) NSDictionary *allResponseFields;

@end


@implementation STPPaymentMethod

- (NSString *)description {
    NSArray *props = @[
                       // Object
                       [NSString stringWithFormat:@"%@: %p", NSStringFromClass([self class]), self],
                       
                       // Identifier
                       [NSString stringWithFormat:@"stripeId = %@", self.stripeId],
                       
                       // STPPaymentMethod details (alphabetical)
                       [NSString stringWithFormat:@"billingDetails = %@", self.billingDetails],
                       [NSString stringWithFormat:@"card = %@", self.card],
                       [NSString stringWithFormat:@"created = %@", self.created],
                       [NSString stringWithFormat:@"customerId = %@", self.customerId],
                       [NSString stringWithFormat:@"liveMode = %@", self.liveMode ? @"YES" : @"NO"],
                       [NSString stringWithFormat:@"metadata = %@", self.metadata],
                       [NSString stringWithFormat:@"type = %@", self.type],
                       ];
    return [NSString stringWithFormat:@"<%@>", [props componentsJoinedByString:@"; "]];
}

#pragma mark - STPAPIResponseDecodable

+ (nullable instancetype)decodedObjectFromAPIResponse:(nullable NSDictionary *)response {
    NSDictionary *dict = [response stp_dictionaryByRemovingNulls];
    if (!dict) {
        return nil;
    }
    
    // Required fields
    NSString *stripeId = [dict stp_stringForKey:@"id"];
    if (!stripeId) {
        return nil;
    }
    
    STPPaymentMethod * paymentMethod = [self new];
    paymentMethod.allResponseFields = dict;
    paymentMethod.stripeId = stripeId;
    paymentMethod.created = [dict stp_dateForKey:@"created"];
    paymentMethod.liveMode = [dict stp_boolForKey:@"livemode" or:NO];
    paymentMethod.billingDetails = [STPPaymentMethodBillingDetails decodedObjectFromAPIResponse:[dict stp_dictionaryForKey:@"billing_details"]];
    paymentMethod.card = [STPPaymentMethodCard decodedObjectFromAPIResponse:[dict stp_dictionaryForKey:@"card"]];
    paymentMethod.type = [dict stp_stringForKey:@"type"];
    paymentMethod.customerId = [dict stp_stringForKey:@"customer"];
    paymentMethod.metadata = [[dict stp_dictionaryForKey:@"metadata"] stp_dictionaryByRemovingNonStrings];
    return paymentMethod;
}

@end
