// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import PackageDescription

let package = Package(
  name: "InteropForGoogle",
  platforms: [.iOS(.v11), .macCatalyst(.v13), .macOS(.v10_13), .tvOS(.v12), .watchOS(.v7)],
  products: [
    .library(
      name: "RecaptchaInterop",
      targets: ["RecaptchaInterop"]
    ),
  ],
  targets: [
    .target(
      name: "RecaptchaInterop",
      path: "RecaptchaEnterprise/RecaptchaInterop",
      publicHeadersPath: "Public"
    ),
  ]
)
