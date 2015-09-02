@testable import Swish
import Quick
import Nimble
import Result

func exampleRequest() -> NSURLRequest {
  return NSURLRequest(URL: NSURL(string: "http://example.com")!)
}

func fakeData() -> NSData {
  return "Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
}

func fakeResponse(code: Int) -> NSURLResponse {
  return NSHTTPURLResponse(URL: NSURL(), statusCode: code, HTTPVersion: .None, headerFields: .None)!
}

class RequestPerformerSpec: QuickSpec {
  override func spec() {
    describe("NetworkRequestPerformer") {
      describe("performRequest(completionHandler:)") {
        it("performs the request") {
          let fakeSession = FakeSession()
          let performer = NetworkRequestPerformer(session: fakeSession)

          let request = exampleRequest()
          performer.performRequest(request) { _ in }

          expect(fakeSession.providedRequest).to(equal(request))
          expect(fakeSession.performedRequest).to(beTruthy())
        }

        context("when the request didn't produce an error") {
          it("returns a Result with the HTTPResponse") {
            let fakeSession = FakeSession(data: fakeData(), response: fakeResponse(200))
            var returnedCode: Int = 0
            var returnedData: NSData?

            let performer = NetworkRequestPerformer(session: fakeSession)
            performer.performRequest(exampleRequest()) { result in
              returnedCode = result.value!.code
              returnedData = result.value!.data
            }

            expect(returnedCode).to(equal(200))
            expect(returnedData).to(equal(fakeData()))
          }
        }

        context("when the request produces an error") {
          it("returns a Result with the error") {
            let error = NSError(domain: "TestDomain", code: 1, userInfo: .None)
            let fakeSession = FakeSession(error: error)
            var returnedError: NSError?

            let performer = NetworkRequestPerformer(session: fakeSession)
            performer.performRequest(exampleRequest()) { result in
              returnedError = result.error!
            }

            expect(returnedError).to(equal(error))
          }
        }
      }
    }
  }
}
