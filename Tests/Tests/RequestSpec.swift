import Swish
import Quick
import Nimble
import Result

struct User: Decodable {
  let name: String
}

struct DecodableRequest: Request {
  typealias ResponseObject = User

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "https://example.com")!)
  }
}

struct DecodableCollectionRequest: Request {
  typealias ResponseObject = [User]

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "https://example.com")!)
  }
}

struct EmptyResponseRequest: Request {
  typealias ResponseObject = EmptyResponse

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "https://example.com")!)
  }
}

func json(_ string: String) -> Data {
  return string.data(using: .utf8)!
}

class RequestSpec: QuickSpec {
  override func spec() {
    describe("Request") {
      describe("default parse implementation") {
        context("when the ResponseObject is decodable") {
          it("decodes the response as json") {
            let request = DecodableRequest()
            let result = try? request.parse(json(
              """
              { "name": "gvg" }
              """
            ))

            expect(result?.name).to(equal("gvg"))
          }
        }

        context("when the ResponseObject is a collection type of decodable objects") {
          it("decodes the collection as a json array") {
            let request = DecodableCollectionRequest()
            let result = try? request.parse(json(
              """
              [
                { "name": "giles" },
                { "name": "gordon" }
              ]
              """
            ))

            expect(result?.count).to(equal(2))
            expect(result?.first?.name).to(equal("giles"))
          }
        }

        context("when the ResponseObject is an EmptyResponse") {
          it("should result in Success") {
            let request = EmptyResponseRequest()
            expect { try request.parse(Data()) }.toNot(throwError())
          }
        }
      }

      describe("custom parse implementation") {
        it("uses the custom parse function instead of json") {
          let request = FakeStringRequest()
          let data = "Hello, world!".data(using: .utf8)!

          expect { try request.parse(data) }.to(equal("Hello, world!"))
        }

        it("wraps any custom error if parsing fails") {
          let request = FakeStringRequest()
          let data = "Hello, world!".data(using: .utf16)!

          expect { try request.parse(data) }.to(throwError(FakeError(message: "invalid UTF-8")))
        }
      }
    }
  }
}
