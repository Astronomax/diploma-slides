#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
typst compile "$ROOT/slides.typ" "$ROOT/slides-typst.pdf"
