# BackgroundTasks
Apple has introduced the [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks) framework in iOS 13 to allow apps to run tasks in the background state to keep app content up to date.
Register launch handlers for tasks when the app launches and schedule them as required. The system will launch your app in the background and execute the tasks. The system decides the best time to launch your background task, and provides your app up to 30 seconds off background runtime. Complete your work within this time period and ACK, or the system terminates your app.

# BGTasks
[![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org)
[![CocoaPods](https://img.shields.io/cocoapods/v/BGTasks.svg)](https://github.com/PhonePe/BGTasks)

A wrapper over iOS provided **BackgroundTasks** framework to ensure smooth onboarding of use cases and handle all the complex functionalities of **BackgroundTasks** within it.
Functionalities provided in the framework are:
- Integrate or register a use case for background sync/refresh with ease. 
- Handled all complex registration and callbacks mechanisms provided by OS. 
- Prioritising use cases based on:
  - Strategy [everyTime, onceADayAnyTime, every4Hours, every12Hours, every24Hours]
  - Callbacks are given to use case based on the threshold or elapsed time-interval from the last sync time.
- In-built analytics support to know how many tasks were scheduled, launched and completed. This also given data on a use case level. 

## API usage
#### Framework Initialisation
```swift
import BGTasks

let permittedIdentifiers: [BGTaskSchedulerType: String] = [
    .appRefreshTask: "com.app.refresh.task",
    .processingTaskWithConnectivityWithExternalPower: "com.processing.task.with.connect.with.power",
    .processingTaskWithConnectivityWithoutExternalPower: "com.processing.task.with.connect.no.power",
    .processingTaskWithoutConnectivity: "com.processing.task.no.connectivity"
]
let config = BGConfigurationProvider.RegistrationData(permittedIdentifiers: permittedIdentifiers)
BGConfigurationProvider.shared.configure(config: config)
```
All the identifiers must be added into the project's `Info.plist` under `BGTaskSchedulerPermittedIdentifiers` key.

#### Use-case registration
```swift
import BGTasks

let data = BGSyncRegistrationData(
    identifier: "<unique-id>",
    configuration: .init(strategy: .everyTime,
                         requiresNetworkConnectivity: true)) { completion in
    //perform and call completion.
    completion(true)
}
BGFrameworkFactory.registrationController().registerSyncItem(data)
```

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate BGTasks into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'BGTasks', '~> 1.0.2'
```

# Credits
[Shridhar](https://twitter.com/shridhar91),
[Srikanth KV](https://twitter.com/SrikanthVKabadi)
