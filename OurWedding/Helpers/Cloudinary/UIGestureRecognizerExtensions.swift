// The MIT License (MIT)
//
// Copyright (c) 2015-2016 Qvik (www.qvik.fi)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import UIKit

/// Extensions to the UIGestureRecognizer class
public extension UIGestureRecognizer {
    fileprivate struct InvokeCallback {
        static var invokeCallback: Any?
    }

    @objc fileprivate func invokeCallback(_ recognizer: UIGestureRecognizer) {
        if let callbackWithRecognizer = InvokeCallback.invokeCallback as? ((UIGestureRecognizer) -> Void) {
            callbackWithRecognizer(recognizer)
		} else if let callback = InvokeCallback.invokeCallback as? (() -> Void) {
            callback()
        }
    }

    /**
     Convenience initializer that accepts a callback closure instead of a selector. The callback
     must accept a UIGestureRecognizer parameter.

     - parameter callbackWithRecognizer: the callback closure that is called when a gesture is recognized.
     */
    convenience init(callbackWithRecognizer: @escaping ((UIGestureRecognizer) -> Void)) {
        self.init()

        InvokeCallback.invokeCallback = callbackWithRecognizer
        addTarget(self, action: #selector(invokeCallback))
    }

    /**
     Convenience initializer that accepts a callback closure instead of a selector. The callback
     must accept no parameters.

     - parameter callback: the callback closure that is called when a gesture is recognized.
     */
	convenience init(callback: @escaping (() -> Void)) {
        self.init()

        InvokeCallback.invokeCallback = callback
        addTarget(self, action: #selector(invokeCallback))
    }
}
