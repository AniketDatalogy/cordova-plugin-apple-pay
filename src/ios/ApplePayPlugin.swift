
import Foundation
import PassKit

@objc(ApplePayPlugin) class ApplePayPlugin: CDVPlugin {
    
    @objc(canMakePayments:)
    func canMakePayments(command: CDVInvokedUrlCommand) {
        let canMakePayments = PKPaymentAuthorizationViewController.canMakePayments()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: canMakePayments)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(makePaymentRequest:)
    func makePaymentRequest(command: CDVInvokedUrlCommand) {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Cannot make payments")
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            return
        }

        let paymentRequest = PKPaymentRequest()
        // Configure the payment request
        // Example configuration:
        paymentRequest.merchantIdentifier = "your.merchant.identifier"
        paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Product Name", amount: NSDecimalNumber(string: "9.99"))
        ]

        guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error creating payment view controller")
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            return
        }

        paymentVC.delegate = self
        self.viewController.present(paymentVC, animated: true, completion: nil)
    }
}

extension ApplePayPlugin: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Handle the payment authorization
        let status = PKPaymentAuthorizationStatus.success
        let result = PKPaymentAuthorizationResult(status: status, errors: nil)
        completion(result)
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Payment successful")
        self.commandDelegate.send(pluginResult, callbackId: "yourCallbackId")
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        // Optionally send a callback indicating the payment sheet was dismissed
    }
}

