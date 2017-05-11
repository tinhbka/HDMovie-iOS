//
//  IAPHelper.m
//  PPFoundation,
//  Helper Functions and Classes for Ordinary Application Development on iPhone
//
//  Created by meinside on 11. 4. 26.
//
//  last update: 12.07.18.
//

#import "PPIAPHelper.h"


@implementation PPIAPHelper

@synthesize delegate;
@synthesize productsRequest;
@synthesize paymentQueue;

static PPIAPHelper *_instance;

- (id)init {
	if ((self = [super init])) {
		self.paymentQueue = [SKPaymentQueue defaultQueue];
		[paymentQueue addTransactionObserver:self];
	}
	return self;
}

+ (PPIAPHelper *)sharedInstance {
	if (!_instance) {
		_instance = [[PPIAPHelper alloc] init];
	}
	return _instance;
}

+ (void)disposeSharedInstance {
	_instance = nil;
}

- (void)dealloc {
	self.delegate = nil;
	[paymentQueue removeTransactionObserver:self];
}

#pragma mark -
#pragma mark request functions

+ (BOOL)canMakePayments {
	return [SKPaymentQueue canMakePayments];
}

- (void)requestProductsWithIdentifiers:(NSSet *)identifiers {
	@synchronized(self)
	{
		NSLog(@"requesting products with identifiers: %@", identifiers);

		self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
		self.productsRequest.delegate = self;
		[self.productsRequest start];
	}
}

- (void)purchaseProduct:(SKProduct *)product {
	NSLog(@"trying to purchase product: %@", product);

	[paymentQueue addPayment:[SKPayment paymentWithProduct:product]];
}

// deprecated
//- (void)purchaseProductWithIdentifier:(NSString*)identifier
//{
//	NSLog(@"trying to purchase product with identifier: %@", identifier);
//
//	[paymentQueue addPayment:[SKPayment paymentWithProductIdentifier:identifier]];
//}

- (void)finishTransaction:(SKPaymentTransaction *)transaction {
	NSLog(@"finishing transaction: %@", transaction);

	[paymentQueue finishTransaction:transaction];
}

- (void)restoreCompletedPurchases {
	NSLog(@"trying to restore completed purchases");

	[paymentQueue restoreCompletedTransactions];
}

#pragma mark -
#pragma mark sk request delegate functions

- (void)requestDidFinish:(SKRequest *)request {
	NSLog(@"request did finish: %@", request);

	if ([delegate respondsToSelector:@selector(requestDidFinish:)])
		[delegate requestDidFinish:request];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"request did fail with error: %@ / %@", request, error);

	if ([delegate respondsToSelector:@selector(request:didFailWithError:)])
		[delegate request:request didFailWithError:error];
}

#pragma mark -
#pragma mark sk products request delegate functions

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"received products response: %@", response);

	[delegate receivedProductsResponse:response];
}

#pragma mark -
#pragma mark sk payment transaction observer delegate functions

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	NSLog(@"updated transactions: %@", transactions);

	[delegate updatedTransactions:transactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
	NSLog(@"removed transactions: %@", transactions);

	[delegate purchaseCompleted:transactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
	NSLog(@"restoring completed transactions failed: %@", error);

	[delegate restoreFailed:error];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
	NSLog(@"restored completed transactions: %@", queue);

	[delegate restoreCompleted:queue];
}

@end
