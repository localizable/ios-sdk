import Localizable

enum LocalizableString {
	/// Hello
	case Hello
	/// Goodbye
	case Goodbye
	/// So new, so fresh and clean
	case NewString
}

extension LocalizableString: CustomStringConvertible {
	var description: String { return self.string }

	var string: String {
		switch self {
			 case .Hello:
				 return Localizable.stringForKey("Hello")
			 case .Goodbye:
				 return Localizable.stringForKey("Goodbye")
			 case .NewString:
				 return Localizable.stringForKey("NewString")
		}
	}
}

func localized(string: LocalizableString) -> String {
	return string.string
}
