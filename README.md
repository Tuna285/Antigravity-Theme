# Kanagawa Theme for Google Antigravity 2.x

[🇻🇳 Tiếng Việt](#tiếng-việt) | [🇺🇸 English](#english)

### Preview / Xem trước

![Kanagawa Theme Home & Aqua-to-Gold Composer](docs/screenshots/kanagawa-home.png)
*Kanagawa Wave default wallpaper & aqua-to-gold gradient composer / Hình nền Kanagawa mặc định & khung nhập gradient xanh ↔ vàng.*

| Custom Wallpaper + Review Panel | Custom Avatars + Diff View |
| :---: | :---: |
| ![Custom Wallpaper & Review Panel](docs/screenshots/custom-wallpaper-review.png) | ![Custom Avatars & Right Diff Panel](docs/screenshots/custom-avatars-diff.png) |
| *Custom wallpaper, 3-column translucent layout & file review* | *Custom user/agent avatars & translucent red/green code diff* |

---

<a name="tiếng-việt"></a>
## 🇻🇳 Tiếng Việt

Theme **Kanagawa Wave (Tối)** & **Kanagawa Lotus (Sáng)** cho **Google Antigravity 2.x** trên Windows — nền ảnh sắc nét không blur, các khung panel bo tròn trong suốt vừa đủ, màn hình loading phong cách Kanagawa, khung chat gradient xanh ↔ vàng và bộ công cụ cho phép người dùng tự đổi **hình nền**, **màu theme / preset** và **cả 2 avatar** chỉ trong vài giây.

### Yêu cầu

- **Windows** đã cài **Google Antigravity 2.x** (`%LOCALAPPDATA%\Programs\Antigravity`)
- **Node.js** (để script chạy `@electron/asar` giải nén/đóng gói `app.asar` và xử lý ảnh/màu)

### Cài đặt

1. Tải repo về máy:
   ```powershell
   git clone https://github.com/Tuna285/Antigravity-Theme.git
   cd Antigravity-Theme
   ```
2. Đóng hoàn toàn Antigravity (hoặc mở **PowerShell ở ngoài**, không chạy trong terminal bên trong Antigravity, rồi dùng cờ `-KillRunning`):
   ```powershell
   .\install.ps1 -KillRunning
   ```
   *(Hoặc đóng Antigravity hoàn toàn rồi click đúp `install.bat`.)*
3. Mở lại Antigravity để dùng theme và màn hình loading mới.

> **Lưu ý:** Khi Antigravity tự cập nhật phiên bản mới, file `app.asar` sẽ trở về bản gốc. Bạn chỉ cần chạy lại `.\install.ps1 -KillRunning` là theme hoạt động lại bình thường.

### Tùy biến dễ dàng (Hình nền, Màu theme & 2 Avatar)

Không cần mở hay tự sửa file `kanagawa.css` nặng hay tự chuyển ảnh sang Base64.

- **Cách 1 — Menu tương tác / Click đúp:** Click đúp **`customize-kanagawa.bat`** hoặc chạy:
  ```powershell
  .\customize-kanagawa.ps1 -Menu

  # Hoặc chọn thẳng từng file ảnh qua hộp thoại Windows Explorer:
  .\customize-kanagawa.ps1 -PickWallpaper
  .\customize-kanagawa.ps1 -PickUserAvatar
  .\customize-kanagawa.ps1 -PickAgentAvatar
  ```
- **Cách 2 — Dùng tham số dòng lệnh / Preset màu có sẵn:**
  ```powershell
  # Đổi nhanh 12 preset màu có sẵn:
  # kanagawa-wave | kanagawa-dragon | sakura-dusk | midnight-aqua | catppuccin-mocha | rose-pine | tokyo-night | nord-frost | everforest | gruvbox-warm | vesper-minimal | oxocarbon
  .\customize-kanagawa.ps1 -Preset catppuccin-mocha

  # Truyền thẳng đường dẫn ảnh (hỗ trợ png, jpg, jpeg, webp, svg, gif, bmp)
  .\customize-kanagawa.ps1 -Wallpaper "D:\Pictures\bg.jpg" -UserAvatar "D:\Pictures\me.png" -AgentAvatar "D:\Pictures\bot.png"

  # Tắt hình nền (dùng nền màu trơn theo preset)
  .\customize-kanagawa.ps1 -NoWallpaper
  ```
- **Cách 3 — Sửa file cấu hình:** Chỉnh mã màu hex, đường dẫn ảnh (đặt `"wallpaper": "NONE"` để tắt hình nền) hoặc chữ trên màn hình loading trong `kanagawa-theme/kanagawa.config.json`, sau đó chạy:
  ```powershell
  .\customize-kanagawa.ps1
  ```

Mỗi lần tùy biến sẽ tự cập nhật `kanagawa-theme/kanagawa.css`, `kanagawa-theme/loading.html`, đồng bộ sang Antigravity và tự reload giao diện ngay lập tức (**không cần đóng gói lại `app.asar`**).

### Reload & Gỡ cài đặt

- **Đồng bộ & reload thủ công:** `.\switch-theme.ps1` (hoặc click đúp `switch-theme.bat`)
- **Gỡ theme & khôi phục Antigravity gốc:**
  ```powershell
  .\uninstall.ps1 -KillRunning
  ```

---

<a name="english"></a>
## 🇺🇸 English

A crisp, unblurred **Kanagawa Wave (Dark)** & **Kanagawa Lotus (Light)** theme for **Google Antigravity 2.x** on Windows — featuring rounded translucent panes, a Kanagawa wave startup loading screen, aqua-to-gold composer gradient, and a built-in customizer to swap your **wallpaper**, **color palette / presets**, and **both chat avatars** in seconds.

### Requirements

- **Windows** with **Google Antigravity 2.x** installed (`%LOCALAPPDATA%\Programs\Antigravity`)
- **Node.js** (used for `@electron/asar` extraction/repacking and image/color customization)

### Installation

1. Clone this repository:
   ```powershell
   git clone https://github.com/Tuna285/Antigravity-Theme.git
   cd Antigravity-Theme
   ```
2. Close Antigravity completely (or run from an **external PowerShell** window with `-KillRunning`):
   ```powershell
   .\install.ps1 -KillRunning
   ```
   *(Or close Antigravity completely and double-click `install.bat`.)*
3. Launch Antigravity.

> **Note:** Antigravity auto-updates overwrite `app.asar` with the stock bundle. Simply re-run `.\install.ps1 -KillRunning` after an update to restore the theme.

### Easy Customization (Wallpaper, Colors, & 2 Avatars)

No need to manually edit `kanagawa.css` or Base64-encode images.

- **Option A — Interactive Menu / File Picker:** Double-click **`customize-kanagawa.bat`** or run:
  ```powershell
  .\customize-kanagawa.ps1 -Menu

  # Or pick files directly via Windows Explorer dialog:
  .\customize-kanagawa.ps1 -PickWallpaper
  .\customize-kanagawa.ps1 -PickUserAvatar
  .\customize-kanagawa.ps1 -PickAgentAvatar
  ```
- **Option B — CLI Presets & Image Paths:**
  ```powershell
  # Switch among 12 built-in presets:
  # kanagawa-wave | kanagawa-dragon | sakura-dusk | midnight-aqua | catppuccin-mocha | rose-pine | tokyo-night | nord-frost | everforest | gruvbox-warm | vesper-minimal | oxocarbon
  .\customize-kanagawa.ps1 -Preset catppuccin-mocha

  # Pass image paths directly (png, jpg, jpeg, webp, svg, gif, bmp)
  .\customize-kanagawa.ps1 -Wallpaper "D:\Pictures\bg.jpg" -UserAvatar "D:\Pictures\me.png" -AgentAvatar "D:\Pictures\bot.png"

  # Disable wallpaper (use solid preset background color)
  .\customize-kanagawa.ps1 -NoWallpaper
  ```
- **Option C — Edit Config File:** Edit hex colors, image paths (set `"wallpaper": "NONE"` to disable wallpaper), or loading screen text in `kanagawa-theme/kanagawa.config.json`, then run:
  ```powershell
  .\customize-kanagawa.ps1
  ```

Every change regenerates `kanagawa-theme/kanagawa.css` & `kanagawa-theme/loading.html`, syncs to Antigravity, and hot-reloads the window without restarting (**no `app.asar` repack needed after initial install**).

### Reload & Uninstall

- **Manual sync & hot-reload:** `.\switch-theme.ps1` (or double-click `switch-theme.bat`)
- **Uninstall & restore stock Antigravity:**
  ```powershell
  .\uninstall.ps1 -KillRunning
  ```

---

## Credits / Nguồn tham khảo

- Theme injector, Chrome DevTools hot-reload workflow, and `app.asar` patcher architecture derived from [AreSet01/antigravity-theme](https://github.com/AreSet01/antigravity-theme) (MIT License).
- Kanagawa color palette inspired by [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim).
