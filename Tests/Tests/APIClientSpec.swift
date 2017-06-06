import Swish
import Quick
import Nimble
import Result

class APIClientSpec: QuickSpec {
  override func spec() {
    describe("APIClient") {
      context("when the status code is in the 200 range") {
        describe("perform(request:completionHandler:)") {
          it("passes the request's request object to the request performer") {
            let request = FakeRequest()
            let performer = FakeRequestPerformer(
              responseData: .json([:])
            )
            let client = APIClient(requestPerformer: performer)

            client.perform(request) { _ in }

            expect(performer.passedRequest).to(equal(request.build()))
          }

          describe("parsing") {
            context("when the parsing operation is successful") {
              it("returns the parsed object to the completion block") {
                let request = FakeRequest()
                let performer = FakeRequestPerformer(
                  responseData: .json(["text": "hello world"])
                )

                let client = APIClient(requestPerformer: performer)
                var result: Result<String, SwishError>?

                client.perform(request) { result = $0 }

                expect(result?.value).toEventually(equal("hello world"))
              }
            }

            context("when the parsing operation fails") {
              it("returns a failure state to the completion block") {
                let request = FakeRequest()
                let performer = FakeRequestPerformer(
                  responseData: .json(["foo": "bar"])
                )

                let client = APIClient(requestPerformer: performer)
                var error: Error?

                client.perform(request) {
                  error = $0.error
                }

                expect(error).toEventually(matchError(SwishError.self))
              }
            }

            context("when the data is empty") {
              it("returns a null JSON object") {
                let request = FakeEmptyDataRequest()
                let performer = FakeRequestPerformer(
                  responseData: .data(Data())
                )

                let client = APIClient(requestPerformer: performer)
                var result: Result<EmptyResponse, SwishError>?

                client.perform(request) { result = $0 }

                expect(result?.value).toEventually(beVoid())
              }
            }

            context("when the data is .None") {
              it("returns a null JSON object") {
                let request = FakeEmptyDataRequest()
                let performer = FakeRequestPerformer(
                  responseData: .data(Data())
                )

                let client = APIClient(requestPerformer: performer)
                var result: Result<EmptyResponse, SwishError>?

                client.perform(request) { result = $0 }

                expect(result?.value).toEventually(beVoid())
              }
            }
          }

          describe("completionHandler") {
            it("performs on the main thread") {
              let request = FakeRequest()
              let performer = FakeRequestPerformer(
                responseData: .json([:])
              )

              let client = APIClient(requestPerformer: performer)
              var isMainThread = false

              client.perform(request) { _ in
                isMainThread = Thread.isMainThread
              }

              expect(isMainThread).toEventually(beTrue())
            }
          }
        }
      }

      context("when the status code is in the 300 range") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let expectedJSON = ["foo": "bar"]
          let expectedCode = 301
          let performer = FakeRequestPerformer(
            responseData: .json(expectedJSON),
            statusCode: expectedCode
          )

          let client = APIClient(requestPerformer: performer)
          var error: SwishError?

          client.perform(request) {
            error = $0.error
          }

          expect(error).toEventually(matchError(SwishError.serverError(code: expectedCode, data: performer.data)))
        }
      }

      context("when the status code is in the 400 range") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let expectedJSON = ["foo": "bar"]
          let expectedCode = 401
          let performer = FakeRequestPerformer(
            responseData: .json(expectedJSON),
            statusCode: expectedCode
          )

          let client = APIClient(requestPerformer: performer)
          var error: SwishError?

          client.perform(request) {
            error = $0.error
          }

          expect(error).toEventually(matchError(SwishError.serverError(code: expectedCode, data: performer.data)))
        }
      }

      context("when the status code is in the 500 range") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let expectedJSON = ["foo": "bar"]
          let expectedCode = 500
          let performer = FakeRequestPerformer(
            responseData: .json(expectedJSON),
            statusCode: expectedCode
          )

          let client = APIClient(requestPerformer: performer)
          var error: SwishError?

          client.perform(request) {
            error = $0.error
          }

          expect(error).toEventually(matchError(SwishError.serverError(code: expectedCode, data: performer.data)))
        }
      }

      context("when the status code is in the not between 200...599") {
        it("returns the appropriate error") {
          let request = FakeRequest()
          let expectedJSON = ["foo": "bar"]
          let expectedCode = 600
          let performer = FakeRequestPerformer(
            responseData: .json(expectedJSON),
            statusCode: expectedCode
          )

          let client = APIClient(requestPerformer: performer)
          var error: SwishError?

          client.perform(request) {
            error = $0.error
          }

          expect(error).toEventually(matchError(SwishError.serverError(code: expectedCode, data: performer.data)))
        }
      }

      describe("scheduling completion blocks") {
        it("dispatches onto the main queue by default") {
          let performer = FakeRequestPerformer(responseData: .json([:]))
          let client = APIClient(requestPerformer: performer)

          var isOnMain: Bool?
          client.perform(FakeRequest()) { _ in
            isOnMain = Thread.isMainThread
          }

          expect(isOnMain).toEventually(beTrue())
        }

        it("doesn't dispatch onto main queue when using the immediate scheduler") {
          let performer = FakeRequestPerformer(responseData: .json([:]), background: true)
          let client = APIClient(requestPerformer: performer, scheduler: immediateScheduler)

          var isOnMain: Bool?
          client.perform(FakeRequest()) { _ in
            isOnMain = Thread.isMainThread
          }

          expect(isOnMain).toEventually(beFalse())
        }

        it("dispatches via a custom scheduler if set") {
          var calledNoopScheduler = false
          var completed = false

          let noopScheduler: Scheduler = { _ in
            calledNoopScheduler = true
          }

          let performer = FakeRequestPerformer(responseData: .json([:]), background: false)
          let client = APIClient(requestPerformer: performer, scheduler: noopScheduler)

          client.perform(FakeRequest()) { _ in
            completed = true
          }

          expect(calledNoopScheduler) == true
          expect(completed) == false
        }
      }
    }
  }
}
