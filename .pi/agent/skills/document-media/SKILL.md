---
name: document-media
description: Extracts text and inspects local PDFs, office documents, ebooks, images, audio, and video using Poppler, OCR, Pandoc, macOS textutil, ffprobe, and ffmpeg while preserving originals and bounding generated output.
compatibility: Requires Poppler, pdftohtml, Tesseract, OCRmyPDF, Pandoc, ffprobe, and ffmpeg on PATH; uses macOS textutil when available.
---

# Document and Media Tools

Preserve source files. Write generated files to a fresh temporary directory by default, report its path when the user needs the artifacts, and remove it when outputs are only intermediate.

```bash
tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/pi-document-media.XXXXXX")"
```

Quote every path. Never overwrite an existing output; use `-n` with `ffmpeg`. Inspect the file type, size, and relevant metadata before choosing an extractor.

## Extraction order

1. Inspect metadata and determine whether the document already contains text.
2. Prefer native text extraction.
3. Retry with layout preservation only when spatial structure matters.
4. Render and OCR selected pages only when native extraction is empty or unusable.
5. Create a searchable OCR PDF only when the user requests one.

## PDF inspection and native text

Inspect a PDF before extraction:

```bash
pdfinfo '/path/to/input.pdf'

pdffonts -f 1 -l 10 '/path/to/input.pdf'

pdfimages -list -f 1 -l 10 '/path/to/input.pdf'
```

Do not assume that a font listing guarantees useful text. Try `pdftotext` and inspect whether its output is meaningful. Bound the first pass to 10 pages:

```bash
pdftotext -f 1 -l 10 -enc UTF-8 \
  '/path/to/input.pdf' "$tmpdir/output.txt"
```

When columns, tables, or positioning matter, retry with layout preservation:

```bash
pdftotext -f 1 -l 10 -layout -enc UTF-8 \
  '/path/to/input.pdf' "$tmpdir/output-layout.txt"
```

Use `pdftohtml` when HTML structure is more useful than plain text:

```bash
pdftohtml -q -i -f 1 -l 10 -enc UTF-8 \
  '/path/to/input.pdf' "$tmpdir/output.html"
```

Inspect only the generated text needed for the request. Do not pass PDF passwords on the command line; ask the user to provide an already-accessible document through an appropriate secure workflow.

## Scanned PDFs and image OCR

If native extraction fails, render only the relevant pages at a moderate resolution and size:

```bash
pdftoppm -f 1 -l 3 -r 150 -scale-to 1600 -png \
  '/path/to/input.pdf' "$tmpdir/page"
```

OCR a selected rendered page to standard output or a temporary text file. Use the document's known language instead of assuming English when possible:

```bash
tesseract "$tmpdir/page-1.png" "$tmpdir/page-1" -l eng txt
```

Default to at most three OCR pages on the first pass because OCR is expensive. Do not claim OCR text is exact; preserve uncertainty around names, numbers, punctuation, and tables.

When the user explicitly requests a searchable PDF, use OCRmyPDF to create a new temporary output while retaining existing text. `--pages` limits OCR work but the output PDF still contains the full document:

```bash
ocrmypdf --no-overwrite --output-type pdf --pages 1-10 \
  --skip-text --deskew --rotate-pages --jobs 2 \
  --tesseract-timeout 60 --max-ocr-image-mpixels 25 \
  '/path/to/input.pdf' "$tmpdir/searchable.pdf"
```

Never replace the source PDF. Do not use `--force-ocr`, remove backgrounds, downsample visible pages, or perform lossy optimization unless the user requests that tradeoff.

## Office documents, ebooks, and markup

On macOS, use `textutil` for a lightweight conversion of supported DOC, DOCX, RTF, HTML, and related documents:

```bash
textutil -convert txt -output "$tmpdir/output.txt" \
  '/path/to/input.docx'
```

Use Pandoc for supported formats such as DOCX, ODT, EPUB, HTML, and markup when `textutil` is unsuitable:

```bash
pandoc --to=plain --wrap=none \
  --output="$tmpdir/output.txt" '/path/to/input.docx'
```

Do not enable Lua filters, external filters, shell commands, or media extraction unless explicitly required. Check source and output sizes before reading converted content; document formats do not offer a universal page-range limit.

## Media metadata

Use `ffprobe` before extraction and request only useful structured fields:

```bash
ffprobe -v error -of json \
  -show_entries 'format=filename,format_name,duration,size:stream=index,codec_type,codec_name,width,height,sample_rate,channels' \
  '/path/to/input'
```

Avoid packet- or frame-level dumps unless specifically needed because they can be very large.

## Targeted media extraction

Extract one frame at a known timestamp:

```bash
ffmpeg -hide_banner -loglevel error -n -ss '00:00:10' \
  -i '/path/to/input' -frames:v 1 "$tmpdir/frame.png"
```

Extract a short clip, bounding duration and output dimensions and bitrate as appropriate:

```bash
ffmpeg -hide_banner -loglevel error -n -ss '00:00:10' -t 15 \
  -i '/path/to/input' -vf 'scale=1280:-2' -c:v libx264 -crf 23 \
  -c:a aac -b:a 128k "$tmpdir/clip.mp4"
```

Extract a short mono audio segment:

```bash
ffmpeg -hide_banner -loglevel error -n -ss '00:00:10' -t 30 \
  -i '/path/to/input' -vn -ac 1 -ar 16000 "$tmpdir/audio.wav"
```

Default bounds unless the user requests otherwise:

- At most 10 PDF pages for native extraction on the first pass.
- At most three OCR pages on the first pass.
- One frame, or at most 12 targeted frames.
- At most 30 seconds for a clip or audio sample.
- Scale rendered pages and video frames to at most 1600 and 1280 pixels wide, respectively, when full resolution is unnecessary.
- Check expected size and available disk space before larger extraction.

## Safety and limitations

Never modify or overwrite originals. Do not recursively scan personal document or media collections. Remove temporary artifacts after use unless the user asked to keep them.

OCR is text recognition, not guaranteed transcription accuracy. `ffmpeg` audio extraction does not transcribe speech; do not claim speech-transcription support unless a separate configured speech-recognition tool is available and actually used.
