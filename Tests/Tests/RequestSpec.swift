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
            let result = request.parse(json(
              """
              { "name": "gvg" }
              """
            ))

            expect(result.value?.name).to(equal("gvg"))
          }
        }

        context("when the ResponseObject is a collection type of decodable objects") {
          it("decodes the collection as a json array") {
            let request = DecodableCollectionRequest()
            let result = request.parse(json(
              """
              [
                { "name": "giles" },
                { "name": "gordon" }
              ]
              """
            ))

            expect(result.value?.count).to(equal(2))
            expect(result.value?.first?.name).to(equal("giles"))
          }
        }

        context("when the ResponseObject is an EmptyResponse") {
          it("should result in Success") {
            let request = EmptyResponseRequest()
            let result = request.parse(Data())

            expect(result).to(beSuccessful())
          }
        }
      }
    }
  }
}
