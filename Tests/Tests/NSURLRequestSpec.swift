import Swish
import Quick
import Nimble

class NSURLRequestSpec: QuickSpec {
  override func spec() {
    describe("jsonPayload") {
      context("when given an encodable object") {
        it("serializes and deserializes correctly") {
          let urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
          urlRequest.jsonPayload = ["ids": [0, 1, 2]]

          let payloadFromRequest = urlRequest.jsonPayload as? [String: AnyObject]
          let ids = payloadFromRequest?["ids"] as? [Int]

          expect(ids).to(equal([0, 1, 2]))
        }
      }

      context("when given an encodable array") {
        it("serializes and deserializes correctly") {
          let urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
          urlRequest.jsonPayload = [["id": 1]]

          let payloadFromRequest = urlRequest.jsonPayload as? [[String: AnyObject]]
          let item = payloadFromRequest?[0]["id"] as? Int

          expect(item).to(equal(1))
        }
      }

      context("when the HTTPBody cannot be decoded") {
        it("returns an empty dictionary") {
          let urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.example.com")!)
          urlRequest.HTTPBody = NSData()

          let payloadFromRequest = urlRequest.jsonPayload as? [String: AnyObject]

          expect(payloadFromRequest?.count).to(equal(0))
        }
      }
    }
  }
}
