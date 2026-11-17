#!/usr/bin/env python3
"""
Scan a music folder and report audio quality, worst files first.
Read-only - never modifies anything.

Usage:
    python bitrate-audit.py "D:\\Music" "C:\\MusicTools\\reports\\bitrate-report.txt"
"""

import os
import sys

try:
    from mutagen import File
except ImportError:
    print("mutagen not installed.  Run:  pip install mutagen")
    sys.exit(1)

AUDIO_EXT = ('.mp3', '.m4a', '.flac', '.opus', '.ogg', '.wav', '.wma', '.aac')

LOSSLESS = ('.flac', '.wav', '.alac')


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    root = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else 'bitrate-report.txt'

    if not os.path.isdir(root):
        print(f"Not a folder: {root}")
        sys.exit(1)

    rows = []
    scanned = 0

    print(f"Scanning {root} ...")

    for dirpath, _, filenames in os.walk(root):
        for fn in filenames:
            if not fn.lower().endswith(AUDIO_EXT):
                continue

            path = os.path.join(dirpath, fn)
            scanned += 1
            if scanned % 500 == 0:
                print(f"  {scanned} files...")

            try:
                audio = File(path)
                if audio is None or not hasattr(audio, 'info'):
                    rows.append((-1, path, 'UNREADABLE'))
                    continue

                br = int(getattr(audio.info, 'bitrate', 0)) // 1000
                length = float(getattr(audio.info, 'length', 0))
                ext = os.path.splitext(fn)[1].lower()

                if ext in LOSSLESS:
                    note = f'LOSSLESS {br}kbps  {length/60:.1f}min'
                    sort_key = 9999
                else:
                    note = f'{br}kbps  {length/60:.1f}min'
                    sort_key = br

                rows.append((sort_key, path, note))

            except Exception as e:
                rows.append((-1, path, f'ERROR: {e}'))

    rows.sort(key=lambda r: r[0])

    with open(out, 'w', encoding='utf-8') as f:
        f.write('MUSIC QUALITY AUDIT\n')
        f.write(f'Folder: {root}\n')
        f.write('Sorted worst first. Nothing was modified.\n')
        f.write('=' * 70 + '\n\n')
        for _, path, note in rows:
            f.write(f'{note}\t{path}\n')

    unreadable = sum(1 for r in rows if r[0] == -1)
    under128 = sum(1 for r in rows if 0 <= r[0] < 128)
    under192 = sum(1 for r in rows if 0 <= r[0] < 192)
    under256 = sum(1 for r in rows if 0 <= r[0] < 256)
    lossless = sum(1 for r in rows if r[0] == 9999)

    print()
    print('=' * 50)
    print(f'  Total audio files : {len(rows)}')
    print(f'  Lossless          : {lossless}')
    print(f'  Under 256 kbps    : {under256}')
    print(f'  Under 192 kbps    : {under192}   <- worth replacing')
    print(f'  Under 128 kbps    : {under128}   <- definitely replace')
    print(f'  Unreadable/broken : {unreadable}')
    print('=' * 50)
    print(f'  Full report: {out}')


if __name__ == '__main__':
    main()
