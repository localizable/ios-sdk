import Quick
import Nimble

@testable import Localizable

class LocalizableSpec: QuickSpec {
  override func spec() {
    describe("The Localizable SDK") {

      UserDefaultsHelper.currentLanguageCode = nil

      it("Starts in english") {
        Localizable.setLanguageCode("en")
        expect(Localizable.string("Hello")) == "Hello"
      }

      it("Can change to spanish") {
        Localizable.setLanguageCode("es")
        expect(Localizable.string("Hello")) == "Hola"
      }

      it("Can change to Base") {
        Localizable.setLanguageCode("Base")
        expect(Localizable.string("💩")) == "poop"
      }

      it("Can't change to Something else") {
        Localizable.setLanguageCode("SomethingElse")
        expect(Localizable.string("💩")) == "poop"
      }
    }
  }
}
