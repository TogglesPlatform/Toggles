//  TweaksDatasource+FullTweaks.swift

import Foundation

extension TweaksDatasource {
    
    var fullTweaks: [FullTweak] {
        var fullTweaks: [FullTweak] = []
        
        for (feature, togglesByVariable) in tweaks {
            for (variable, tweak) in togglesByVariable {
                let fullTweak = FullTweak(title: tweak.title,
                                          description: tweak.description,
                                          group: tweak.group,
                                          value: tweak.value,
                                          encrypted: tweak.encrypted,
                                          generatedPropertyName: tweak.generatedPropertyName,
                                          variable: variable,
                                          feature: feature)
                fullTweaks.append(fullTweak)
            }
        }
        
        return fullTweaks.sorted()
    }
}
