# Protocols #

This documents each public protocol's intended use and the defaults for each that come built in to Swish.

At a  high level, here's what goes on:

* A `Client` is told to perform a `Request`, which is done via the `RequestPerformer`.
* The `RequestPerformer` will ensure it has a valid HTTP response code, and if so, hand the `Data` from the `HTTPResponse` to the `Deserializer`.
* The `Deserializer` will convert this `Data` into a `Representation`, which is specified by the `Request`'s `ResponseParser`. The idea here is that the `Deserializer` can convert `Data` into an intermediary form that can then be parsed into the `ResponseObject`.

In diagram form:

```swift
Request —— RequestPerformer.perform —————————> Data
        —— Deserializer.deserialize —————————> Any
        —— Parser.parse —————————————————————> Parser.Representation
        —— Request.parse ————————————————————> Request.ResponseObject
```

When translated into the concrete types given by the Swish defaults:

```swift
Request —— NetworkRequestPerformer.perform —————————> Data
        —— JSONDeserializer.deserialize ————————————> Any
        —— JSON.parse ——————————————————————————————> JSON
        —— Request.parse ———————————————————————————> Request.ResponseObject
```

### Request ###

The `Request` protocol models a requestable object (for example, a JSON endpoint). In addition, it defines two associated types:

- A `ResponseObject` that defines what type of object to expect back from the request.
- A `ResponseParser` that conforms to the `Parser` protocol, which provides a way to go from `Any` into the `Parser.Representation`.

It is the job of a `Request` to convert from the `Parser.Representation` into the `ResponseObject`. It does the via the `parse` function.

### Parser ###
The `Parser` protocol defines a way to convert `Any` into a `Representation`. This `Representation` is then fed into the `Request.parse` function to produce a `ResponseObject`.

### Deserializer ###
The `Deserializer` protocol defines a way to convert `Data?` into `Any`. The `Any` can then be fed into `Request.ResponseParser.parse`.

### Client ###

The `Client` protocol defines the core `perform` method that handles tying the other protocols together. It requires an object of type `Deserializer` that is responsible for dealing with the response's `Data`.

The provided `Client` in Swish is `APIClient`. `APIClient` is instantiated (by default) with a `NetworkRequestPerformer` and a `JSONDeserializer`.

### RequestPerformer ###

The `RequestPerformer` protocol defines the layer that actually performs the raw networking.

The default `RequestPerformer` is `NetworkRequestPerformer` that makes network requests via `URLSession`.
