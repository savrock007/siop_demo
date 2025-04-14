#!/bin/bash

LOGFILE="laravel_resource_log.txt"
INTERVAL=1

echo "elapsed_ms,%cpu,%mem,rss_kb" > "$LOGFILE"

PID=$(pgrep -f "php artisan serve")

if [ -z "$PID" ]; then
    echo "Laravel server not running."
    exit 1
fi

echo "Monitoring PID $PID..."

START_TIME=$(perl -MTime::HiRes=time -e 'printf "%.0f\n", time()*1000')

while true
do
    CURRENT_TIME=$(perl -MTime::HiRes=time -e 'printf "%.0f\n", time()*1000')
    ELAPSED_MS=$((CURRENT_TIME - START_TIME))

    STATS=$(ps -p "$PID" -o %cpu=,%mem=,rss= | awk '{print $1","$2","$3}')

    if [ -n "$STATS" ]; then
        echo "$ELAPSED_MS,$STATS" >> "$LOGFILE"
    fi

    sleep $INTERVAL
done

