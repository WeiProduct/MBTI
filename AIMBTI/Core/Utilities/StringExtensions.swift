import Foundation

extension String {
    var localized: String {
        LocalizedStrings.shared.get(self)
    }
}