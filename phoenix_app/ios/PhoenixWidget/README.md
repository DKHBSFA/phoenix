# PhoenixWidget — Xcode Setup Required

The Swift source files in this directory are ready. To activate the widget extension, the Xcode project must be configured manually:

## Steps

1. Open `ios/Runner.xcworkspace` in Xcode (not the `.xcodeproj`)

2. Add a new target:
   - File → New → Target → Widget Extension
   - Product Name: `PhoenixWidget`
   - Language: Swift
   - Uncheck "Include Configuration Intent"
   - When prompted to activate the scheme, click Cancel (keep Runner active)

3. Point the target at this directory:
   - In the PhoenixWidget target → Build Settings → find your source files
   - Xcode will have created its own stubs — delete them and add the files from this folder instead

4. Enable App Groups capability:
   - Select Runner target → Signing & Capabilities → + Capability → App Groups
   - Add group: `group.phoenix.widget`
   - Repeat for PhoenixWidget target

5. Verify the widget extension's bundle ID follows the pattern:
   `<your.runner.bundle.id>.PhoenixWidget`

6. Build and run on device to confirm the widget appears in the widget gallery.

## Data Keys

The widget reads from UserDefaults shared via app group `group.phoenix.widget`.

| Key | Type | Description |
|-----|------|-------------|
| `phoenix_protocol_done` | Int | Completed protocol steps today |
| `phoenix_protocol_total` | Int | Total protocol steps (default 6) |
| `phoenix_steps` | Int | Daily step count from ring |
| `phoenix_level_number` | Int | Current Phoenix level number |
| `phoenix_level_name` | String | Level display name |
| `phoenix_next_step` | String | Next recommended action |
| `phoenix_sleep_done` | Bool | Sleep protocol completed |
| `phoenix_training_done` | Bool | Training completed |
| `phoenix_fasting_done` | Bool | Fasting completed |
| `phoenix_cold_done` | Bool | Cold exposure completed |
| `phoenix_meditation_done` | Bool | Meditation completed |
| `phoenix_hrv_ms` | Double | Latest HRV reading in ms |
| `phoenix_recovery` | String | Recovery status label |
| `phoenix_sleep_summary` | String | Sleep summary text |

These keys must be written from the Flutter side via `home_widget` using the same app group.
