@testable import Swish
import Quick
import Nimble
import Result

func exampleRequest() -> URLRequest {
  return URLRequest(url: URL(string: "https://example.com")!)
}

func fakeData() -> Data {
  return "Hello World".data(using: .utf8, allowLossyConversion: false)!
}

func fakeResponse(_ code: Int) -> URLResponse {
  return HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: code, httpVersion: .none, headerFields: .none)!
}

class RequestPerformerSpec: QuickSpec {
  override func spec() {
    describe("NetworkRequestPerformer") {
      describe("performRequest(completionHandler:)") {
        it("performs the request") {
          let fakeSession = FakeSession()
          let performer = NetworkRequestPerformer(session: fakeSession)

          let request = exampleRequest()
          performer.perform(request) { _ in }

          expect(fakeSession.providedRequest).to(equal(request))
          expect(fakeSession.performedRequest).to(beTruthy())
        }

        context("when the request didn't produce an error") {
          it("returns a Result with the HTTPResponse") {
            let fakeSession = FakeSession(data: fakeData(), response: fakeResponse(200))
            var returnedCode: Int = 0
            var returnedData: Data?

            let performer = NetworkRequestPerformer(session: fakeSession)
            performer.perform(exampleRequest()) { result in
              returnedCode = result.value!.code
              returnedData = result.value!.data
            }

            expect(returnedCode).to(equal(200))
            expect(returnedData).to(equal(fakeData()))
          }
        }

        context("when the request produces an error") {
          it("returns a Result with the error") {
            let error = NSError(domain: "TestDomain", code: 1, userInfo: .none)
            let fakeSession = FakeSession(error: error)
            var returnedError: Error?

            let performer = NetworkRequestPerformer(session: fakeSession)
            performer.perform(exampleRequest()) { result in
              returnedError = result.error
            }

            expect(returnedError).to(matchError(SwishError.urlSessionError(error)))
          }
        }
      }
    }
  }
}
