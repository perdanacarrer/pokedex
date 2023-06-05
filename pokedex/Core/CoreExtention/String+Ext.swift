//
//  String+Ext.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit

extension String {
    // MARK: - Conversion
    
    public func performXOROperation(withKey key: UInt8) -> String {
        return String(bytes: self.utf8.map{$0 ^ key}, encoding: String.Encoding.utf8) ?? ""
    }
    
    public func getCleanedURL() -> URL? {
        guard self.isEmpty == false else { return nil }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
    }
    
    public func cleanIdrFormat() -> String {
        return self.replacingOccurrences(of: ".", with: "")
    }
    
    public func cleanDigitalAssetFormat() -> String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
    
    public func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch { return ""}
    }
    
    public func trimSpecialCharacters() -> String {
        return self.components(separatedBy: .punctuationCharacters).joined()
            .components(separatedBy: .symbols).joined().components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    public func removeTrailingZero() -> String {
        return self.removingRegexMatches(pattern: #"0*$"#)
    }
    
    public func removeTrailingDot() -> String {
        return self.removingRegexMatches(pattern: "\\.$")
    }
    
    // MARK: - Validation
    
    public var isNumber: Bool {
        return Double(self) != nil
    }
    
    public var isNotInfinite: Bool {
        if self.lowercased().contains("nan") || self.lowercased().contains("inf") {
            return false
        } else {
            return true
        }
    }
    
    public func isValidHtmlString() -> Bool {
        return (self.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil)
    }
    
    public var toBool: Bool {
        return (self == "true") || (self == "1")
    }
    
    public func stringToDate(dateFormats: String, timezoneAbbreviation: String) -> Date {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormats
        dateFormatter.timeZone = TimeZone(abbreviation: timezoneAbbreviation)
        guard let date = dateFormatter.date(from: dateString) else { return Date()}
        return date
    }
    
    // MARK: - Regex
    public func isValidEmail() -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
                + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    public func isValidUrl() -> Bool {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return predicate.evaluate(with: self)
    }
    
    public func isValidPhoneNumber() -> Bool {
        var result : Bool?
        var PHONE_REGEX: String!
        PHONE_REGEX = "^[0-9]{9,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        result = phoneTest.evaluate(with: self)
        return result!
    }
    
    // MARK: - Password
    public func isPasswordEightPlusCharacter() -> Bool {
        if self.count >= 8 {
            return true
        }
        return false
    }
    
    public func isPasswordContainUppercaseLetter() -> Bool {
        if self.range(of: ".*[A-Z]+.*", options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    public func isPasswordContainLowercaseLetter() -> Bool {
        if self.range(of: ".*[a-z]+.*", options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    public func isPasswordContainSymbolOrNumber() -> Bool {
        if self.range(of: ".*[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+.*", options: .regularExpression) != nil ||
            self.range(of: ".*[0-9]+.*", options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    public func toInt64() -> Int64 {
        return Int64(self) ?? 0
    }
    
    public func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    
    public func toDouble() -> Double {
        return Double(self) ?? 0
    }
    
    public var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y":
            return true
        case "false", "f", "no", "n", "":
            return false
        default:
            if let int = Int(self) {
                return int != 0
            }
            return nil
        }
    }
    
    public func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
  public func stringtoJSON() -> [String:Any] {
        let data = Data(self.utf8)
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return [:]
    }

    public func stripDiacritics() -> String {
        self.folding(options: .diacriticInsensitive, locale: .current)
    }
}

