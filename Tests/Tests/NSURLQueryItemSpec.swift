import Swish
import Quick
import Nimble

class NSURLQueryItemSpec: QuickSpec {
  override func spec() {
    describe("initAndEncode") {
      it("returns a query item with URL encoded entries") {
        let result = NSURLQueryItem.initAndEncode("key", value: "value=&")

        expect(result?.name).to(equal("key"))
        expect(result?.value).to(equal("value%3D%26"))
      }
    }

    describe("decode") {
      it("decodes into a list of NSURLQueryItems") {
        let queryString = "firstKey=firstValue&secondKey=secondValue%3D%26"
        let data = queryString.dataUsingEncoding(NSUTF8StringEncoding)

        let result = NSURLQueryItem.decode(data)

        let first = result.first
        expect(first?.name).to(equal("firstKey"))
        expect(first?.value).to(equal("firstValue"))

        let second = result.last
        expect(second?.name).to(equal("secondKey"))
        expect(second?.value).to(equal("secondValue=&"))
      }
    }
  }
}
