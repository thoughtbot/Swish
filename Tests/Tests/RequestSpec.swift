import Swish
import Argo
import Quick
import Nimble
import Result
import Runes

struct User: Argo.Decodable {
  let name: String

  static func decode(_ json: JSON) -> Decoded<User> {
    return User.init <^> json <| "name"
  }
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

class RequestSpec: QuickSpec {
  override func spec() {
    describe("Request") {
      describe("default parse implementation") {
        context("when the ResponseObject is decodable") {
          it("decodes the response as json") {
            let request = DecodableRequest()
            let json = JSON(["name": "gvg"])
            let result = request.parse(json)

            expect(result.value?.name).to(equal("gvg"))
          }
        }

        context("when the ResponseObject is a collection type of decodable objects") {
          it("decodes the collection as a json array") {
            let request = DecodableCollectionRequest()
            let json = JSON([
              ["name": "giles"],
              ["name": "gordon"]
            ])
            let result = request.parse(json)

            expect(result.value?.count).to(equal(2))
            expect(result.value?.first?.name).to(equal("giles"))
          }
        }

        context("when the ResponseObject is an EmptyResponse") {
          it("should result in Success") {
            let request = EmptyResponseRequest()
            let result = request.parse(JSON.null)

            expect(result).to(beSuccessful())
          }
        }
      }
    }
  }
}
