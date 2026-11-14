# K9OKibo

Official Swift SDK for [Kilimanjaro](#74-about-kilimanjaro) Kibo.
Zero-knowledge encryption for iOS and macOS: encrypt and decrypt on the device with your own key management service (KMS).

## Contents

**A. Get started**

1. [Links](#1-links)
2. [Install](#2-install)
3. [Choose the right package](#3-choose-the-right-package)
4. [Requirements](#4-requirements)
5. [Quick start](#5-quick-start)

**B. Troubleshoot**

6. [Handle errors](#6-handle-errors)

**C. Reference**

7. [Appendix](#7-appendix)
   - 7.1 [Error fields](#71-error-fields)
   - 7.2 [Functions](#72-functions)
   - 7.3 [Related packages](#73-related-packages)
   - 7.4 [About Kilimanjaro](#74-about-kilimanjaro)
8. [License](#8-license)

## A. Get started

### 1. Links

- Website: <https://kilimanjaro.dev>
- Documentation / Developer Hub: <https://docs.kilimanjaro.dev>
- Open source
  - Platform: <https://github.com/k9o-platform>
  - Community: <https://github.com/k9o-community>

### 2. Install

```swift
dependencies: [
    .package(url: "https://github.com/k9o-platform/sdk-kibo-swift.git", from: "1.5.2"),
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "K9OKibo", package: "sdk-kibo-swift"),
        ]
    ),
]
```

### 3. Choose the right package

| Package | Use it when you are… | Registry | Source |
| --- | --- | --- | --- |
| `K9OCore` | Calling the platform from an iOS or macOS app as a signed-in user. | Swift Package Manager (resolves from the repository) | [sdk-swift](https://github.com/k9o-platform/sdk-swift) |
| `K9OGate` | Signing users in: sign in, refresh and sign out, with the refresh token kept in the Keychain. | Swift Package Manager (resolves from the repository) | [sdk-swift](https://github.com/k9o-platform/sdk-swift) |
| `K9OKibo` | Encrypting and decrypting on the device with a key in your own KMS. | Swift Package Manager (resolves from the repository) | [sdk-kibo-swift](https://github.com/k9o-platform/sdk-kibo-swift) |
| `K9OBarbican` | Checking model input and redacting model output on the device. | Swift Package Manager (resolves from the repository) | [sdk-barbican-swift](https://github.com/k9o-platform/sdk-barbican-swift) |

### 4. Requirements

- iOS 15 or later, or macOS 12 or later
- Swift 5.9 or later

### 5. Quick start

Encryption and decryption run on the device, against your KMS. The platform never sees plaintext or unwrapped keys.

```swift
import K9OKibo

let output = try await encrypt(input)
```

`input` is an `EncryptInput`. `output` is an `EncryptOutput` holding an opaque envelope.

Keep the envelope yourself; it means nothing to the platform.

Decrypt it later with a `DecryptInput`:

```swift
let plaintext = try await decrypt(decryptInput)
```

The strategy, attestation tier and encryption context must match the values used to encrypt.
They are bound to the envelope and are not read back from it.

See the [functions](#72-functions).

[↑ Back to Contents](#contents)

## B. Troubleshoot

### 6. Handle errors

Both functions throw `K9OKiboError`.

```swift
do {
    _ = try await encrypt(input)
} catch K9OKiboError.upstreamKms(let message) {
    print("Your KMS reported: \(message)")
} catch {
    print("Encryption failed: \(error.localizedDescription)")
}
```

See all [error cases](#71-error-fields).

[↑ Back to Contents](#contents)

## C. Reference

### 7. Appendix

- [Error fields](#71-error-fields)
- [Functions](#72-functions)
- [Related packages](#73-related-packages)
- [About Kilimanjaro](#74-about-kilimanjaro)

#### 7.1 Error fields

| Case | Meaning |
|---|---|
| `.platform(code:message:)` | A platform error with a `K9O_*` code |
| `.upstreamKms(message:)` | Your own KMS returned an error |
| `.postureViolation(code:message:dimension:requested:declared:)` | The requested security posture is below the project's declared floor |

The code of a `.postureViolation` is `K9O_CRYPTO_POSTURE_FLOOR_VIOLATION`.

#### 7.2 Functions

| Function | Meaning |
|---|---|
| `encrypt(_:)` | Takes an `EncryptInput`; returns an `EncryptOutput` |
| `decrypt(_:)` | Takes a `DecryptInput`; returns a `DecryptOutput` |

Both are `async throws`. The input and output types come from the cryptographic core that this package wraps.

#### 7.3 Related packages

| Package | What it does |
|---|---|
| `K9OGate` | Signs end users in; in the `sdk-swift` package |
| `K9OCore` | Project-plane client; in the `sdk-swift` package |

#### 7.4 About Kilimanjaro

Kilimanjaro is a modular developer platform for building secure enterprise applications.
You define AI agents, functions and data pipelines on the platform.
The SDKs let you deploy and invoke them, read and write your data, publish to and subscribe to streams, sign users in, and encrypt with keys you hold.

It provides four building blocks:

- **Keep**: AI security and governance. Guardrails and policy for the agents you run.
- **Pulse**: data intelligence and real-time stream processing. Streams, analytics and live feeds.
- **Gate**: customer identity and access management. Sign-in and sessions, and automatic data scoping so a signed-in user reaches only their own data.
- **Kibo**: cryptographic keys and secrets management. Client-side encryption with keys you hold, and a secrets vault.

### 8. License

Apache-2.0 © Formelo Inc. See `LICENSE` and `NOTICE`.

[↑ Back to Contents](#contents)
