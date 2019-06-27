//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "MockSSKEnvironment.h"
#import "OWSPrimaryStorage.h"
#import "SSKBaseTestObjC.h"
#import "SignalRecipient.h"
#import "TSAccountManager.h"
#import "TestAppContext.h"
#import <SignalServiceKit/SignalServiceKit-Swift.h>

@interface SignalRecipientTest : SSKBaseTestObjC

@property (nonatomic) NSString *localNumber;

@end

#pragma mark -

@implementation SignalRecipientTest

- (void)setUp
{
    [super setUp];

    self.localNumber = @"+13231231234";
    [[TSAccountManager sharedInstance] registerForTestsWithLocalNumber:self.localNumber uuid:[NSUUID new]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSelfRecipientWithExistingRecord
{
    // Sanity Check
    XCTAssertNotNil(self.localNumber);

    [self writeWithBlock:^(SDSAnyWriteTransaction *transaction) {
        [SignalRecipient markRecipientAsRegisteredAndGet:self.localNumber.transitional_signalServiceAddress
                                             transaction:transaction];

        XCTAssertTrue([SignalRecipient isRegisteredRecipient:self.localNumber.transitional_signalServiceAddress
                                                 transaction:transaction]);
    }];
}

- (void)testRecipientWithExistingRecord
{
    // Sanity Check
    XCTAssertNotNil(self.localNumber);
    NSString *recipientId = @"+15551231234";
    [self writeWithBlock:^(SDSAnyWriteTransaction *transaction) {
        [SignalRecipient markRecipientAsRegisteredAndGet:recipientId.transitional_signalServiceAddress
                                             transaction:transaction];

        XCTAssertTrue([SignalRecipient isRegisteredRecipient:recipientId.transitional_signalServiceAddress
                                                 transaction:transaction]);
    }];
}

@end
