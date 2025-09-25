<#
.SYNOPSIS
    Builds an optimized Android App Bundle (AAB) for Flutter apps.
.DESCRIPTION
    - Supports clean builds
    - Includes optional bundle size analysis using bundletool
    - Applies best practices: obfuscation, icon tree shaking, resource shrinking
.PARAMETER BuildMode
    The Flutter build mode (e.g., release, debug). Default is "release".
.PARAMETER Clean
    If specified, performs `flutter clean` before build.
.PARAMETER Analyze
    If specified, performs bundle size analysis using bundletool.
.PARAMETER Verbose
    If specified, enables verbose Flutter output.
#>

param(
    [string]$BuildMode = "release",
    [switch]$Clean = $false,
    [switch]$Analyze = $false,
    [switch]$Verbose = $false
)

# ─────────────────────────────────────────────
# Styling Helpers
# ─────────────────────────────────────────────
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Cyan"

function Write-ColorOutput($Color, $Message) {
    Write-Host $Message -ForegroundColor $Color
}

# ─────────────────────────────────────────────
# Output Sections
# ─────────────────────────────────────────────
function Show-Header() {
    Write-ColorOutput $Blue "=================================="
    Write-ColorOutput $Blue "  Android AAB Build Script"
    Write-ColorOutput $Blue "  Optimized for Google Play Store"
    Write-ColorOutput $Blue "==================================`n"
}

function Show-BuildInfo() {
    Write-ColorOutput $Yellow "Build Configuration:"
    Write-ColorOutput $Yellow "- Build Mode: $BuildMode"
    Write-ColorOutput $Yellow "- Clean Build: $Clean"
    Write-ColorOutput $Yellow "- Bundle Analysis: $Analyze"
    Write-ColorOutput $Yellow "- Verbose Output: $Verbose`n"
}

function Show-OptimizationTips() {
    Write-ColorOutput $Blue "Optimization Features Applied:"
    Write-ColorOutput $Green "✓ Code obfuscation enabled"
    Write-ColorOutput $Green "✓ Tree shaking for unused icons"
    Write-ColorOutput $Green "✓ Resource shrinking enabled"
    Write-ColorOutput $Green "✓ ProGuard optimization (from build.gradle)"
    Write-ColorOutput $Green "✓ Split debug info (reduces app size)"
    Write-ColorOutput $Green "✓ R8 full mode enabled (from gradle.properties)`n"

    Write-ColorOutput $Yellow "Additional Tips for Size Reduction:"
    Write-ColorOutput $Yellow "• Use vector drawables instead of multiple PNG densities"
    Write-ColorOutput $Yellow "• Compress images using tools like TinyPNG"
    Write-ColorOutput $Yellow "• Remove unused dependencies from pubspec.yaml"
    Write-ColorOutput $Yellow "• Use --analyze-size flag for detailed size breakdown`n"
}

function Show-NextSteps() {
    Write-ColorOutput $Blue "Next Steps for Google Play Store:"
    Write-ColorOutput $Yellow "1. Test the AAB on different device configurations"
    Write-ColorOutput $Yellow "2. Upload to Google Play Console"
    Write-ColorOutput $Yellow "3. Use Play Console's App Bundle Explorer for analysis"
    Write-ColorOutput $Yellow "4. Set up Play App Signing if not done already`n"
}

# ─────────────────────────────────────────────
# Flutter Checks and Commands
# ─────────────────────────────────────────────
function Test-FlutterInstallation() {
    Write-ColorOutput $Blue "Checking Flutter installation..."
    try {
        $null = flutter --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput $Green "✓ Flutter is installed"
            return $true
        } else {
            throw "Flutter not found in PATH"
        }
    } catch {
        Write-ColorOutput $Red "✗ Flutter not found in PATH"
        return $false
    }
}

function Invoke-FlutterClean() {
    if ($Clean) {
        Write-ColorOutput $Blue "Cleaning previous build artifacts..."
        flutter clean
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput $Green "✓ Clean completed"
        } else {
            Write-ColorOutput $Red "✗ Clean failed"
            exit 1
        }
    }
}

function Invoke-FlutterPubGet() {
    Write-ColorOutput $Blue "Getting Flutter dependencies..."
    flutter pub get
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $Green "✓ Dependencies resolved"
    } else {
        Write-ColorOutput $Red "✗ Failed to get dependencies"
        exit 1
    }
}

function Invoke-FlutterBuildAAB() {
    Write-ColorOutput $Blue "Building Android App Bundle..."

    $buildArgs = @(
        "build", "appbundle",
        "--$BuildMode",
        "--obfuscate",
        "--split-debug-info=build/debug-info",
        "--tree-shake-icons",
        "--shrink"
    )

    if ($Verbose) {
        $buildArgs += "--verbose"
    }

    Write-ColorOutput $Yellow "Build command: flutter $($buildArgs -join ' ')"

    & flutter @buildArgs

    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput $Green "✓ AAB build completed successfully"
    } else {
        Write-ColorOutput $Red "✗ AAB build failed"
        exit 1
    }
}

# ─────────────────────────────────────────────
# Bundle Output and Analysis
# ─────────────────────────────────────────────
function Get-AABInfo() {
    $aabPath = "build\app\outputs\bundle\release\app-release.aab"
    if (Test-Path $aabPath) {
        $fileInfo = Get-Item $aabPath
        $sizeInMB = [math]::Round($fileInfo.Length / 1MB, 2)

        Write-ColorOutput $Green "✓ AAB file created successfully"
        Write-ColorOutput $Yellow "  Path: $aabPath"
        Write-ColorOutput $Yellow "  Size: $sizeInMB MB"
        Write-ColorOutput $Yellow "  Created: $($fileInfo.CreationTime)"

        return $aabPath
    } else {
        Write-ColorOutput $Red "✗ AAB file not found at expected location"
        return $null
    }
}

function Invoke-BundleAnalysis($aabPath) {
    if ($Analyze -and $aabPath) {
        Write-ColorOutput $Blue "Analyzing bundle size..."

        try {
            # Check if bundletool is available
            $null = bundletool version 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput $Green "✓ Bundletool found, generating size analysis..."
                bundletool get-size total --bundle="$aabPath"
            } else {
                throw "Bundletool is not available."
            }
        }
        catch {
            Write-ColorOutput $Yellow "! Bundletool not found or failed. Install it from:"
            Write-ColorOutput $Yellow "  https://github.com/google/bundletool/releases"
        }
    }
}


# ─────────────────────────────────────────────
# Main Execution
# ─────────────────────────────────────────────
try {
    Show-Header
    Show-BuildInfo

    if (-not (Test-FlutterInstallation)) {
        Write-ColorOutput $Red "Please install Flutter and add it to your PATH"
        exit 1
    }

    if (-not (Test-Path "pubspec.yaml")) {
        Write-ColorOutput $Red "✗ Not in a Flutter project directory"
        exit 1
    }

    Invoke-FlutterClean
    Invoke-FlutterPubGet
    Invoke-FlutterBuildAAB

    $aabPath = Get-AABInfo
    Invoke-BundleAnalysis $aabPath

    Show-OptimizationTips
    Show-NextSteps

    Write-ColorOutput $Green "🎉 Build completed successfully!"
} catch {
    Write-ColorOutput $Red "❌ Build failed with error: $($_.Exception.Message)"
    exit 1
}
