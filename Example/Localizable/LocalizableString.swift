import UIKit
import Localizable

enum LocalizableString {
	/// Hello
	case Hello
	/// Goodbye
	case Goodbye
}

extension LocalizableString: CustomStringConvertible {
	var description: String { return self.string }

	var string: String {
		switch self {
			 case .Hello:
				 return Localizable.stringForKey("Hello")
			 case .Goodbye:
				 return Localizable.stringForKey("Goodbye")
		}
	}
}

func localized(string: LocalizableString) -> String {
	return string.string
}
