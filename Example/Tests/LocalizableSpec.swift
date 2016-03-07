import Quick
import Nimble

@testable import Localizable

class LocalizableSpec: QuickSpec {
  override func spec() {
    describe("The Localizable SDK") {

      UserDefaultsHelper.currentLanguageCode = nil

      it("Starts in english") {
        Localizable.setLanguageWithCode("en")
        expect(Localizable.stringForKey("Hello")) == "Hello"
      }

      it("Can change to spanish") {
        Localizable.setLanguageWithCode("es")
        expect(Localizable.stringForKey("Hello")) == "Hola"
      }

      it("Can change to Base") {
        Localizable.setLanguageWithCode("Base")
        expect(Localizable.stringForKey("💩")) == "poop"
      }

      it("Can't change to Something else") {
        Localizable.setLanguageWithCode("SomethingElse")
        expect(Localizable.stringForKey("💩")) == "poop"
      }
    }
  }
}
