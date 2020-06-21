last_month != date +%Y-%m --date 'last month'
last_zip != ls *.zip | sort -r | head -1
new_files != find reciepts/ -type f -newer ${last_zip}

${last_month}.zip: ${new_files}
	zip $@ $^

.PHONY: clean
clean:
	rm *.zip
