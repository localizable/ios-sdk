import UIKit
import Localizable

enum LocalizableString {
	/// English String
	case Testing
	/// Ohohoho maluca %@
	case AtuaMaeDe4(String)
}

extension LocalizableString: CustomStringConvertible {
	var description: String { return self.string }

	var string: String {
		switch self {
			 case .Testing:
				 return Localizable.stringForKey("Testing")
			 case .AtuaMaeDe4(let p0):
				 return Localizable.stringForKey("Atua.mae.de.4", p0)
		}
	}
}

func localized(string: LocalizableString) -> String {
	return string.string
}
