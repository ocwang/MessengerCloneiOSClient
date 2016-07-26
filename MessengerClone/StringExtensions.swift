//
//  StringExtensions.swift
//  MessengerClone
//
//  Created by Chase Wang on 7/23/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import Foundation

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}