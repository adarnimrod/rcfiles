last_month != date +%Y-%m --date '3 months ago'
last_zip != find -maxdepth 1 -name '20*.zip' \! -name '${last_month}.zip' -printf '%f\n' | sort -r | head -1
new_files != find receipts/ -type f -newer ${last_zip}

.PHONY: send
send: ${last_month}.zip
	./send_receipts "$<"

${last_month}.zip: ${new_files}
	zip $@ $(patsubst %,'%',$^)

.PHONY: clean
clean:
	rm *.zip
