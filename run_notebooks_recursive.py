#!/usr/bin/env python3
"""Execute Jupyter notebooks recursively and report pass/fail summary."""

from __future__ import annotations

import argparse
import importlib
import sys
import time
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Execute .ipynb notebooks recursively and validate they run."
    )
    parser.add_argument(
        "root",
        nargs="?",
        default="Python",
        help="Root directory to search recursively (default: Python)",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=600,
        help="Per-cell timeout in seconds (default: 600)",
    )
    parser.add_argument(
        "--kernel",
        default=None,
        help="Kernel name override (default: notebook metadata)",
    )
    parser.add_argument(
        "--in-place",
        action="store_true",
        help="Write outputs back to each source notebook.",
    )
    parser.add_argument(
        "--output-dir",
        default=None,
        help="Directory where executed notebooks are written (mirrors tree).",
    )
    parser.add_argument(
        "--stop-on-fail",
        action="store_true",
        help="Stop at first failed notebook (default: keep running all).",
    )
    parser.add_argument(
        "--pattern",
        default="*.ipynb",
        help="Filename glob pattern (default: *.ipynb)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="List notebooks to execute without executing.",
    )
    return parser.parse_args()


def discover_notebooks(root: Path, pattern: str) -> list[Path]:
    return sorted(
        p
        for p in root.rglob(pattern)
        if p.is_file() and ".ipynb_checkpoints" not in p.parts
    )


def execute_notebook(
    path: Path,
    timeout: int,
    kernel: str | None,
    in_place: bool,
    output_root: Path | None,
    root: Path,
) -> tuple[bool, str]:
    try:
        nbformat = importlib.import_module("nbformat")
        preprocessors = importlib.import_module("nbconvert.preprocessors")
        ExecutePreprocessor = getattr(preprocessors, "ExecutePreprocessor")
        CellExecutionError = getattr(preprocessors, "CellExecutionError")
    except ImportError as exc:
        return False, (
            "Missing dependency for execution: "
            f"{exc}. Install with: pip install nbformat nbconvert jupyter_client"
        )

    notebook = nbformat.read(path, as_version=4)
    pre = ExecutePreprocessor(timeout=timeout, kernel_name=kernel)

    try:
        pre.preprocess(notebook, {"metadata": {"path": str(path.parent)}})
    except CellExecutionError as exc:
        return False, str(exc)
    except Exception as exc:  # noqa: BLE001
        return False, repr(exc)

    if in_place:
        target = path
    elif output_root is not None:
        target = output_root / path.relative_to(root)
        target.parent.mkdir(parents=True, exist_ok=True)
    else:
        target = None

    if target is not None:
        nbformat.write(notebook, target)

    return True, "OK"


def main() -> int:
    args = parse_args()
    root = Path(args.root).resolve()

    if not root.exists() or not root.is_dir():
        print(f"[ERROR] Root directory does not exist or is not a directory: {root}")
        return 2

    notebooks = discover_notebooks(root, args.pattern)
    if not notebooks:
        print(f"[WARN] No notebooks found under: {root}")
        return 1

    print(f"Found {len(notebooks)} notebook(s) under {root}")
    for nb in notebooks:
        print(f" - {nb}")

    if args.dry_run:
        return 0

    output_root = Path(args.output_dir).resolve() if args.output_dir else None
    if output_root is not None:
        output_root.mkdir(parents=True, exist_ok=True)

    passed = 0
    failed = 0
    start = time.time()

    for idx, nb in enumerate(notebooks, start=1):
        print(f"\n[{idx}/{len(notebooks)}] Executing: {nb}")
        ok, message = execute_notebook(
            path=nb,
            timeout=args.timeout,
            kernel=args.kernel,
            in_place=args.in_place,
            output_root=output_root,
            root=root,
        )
        if ok:
            passed += 1
            print("  [PASS]", message)
        else:
            failed += 1
            print("  [FAIL]", message)
            if args.stop_on_fail:
                break

    elapsed = time.time() - start
    print("\n===== Summary =====")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    print(f"Elapsed: {elapsed:.1f}s")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
