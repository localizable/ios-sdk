import Quick
import Nimble

@testable import Localizable

class LanguageSpec: QuickSpec {
  override func spec() {
    describe("The available languages") {
      it("are") {
        expect(Set(AppLanguage.availableLanguageCodes)) == Set(["Base", "en", "fr", "es", "pt-PT", "de", "zh-Hans"])
      }
    }
    describe("The English Language") {
      let language = AppLanguage(code: "en")

      it("can say hello") {
        expect(language["Hello"]) == "Hello"
      }

      it("can say goodbye") {
        expect(language["Goodbye"]) == "Goodbye"
      }

      it("can't translate 💩") {
        expect(language["💩"]) != "poop"
      }
    }

    describe("The Base Language") {
      let language = AppLanguage(code: "Base")

      it("can say hello") {
        expect(language["Hello"]) == "Hello"
      }

      it("can say goodbye") {
        expect(language["Goodbye"]) == "Goodbye"
      }

      it("can translate 💩") {
        expect(language["💩"]) == "poop"
      }
    }
  }
}
