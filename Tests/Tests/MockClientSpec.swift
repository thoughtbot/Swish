import Foundation
import Nimble
import Quick
import Swish

class MockClientSpec: QuickSpec {
  override func spec() {
    describe("MockClient") {
      describe("perform(request:completionHandler:)") {
        context("when using an any matcher") {
          it("returns the single given response") {
            let client = MockClient()
              .when(FakeRequest.self, "hello world")

            self.expectResponse(client, FakeRequest(), "hello world")
          }
        }

        context("when using an mutliple any matchers") {
          it("returns the appropriate given response") {
            let client = MockClient()
              .when(FakeRequest.self, "hello world")
              .when(FakeRequestWithArguments.self, true)

            self.expectResponse(client, FakeRequest(), "hello world")
            self.expectResponse(client, FakeRequestWithArguments(arg: "xyz"), true)
          }
        }

        context("when using an equality matcher") {
          it("gives a different repsonse according to the specific request") {
            let client = MockClient()
              .when(FakeRequestWithArguments(arg: "xyz"), true)
              .when(FakeRequestWithArguments(arg: "abc"), false)

            self.expectResponse(client, FakeRequestWithArguments(arg: "xyz"), true)
            self.expectResponse(client, FakeRequestWithArguments(arg: "abc"), false)
          }
        }

        context("when using a predicate matcher") {
          it("it returns the appropriate response") {
            let client = MockClient()
              .when(FakeRequestWithArguments(arg: "xyz"), true)
              .when { (req: FakeRequestWithArguments) -> Bool? in
                if req.arg.count > 5 {
                  return .some(true)
                } else {
                  return .some(false)
                }
              }

            self.expectResponse(client, FakeRequestWithArguments(arg: "xyz"), true)
            self.expectResponse(client, FakeRequestWithArguments(arg: "abc"), false)
            self.expectResponse(client, FakeRequestWithArguments(arg: "def"), false)
            self.expectResponse(client, FakeRequestWithArguments(arg: "abcdef"), true)
          }
        }
      }
    }
  }

  private func expectResponse<T>(_ client: Client, _ request: T, _ expectedResponse: T.ResponseObject) where T: Request, T.ResponseObject: Equatable {
    waitUntil(timeout: 1) { done in
      client.perform(request) { response in
        if case let .success(response) = response {
          expect(response).to(equal(expectedResponse))
          done()
        }
      }
    }
  }
}
