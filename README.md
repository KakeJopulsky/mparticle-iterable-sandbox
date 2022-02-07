# mparticle-iterable-sandbox
Sandbox application built with Iterable's mParticle Kit

## Installation

Use the package manager [Cocoa Pods](https://cocoapods.org/) to install the deps listed in the PodFile.

```bash
pip install
```

## Configuration

1. Setup an iOS input in mParticle in mParticle, and obtain the mParticle Key and Secret
  - Setup your Iterable project as an output
2. Input the keys in `MParticleManager.swift`

```swift
private static let mParticleKey = "<MPARTICLE_KEY>"
private static let mParticleSecret = "<API_SECRET>"
```
3. Setup [push notifications](https://support.iterable.com/hc/en-us/articles/115000315806-Setting-up-iOS-Push-Notifications-) on your Iterable project.

4. Connect your iOS device and run the application. 

