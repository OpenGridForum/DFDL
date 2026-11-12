"""Write the landing page for the workgroup review version on GitHub Pages.

The pages workflow builds the OGF edition from the latest review tag and
publishes it with this page in front, so the link sent to reviewers never
changes while the version behind it does.  The page names the tag, links the
HTML and PDF, and opens a new issue titled "<tag> issue: " whose body names
the tag and commit, so every report says which version it was found in.

    python3 tools/review-page.py --tag v1.2.2-RC1 --date 2026-11-12 \
        --commit 54d8a0e --repo OpenGridForum/DFDL \
        --stem gwdrp-dfdl-v1.2.2-GFD-R.240 --docid GFD-R.240 \
        --out site/spec/index.html
"""

import argparse
import html
from pathlib import Path
from urllib.parse import quote

PAGE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>DFDL {tag} review</title>
<style>
  :root {{
    --bg: #f6f8fa; --card: #ffffff; --fg: #1f2328; --muted: #59636e;
    --rule: #d1d9e0; --accent: #0b5cad; --accent-fg: #ffffff;
  }}
  @media (prefers-color-scheme: dark) {{
    :root {{
      --bg: #0d1117; --card: #161b22; --fg: #e6edf3; --muted: #9198a1;
      --rule: #30363d; --accent: #3a8ee6; --accent-fg: #0d1117;
    }}
  }}
  * {{ box-sizing: border-box; }}
  body {{
    margin: 0; background: var(--bg); color: var(--fg);
    font: 16px/1.5 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  }}
  main {{
    max-width: 44rem; margin: 0 auto; padding: 4rem 1rem 2rem; text-align: center;
  }}
  .eyebrow {{
    margin: 0; color: var(--muted); font-size: 0.8rem; font-weight: 600;
    letter-spacing: 0.08em; text-transform: uppercase;
  }}
  h1 {{
    margin: 0.4rem 0 0.5rem; font-size: 3rem; line-height: 1.1;
    letter-spacing: -0.02em; font-variant-numeric: tabular-nums;
  }}

  .formats {{
    display: flex; flex-wrap: wrap; justify-content: center; gap: 0.75rem;
    margin: 2rem 0 2.5rem;
  }}
  .button {{
    display: inline-block; padding: 0.7rem 1.4rem; border-radius: 6px;
    border: 1px solid var(--accent); font-weight: 600; text-decoration: none;
  }}
  .primary {{ background: var(--accent); color: var(--accent-fg); }}
  .secondary {{ color: var(--accent); }}
  .button:hover {{ filter: brightness(1.1); }}
  .report {{
    padding: 1rem 1.25rem; background: var(--card);
    border: 1px solid var(--rule); border-radius: 6px;
  }}
  .report p {{ margin: 0; }}
  a {{ color: var(--accent); }}
  footer {{
    margin-top: 3rem; padding-top: 1rem; border-top: 1px solid var(--rule);
    color: var(--muted); font-size: 0.85rem;
  }}
  footer p {{ margin: 0.25rem 0; }}
  code {{ font-size: 0.95em; }}
</style>
</head>
<body>
<main>
<p class="eyebrow">DFDL Working Group &middot; review version</p>
<h1>{tag}</h1>

<div class="formats">
  <a class="button primary" href="{stem}.htm" target="_blank"
     rel="noopener">Read online</a>
  <a class="button secondary" href="{stem}.pdf" target="_blank"
     rel="noopener">PDF</a>
</div>

<div class="report">
  <p><strong>Found a problem?</strong>
  <a href="{issue_url}">Report it on GitHub</a>, naming the section.</p>
</div>

<footer>
  <p>Tagged {date} &middot; <a href="{tag_url}"><code>{tag}</code></a>
  &middot; commit <code>{commit}</code></p>
  <p>A draft for review, not the published {docid}. The published editions
  are available from OGF and ISO.</p>
</footer>
</main>
</body>
</html>
"""


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--tag", required=True, help="review tag, e.g. v1.2.2-RC1")
    parser.add_argument("--date", required=True, help="date the tag was made")
    parser.add_argument("--commit", required=True, help="short commit the tag names")
    parser.add_argument("--repo", required=True, help="owner/name on GitHub")
    parser.add_argument("--stem", required=True, help="file name of the HTML and PDF")
    parser.add_argument(
        "--docid", required=True, help="OGF document ID, e.g. GFD-R.240"
    )
    parser.add_argument("--out", required=True, type=Path, help="page to write")
    args = parser.parse_args()

    label = args.tag.removeprefix("v")
    base = f"https://github.com/{args.repo}"
    title = quote(f"{args.tag} issue: ")
    body = quote(f"Version: {args.tag} (commit {args.commit})\nSection: \n\n")
    page = PAGE.format(
        label=html.escape(label),
        tag=html.escape(args.tag),
        date=html.escape(args.date),
        commit=html.escape(args.commit),
        stem=html.escape(args.stem),
        docid=html.escape(args.docid),
        issue_url=html.escape(f"{base}/issues/new?title={title}&body={body}"),
        tag_url=html.escape(f"{base}/tree/{quote(args.tag)}"),
    )
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(page, encoding="utf-8")


if __name__ == "__main__":
    main()
