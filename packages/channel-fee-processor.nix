{ pkgs }:

# This function defines the derivation, taking the pkgs set as an argument.
pkgs.stdenv.mkDerivation {
  pname = "channel-fee-processor";
  version = "1.0.0";

  # Define the dependencies (tools used by the script)
  buildInputs = [
    pkgs.bash
    pkgs.coreutils
    pkgs.gawk
    pkgs.jq
    pkgs.xz
    pkgs.findutils
  ];

  # The script content using pkgs.writeScriptBin
  feeProcessorScript = pkgs.writeScriptBin "process_fees" ''
    #!${pkgs.bash}/bin/bash

    # --- Configuration ---
    OUTPUT_DIR="channel_fees"
    ${pkgs.coreutils}/bin/mkdir -p "$OUTPUT_DIR"
    HEADER="date,in_ppm,out_ppm"
    BATCH_SIZE=30

    # --- Auto-Detect Resume Timestamp ---
    echo "Checking for previous progress in $OUTPUT_DIR..." >&2
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
        | {c: .[0].short_channel_id, in: $fees["1"], out: $fees["0"]} 
      ) 
    | .[] 
    | "\(.c)\t\($date),\(.in // "null"),\(.out // "null")"
    '

    # --- Main Processing Pipeline (ensure all commands use explicit paths) ---
    ${pkgs.findutils}/bin/find . -maxdepth 1 -name "*.json.xz" -printf "%T@ %p\n" | \
    ${pkgs.coreutils}/bin/sort -n | \
    ${pkgs.gawk}/bin/awk -v start="$START_TS" '$1 > start {print $2}' | \
    while read -r file; do
        
        DATE=$(${pkgs.coreutils}/bin/stat -c %Y "$file")
        
        ${pkgs.xz}/bin/xzcat "$file" | ${pkgs.jq}/bin/jq -r --arg date "$DATE" "$JQ_SCRIPT"
        
        ((counter++))
        echo "Buffered: $file ($DATE) [Batch: $counter/$BATCH_SIZE]" >&2
        
        if (( counter >= BATCH_SIZE )); then
            echo "__FLUSH__"
            echo "--- Flushing Batch to Disk ---" >&2
            counter=0
        fi

    done | ${pkgs.gawk}/bin/awk -F'\t' -v dir="$OUTPUT_DIR" -v header="$HEADER" '
        # (The rest of your awk script for flushing batches)
        $1 == "__FLUSH__" {
            # ... awk flush logic ...
            print "awk: Writing batch to disk..." > "/dev/stderr"
            for (scid in buffer) {
                outfile = dir "/" scid ".csv"
                if ( !seen[scid]++ ) {
                    if ( (getline test < outfile) < 0 ) {
                        print header > outfile
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
            if (buffer[$1] == "") {
                buffer[$1] = $2
            } else {
                buffer[$1] = buffer[$1] "\n" $2
            }
        }
        END {
            if (length(buffer) > 0) {
                print "awk: Flushing final remnants..." > "/dev/stderr"
                for (scid in buffer) {
                    outfile = dir "/" scid ".csv"
                    if ( !seen[scid]++ ) {
                        if ( (getline test < outfile) < 0 ) {
                            print header > outfile
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
  '';

  installPhase = ''
    mkdir -p $out/bin
    ln -s $feeProcessorScript $out/bin/process_fees
  '';
}
