import Swish
import Quick
import Nimble
import Result

class APIClientSpec: QuickSpec {
  override func spec() {
    describe("APIClient") {
      context("when the status code is in the 200 range") {
        describe("performRequest(completionHandler:") {
          it("passes the request's request object to the request performer") {
            let request = FakeRequest()
            let performer = FakeRequestPerformer(
              responseData: .JSON([:])
            )
            let client = APIClient(requestPerformer: performer)

            client.performRequest(request) { _ in }

            expect(performer.passedRequest).to(equal(request.build()))
          }

          describe("parsing") {
            context("when the parsing operation is successful") {
              it("returns the parsed object to the completion block") {
                let request = FakeRequest()
                let performer = FakeRequestPerformer(
                  responseData: .JSON(["text": "hello world"])
                )

                let client = APIClient(requestPerformer: performer)
                var result: Result<String, NSError>?

                client.performRequest(request) { result = $0 }

                expect(result?.value).toEventually(equal("hello world"))
              }
            }

            context("when the parsing operation fails") {
              it("returns a failure state to the completion block") {
                let request = FakeRequest()
                let performer = FakeRequestPerformer(
                  responseData: .JSON( ["foo": "bar"])
                )

                let client = APIClient(requestPerformer: performer)
                var message: NSString?

                client.performRequest(request) {
                  message = $0.error?.userInfo[NSLocalizedDescriptionKey] as? NSString
                }

                expect(message).toEventually(equal("MissingKey(text)"))
              }
            }

            context("when the data is empty") {
              it("returns a null JSON object") {
                let request = FakeEmptyDataRequest()
                let performer = FakeRequestPerformer(
                  responseData: .Data(NSData())
                )

                let client = APIClient(requestPerformer: performer)
                var result: Result<EmptyResponse, NSError>?

                client.performRequest(request) { result = $0 }

                expect(result?.value).toEventually(beVoid())
              }
            }

            context("when the data is .None") {
              it("returns a null JSON object") {
                let request = FakeEmptyDataRequest()
                let performer = FakeRequestPerformer(
                  responseData: .Data(.None)
                )

                let client = APIClient(requestPerformer: performer)
                var result: Result<EmptyResponse, NSError>?

                client.performRequest(request) { result = $0 }

                expect(result?.value).toEventually(beVoid())
              }
            }
          }

          describe("completionHandler") {
            it("performs on the main thread") {
              let request = FakeRequest()
              let performer = FakeRequestPerformer(
                responseData: .JSON([:])
              )

              let client = APIClient(requestPerformer: performer)
              var isMainThread = false

              client.performRequest(request) { _ in
                isMainThread = NSThread.currentThread() == NSThread.mainThread()
              }

              expect(isMainThread).toEventually(beTrue())
            }
          }
        }
      }

      context("when the status code is in the 300 range") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let performer = FakeRequestPerformer(
            responseData: .JSON(["foo": "bar"]),
            statusCode: 301
          )

          let client = APIClient(requestPerformer: performer)
          var message: NSString?

          client.performRequest(request) {
            message = $0.error?.userInfo[NSLocalizedDescriptionKey] as? NSString
          }

          expect(message).toEventually(equal("Multiple choices: 301"))
        }
      }

      context("when the status code is in the 400 range") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let performer = FakeRequestPerformer(
            responseData: .JSON(["foo": "bar"]),
            statusCode: 401
          )

          let client = APIClient(requestPerformer: performer)
          var message: NSString?

          client.performRequest(request) {
            message = $0.error?.userInfo[NSLocalizedDescriptionKey] as? NSString
          }

          expect(message).toEventually(equal("Bad request: 401"))
        }
      }

      context("when the status code is in the 500 range") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let performer = FakeRequestPerformer(
            responseData: .JSON(["foo": "bar"]),
            statusCode: 500
          )

          let client = APIClient(requestPerformer: performer)
          var message: NSString?

          client.performRequest(request) {
            message = $0.error?.userInfo[NSLocalizedDescriptionKey] as? NSString
          }

          expect(message).toEventually(equal("Server error: 500"))
        }
      }

      context("when the status code is in the not between 200...599") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let performer = FakeRequestPerformer(
            responseData: .JSON(["foo": "bar"]),
            statusCode: 600
          )

          let client = APIClient(requestPerformer: performer)
          var message: NSString?

          client.performRequest(request) {
            message = $0.error?.userInfo[NSLocalizedDescriptionKey] as? NSString
          }

          expect(message).toEventually(equal("Unknown error: 600"))
        }
      }

      context("when there is an error") {
        it("returns the JSON with the error") {
          let expectedJSON = ["foo": "bar"]
          let request = FakeRequest()
          let performer = FakeRequestPerformer(
            responseData: .JSON(expectedJSON),
            statusCode: 600
          )

          let client = APIClient(requestPerformer: performer)
          var returnedJSON: [String: String]?

          client.performRequest(request) {
            returnedJSON = $0.error?.userInfo[NetworkErrorJSONKey] as? [String: String]
          }

          expect(returnedJSON).toEventually(equal(expectedJSON))
        }
      }
    }
  }
}
