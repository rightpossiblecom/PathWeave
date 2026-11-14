# PathWeave — Release & Client Handoff Documentation

This document contains everything required to upload, sign, verify, update, and transfer **PathWeave** on Google Play Console.

---

## 1. Application Summary

| Field | Value |
| --- | --- |
| **App Name** | `PathWeave` |
| **Package ID / Application ID** | `com.pathweave.app` |
| **Version Name** | `1.0.0` |
| **Version Code (Build Number)** | `1` (`1.0.0+1` in `pubspec.yaml`) |
| **Category** | Games -> Puzzle |
| **Account / Login Required** | None (100% offline, zero data collection) |
| **Support Email** | `support@pathweave.app` |
| **Primary Seed Color** | `#0F766E` (Deep Teal / Mint Weave) |

---

## 2. Android Release Signing Credentials (JKS Key)

Both the release keystore and signing configuration are included directly in this repository and handoff bundle so future updates can be built and signed immediately without regenerating keys.

- **Keystore File (Release Backup):** `docs/release/pathweave-release.jks`
- **Keystore File (Active Gradle Path):** `android/app/pathweave-release.jks`
- **Key Properties File:** `android/key.properties` (backup copy in `docs/release/key.properties`)
- **Keystore Type / Algorithm:** RSA 2048-bit (`SHA384withRSA`), validity 10,000 days (until April 1, 2054)
- **Key Alias:** `pathweave`
- **Keystore Password (`storePassword`):** `pathweave123`
- **Key Password (`keyPassword`):** `pathweave123`
- **Distinguished Name (DN):** `CN=PathWeave, OU=PathWeave, O=PathWeave, L=Lagos, ST=Lagos, C=NG`
- **Certificate SHA-1:** `25:3B:E5:56:AD:C4:97:84:04:60:4D:31:DC:C3:E6:52:A8:0F:68:CC`
- **Certificate SHA-256:** `DF:78:A1:FA:52:31:65:8E:A4:9F:A4:32:BE:7C:EB:8E:9A:6C:ED:48:4A:93:01:15:05:FB:9C:35:CE:23:39:1A`

---

## 3. Release Artifacts & Store Assets

| Asset | Location | Notes |
| --- | --- | --- |
| **Signed Production App Bundle (AAB)** | `docs/release/app-release.aab` & `build/app/outputs/bundle/release/app-release.aab` | Built locally with `flutter build appbundle --release` and signed with `pathweave-release.jks`. *(Excluded from GitHub via `.gitignore` to keep the repo light; build anytime in one command below.)* |
| **App Icon (1024×1024 PNG)** | `assets/app_logo.png` | High-res Play Console icon + source for Android adaptive & iOS icons |
| **Feature Graphic (1024×500 PNG)** | `docs/release/featured_graphic_pathweave.png` | Ready for Google Play Store listing |
| **Store Listing Copy** | `docs/release/play_store_listing.txt` | Title, 76-char short description, plain-text full description, category, and Data Safety answers |
| **Privacy Policy** | `docs/release/privacy_policy.md` | Matches in-app Privacy Policy ("We do not collect any personal data") |

---

## 4. Rebuilding the Signed AAB Locally

```bash
flutter pub get
flutter build appbundle --release
```

The signed bundle is output to `build/app/outputs/bundle/release/app-release.aab`.  
To verify the signature at any time:

```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

---

## 5. Google Play Console Upload & Account Transfer Checklist

1. **Create App in Google Play Console**
   - App name: **PathWeave**
   - Default language: **English (United States) – en-US**
   - App or game: **Game**
   - Free or paid: **Free**
2. **Store Listing**
   - Copy Title, Short Description, and Full Description from `docs/release/play_store_listing.txt`.
   - Upload `assets/app_logo.png` (512×512 / 1024×1024 icon) and `docs/release/featured_graphic_pathweave.png` (1024×500 feature graphic).
3. **App Content Declarations**
   - **Privacy Policy:** Host `docs/release/privacy_policy.md` on your domain/Vercel URL and paste the link.
   - **App Access:** Select *"All functionality in my app is available without any access restrictions"* (no login required).
   - **Ads:** Select *"No, my app does not contain ads"*.
   - **Content Rating:** Complete questionnaire -> Game / Utility Puzzle -> No violence, no social features, no purchases.
   - **Target Audience:** 13+ / General audience.
   - **Data Safety:** Select *"No, my app does not collect or share any of the required user data types"*.
4. **Upload Production Bundle**
   - Go to **Test and release -> Production** (or **Internal testing** first), create a new release, and upload `app-release.aab`.
   - Play App Signing will verify the upload certificate (`SHA1: 25:3B:E5:56:AD:C4:97:84:04:60:4D:31:DC:C3:E6:52:A8:0F:68:CC`).
5. **Client Transfer**
   - Hand over the source ZIP (or GitHub repository `https://github.com/rightpossiblecom/PathWeave`) along with `docs/release/pathweave-release.jks` and `docs/release/key.properties`.
   - In Play Console (**Settings -> App transfer**), initiate transfer to the buyer's verified Play Console Developer Account using the target transaction ID once live.
