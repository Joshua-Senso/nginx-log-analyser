#!/bin/bash
set -euo pipefail

LOG_FILE="${1:-access.log}"

if [ ! -f "$LOG_FILE" ]; then
  echo "Usage: $0 <nginx-access-log-file>"
  echo "Error: file not found: $LOG_FILE"
  exit 1
fi

echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" \
  | sort | uniq -c | sort -nr | head -5 \
  | awk '{printf "%s - %s requests\n", $2, $1}'

echo
echo "Top 5 most requested paths:"
# Nginx combined log: request is usually in field 6 (method) and 7 (path)
# e.g. "GET /path HTTP/1.1"
awk '{print $7}' "$LOG_FILE" \
  | sort | uniq -c | sort -nr | head -5 \
  | awk '{printf "%s - %s requests\n", $2, $1}'

echo
echo "Top 5 response status codes:"
awk '{print $9}' "$LOG_FILE" \
  | sort | uniq -c | sort -nr | head -5 \
  | awk '{printf "%s - %s requests\n", $2, $1}'

echo
echo "Top 5 user agents:"
awk '{
  line=$0
  last = match(line, /"[^"]*"$/)
  if (last) {
    ua = substr(line, RSTART+1, RLENGTH-2)
    print ua
  }
}' "$LOG_FILE" \
  | sort | uniq -c | sort -nr | head -5 \
  | awk '{
      count=$1
      $1=""
      sub(/^ /,"")
      printf "%s - %s requests\n", $0, count
    }'
