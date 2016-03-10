import Result

public protocol Parser {
  associatedtype Representation

  static func parse(j: AnyObject) -> Result<Representation, SwishError>
}
