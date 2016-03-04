import Foundation
import Argo
import Result

/**
  Used to represent a request that doesn't return any JSON.
*/
public typealias EmptyResponse = Void

/// An abstract object representing an interaction with a specific endpoint.
public protocol Request {
  /**
    The object that the endpoint is expected to return.
  */
  typealias ResponseObject

  /**
    Build an instance of `NSURLRequest` that hits the specific endpoint.

    - returns: A constructed `NSURLRequest`.
  */
  func build() -> NSURLRequest

  /**
    Parse the endpoint's response JSON into a model object.

    - parameter j: The `JSON` from the server.

    - returns: A `Result` type of either the specified `ResponseObject`, or an
               `NSError`.
  */
  func parse(j: JSON) -> Result<ResponseObject, NSError>
}

public extension Request where ResponseObject: Decodable, ResponseObject.DecodedType == ResponseObject {
  /**
    Parse `JSON` response into a `Decodable` object.

    This is a default implemtnation for `parse` that provides basic support for
    parsing a `Decodable` object. It assumes no root key, and no specialized
    transformations.

    - parameter j: The `JSON` from the server.

    - returns: A `Result` type of either the parsed `Decodable` object, or an
               `NSError`.
  */
  func parse(j: JSON) -> Result<ResponseObject, NSError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject: CollectionType, ResponseObject.Generator.Element: Decodable, ResponseObject.Generator.Element.DecodedType == ResponseObject.Generator.Element {
  /**
    Parse `JSON` into an array of `Decodable` objects.

    This is a default implementation for `parse` that provides basic support
    for parsing a collection of `Decodable` objects. It assumes no root key,
    and no specialized transformations.

    - parameter j: The `JSON` from the server.

    - returns: A `Result` type of either the parsed array of `Decodable`
               objects, or an `NSError`.
  */
  func parse(j: JSON) -> Result<[ResponseObject.Generator.Element], NSError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject == EmptyResponse {
  /**
    Parse an empty response.

    This is a default implementation for `parse` for empty responses.

    Since there is nothing to actually parse here, we can just return
    `.Success`.

    - parameter j: The `JSON` from the server. This value is ignored.

    - returns: An empty success case: `.Success()`.
  */
  func parse(_: JSON) -> Result<ResponseObject, NSError> {
    return .Success()
  }
}
