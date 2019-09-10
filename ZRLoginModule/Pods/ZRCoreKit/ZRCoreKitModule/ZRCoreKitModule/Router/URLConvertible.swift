//
//  URLConvertible.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// A type which can be converted to an URL string.
public protocol URLConvertible {
    var urlValue: URL? { get }
    var urlStringValue: String { get }
    var pattern: String { get }
    var moduler: String? { get }
    var path: String? { get }
    /// Returns URL query parameters. For convenience, this property will never return `nil` even if
    /// there's no query string in the URL. This property doesn't take care of the duplicated keys.
    /// For checking duplicated keys, use `queryItems` instead.
    ///
    /// - seealso: `queryItems`
    var queryParameters: [String: String] { get }
    
//    var queryPaths: [String]? { get }
    
    /// Returns `queryItems` property of `URLComponents` instance.
    ///
    /// - seealso: `queryParameters`
    @available(iOS 8, *)
    var queryItems: [URLQueryItem]? { get }
}

extension URLConvertible {
    
    public var pattern: String {
        return self.urlStringValue.components(separatedBy: "?")[0].components(separatedBy: "#")[0]
    }
    
    public var queryParameters: [String: String] {
        var parameters = [String: String]()
        self.urlValue?.query?.components(separatedBy: "&").forEach { component in
            guard let separatorIndex = component.firstIndex(of: "=") else { return }
            let keyRange = component.startIndex..<separatorIndex
            let valueRange = component.index(after: separatorIndex)..<component.endIndex
            let key = String(component[keyRange])
            let value = component[valueRange].removingPercentEncoding ?? String(component[valueRange])
            parameters[key] = value
        }
        return parameters
    }
    
    
    @available(iOS 8, *)
    public var queryItems: [URLQueryItem]? {
        return URLComponents(string: self.urlStringValue)?.queryItems
    }
    
    public var moduler: String? {
        if let components = URLComponents(string: self.urlStringValue), let scheme = components.scheme{
            return scheme
        }
        return nil
    }
    
    public var path: String? {
        if let components = URLComponents(string: self.urlStringValue), let host = components.host{
            return host
        }
        return nil
    }
}

extension String: URLConvertible {
    public var urlValue: URL? {
        if let url = URL(string: self) {
            return url
        }
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
    }
    
    public var urlStringValue: String {
        return self
    }
}

extension URL: URLConvertible {
    public var urlValue: URL? {
        return self
    }
    
    public var urlStringValue: String {
        return self.absoluteString
    }
}
