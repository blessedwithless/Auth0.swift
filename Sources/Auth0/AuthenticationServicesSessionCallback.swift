#if os(iOS) || os(macOS) // Added by Auth0toSPM
import Foundation // Added by Auth0toSPM
import Auth0ObjC // Added by Auth0toSPM
// AuthenticationServicesSessionCallback.swift
//
// Copyright (c) 2020 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if canImport(AuthenticationServices)
import AuthenticationServices

@available(iOS 12.0, macOS 10.15, *)
final class AuthenticationServicesSessionCallback: SessionCallbackTransaction {

    init(url: URL, schemeURL: URL, callback: @escaping (Bool) -> Void) {
        super.init(callback: callback)

        let authSession = ASWebAuthenticationSession(url: url,
                                                     callbackURLScheme: schemeURL.scheme) { [weak self] url, _ in
            self?.callback(url != nil)
            TransactionStore.shared.clear()
        }

        #if swift(>=5.1)
        if #available(iOS 13.0, *) {
            authSession.presentationContextProvider = self
        }
        #endif

        self.authSession = authSession
        authSession.start()
    }

}
#endif

#endif // Added by Auth0toSPM
