/// This is an Auto-Generated file by Localizable's run script
import Localizable

enum LocalizableString {
    /// Hello
    case Hello
    /// Goodbye
    case Goodbye
    /// poop
    case 💩
    /// So new, so fresh and clean %@
    case NewString(String)
}

extension LocalizableString: CustomStringConvertible {
    var description: String { return self.string }

    var string: String {
        switch self {
             case .Hello:
                 return Localizable.string("Hello")
             case .Goodbye:
                 return Localizable.string("Goodbye")
             case .💩:
                 return Localizable.string("💩")
             case .NewString(let p0):
                 return Localizable.string("NewString", p0)
        }
    }
}

func localizable(string: LocalizableString) -> String {
    return string.string
}
