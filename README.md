# OpenWhiskAction
Swift Package for wrapping Swift functions to support execution as OpenWhisk actions

## installation

Install the package by adding the dependency to `Package.swift`.

```swift
let package = Package(
    name: "Action",
    dependencies: [
        .Package(url: "https://github.com/jthomas/OpenWhiskAction.git", majorVersion: 0)
    ]
)
```

## usage

This package exposes a public function (`OpenWhiskAction` ) that should be called with a function reference (`([String: Any]) -> [String: Any])`) as a named parameter (`main`). The callback will be executed with the invocation parameters. Returned values will be serialised to as the invocation response.

```swift
import OpenWhiskAction

func hello(args: [String:Any]) -> [String:Any] {
    if let name = args["name"] as? String {
      return [ "greeting" : "Hello \(name)!" ]
    } else {
      return [ "greeting" : "Hello stranger!" ]
    }
}

OpenWhiskAction(main: hello)
```

This source file should be compiled into a binary for deployment to OpenWhisk.

## compiling with docker

OpenWhisk actions for the Swift runtime use a [custom Docker image]() as the runtime environment. Compiling the application binary using this image will ensure it is compatible with the platform runtime. 

This command will run the `swift build` system within a container from this image. The host filesystem is mounted into the container at `/swift-package`. Binaries and other build artifacts will be available in `./.build/release/` after the command has executed.

```
docker run --rm -it -v $(pwd):/swift-package openwhisk/swift3action bash -e -c "cd /swift-package && swift build -v -c release"
```

## deploying to openwhisk

OpenWhisk actions can be created from a zip file containing the action artifacts. The zip file will be expanded prior to execution. In the Swift environment, the compiled Swift binary executed by the platform is expected to be at `./.build/release/Action`. 

If an action is deployed from a zip file which contains this file, the runtime will execute this binary rather than compiling a new binary from source code within the zip file.

```sh
$ zip action.zip .build/release/Action
  adding: .build/release/Action (deflated 67%)
$ wsk action create swift-action --kind swift:3 action.zip
ok: created action swift-action
$ wsk action invoke --blocking --result -p name "Bernie Sanders" swift-action
{
    "greeting": "Hello Bernie Sanders!"
}
```