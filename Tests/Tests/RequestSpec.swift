@testable import Swish
import Argo
import Quick
import Nimble
import Result

struct User: Decodable {
  let name: String

  static func decode(json: JSON) -> Decoded<User> {
    return User.init <^> json <| "name"
  }
}

struct DecodableRequest: Request {
  typealias ResponseObject = User

  func build() -> NSURLRequest {
    return NSURLRequest()
  }
}

struct DecodableCollectionRequest: Request {
  typealias ResponseObject = [User]

  func build() -> NSURLRequest {
    return NSURLRequest()
  }
}

struct EmptyResponseRequest: Request {
  typealias ResponseObject = EmptyResponse

  func build() -> NSURLRequest {
    return NSURLRequest()
  }
}

class RequestSpec: QuickSpec {
  override func spec() {
    describe("Request") {
      describe("default parse implementation") {
        context("when the ResponseObject is decodable") {
          let request = DecodableRequest()
          let json = JSON.parse(["name": "gvg"])
          let result = request.parse(json)

          expect(result.value?.name).to(equal("gvg"))
        }

        context("when the ResponseObject is a collection type of decodable objects") {
          let request = DecodableCollectionRequest()
          let json = JSON.parse([
            ["name": "giles"],
            ["name": "gordon"]
          ])
          let result = request.parse(json)

          expect(result.value?.count).to(equal(2))
          expect(result.value?.first?.name).to(equal("giles"))
        }

        context("when the ResponseObject is an EmptyResponse") {
          it("should result in Success") {
            let request = EmptyResponseRequest()
            let result = request.parse(.Null)

            expect(result).to(beSuccessful())
          }
        }
      }
    }
  }
}
