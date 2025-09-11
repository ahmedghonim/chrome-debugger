# Chrome Debugger Setup

Professional Chrome debugging configuration for VS Code with full profile support, extensions, and saved passwords.

## ⚠️ **CRITICAL SECURITY WARNING**

**This tool copies ALL personal data from your Chrome profile including:**
- 🔑 **Saved passwords** (banking, personal accounts, etc.)
- 🍪 **Cookies & sessions** (auto-login tokens)
- 📧 **Personal browsing data**
- 💳 **Autofill information** (credit cards, addresses)

### 🚨 **DANGER: Development Mode Risks**
- **Debug Chrome runs with disabled security features**
- **Personal data is exposed in development environment**
- **Risk of accidentally committing sensitive data to git**
- **Potential data leakage during debugging sessions**

### 🛡️ **Security Best Practices**
1. **❌ NEVER copy passwords for work/client projects**
2. **✅ Use password copying ONLY for personal projects**
3. **🔒 Always answer "NO" to password copying in team environments**
4. **🗑️ Regularly clean debug profiles containing sensitive data**
5. **📝 Ensure debug profiles are in .gitignore (included by default)**
6. **🔍 Review what data you're copying before proceeding**

## 🌟 Features

- ✅ **Multiple Chrome Profile Support** - Select from ANY of your Chrome profiles (Default, Profile 1, Profile 2, etc.)
- ✅ **Interactive Profile Selection** - Script automatically detects and lists all available Chrome profiles
- ✅ **Custom Debug Profile Names** - Name your debug profiles as you want
- ✅ **Optional Password Copying** - Choose whether to include saved passwords ⚠️
- ✅ **Complete Extension Support** - All extensions with their data and settings from selected profile
- ✅ **Professional UI** - Colored output with progress indicators
- ✅ **VS Code Integration** - Automatically updates launch.json
- ✅ **Security Awareness** - Clear warnings about data copying risks

## 📦 What Gets Copied

The script copies comprehensive Chrome data from **your selected Chrome profile** (you choose which one):

- **🧩 Extensions** - All installed extensions with their data
- **⚙️ Preferences** - Extension settings and configurations
- **🔐 Login Data** - Saved passwords (optional)
- **🍪 Cookies** - Browser cookies and sessions
- **📚 Bookmarks** - All your bookmarks
- **💾 Local Storage** - Extension and website storage
- **🗂️ IndexedDB** - Advanced extension storage
- **🔒 Secure Preferences** - Encrypted settings

## 👥 Chrome Profiles Explained

**Your Chrome browser can have multiple profiles**, each with its own:
- 🧩 **Different extensions** (work extensions vs personal extensions)
- 🔑 **Separate saved passwords** (work accounts vs personal accounts)  
- 📚 **Different bookmarks** (work bookmarks vs personal bookmarks)
- 🍪 **Separate cookies/sessions** (logged into different accounts)
- ⚙️ **Unique settings** (themes, preferences, etc.)

**Common Chrome Profile Examples:**
- **Default Profile** - Your main personal browsing
- **Profile 1** - Work profile with work extensions
- **Profile 2** - Testing profile with development extensions
- **Profile 3** - Clean profile for specific projects

**The script lets you choose which profile's data to copy**, so you can debug with the exact extensions and settings from any of your Chrome profiles!

## 🚀 Quick Start

1. **Download the script:**
   ```bash
   wget https://raw.githubusercontent.com/ahmedghonim/chrome-debugger/main/setup-chrome-debug.sh
   # or
   curl -O https://raw.githubusercontent.com/ahmedghonim/chrome-debugger/main/setup-chrome-debug.sh
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
   - **Select from ANY of your Chrome profiles** (Default, Profile 1, Profile 2, etc.)
   - ⚠️ **Choose "NO" for passwords** (recommended for security)
   - Wait for the copying process to complete

5. **Start debugging in VS Code:**
   - Press `F5` or go to Run and Debug
   - Select your newly created debug configuration
   - Chrome will open with extensions and safe data!

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
[3] Profile 3
[4] Profile 5
[5] Profile 6
[6] Profile 7
[7] Profile 9

📝 Select source profile [1-7]: 1
✅ Selected: Default Profile
```

**Note:** The script automatically detects ALL Chrome profiles on your system. You can select any profile - each may have different extensions, bookmarks, and saved data. Choose the profile that has the extensions and settings you want in your debug environment.

### Step 3: Password Settings ⚠️
```
🔐 Password Settings
   Do you want to copy saved passwords to the debug profile? (y/N): N
⚠️  Passwords will NOT be copied (RECOMMENDED for security)
```

**Security Recommendation:** Always select "N" for work projects to protect sensitive data.

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
- `my-project-debug` - For main development (no passwords)
- `testing-debug` - For testing with clean profile (no passwords)
- `personal-debug` - For personal projects (passwords optional)
- `safe-debug` - Extensions only, no sensitive data

## 🛡️ Security Guidelines

### For Team/Work Projects ✅
- **Always select "NO"** when asked about copying passwords
- Use debug profiles for extensions and development convenience only
- Regularly review and clean debug profiles
- Never commit debug profile folders to version control

### For Personal Projects ⚠️
- Consider if you really need saved passwords in debug mode
- Use separate debug profiles for sensitive vs non-sensitive projects
- Be aware that debug Chrome has reduced security features
- Clean up debug profiles after project completion

### Data Protection Checklist
- [ ] Debug profiles are in .gitignore
- [ ] No passwords copied for work projects
- [ ] Regular cleanup of old debug profiles
- [ ] Team members aware of security implications
- [ ] Review sensitive data before copying

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