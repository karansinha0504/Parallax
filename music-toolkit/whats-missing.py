#!/usr/bin/env python3
"""
Compare a list of wanted songs against your beets library and output
only the ones you do not already own.

Usage:
    python whats-missing.py wanted.txt library.txt [output_folder]

wanted.txt  - one song per line, any format:
                  Artist - Title
                  Title by Artist
                  01 - Kabira (PagalWorld.com).mp3
library.txt - produced by:  beet ls -f "$artist - $title" > library.txt
"""

import os
import re
import sys

try:
    from rapidfuzz import fuzz, process
except ImportError:
    print("rapidfuzz not installed.  Run:  pip install rapidfuzz")
    sys.exit(1)

# Match confidence, 0-100.
# Lower  = more aggressive matching, fewer things called missing
# Higher = stricter, more things called missing
THRESHOLD = 82
UNCERTAIN_BAND = 12   # how far below threshold still counts as "close"

JUNK_PATTERN = re.compile(
    r'\(.*?(?:\.com|\.in|\.net|\.info|official|lyric|video|audio|hd|full\s*song).*?\)'
    r'|\[.*?\]'
    r'|\b(?:official|lyrics?|video|audio|hd|4k|full\s*song|mp3|320kbps|128kbps|'
    r'free\s*download|downloaded\s*from)\b'
    r'|\.(?:mp3|m4a|flac|opus|ogg|wav)$',
    re.IGNORECASE,
)

TRACK_NUM = re.compile(r'^\s*\d{1,3}[\s\.\-_]+')


def normalise(s: str) -> str:
    """Strip download-site junk, track numbers, punctuation and case."""
    s = s.strip()
    s = TRACK_NUM.sub('', s)
    s = JUNK_PATTERN.sub(' ', s)
    s = re.sub(r'[^\w\s]', ' ', s)
    s = re.sub(r'\s+', ' ', s)
    return s.lower().strip()


def load(path):
    with open(path, encoding='utf-8', errors='replace') as f:
        return [line.strip() for line in f if line.strip()]


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    wanted_path = sys.argv[1]
    library_path = sys.argv[2]
    outdir = sys.argv[3] if len(sys.argv) > 3 else '.'

    os.makedirs(outdir, exist_ok=True)

    wanted_raw = load(wanted_path)
    library_raw = load(library_path)

    if not library_raw:
        print("Library list is empty. Run the export option first.")
        sys.exit(1)

    library_norm = [normalise(x) for x in library_raw]
    lookup = {}
    for norm, raw in zip(library_norm, library_raw):
        lookup.setdefault(norm, raw)

    missing, have, uncertain = [], [], []
    seen = set()

    for raw in wanted_raw:
        norm = normalise(raw)
        if not norm or norm in seen:
            continue
        seen.add(norm)

        match = process.extractOne(
            norm, library_norm, scorer=fuzz.token_set_ratio
        )

        if match is None:
            missing.append(raw)
            continue

        matched_norm, score, _ = match

        if score >= THRESHOLD:
            have.append((raw, lookup.get(matched_norm, ''), score))
        elif score >= THRESHOLD - UNCERTAIN_BAND:
            uncertain.append((raw, lookup.get(matched_norm, ''), score))
        else:
            missing.append(raw)

    missing_file = os.path.join(outdir, 'missing.txt')
    uncertain_file = os.path.join(outdir, 'uncertain.txt')
    have_file = os.path.join(outdir, 'already-have.txt')

    with open(missing_file, 'w', encoding='utf-8') as f:
        for line in missing:
            f.write(line + '\n')

    with open(uncertain_file, 'w', encoding='utf-8') as f:
        f.write('CLOSE CALLS - check these by hand.\n')
        f.write('Transliterated titles vary a lot (Kabira / Kabhira /\n')
        f.write('Kabira - Encore), so this is where matching is weakest.\n')
        f.write('=' * 60 + '\n\n')
        for raw, found, score in uncertain:
            f.write(f'WANTED : {raw}\n')
            f.write(f'MAYBE  : {found}   ({score:.0f}% match)\n\n')

    with open(have_file, 'w', encoding='utf-8') as f:
        for raw, found, score in have:
            f.write(f'{raw}\t->\t{found}\t({score:.0f}%)\n')

    print()
    print('=' * 50)
    print(f'  Wanted list     : {len(seen)} unique songs')
    print(f'  Already have    : {len(have)}')
    print(f'  Missing         : {len(missing)}')
    print(f'  Uncertain       : {len(uncertain)}   <- check by hand')
    print('=' * 50)
    print(f'  {missing_file}')
    print(f'  {uncertain_file}')
    print()
    print('  If too many things are called missing, lower THRESHOLD')
    print('  toward 75 at the top of this script. If it wrongly says')
    print('  you already have things, raise it toward 88.')


if __name__ == '__main__':
    main()
