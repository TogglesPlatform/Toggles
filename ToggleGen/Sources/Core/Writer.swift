//  Writer.swift

import Foundation

typealias Content = String

class Writer {
    
    private enum Constants: String {
        case swift
    }
    
    func saveVariables(_ content: Content, outputPath: String, variablesStructName: String) throws {
        let vriablesFileName = URL(fileURLWithPath: outputPath)
            .appendingPathComponent(variablesStructName)
            .appendingPathExtension(Constants.swift.rawValue)
        try write(content, to: vriablesFileName)
    }
    
    func saveAccessor(_ content: Content, outputPath: String, accessorClassName: String) throws {
        let accessorFileName = URL(fileURLWithPath: outputPath)
            .appendingPathComponent(accessorClassName)
            .appendingPathExtension(Constants.swift.rawValue)
        try write(content, to: accessorFileName)
    }
    
    private func write(_ content: Content, to url: URL) throws {
        let existingContent = try? String(contentsOf: url, encoding: .utf8)
        switch (existingContent, content) {
        case (.none, let newContent):
            try writeContent(newContent, at: url)
        case (.some(let existingContent), let newContent) where existingContent != newContent:
            try writeContent(newContent, at: url)
        case (.some, _):
            break
        }
    }
    
    private func writeContent(_ content: String, at url: URL) throws {
        let fileManager = FileManager.default
        let absolutePathToFolder = url.deletingLastPathComponent().path
        var fileIsDirectory: ObjCBool = true
        if !fileManager.fileExists(atPath: absolutePathToFolder, isDirectory: &fileIsDirectory) {
           try fileManager.createDirectory(atPath: absolutePathToFolder, withIntermediateDirectories: true, attributes: nil)
        }
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
}
