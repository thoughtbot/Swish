import Foundation
import Nimble
import Quick
import Swish
import Swoosh

class MockClientSpec: QuickSpec {
  override func spec() {
    describe("MockClient") {
      context("empty client") {
        it("shouldn't give a result") {
          let client = MockClient()

          client.perform(FakeRequest()) { _ in
            fail()
          }
        }
      }

      context("when() with a metatype") {
        it("succeeds when given a successful response") {
          let client = MockClient()
            .when(FakeRequest.self, "Yay")

          self.expectResponse(client, FakeRequest(), "Yay")
        }

        it("fails when given a failure") {
          let client = MockClient().when(FakeRequest.self, .serverError(code: 404, data: nil))

          self.expectResponse(client, FakeRequest()) { result in
            switch result {
            case .success:
              fail()
            default:
              break
            }
          }
        }
      }

      context("when() with a request instance") {
        it("succeeds when given a successful response") {
          let client = MockClient()
            .when(FakeRequest(), "Yay")

          self.expectResponse(client, FakeRequest(), "Yay")
        }

        it("fails when given a failure") {
          let client = MockClient().when(FakeRequest(), .serverError(code: 404, data: nil))

          self.expectResponse(client, FakeRequest()) { result in
            switch result {
            case .success:
              fail()
            default:
              break
            }
          }
        }
      }

      context("when() given a matching function") {
        it("succeeds when the fn returns a response object") {
          let client = MockClient()
            .when { (_: FakeRequest) in
              "Yay"
            }

          self.expectResponse(client, FakeRequest(), "Yay")
        }

        it("fails when the fn returns an error") {
          let client = MockClient()
            .when { (_: FakeRequest) in
              .serverError(code: 404, data: nil)
            }

          self.expectResponse(client, FakeRequest()) { result in
            switch result {
            case .success:
              fail()
            default:
              break
            }
          }
        }
      }

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

  private func expectResponse<T>(_ client: Client, _ request: T, responseExpectation: @escaping (Result<T.ResponseObject, SwishError>) -> Void) where T: Request {
    waitUntil(timeout: 1) { done in
      client.perform(request) { response in
        responseExpectation(response)
        done()
      }
    }
  }
}
