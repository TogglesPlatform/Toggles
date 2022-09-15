//  Templater.swift

import Foundation
import Stencil

class Templater {
    
    func renderTemplate(at url: URL, with context: [String: Any]) throws -> String {
        let templateString = try String(contentsOf: url)
        let template = Template(templateString: templateString)
        return try template.render(context)
    }
}
