# AGENTS.md — AI Agent Guide for Antigravity Kanagawa Theme

[🇻🇳 Tiếng Việt](#tiếng-việt) | [🇺🇸 English](#english)

This file instructs AI coding assistants (Antigravity, Claude Code, Codex, Cursor, Gemini CLI, etc.) on how to safely **install**, **customize**, **hot-reload**, **modify**, and **troubleshoot** this repository without breaking Google Antigravity 2.x.

---

<a name="tiếng-việt"></a>
## 🇻🇳 Tiếng Việt — Hướng dẫn dành cho AI

### 1. Kiến trúc & Vai trò từng file

- `install.ps1` / `install.bat`: Giải nén `%LOCALAPPDATA%\Programs\Antigravity\resources\app.asar`, backup thành `app.asar.pixel-backup`, patch `dist/utils.js` & `dist/ipcHandlers.js`, chèn `patch/pixelTheme.js`, đóng gói lại `app.asar`, rồi copy `kanagawa-theme/` sang `resources\kanagawa-theme\` và ghi `resources\active-theme.json`.
- `patch/pixelTheme.js`: Injector chạy trong `app.asar`, nạp CSS của theme active và `loading.html` khi Antigravity khởi động.
- `kanagawa-theme/kanagawa.config.json`: Nguồn cấu hình trung tâm (preset, bảng màu `dark`/`light`, `wallpaper`, `wallpaperPosition`, `userAvatar`, `agentAvatar`, chữ `loading`).
- `kanagawa-theme/kanagawa.css`: Stylesheet hoàn chỉnh của theme (chứa 2 block tự động sinh ở cuối file: `KANAGAWA-CUSTOM-SURFACE` và `KANAGAWA-EMBEDDED-ASSETS`).
- `kanagawa-theme/loading.html`: Màn hình loading khi mở Antigravity (được sinh tự động từ `kanagawa.config.json`).
- `scripts/apply_kanagawa_config.js`: Đọc `kanagawa.config.json` + cờ CLI -> ghi lại block màu & ảnh nhúng trong `kanagawa.css`, sinh lại `loading.html`, kiểm tra cân bằng ngoặc `{}` trước khi ghi file.
- `customize-kanagawa.ps1` / `customize-kanagawa.bat`: Wrapper PowerShell gọi `apply_kanagawa_config.js` rồi tự chạy `switch-theme.ps1` để đồng bộ và hot-reload.
- `switch-theme.ps1` / `switch-theme.bat`: Copy `kanagawa-theme/*` vào `%LOCALAPPDATA%\Programs\Antigravity\resources\kanagawa-theme\` và gửi `Page.reload` qua CDP (`%APPDATA%\Antigravity\DevToolsActivePort`).
- `uninstall.ps1` / `uninstall.bat`: Khôi phục `app.asar.pixel-backup` và xóa `resources\kanagawa-theme\` + `active-theme.json`.

### 2. Quy tắc an toàn bắt buộc cho AI

1. **KHÔNG tự chạy `.\install.ps1 -KillRunning` hoặc `.\uninstall.ps1 -KillRunning` từ terminal bên trong Antigravity:** Lệnh `-KillRunning` sẽ tắt tiến trình `Antigravity` (giết luôn phiên làm việc của chính bạn). Nếu cần cài mới / gỡ cài đặt / cập nhật `patch\pixelTheme.js`, hãy yêu cầu người dùng đóng Antigravity hoặc tự chạy lệnh từ một cửa sổ PowerShell bên ngoài.
2. **Tùy biến giao diện KHÔNG cần đóng Antigravity hay repack `app.asar`:** Sau khi đã cài 1 lần, mọi thao tác đổi hình nền, màu, preset, avatar hoặc sửa CSS đều dùng `.\customize-kanagawa.ps1` hoặc `.\switch-theme.ps1` (hot-reload an toàn ngay trong phiên AI).
3. **KHÔNG lưu ảnh lớn (hình nền > ~2 MB) vào CSS Custom Property (`--kn-*`):** Chromium cắt cụt CSS variable lớn hơn ~2 MB khiến hình nền bị đen thui. Luôn dùng `scripts/apply_kanagawa_config.js` để xuất rule trực tiếp (`html::before`, avatar `::before`) trong block `KANAGAWA-EMBEDDED-ASSETS`.
4. **Không sửa tay vào trong 2 block được quản lý tự động** ở cuối `kanagawa-theme/kanagawa.css`:
   - `/* === KANAGAWA-CUSTOM-SURFACE-START === */` ... `END`
   - `/* === KANAGAWA-EMBEDDED-ASSETS-START === */` ... `END`
   Nếu cần sửa CSS layout/component cố định, hãy sửa phía **trước** các block này.
5. **PowerShell 5.1 & Encoding:** Khi nối nhiều lệnh trên Windows PowerShell 5.1, dùng `;` (không dùng `&&`). Nếu chỉnh sửa file `.ps1`, giữ nguyên **UTF-8 BOM**.
6. **Kiểm tra trước khi ghi file thật:** Khi test thay đổi logic script/config, ưu tiên chạy `node scripts/apply_kanagawa_config.js --dry-run` (và cờ thử nghiệm tương ứng) để xác nhận `braces` cân bằng và không ghi đè ngoài ý muốn theme hiện tại của người dùng.

### 3. Quy trình AI thực hiện cài đặt & tùy biến

#### A. Hướng dẫn người dùng cài đặt lần đầu (hoặc sau khi Antigravity tự update)
- Yêu cầu môi trường: Windows, Google Antigravity 2.x tại `%LOCALAPPDATA%\Programs\Antigravity`, Node.js (để chạy `npx @electron/asar` và scripts).
- Nếu chưa cài, hướng dẫn người dùng chạy trong **PowerShell bên ngoài** tại thư mục repo:
  ```powershell
  .\install.ps1 -KillRunning
  ```
- Sau đó mở lại Antigravity.

#### B. Tùy biến nhanh theo yêu cầu người dùng (chạy trực tiếp bằng shell)
- **Xem danh sách preset:**
  ```powershell
  node scripts/apply_kanagawa_config.js --list-presets
  ```
  *(12 preset có sẵn: `kanagawa-wave`, `kanagawa-dragon`, `sakura-dusk`, `midnight-aqua`, `catppuccin-mocha`, `rose-pine`, `tokyo-night`, `nord-frost`, `everforest`, `gruvbox-warm`, `vesper-minimal`, `oxocarbon`)*
- **Đổi preset màu:**
  ```powershell
  .\customize-kanagawa.ps1 -Preset sakura-dusk
  ```
- **Đổi hình nền & vị trí canh ảnh:**
  ```powershell
  .\customize-kanagawa.ps1 -Wallpaper "C:\path\to\wallpaper.jpg" -WallpaperPosition "right top"
  ```
- **Tắt hình nền (dùng nền màu trơn theo preset):**
  ```powershell
  .\customize-kanagawa.ps1 -NoWallpaper
  ```
  *(Hoặc truyền `-Wallpaper NONE`, hoặc đặt `"wallpaper": "NONE"` / `"off"` / `""` trong `kanagawa.config.json`.)*
- **Đổi 2 avatar:**
  ```powershell
  .\customize-kanagawa.ps1 -UserAvatar "C:\path\to\user.png" -AgentAvatar "C:\path\to\agent.png"
  ```
  - Để khôi phục icon sao 4 cánh vector cho Agent Avatar: `-AgentAvatar SVG_STAR`.
- **Chỉnh riêng từng mã màu hex qua CLI:**
  - `-DarkPrimary "#..."`
  - `-DarkBlue "#..."`
  - `-DarkAqua "#..."`
  - `-DarkSurface "#..."`
  - `-LightPrimary "#..."`
- **Chỉ tạo/cập nhật file trong repo mà chưa reload Antigravity:** thêm `-NoReload`.
- **Chỉnh toàn bộ bảng màu / chữ màn hình loading:** Sửa trực tiếp `kanagawa-theme/kanagawa.config.json` (`dark.*`, `light.*`, `agentAvatar.bgStops`, `agentAvatar.iconStops`, `loading.title`, `loading.subtitle`), sau đó chạy:
  ```powershell
  .\customize-kanagawa.ps1
  ```

#### C. Lưu ý tính di động (Portability) của `kanagawa.config.json`
Khi truyền đường dẫn ảnh nằm ngoài thư mục `kanagawa-theme/`, `apply_kanagawa_config.js` tự nhúng ảnh dạng Base64 Data URL vào `kanagawa.css` rồi đổi giá trị trong `kanagawa.config.json` thành `"KEEP_EMBEDDED"` để config không bị dính đường dẫn cục bộ (`C:\Users\...`) nếu repo được push lên GitHub.

#### D. Xử lý lỗi thường gặp
- **Hình nền bị đen sau khi đổi ảnh:** Kiểm tra xem `kanagawa.css` có rule `html::before` trong block `KANAGAWA-EMBEDDED-ASSETS` hay vẫn còn biến `--kn-wallpaper` cũ; chạy lại `node scripts/apply_kanagawa_config.js --wallpaper "<đường-dẫn>"` rồi `.\switch-theme.ps1`.
- **Hot-reload không đổi giao diện:** Đảm bảo `%APPDATA%\Antigravity\DevToolsActivePort` tồn tại và `switch-theme.ps1` chỉ reload target có URL `^https?:`; nếu chưa có CDP port, bảo người dùng bấm `Ctrl+R` trong Antigravity.

---

<a name="english"></a>
## 🇺🇸 English — AI Agent Instructions

### 1. Repository Architecture

- `install.ps1` / `install.bat`: Extracts `%LOCALAPPDATA%\Programs\Antigravity\resources\app.asar`, creates `app.asar.pixel-backup`, patches `dist/utils.js` & `dist/ipcHandlers.js`, injects `patch/pixelTheme.js`, repacks `app.asar`, deploys `kanagawa-theme/` to `resources\kanagawa-theme\`, and writes `resources\active-theme.json`.
- `patch/pixelTheme.js`: Runtime loader inside `app.asar` that injects the active theme CSS and custom `loading.html`.
- `kanagawa-theme/kanagawa.config.json`: Source of truth for preset, `dark`/`light` palettes, `wallpaper`, `wallpaperPosition`, `userAvatar`, `agentAvatar`, and `loading` text.
- `kanagawa-theme/kanagawa.css`: Main theme stylesheet (ends with two script-managed blocks: `KANAGAWA-CUSTOM-SURFACE` and `KANAGAWA-EMBEDDED-ASSETS`).
- `kanagawa-theme/loading.html`: Startup loading overlay HTML generated from `kanagawa.config.json`.
- `scripts/apply_kanagawa_config.js`: Applies `kanagawa.config.json` + CLI overrides into `kanagawa.css` and `loading.html`, encodes local images as Base64 data URIs, and validates balanced `{}` braces before writing.
- `customize-kanagawa.ps1` / `customize-kanagawa.bat`: PowerShell wrapper invoking `apply_kanagawa_config.js` followed by `switch-theme.ps1`.
- `switch-theme.ps1` / `switch-theme.bat`: Syncs `kanagawa-theme/*` to Antigravity `resources\kanagawa-theme\` and triggers CDP `Page.reload` via `%APPDATA%\Antigravity\DevToolsActivePort`.
- `uninstall.ps1` / `uninstall.bat`: Restores `app.asar.pixel-backup` and removes deployed theme files.

### 2. Mandatory Safety Rules for AI Agents

1. **NEVER run `.\install.ps1 -KillRunning` or `.\uninstall.ps1 -KillRunning` from an integrated terminal inside Antigravity:** It terminates the `Antigravity` process (killing your own active session). Instruct the user to run those from an **external PowerShell** window when installing, uninstalling, or updating `patch\pixelTheme.js`.
2. **Customization never requires repacking `app.asar`:** Once installed, always use `.\customize-kanagawa.ps1` or `.\switch-theme.ps1` for safe live updates.
3. **NEVER store large wallpapers (> ~2 MB) inside CSS custom properties (`--kn-*`):** Chromium truncates oversized CSS variables, resulting in a black background. Always let `scripts/apply_kanagawa_config.js` emit direct rules (`html::before`, avatar `::before`) inside `KANAGAWA-EMBEDDED-ASSETS`.
4. **Do not manually edit inside managed blocks** at the bottom of `kanagawa-theme/kanagawa.css` (`KANAGAWA-CUSTOM-SURFACE-START/END` and `KANAGAWA-EMBEDDED-ASSETS-START/END`); put permanent layout/component CSS edits before them.
5. **PowerShell 5.1 & UTF-8 BOM:** Use `;` instead of `&&` in Windows PowerShell 5.1 commands, and preserve **UTF-8 BOM** when editing any `.ps1` file.
6. **Dry-run before mutating live config when testing:** Use `node scripts/apply_kanagawa_config.js --dry-run` to verify CSS byte size and balanced braces without overwriting user files.

### 3. Standard AI Runbooks

#### A. Initial Installation / After Antigravity Auto-Update
- Prerequisites: Windows, Google Antigravity 2.x (`%LOCALAPPDATA%\Programs\Antigravity`), Node.js.
- Prompt user to run in an **external PowerShell** window in repo root:
  ```powershell
  .\install.ps1 -KillRunning
  ```
- Re-launch Antigravity.

#### B. Programmatic Customization
- List presets (`kanagawa-wave`, `kanagawa-dragon`, `sakura-dusk`, `midnight-aqua`, `catppuccin-mocha`, `rose-pine`, `tokyo-night`, `nord-frost`, `everforest`, `gruvbox-warm`, `vesper-minimal`, `oxocarbon`):
  ```powershell
  node scripts/apply_kanagawa_config.js --list-presets
  ```
- Switch preset:
  ```powershell
  .\customize-kanagawa.ps1 -Preset sakura-dusk
  ```
- Set wallpaper & CSS `background-position`:
  ```powershell
  .\customize-kanagawa.ps1 -Wallpaper "C:\path\to\bg.jpg" -WallpaperPosition "center center"
  ```
- Disable wallpaper (solid theme background only):
  ```powershell
  .\customize-kanagawa.ps1 -NoWallpaper
  ```
  *(Equivalent to `-Wallpaper NONE` or `"wallpaper": "NONE"` / `"off"` / `""` in `kanagawa.config.json`.)*
- Set both avatars (use `-AgentAvatar SVG_STAR` to restore the built-in gradient star):
  ```powershell
  .\customize-kanagawa.ps1 -UserAvatar "C:\path\to\user.png" -AgentAvatar "C:\path\to\agent.png"
  ```
- Quick hex overrides: `-DarkPrimary`, `-DarkBlue`, `-DarkAqua`, `-DarkSurface`, `-LightPrimary`.
- Full palette / gradient / loading text edit: Update `kanagawa-theme/kanagawa.config.json` (`dark.*`, `light.*`, `agentAvatar.bgStops`, `agentAvatar.iconStops`, `loading.title`, `loading.subtitle`), then run `.\customize-kanagawa.ps1` (pass `-NoReload` to skip CDP reload).

#### C. Config Portability Note
When an image path outside `kanagawa-theme/` is applied, `apply_kanagawa_config.js` embeds the image data URI into `kanagawa.css` and resets that config field to `"KEEP_EMBEDDED"` so `kanagawa.config.json` stays free of machine-specific paths.
