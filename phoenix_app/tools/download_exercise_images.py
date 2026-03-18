#!/usr/bin/env python3
"""
Download exercise images from Wger open-source fitness API.
Maps Phoenix exercise names → Wger search → download best image → convert to WebP.

Usage:
    python3 tools/download_exercise_images.py

Output:
    assets/exercises/{id}.webp for each exercise found

Requires: curl, convert (ImageMagick) or cwebp
License: Wger images are AGPL-licensed open-source content.
"""

import json
import os
import subprocess
import sys
import time
import urllib.request
import urllib.parse
import urllib.error

# ═══════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════

ASSETS_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'exercises')
WGER_BASE = 'https://wger.de'
WGER_SEARCH = f'{WGER_BASE}/api/v2/exercise/search/?term={{term}}&language=2&format=json'

# Delay between API calls to be polite
API_DELAY = 0.5  # seconds

# Phoenix exercise ID → search term mapping.
# IDs are sequential based on insertion order in exercise_seed.dart.
# When Wger doesn't have a good match, we map to the closest equivalent.
EXERCISE_MAP = {
    # ── PUSH (gym) ──
    1: 'Chest Press Machine',
    2: 'Bench Press',
    3: 'Incline Bench Press',
    4: 'Dumbbell Shoulder Press',
    5: 'Weighted Dip',
    6: 'Overhead Press Barbell',

    # ── PUSH (home) ──
    7: 'Dumbbell Floor Press',
    8: 'Dumbbell Bench Press',
    9: 'Incline Dumbbell Press',
    10: 'Kettlebell Press',
    11: 'Ring Dip',

    # ── PUSH (bodyweight) ──
    12: 'Wall Push-up',
    13: 'Push-up',       # Incline push-up → same image family
    14: 'Push-up',
    15: 'Diamond Push-up',
    16: 'Archer Push-up',
    17: 'Planche',

    # ── PUSH accessories ──
    18: 'Tricep Extension',
    19: 'Lateral Raise',
    20: 'Face Pull',

    # ── PULL (gym) ──
    21: 'Lat Pulldown',
    22: 'Seated Row',
    23: 'Barbell Row',
    24: 'Pull-up',
    25: 'Weighted Pull-up',
    26: 'Muscle-up',

    # ── PULL (home) ──
    27: 'Band Pull-apart',
    28: 'Dumbbell Row',
    29: 'Kettlebell Row',
    30: 'Dumbbell Row',  # Weighted row → similar

    # ── PULL (bodyweight) ──
    31: 'Dead Hang',
    32: 'Inverted Row',  # Australian Row
    33: 'Pull-up',       # Negatives
    34: 'Pull-up',
    35: 'Archer Pull-up',
    36: 'Muscle-up',

    # ── PULL accessories ──
    37: 'Bicep Curl',
    38: 'Reverse Fly',

    # ── SQUAT (gym) ──
    39: 'Leg Press',
    40: 'Back Squat',
    41: 'Front Squat',
    42: 'Pause Squat',
    43: 'Squat',         # ATG Squat
    44: 'Squat',         # Olympic Squat

    # ── SQUAT (home) ──
    45: 'Goblet Squat',
    46: 'Dumbbell Squat',
    47: 'Bulgarian Split Squat',
    48: 'Pistol Squat',

    # ── SQUAT (bodyweight) ──
    49: 'Squat',         # Assisted
    50: 'Squat',         # Bodyweight
    51: 'Bulgarian Split Squat',
    52: 'Shrimp Squat',
    53: 'Pistol Squat',
    54: 'Pistol Squat',  # Weighted

    # ── SQUAT accessories ──
    55: 'Leg Extension',
    56: 'Calf Raise',
    57: 'Lunges',

    # ── HINGE (gym) ──
    58: 'Leg Curl',
    59: 'Romanian Deadlift',
    60: 'Deadlift',
    61: 'Sumo Deadlift',
    62: 'Deadlift',      # Deficit
    63: 'Deadlift',      # Snatch Grip

    # ── HINGE (home) ──
    64: 'Kettlebell Deadlift',
    65: 'Romanian Deadlift Dumbbell',
    66: 'Kettlebell Swing',
    67: 'Single Leg Romanian Deadlift',

    # ── HINGE (bodyweight) ──
    68: 'Glute Bridge',
    69: 'Glute Bridge',  # Single Leg
    70: 'Nordic Curl',
    71: 'Nordic Curl',
    72: 'Nordic Curl',   # Single Leg
    73: 'Nordic Curl',   # Full

    # ── HINGE accessories ──
    74: 'Hip Thrust',
    75: 'Back Extension',

    # ── CORE ──
    76: 'Dead Bug',
    77: 'Bird Dog',
    78: 'Plank',
    79: 'Side Plank',
    80: 'Ab Wheel',
    81: 'Pallof Press',
    82: 'Hanging Knee Raise',
    83: 'Ab Wheel',      # Standing
    84: 'Dragon Flag',
    85: 'L-sit',
    86: 'Dragon Flag',
    87: 'Front Lever',

    # ── FUNCTIONAL (Turkish Get-Up, Carries) ──
    88: 'Turkish Get-Up',     # Half TGU
    89: 'Turkish Get-Up',
    90: 'Turkish Get-Up',     # Barbell
    91: 'Farmer Walk',
    92: 'Farmer Walk',        # Heavy
    93: 'Suitcase Carry',
    94: 'Suitcase Carry',     # Heavy
    95: 'Overhead Carry',
    96: 'Overhead Carry',     # Heavy
    97: 'Overhead Carry',     # Pesante gym
}


# ═══════════════════════════════════════════════════════════════
# DOWNLOAD LOGIC
# ═══════════════════════════════════════════════════════════════

def search_wger(term: str) -> dict | None:
    """Search Wger API for an exercise, return first result with image."""
    url = WGER_SEARCH.format(term=urllib.parse.quote(term))
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'PhoenixApp/1.0'})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read())
    except (urllib.error.URLError, json.JSONDecodeError) as e:
        print(f'  ⚠ API error for "{term}": {e}')
        return None

    suggestions = data.get('suggestions', [])
    # Find first suggestion with an image
    for s in suggestions:
        img = s.get('data', {}).get('image')
        if img:
            return s['data']
    return None


def download_image(url: str, output_path: str) -> bool:
    """Download image from URL and convert to WebP."""
    tmp_path = output_path + '.tmp'
    full_url = url if url.startswith('http') else f'{WGER_BASE}{url}'

    try:
        req = urllib.request.Request(full_url, headers={'User-Agent': 'PhoenixApp/1.0'})
        with urllib.request.urlopen(req, timeout=15) as resp:
            with open(tmp_path, 'wb') as f:
                f.write(resp.read())
    except (urllib.error.URLError, OSError) as e:
        print(f'  ⚠ Download error: {e}')
        return False

    # Convert to WebP using ImageMagick
    try:
        subprocess.run(
            ['convert', tmp_path, '-resize', '600x600>', '-quality', '80', output_path],
            check=True, capture_output=True,
        )
        os.remove(tmp_path)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        # Fallback: try cwebp
        try:
            subprocess.run(
                ['cwebp', '-q', '80', '-resize', '600', '0', tmp_path, '-o', output_path],
                check=True, capture_output=True,
            )
            os.remove(tmp_path)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            # Keep original file renamed
            if os.path.exists(tmp_path):
                os.rename(tmp_path, output_path)
            return True


def main():
    os.makedirs(ASSETS_DIR, exist_ok=True)

    total = len(EXERCISE_MAP)
    downloaded = 0
    skipped = 0
    not_found = 0
    already_cached = {}  # term → local path (avoid re-downloading same image)

    print(f'Phoenix Exercise Image Downloader')
    print(f'Downloading images for {total} exercises from Wger API...')
    print(f'Output: {os.path.abspath(ASSETS_DIR)}')
    print()

    not_found_list = []

    for ex_id, search_term in sorted(EXERCISE_MAP.items()):
        output_path = os.path.join(ASSETS_DIR, f'{ex_id}.webp')

        # Skip if already exists
        if os.path.exists(output_path):
            skipped += 1
            print(f'  [{ex_id:3d}] {search_term:40s} → exists, skipping')
            continue

        # Check if we already downloaded this term (shared images)
        if search_term in already_cached and os.path.exists(already_cached[search_term]):
            # Copy the cached file
            subprocess.run(['cp', already_cached[search_term], output_path], check=True)
            downloaded += 1
            print(f'  [{ex_id:3d}] {search_term:40s} → copied from cache')
            continue

        # Search and download
        time.sleep(API_DELAY)
        result = search_wger(search_term)

        if result and result.get('image'):
            img_url = result['image']
            print(f'  [{ex_id:3d}] {search_term:40s} → {result["name"]}', end='')

            if download_image(img_url, output_path):
                size_kb = os.path.getsize(output_path) / 1024
                print(f' ({size_kb:.0f} KB)')
                downloaded += 1
                already_cached[search_term] = output_path
            else:
                print(' FAILED')
                not_found += 1
                not_found_list.append((ex_id, search_term))
        else:
            print(f'  [{ex_id:3d}] {search_term:40s} → NOT FOUND')
            not_found += 1
            not_found_list.append((ex_id, search_term))

    print()
    print(f'═══════════════════════════════════════')
    print(f'Results: {downloaded} downloaded, {skipped} cached, {not_found} not found')
    print(f'Total files in assets/exercises/: {len([f for f in os.listdir(ASSETS_DIR) if f.endswith(".webp")])}')

    if not_found_list:
        print()
        print('Missing exercises (need manual images):')
        for eid, term in not_found_list:
            print(f'  {eid}: {term}')

    print()
    print('Done. Run `flutter pub get` to refresh asset bundle.')


if __name__ == '__main__':
    main()
