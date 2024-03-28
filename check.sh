#!/bin/bash

DESKTOP_USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0"
MOBILE_USER_AGENT="Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604."
HEADLESS_CHROME="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --headless --disable-gpu --dump-dom"
TEMP_PATH="/tmp"

check_youtube_availability() {
    STATUS=$(($(curl -I -H "User-Agent: $DESKTOP_USER_AGENT" https://www.youtube.com/@$1 2>/dev/null | head -n 1 | cut -d$' ' -f2)))
    
    printf $([ $STATUS != 200 ] && echo "\033[0;32mAvailable\033[0m" || echo "\033[0;31mUnavailable\033[0m")
}

check_twitch_availability() {
    # idon't know why
    curl -s -H "User-Agent: $DESKTOP_USER_AGENT" https://www.twitch.tv/$1 > /dev/null && sleep 1
    curl -s -H "User-Agent: $DESKTOP_USER_AGENT" https://www.twitch.tv/$1 > $TEMP_PATH/$1.log
    
    COUNT=$(($( grep $1 $TEMP_PATH/$1.log | wc -l ))) && rm -Rf $TEMP_PATH/$1.log
    
    printf $([ $COUNT -eq 0 ] && echo "\033[0;32mAvailable\033[0m" || echo "\033[0;31mUnavailable\033[0m")
}

check_instagram_availability(){

    eval $HEADLESS_CHROME https://www.instagram.com/$1/ > $TEMP_PATH/$1.log 2>&1

    SIZE=$(($(wc -c < $TEMP_PATH/$1.log))) && rm -Rf $TEMP_PATH/$1.log

    printf $([ $SIZE -gt 300000 ] && echo "\033[0;31mUnavailable\033[0m" || echo "\033[0;32mAvailable\033[0m")
}

check_tiktok_availability() {
    curl -s -H "User-Agent: $DESKTOP_USER_AGENT" https://www.tiktok.com/@$1 > $TEMP_PATH/$1.log

    COUNT=$(($( grep "desc\":\"@$1" $TEMP_PATH/$1.log | wc -l ))) && rm -Rf $TEMP_PATH/$1.log

    printf $([ $COUNT -eq 0 ] && echo "\033[0;32mAvailable\033[0m" || echo "\033[0;31mUnavailable\033[0m")
}

check_threads_availability() {
    curl -s -H "User-Agent: $MOBILE_USER_AGENT" https://www.threads.net/@$1 > $TEMP_PATH/$1.log

    SIZE=$(($(wc -c < $TEMP_PATH/$1.log))) && rm -Rf $TEMP_PATH/$1.log

    printf $([ $SIZE -gt 210000 ] && echo "\033[0;31mUnavailable\033[0m" || echo "\033[0;32mAvailable\033[0m")
}

check_bluesky_availability() {
    curl -s -H "User-Agent: $MOBILE_USER_AGENT" https://bsky.app/profile/$1.bsky.social > $TEMP_PATH/$1.log

    COUNT=$(($( grep $1 $TEMP_PATH/$1.log | wc -l ))) && rm -Rf $TEMP_PATH/$1.log

    printf $([ $COUNT -eq 0 ] && echo "\033[0;32mAvailable\033[0m" || echo "\033[0;31mUnavailable\033[0m")
}

check_all_social_availability() {
    printf "Checking @$1\n"
    RESULT=$(check_youtube_availability $1)
    echo "    YouTube:" $RESULT "(https://youtube.com/@$1)"
    RESULT=$(check_twitch_availability $1)
    echo "    Twitch:" $RESULT "(https://twitch.tv/$1)"
    RESULT=$(check_instagram_availability $1)
    echo "    Instagram:" $RESULT "(https://instagram.com/$1/)"
    RESULT=$(check_tiktok_availability $1)
    echo "    TikTok": $RESULT "(https://tiktok.com/@$1)"
    RESULT=$(check_threads_availability $1)
    echo "    Threads": $RESULT "(https://www.threads.net/@$1)"
    RESULT=$(check_bluesky_availability $1)
    echo "    BlueSky": $RESULT "(https://bsky.app/profile/$1.bsky.social)"
}

random_sleep(){
    SLEEP=$(shuf -i 2-15 -n 1)
    printf "\nSleeping $SLEEP seconds\n" 
    sleep $SLEEP
}

if [ -f $1 ]; then
    COUNTER=0
    cat $1 | while read USERNAME
    do
        [ -z "$USERNAME" ] && continue
        
        [ $COUNTER -gt 0 ] && random_sleep

        check_all_social_availability $USERNAME

        let COUNTER=COUNTER+1
    done
else 
    check_all_social_availability $1
fi
