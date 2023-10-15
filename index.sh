#!/usr/bin/env sh

source secrets

mkdir -p "$HOME/tmp"
start_endpoint="https://innosoftfusiongo.com/sso/login/login-start.php?id=21"
cookiejar="$HOME/tmp/cookiejar"
curl -sIc "$cookiejar" "$start_endpoint" -o /dev/null
process_endpoint="https://innosoftfusiongo.com/sso/login/login-process-fusion.php"
curl -sX POST -c "$cookiejar" -b "$cookiejar" -o /dev/null $process_endpoint -H 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode "username=$username" \
    --data-urlencode "password=$password" \
    --data-urlencode 'Submit=Login'
finish_endpoint="https://innosoftfusiongo.com/sso/login/login-finish.php"
token="$(curl -siIc "$cookiejar" -b "$cookiejar" $finish_endpoint | awk '/Fusion-Token/ {print $2}')"
barcode_endpoint="https://innosoftfusiongo.com/sso/api/barcode.php?id=21"
if [ -n "$token" ]; then
    barcode="$(curl -sX GET -c "$cookiejar" -b "$cookiejar" -H "Authorization: Bearer $token" "$barcode_endpoint" |
        jq -rc '.[].AppBarcodeIdNumber')"
    rm -f "$cookiejar"
    if [ -n "$barcode" ]; then
        echo "https://barcodeapi.org/api/128/$barcode"
        exit 0
    fi
    exit 1
fi
rm -f "$cookiejar"
exit 1
