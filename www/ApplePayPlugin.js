var exec = require('cordova/exec');

var ApplePayPlugin = {
    canMakePayments: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'ApplePayPlugin', 'canMakePayments', []);
    },
    makePaymentRequest: function(paymentDetails, successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'ApplePayPlugin', 'makePaymentRequest', [paymentDetails]);
    }
};

module.exports = ApplePayPlugin;
