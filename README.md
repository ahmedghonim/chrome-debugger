# Chrome Debugger Setup

Professional Chrome debugging configuration for VS Code with full profile support, extensions, and saved passwords.

## 🌟 Features

- ✅ **Interactive Profile Selection** - Choose from all your Chrome profiles
- ✅ **Custom Debug Profile Names** - Name your debug profiles as you want
- ✅ **Optional Password Copying** - Choose whether to include saved passwords
- ✅ **Complete Extension Support** - All extensions with their data and settings
- ✅ **Professional UI** - Colored output with progress indicators
- ✅ **VS Code Integration** - Automatically updates launch.json
- ✅ **Data Integrity** - Copies all Chrome data safely

## 📦 What Gets Copied

The script copies comprehensive Chrome data from your selected profile:

- **🧩 Extensions** - All installed extensions with their data
- **⚙️ Preferences** - Extension settings and configurations
- **🔐 Login Data** - Saved passwords (optional)
- **🍪 Cookies** - Browser cookies and sessions
- **📚 Bookmarks** - All your bookmarks
- **💾 Local Storage** - Extension and website storage
- **🗂️ IndexedDB** - Advanced extension storage
- **🔒 Secure Preferences** - Encrypted settings

## 🚀 Quick Start

1. **Download the script:**
   ```bash
   wget https://raw.githubusercontent.com/ahmedghonim/chrome-debuger/main/setup-chrome-debug.sh
   # or
   curl -O https://raw.githubusercontent.com/ahmedghonim/chrome-debuger/main/setup-chrome-debug.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x setup-chrome-debug.sh
   ```

3. **Run the setup:**
   ```bash
   ./setup-chrome-debug.sh
   ```

4. **Follow the interactive prompts:**
   - Enter your debug profile name
   - Select which Chrome profile to copy from
   - Choose whether to copy passwords
   - Wait for the copying process to complete

5. **Start debugging in VS Code:**
   - Press `F5` or go to Run and Debug
   - Select your newly created debug configuration
   - Chrome will open with all your data!

## 📋 Step-by-Step Usage

### Step 1: Debug Profile Name
```
📁 Debug Profile Configuration
   Enter name for your debug profile (default: chrome-debug-profile): my-project-debug
✅ Debug profile name: my-project-debug
```

### Step 2: Source Profile Selection
```
🔍 Scanning for Chrome profiles...

[1] Default Profile
[2] Profile 1
[3] Profile 6
[4] Profile 7

📝 Select source profile [1-4]: 1
✅ Selected: Default Profile
```

### Step 3: Password Settings
```
🔐 Password Settings
   Do you want to copy saved passwords to the debug profile? (y/N): y
✅ Passwords will be copied
```

### Step 4: Automated Copying
The script will automatically:
- Close any running Chrome processes
- Copy all selected data with progress indicators
- Update your VS Code launch.json configuration
- Show a summary of what was copied

## ⚙️ VS Code Configuration

The script automatically creates/updates `.vscode/launch.json` with this configuration:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "chrome",
            "request": "launch",
            "name": "Debug Chrome - your-profile-name",
            "url": "http://localhost:3003",
            "webRoot": "${workspaceFolder}/src",
            "userDataDir": "${workspaceFolder}/.vscode/your-profile-name"
        }
    ]
}
```

### Manual Configuration

If you prefer to configure manually, add this to your `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "chrome",
            "request": "launch",
            "name": "Debug Chrome with Extensions",
            "url": "http://localhost:YOUR_PORT",
            "webRoot": "${workspaceFolder}/src",
            "userDataDir": "${workspaceFolder}/.vscode/chrome-debug-profile",
            "runtimeArgs": [
                "--disable-web-security",
                "--disable-features=VizDisplayCompositor"
            ]
        }
    ]
}
```

**Configuration Options:**
- `name`: Display name in VS Code debugger dropdown
- `url`: Your development server URL
- `webRoot`: Path to your source files
- `userDataDir`: Path to debug profile (created by script)
- `runtimeArgs`: Additional Chrome flags (optional)

## 🛠️ Customization

### Change Development Server Port
Edit the generated configuration to match your server:
```json
"url": "http://localhost:8080"  // Change from 3003 to your port
```

### Add Chrome Runtime Arguments
```json
"runtimeArgs": [
    "--disable-web-security",
    "--disable-features=VizDisplayCompositor",
    "--allow-running-insecure-content"
]
```

### Multiple Debug Profiles
Run the script multiple times with different names to create multiple debug configurations:
- `my-project-debug` - For main development
- `testing-debug` - For testing with clean profile
- `production-debug` - For production debugging

## 🔧 Troubleshooting

### Chrome Won't Start
- Make sure Chrome is completely closed before running the script
- Check that Chrome is installed in `/Applications/Google Chrome.app`

### Extensions Not Working
- Extensions are copied but may need to be re-enabled
- Go to `chrome://extensions/` in debug Chrome to manage them

### Passwords Not Available
- Make sure you selected "Yes" when asked about copying passwords
- Re-run the script with password copying enabled

### VS Code Can't Attach
- Ensure your development server is running on the specified port
- Check that the `webRoot` path is correct in launch.json

### Permission Errors
```bash
# Fix script permissions
chmod +x setup-chrome-debug.sh

# Fix Chrome profile permissions
sudo chown -R $USER ~/.chrome-debug-profiles
```

## 📁 File Structure

After running the script:
```
your-project/
├── .vscode/
│   ├── launch.json                    # VS Code debug configuration
│   └── your-debug-profile/           # Chrome debug profile
│       └── Default/
│           ├── Extensions/           # Your Chrome extensions
│           ├── Login Data           # Saved passwords (if copied)
│           ├── Cookies              # Browser cookies
│           ├── Bookmarks            # Your bookmarks
│           └── ...                  # Other Chrome data
└── setup-chrome-debug.sh            # The setup script
```

## 🔄 Updating Debug Profile

To update your debug profile with new data from Chrome:
```bash
# Run the script again with the same profile name
./setup-chrome-debug.sh
```

The script will:
- Remove the old debug profile
- Copy fresh data from your selected Chrome profile
- Preserve your VS Code configuration

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Support

If you find this tool helpful:
- ⭐ Star this repository
- 🐛 Report issues on GitHub
- 💡 Suggest improvements
- 🔄 Share with other developers

---

Made with ❤️ for developers who need reliable Chrome debugging with full profile support.