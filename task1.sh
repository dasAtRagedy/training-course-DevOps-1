#!/bin/bash

echo "Script started."

# using awk
awk 'BEGIN { OFS=FS="," }

    function replaceCommas(s,   i, insideQuotes, result, char) {
        result = "";
        insideQuotes = 0;
        for ( i=1; i<=length(s); i++ ) {
            char = substr(s, i, 1);
            if (char == "\"")
                insideQuotes = !insideQuotes;
            else if (char == "," && insideQuotes)
                char = "__COMMA__";
            result = result char;
        }
        return result;
    }

    function restoreCommas(s) {
        gsub(/__COMMA__/, ",", s);
        return s;
    }

    {
        $0 = replaceCommas($0);

        if (NR>1) {
            n = split($3, name, " ");
            out = "";
            for ( i=1; i<=n; i++ ) {
                if ( i!=1 )
                    out = out " ";
                m = split(name[i], words, "-");
                mout = "";
                for ( j=1; j<=m; j++ ) {
                    if ( j!=1 )
                        mout = mout "-";
                    mout = mout toupper(substr(words[j], 1, 1)) tolower(substr(words[j], 2))
                }
                out = out mout;
            };
            $3 = out;

            key = tolower(substr(name[1], 1, 1)) tolower(name[2]);
            seen[key]++;
            lines[NR] = $0;
        }
        else
            print;
    }
    END {
        for ( i=2; i<=NR; i++ ) {
            n = split(lines[i], fields, FS);
            split(fields[3], name, " ");
            key = tolower(substr(name[1], 1, 1)) tolower(name[2]);
            if ( seen[key] > 1 ) {
                fields[5] = key fields[2] "@abc.com";
            } else {
                fields[5] = key "@abc.com";
            }
            
            out = "";
            for ( j=1; j<=n; j++ ){
                if ( j != 1 )
                    out = out FS;
                out = out fields[j];
            }
            out = restoreCommas(out);
            print out;
        }
    }
    ' $1 > accounts_new.csv

echo "Script finished."
