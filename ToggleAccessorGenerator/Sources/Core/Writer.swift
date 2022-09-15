//  Writer.swift

import Foundation

class Writer {
    
    static func write(_ content: Content, to url: URL) throws {
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
    
    private static func writeContent(_ content: String, at url: URL) throws {
        let fileManager = FileManager.default
        let absolutePathToFolder = url.deletingLastPathComponent().path
        var fileIsDirectory: ObjCBool = true
        if !fileManager.fileExists(atPath: absolutePathToFolder, isDirectory: &fileIsDirectory) {
           try fileManager.createDirectory(atPath: absolutePathToFolder, withIntermediateDirectories: true, attributes: nil)
        }
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
}
