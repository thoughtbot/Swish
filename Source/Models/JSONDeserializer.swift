import Argo
import Result

struct JSONDeserializer: Deserializer {
  func deserialize(data: NSData?) -> Result<AnyObject, SwishError> {
    let json = self.parseJSON(data)

    return json.analysis(
      ifSuccess: Result<AnyObject, SwishError>.init,
      ifFailure: { .Failure(.InvalidJSONResponse($0)) }
    )
  }
}

extension JSON: Parser {
  public typealias Representation = JSON

  public static func parse(j: AnyObject) -> Result<JSON, SwishError> {
    return Result(JSON.init(j))
  }
}

private extension JSONDeserializer {
  private func parseJSON(data: NSData?) -> Result<AnyObject, NSError> {
    guard let d = data where d.length > 0 else {
      return .Success(NSNull())
    }

    return Result(
      try NSJSONSerialization
        .JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0))
    )
  }
}
