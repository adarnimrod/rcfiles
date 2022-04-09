last_month != date +%Y-%m --date 'last month'
last_zip != find -maxdepth 1 -name '*.zip' \! -name '${last_month}.zip' -printf '%f\n' | sort -r | head -1
new_files != find reciepts/ -type f -newer ${last_zip}

${last_month}.zip: ${new_files}
	zip $@ $(patsubst %,'%',$^)

.PHONY: clean
clean:
	rm *.zip
