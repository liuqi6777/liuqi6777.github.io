#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v xelatex >/dev/null 2>&1; then
  echo "Error: xelatex is required to build the resumes." >&2
  exit 1
fi

build_dir="$(mktemp -d "${TMPDIR:-/tmp}/resume-build.XXXXXX")"
trap 'rm -rf "$build_dir"' EXIT

cd "$script_dir"
for lang in en zh; do
  for pass in 1 2; do
    if ! xelatex -interaction=nonstopmode -halt-on-error -file-line-error \
      -output-directory="$build_dir" "$lang.tex" >"$build_dir/$lang.stdout" 2>&1; then
      cat "$build_dir/$lang.stdout" >&2
      exit 1
    fi
  done
done

cp "$build_dir/en.pdf" "$script_dir/Qi_Liu_CV_en.pdf"
cp "$build_dir/zh.pdf" "$script_dir/Qi_Liu_CV_zh.pdf"
echo "Built $script_dir/Qi_Liu_CV_en.pdf"
echo "Built $script_dir/Qi_Liu_CV_zh.pdf"
