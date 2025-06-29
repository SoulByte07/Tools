# 📦 Android Split APK Installer (Batch)

This batch script automates the installation of split APK bundles on Android devices using ADB.

---

## 🚀 Features

- Installs split APKs using `adb install-multiple`
- Filters base APKs from split parts using naming convention
- Logs the entire process with timestamps
- Useful after factory resets or app backup/restore situations

---

## 🧰 Requirements

- [ADB installed](https://developer.android.com/tools/releases/platform-tools)
- extract that platform-tools inside APK_Installs folder
- USB Debugging enabled on your Android device
- Place all `.apk` files in the `APKs` folder (i place a .gitkeep file to keep an empty folder)

---

## 🗂 Folder Structure

```
APK_Installation/
├── platform-tools
├── install_split_apks.bat
├──bulk_apk_installs.bat
├── APKs/
│ ├── myapp.apk
│ ├── myapp_split_config.en.apk
│ ├── myapp_split_config.arm64.apk
└── Logs/
```

---

## ▶️ How to Use

1. Enable **Developer Options** and **USB Debugging** on your device.
2. Connect your Android device via USB.
3. Place all related `.apk` files inside the `APKs` folder.
4. Double-click `install_split_apks.bat`.
5. Follow on-screen instructions. A log file will be saved in the `Logs` folder.

---

## 🧠 How It Works

- It detects `.apk` files not containing `_split_` in their filename as base APKs.
- Then it bundles all related APKs (with similar prefix) together.
- Calls `adb install-multiple` to install each bundle.

---

## Debugging

- i have added a BASE_PATH to increase the convinence score of the script.
- i have temparaly added the adb path to the system PATH to avoid the command issues.
- i have added a .gitkeep file in the APKs folder, bacause git doesnt accept empth folders
- Logs will be saved into the Logs folder, to know what was happens at the end.

## 📜 License

MIT – use and modify freely.

---

## 🧩 Tips

- Use consistent naming: e.g., `app.apk`, `app_split_config.*.apk`
- Customize ADB path in the script if needed.