#!/bin/bash
# Simple script to print files using the first available printer

# Check if files were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1> [file2] [file3] ..."
    echo "Example: $0 document.pdf image.png"
    exit 1
fi

# Check for default printer first
DEFAULT_PRINTER=$(lpstat -d 2>/dev/null | grep -oP "(?<=system default destination: ).*")

if [ -n "$DEFAULT_PRINTER" ]; then
    # Use default printer if it exists and is available
    PRINTER_STATUS=$(lpstat -p "$DEFAULT_PRINTER" 2>/dev/null | grep -E "is idle|is printing")
    if [ -n "$PRINTER_STATUS" ]; then
        PRINTER="$DEFAULT_PRINTER"
    fi
fi

# If no default or default unavailable, find first available printer
if [ -z "$PRINTER" ]; then
    PRINTER=$(lpstat -p 2>/dev/null | grep -E "printer .* is idle" | head -n1 | awk '{print $2}')
fi

# Check if a printer was found
if [ -z "$PRINTER" ]; then
    echo "Error: No available printers found"
    echo "Available printers:"
    lpstat -p 2>/dev/null || echo "  (none)"
    exit 1
fi

echo "Using printer: $PRINTER"
echo ""

# Print each file
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Error: File not found: $file"
        continue
    fi

    echo "Printing: $file"
    JOB_ID=$(lp -d "$PRINTER" "$file" 2>&1)

    if [ $? -eq 0 ]; then
        echo "  ✓ $JOB_ID"
    else
        echo "  ✗ Failed: $JOB_ID"
    fi
done

echo ""
echo "Print queue:"
lpstat -o
