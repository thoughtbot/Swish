import Swish
import Quick
import Nimble
import Result

class APIClientSpec: QuickSpec {
  override func spec() {
    describe("APIClient") {
      describe("performRequest(completionHandler:") {
        it("passes the request's request object to the request performer") {
          let request = FakeRequest()
          let performer = FakeRequestPerformer()
          let client = APIClient(requestPerformer: performer)

          client.performRequest(request) { _ in }

          expect(performer.passedRequest).to(equal(request.build()))
        }

        describe("parsing") {
          context("when the parsing operation is successful") {
            it("returns the parsed object to the completion block") {
              let request = FakeRequest()
              let performer = FakeRequestPerformer(returnedJSON:
                ["text": "hello world"]
              )

              let client = APIClient(requestPerformer: performer)
              var result: Result<String, NSError>?

              client.performRequest(request) { result = $0 }

              expect(result?.value).to(equal("hello world"))
            }
          }

          context("when the parsing operation fails") {
            it("returns a failure state to the completion block") {
              let request = FakeRequest()
              let performer = FakeRequestPerformer(returnedJSON:
                ["foo": "bar"]
              )

              let client = APIClient(requestPerformer: performer)
              var result: Result<String, NSError>?

              client.performRequest(request) { result = $0 }

              let message = result?.error?.userInfo[NSLocalizedDescriptionKey] as? NSString

              expect(message).to(equal("MissingKey(text)"))
            }
          }

          context("when the data is `nil`") {
            it("returns a failure state describing the issue") {
              let request = FakeRequest()
              let performer = FakeRequestPerformer()

              let client = APIClient(requestPerformer: performer)
              var result: Result<String, NSError>?

              client.performRequest(request) { result = $0 }

              let message = result?.error?.userInfo[NSLocalizedDescriptionKey] as? NSString

              expect(message).to(equal("No response data"))
            }
          }
        }
      }
    }
  }
}
