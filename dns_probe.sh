#!/bin/bash


#echo "args = $#"
if [[ $# -lt 3 ]]; then
	echo $0 [output file] [dns queries per domain] [domain1] [domain2] ...
	exit -1
fi



#domains=("i0.wp.com" "i1.wp.com" "www.opensubtitles.com" "secure.gravatar.com" "tmdb.org" "images.plex.tv" "plex.tv" "metadata-static.plex.tv" "metadata.provider.plex.tv" "plex.bz" "tvthemes.plexapp.com.cdn.cloudflare.net" "plexapp.com" "plex.services.com" "thetvdb.com" "themoviedb.com" "lencr.org" "plex.tv" "www.plex.tv" "pubsub.plex.bz")

mkdir -p data
mkdir -p wl

DOMAINS="$@"
DNS_COUNT="$2"
OUTPUT="$1"

#echo "Output is $OUTPUT"

# Get always used dns servers and then random N lines from file
cp always_used_resolvers.txt data/resolvers.txt
shuf -n $DNS_COUNT resolvers/resolvers.txt >> data/resolvers.txt

x=0
i=0
for domain in $DOMAINS
do
	x=$((x+1))
	[[ $x -le 2 ]] && continue  #skip first 2 args

	echo "Processing $domain"
	while read dns 
	do	
		IPV4_REGEX='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
		BOGON_REGEX='(0\.|127\.|10\.|192\.168\.|172\.16\.|172\.17\.|172\.18\.|172\.19\.|172\.2[0-9]\.|172\.3[0-1]\.|100\.64\.|169\.254\.|192\.0\.0\.|192\.0\.2\.|22[4-9]\.|23[0-9]\.|24[0-9]\.|25[0-5]\.)'
		
		dig +short +time=2 @$dns $domain | egrep "^${IPV4_REGEX}$" | egrep -v "^${BOGON_REGEX}" | iprange - --except exclude-ips.txt >> data/$domain.txt &

		i=$((i+1))
		if [ $i -ge 5000 ]
		then
			wait
			i=0
			echo -n "."
		fi

	done < data/resolvers.txt
	echo ""
done

echo "Wait for done"
wait
#sleep 5

x=0
echo "" > wl/$OUTPUT

for domain in $DOMAINS
do
	x=$((x+1))
	[[ $x -le 2 ]] && continue  #skip first 2 args

	#Famous one-liner to store only unique lines in a file - http://www.catonmat.net/blog/awk-one-liners-explained-part-two/
	awk '!a[$0]++' data/$domain.txt > data/$domain.txt.tmp

	# Sort and remove BOGON networks, then compact into CIDR ranges using iprange utility 
	cat data/$domain.txt.tmp | sort | uniq | egrep -v "^${BOGON_REGEX}" | iprange - --except exclude-ips.txt | iprange > data/$domain.txt
	rm -f data/$domain.txt.tmp	
	
	echo "#$domain" >> wl/$OUTPUT
	echo "$domain" >> wl/$OUTPUT			# seems many routers will accept a FQDN and then do a DNS lookup
	cat data/$domain.txt >> wl/$OUTPUT
	echo "" >> wl/$OUTPUT

done


echo "Wrote wl/$OUTPUT"
wait




