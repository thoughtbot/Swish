# Advanced Usage #

What if the endpoints you need to query don't return JSON? Perhaps you have an
endpoint, `GET https://www.example.com/isAuthorized` that returns a `200 OK`
with `"yes"` or `"no"` as a response body. We'll have to do a few things:

- Define a custom `ResponseParser` to provide to our `Request` object, because
the default one parses `JSON`.
- Define a custom `Deserializer` to provide to our `APIClient`, because the 
default one uses `JSONSerialization`.

We'll start with the custom `Deserializer`. It will simply pass along the 
`Data` if it exists:

```swift
struct DataDeserializer: Deserializer {
  func deserialize(_ data: Data?) -> Result<Any, SwishError> {
    guard let data = data, !data.isEmpty else {
      return .success(NSNull())
    }

    return .success(data)
  }
}
```

Then, our custom `ResponseParser` will use `String(data:encoding:)` to
transform the incoming `Data` to a `String` representation:

```swift
import Swish

enum StringParserError: Error {
  case badData(Any)
  case invalidUTF8(Data)
  case unexpectedResponse(String)
}

struct StringParser: Parser {
  typealias Representation = String

  static func parse(_ object: Any) -> Result<String, SwishError> {
    guard let data = object as? Data else {
      return .failure(.parseError(StringParserError.badData(object)))
    }

    guard let string = String(data: data, encoding: .utf8) else {
      return .failure(.parseError(StringParserError.invalidUTF8(data)))
    }

    return .success(string)
  }
}
```

Finally, our `Request` will convert the `String` into a `Bool`:

```swift
struct AuthorizedRequest: Request {
  typealias ResponseObject = Bool
  typealias ResponseParser = StringParser

  func build() -> URLRequest {
    let endpoint = URL(string: "https://www.example.com/isAuthorized")!
    return URLRequest(url: endpoint)
  }

  func parse(_ string: String) -> Result<Bool, SwishError> {
    switch string {
    case "yes":
      return .success(true)
    case "no":
      return .success(false)
    default:
      return .failure(.parseError(StringParserError.unexpectedResponse(string)))
    }
  }
}
```

Now, we're ready to make our request:

```swift
let client = APIClient(
  requestPerformer: NetworkRequestPerformer(),
  deserializer: DataDeserializer()
)
let isAuthorizedRequest = AuthorizedRequest()

client.perform(isAuthorizedRequest) { result in
  switch result {
  case .success(true):
    // authorized
  case .success(false):
    // not authorized
  case let .failure(error):
    // handle the error
  }
}
```

A simplyfing change we could make would be to implement `Parser` whose `Representation` would be `Bool`, rather than `String`, allowing us to avoid overriding the `parse` function in `AuthorizedRequest`. We'll leave that as an exercise to the reader!
