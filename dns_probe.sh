#!/bin/bash


echo "args = $#"
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

# Get random N lines from file
echo "192.168.20.100" > data/resolvers.txt
shuf -n $DNS_COUNT resolvers/resolvers.txt >> data/resolvers.txt


x=0
for domain in $DOMAINS
do
	x=$((x+1))
	[[ $x -le 2 ]] && continue  #skip first 2 args

	i=0	
	echo "Processing $domain"
	while read dns 
	do 
		dig +short +time=2 @$dns $domain | grep '^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$' >> data/$domain.txt &

		i=$((i+1))
		if [[ $i == 1000 ]]
		then
			sleep 1.5
			i=0
			echo -n "."
		fi

	done < data/resolvers.txt
	echo ""
done

echo "Wait for done"
sleep 5
x=0

echo "" > wl/$OUTPUT

for domain in $DOMAINS
do
	x=$((x+1))
	[[ $x -le 2 ]] && continue  #skip first 2 args

	#Famous one-liner to store only unique lines in a file - http://www.catonmat.net/blog/awk-one-liners-explained-part-two/
	awk '!a[$0]++' data/$domain.txt | sort | uniq | iprange > data/$domain.txt.tmp	
	mv -f data/$domain.txt.tmp data/$domain.txt

	echo "#$domain" >> wl/$OUTPUT
	cat data/$domain.txt >> wl/$OUTPUT
	echo "" >> wl/$OUTPUT
done
echo "Wrote wl/$OUTPUT"


