{ pkgs }:

pkgs.writeScriptBin "process_fees" ''
  #!${pkgs.bash}/bin/bash

  # --- Configuration ---
  OUTPUT_DIR="channel_fees"
  # We use explicit paths to ensure dependencies work without 'buildInputs'
  ${pkgs.coreutils}/bin/mkdir -p "$OUTPUT_DIR"
  BATCH_SIZE=30

  # --- Auto-Detect Resume Timestamp ---
  echo "Checking for previous progress in $OUTPUT_DIR..." >&2
  
  # Note: Using pkgs.findutils here as corrected previously
  LAST_MODIFIED_FILE=$(${pkgs.findutils}/bin/find "$OUTPUT_DIR" -maxdepth 1 -name "*.csv" -printf "%T@ %p\n" | ${pkgs.coreutils}/bin/sort -nr | ${pkgs.coreutils}/bin/head -n 1 | ${pkgs.coreutils}/bin/cut -d' ' -f2-)

  START_TS=0

  if [ -z "$LAST_MODIFIED_FILE" ]; then
      echo "No previous output found. Starting from the beginning." >&2
  else
      if LAST_LINE=$(${pkgs.coreutils}/bin/tail -n 1 "$LAST_MODIFIED_FILE" 2>/dev/null); then
          LAST_DATE=$(${pkgs.coreutils}/bin/echo "$LAST_LINE" | ${pkgs.coreutils}/bin/cut -d',' -f1)
          if [[ "$LAST_DATE" =~ ^[0-9]+$ ]]; then
              START_TS="$LAST_DATE"
              HUMAN_DATE=$(${pkgs.coreutils}/bin/date -d @$START_TS)
              echo "Found latest data from: $HUMAN_DATE ($START_TS)" >&2
              echo "Resuming processing files NEWER than this timestamp." >&2
          else
              echo "Latest file appeared empty or invalid. Starting from the beginning." >&2
              START_TS=0
          fi
      else
          START_TS=0
      fi
  fi

  # --- JQ Script ---
  JQ_SCRIPT='
  .channels 
  | group_by(.short_channel_id) 
  | map( 
      (map({key: (.direction | tostring), value: .fee_per_millionth}) | from_entries) as $fees 
      | {
          c: .[0].short_channel_id, 
          src: .[0].source, 
          dst: .[0].destination, 
          fee_src: $fees["0"], 
          fee_dst: $fees["1"]
        } 
    ) 
  | .[] 
  | "\(.c)\t\(.src)\t\(.dst)\t\($date),\(.fee_src // "null"),\(.fee_dst // "null")"
  '

  # --- Main Processing Pipeline ---

  ${pkgs.findutils}/bin/find . -maxdepth 1 -name "*.json.xz" -printf "%f\n" | \
  ${pkgs.coreutils}/bin/sort -n | \
  ${pkgs.gawk}/bin/awk -v start="$START_TS" '{
      # Extract timestamp from filename (e.g., "1763733546.json.xz" -> "1763733546")
      match($0, /^([0-9]+)\.json\.xz$/, arr)
      ts = arr[1]
      if (ts > start) print $0
  }' | \
  while read -r file; do
      
      # Extract timestamp from filename to use as date
      DATE=$(${pkgs.coreutils}/bin/basename "$file" .json.xz)
      
      ${pkgs.xz}/bin/xzcat "$file" | ${pkgs.jq}/bin/jq -r --arg date "$DATE" "$JQ_SCRIPT"
      
      ((counter++))
      
      echo "Buffered: $file (timestamp: $DATE) [Batch: $counter/$BATCH_SIZE]" >&2
      
      if (( counter >= BATCH_SIZE )); then
          echo "__FLUSH__"
          echo "--- Flushing Batch to Disk ---" >&2
          counter=0
      fi

  done | ${pkgs.gawk}/bin/awk -F'\t' -v dir="$OUTPUT_DIR" '
      $1 == "__FLUSH__" {
          print "awk: Writing batch to disk..." > "/dev/stderr"
          for (scid in buffer) {
              outfile = dir "/" scid ".csv"
              if ( !seen[scid]++ ) {
                  if ( (getline test < outfile) < 0 ) {
                      print "date," headers[scid] > outfile
                  }
                  close(outfile)
              }
              print buffer[scid] >> outfile
              close(outfile)
          }
          delete buffer
          print "awk: Batch write complete." > "/dev/stderr"
          next
      }
      {
          scid = $1
          src = $2
          dst = $3
          data = $4
          
          if (headers[scid] == "") {
              headers[scid] = src "," dst
          }
          
          if (buffer[scid] == "") {
              buffer[scid] = data
          } else {
              buffer[scid] = buffer[scid] "\n" data
          }
      }
      END {
          if (length(buffer) > 0) {
              print "awk: Flushing final remnants..." > "/dev/stderr"
              for (scid in buffer) {
                  outfile = dir "/" scid ".csv"
                  if ( !seen[scid]++ ) {
                      if ( (getline test < outfile) < 0 ) {
                          print "date," headers[scid] > outfile
                      }
                      close(outfile)
                  }
                  print buffer[scid] >> outfile
                  close(outfile)
              }
          }
      }
  '

  echo "Processing complete." >&2
''
