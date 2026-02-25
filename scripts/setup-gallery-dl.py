#!/usr/bin/env python3
"""Setup gallery-dl authentication for Instagram.

Guides the user through exporting cookies via the
"Get cookies.txt LOCALLY" Chrome extension and writes
~/.config/gallery-dl/config.json.
"""

import json
import sys
import urllib.request
import urllib.error
from pathlib import Path

GALLERY_DL_CONFIG = Path.home() / ".config" / "gallery-dl" / "config.json"
REQUIRED_COOKIES = ["sessionid", "csrftoken"]
EXTENSION_URL = (
    "https://chromewebstore.google.com/detail/"
    "get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc"
)


def parse_cookies_txt(text: str) -> dict[str, str]:
    """Parse pasted Netscape cookies.txt content, return Instagram cookies."""
    cookies = {}
    for line in text.strip().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split("\t")
        if len(parts) < 7:
            continue
        domain, _, _, _, _, name, value = parts[:7]
        if ".instagram.com" in domain and name in REQUIRED_COOKIES:
            cookies[name] = value
    return cookies


def build_config(cookies: dict[str, str]) -> dict:
    """Build a gallery-dl config dict with Instagram cookies."""
    return {
        "extractor": {
            "base-directory": str(Path.home() / "Pictures" / "gallery-dl"),
            "instagram": {
                "cookies": cookies,
                "sleep-request": [6.0, 12.0],
            }
        }
    }


def deep_merge(base: dict, override: dict) -> dict:
    """Recursively merge override into base, preserving existing keys."""
    merged = base.copy()
    for key, value in override.items():
        if key in merged and isinstance(merged[key], dict) and isinstance(value, dict):
            merged[key] = deep_merge(merged[key], value)
        else:
            merged[key] = value
    return merged


def write_config(config: dict) -> None:
    """Write config to gallery-dl's config path, merging with existing config."""
    GALLERY_DL_CONFIG.parent.mkdir(parents=True, exist_ok=True)

    if GALLERY_DL_CONFIG.exists():
        existing = json.loads(GALLERY_DL_CONFIG.read_text())
        config = deep_merge(existing, config)
        print(f"  Merged with existing config (other extractors preserved).")

    GALLERY_DL_CONFIG.write_text(json.dumps(config, indent=2) + "\n")


def verify_cookies(cookies: dict[str, str]) -> bool:
    """Test Instagram cookies by hitting a lightweight endpoint."""
    url = "https://www.instagram.com/api/v1/web/accounts/current_user/"
    req = urllib.request.Request(url)
    req.add_header("Cookie", "; ".join(f"{k}={v}" for k, v in cookies.items()))
    req.add_header("User-Agent", "Mozilla/5.0")
    req.add_header("X-CSRFToken", cookies.get("csrftoken", ""))
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.status == 200
    except urllib.error.HTTPError:
        return False


def print_instructions() -> None:
    """Print step-by-step instructions for exporting cookies."""
    print(
        "\n"
        "=== Instagram Cookie Setup for gallery-dl ===\n"
        "\n"
        'This script uses the "Get cookies.txt LOCALLY" Chrome extension\n'
        "to export your Instagram session cookies.\n"
        "\n"
        "If you don't have the extension installed:\n"
        f"  Install it from: {EXTENSION_URL}\n"
        "\n"
        "Steps:\n"
        "  1. Open Chrome and go to https://www.instagram.com\n"
        "  2. Make sure you are logged in\n"
        '  3. Click the "Get cookies.txt LOCALLY" extension icon\n'
        '  4. Click "Export" (for current site only)\n'
        "  5. Copy ALL the text from the export\n"
    )


def prompt_cookie_paste() -> str:
    """Ask the user to paste cookies.txt content."""
    print('Paste the cookies.txt content below, then press Enter twice when done:\n')
    lines = []
    empty_count = 0
    while True:
        try:
            line = input()
        except EOFError:
            break
        if line == "":
            empty_count += 1
            if empty_count >= 2:
                break
        else:
            empty_count = 0
        lines.append(line)
    return "\n".join(lines)


def main() -> None:
    print_instructions()
    input("Press Enter when you're ready to paste the cookies...")

    text = prompt_cookie_paste()
    cookies = parse_cookies_txt(text)

    missing = [name for name in REQUIRED_COOKIES if name not in cookies]
    if missing:
        print(f"\nError: Missing cookies: {', '.join(missing)}")
        print("Make sure you're logged into Instagram before exporting.")
        sys.exit(1)

    print(f"\nFound cookies: {', '.join(cookies.keys())}")

    config = build_config(cookies)
    write_config(config)
    print(f"Config written to {GALLERY_DL_CONFIG}")

    print("\nVerifying cookies...")
    if verify_cookies(cookies):
        print("Success! gallery-dl is now configured for Instagram.")
    else:
        print("Warning: Cookies were saved but verification failed.")
        print("They may still work — try: gallery-dl <instagram-url>")


if __name__ == "__main__":
    main()
