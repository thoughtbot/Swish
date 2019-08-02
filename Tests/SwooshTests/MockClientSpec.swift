import Foundation
import Nimble
import Quick
import Swish
import Swoosh

class MockClientSpec: QuickSpec {
  override func spec() {
    describe("MockClient") {
      context("when() with a metatype") {
        it("succeeds when given a successful response") {
          let client = MockClient()
            .when(FakeRequest.self, "Yay")

          client.perform(FakeRequest(), completionHandler: { result in
            expect(try! result.get()).to(equal("Yay"))
          })
        }

        it("fails when given a failure") {
          let client = MockClient().when(FakeRequest.self, .serverError(code: 404, data: nil))

          client.perform(FakeRequest(), completionHandler: { result in
            switch result {
            case .success:
              fail()
            default:
              break
            }
          })
        }
      }

      context("when() with a request instance") {
        it("succeeds when given a successful response") {
          let client = MockClient()
            .when(FakeRequest(), "Yay")

          client.perform(FakeRequest(), completionHandler: { result in
            expect(try! result.get()).to(equal("Yay"))
          })
        }

        it("fails when given a failure") {
          let client = MockClient().when(FakeRequest(), .serverError(code: 404, data: nil))

          client.perform(FakeRequest(), completionHandler: { result in
            switch result {
            case .success:
              fail()
            default:
              break
            }
          })
        }
      }

      context("when() given a matching function") {
        it("succeeds when the fn returns a response object") {
          let client = MockClient()
            .when { (_: FakeRequest) in
              "Yay"
            }

          client.perform(FakeRequest(), completionHandler: { result in
            expect(try! result.get()).to(equal("Yay"))
          })
        }

        it("fails when the fn returns an error") {
          let client = MockClient()
            .when { (_: FakeRequest) in
              .serverError(code: 404, data: nil)
            }

          client.perform(FakeRequest(), completionHandler: { result in
            switch result {
            case .success:
              fail()
            default:
              break
            }
          })
        }
      }
    }
  }
}
