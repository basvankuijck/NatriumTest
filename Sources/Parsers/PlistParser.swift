//
//  PlistParser.swift
//  CommandLineKit
//
//  Created by Bas van Kuijck on 11/02/2019.
//

import Foundation
import Yaml
import Francium

class PlistParser: Parseable {

    var yamlKey: String {
        return "plists"
    }

    var isRequired: Bool {
        return false
    }

    func parse(_ dictionary: [String: Yaml]) throws {
        for plist in dictionary {
            let file = File(path: "\(data.projectDir)/\(plist.key)")
            if !file.isExisting {
                throw NatriumError("Cannot find plist: \(file.absolutePath)")
            }

            guard let plistDictionary = plist.value.dictionary else {
                continue
            }

            for keyValue in plistDictionary {
                switch keyValue.value {
                case .null:
                    PlistHelper.remove(key: keyValue.key.stringValue, in: file.absolutePath)

                case .array(let array):
                    PlistHelper.write(array: array.map { $0.stringValue }, for: keyValue.key.stringValue, in: file.absolutePath)

                default:
                    let currentValue = PlistHelper.getValue(for: keyValue.key.stringValue, in: file.absolutePath)
                    if currentValue != keyValue.value.stringValue {
                        PlistHelper.write(value: keyValue.value.stringValue, for: keyValue.key.stringValue, in: file.absolutePath)
                    }
                }
            }
        }
    }
}
