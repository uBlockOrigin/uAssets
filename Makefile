.PHONY: \
	clean \
	validate-filters \
	validate-filters-2020 \
	validate-filters-2021 \
	validate-filters-2022 \
	validate-privacy \
	validate-annoyances \
	validate-badware \
	validate-ubol-filters

build/validate/validate.js: tools/validate/validate.js tools/validate/config.js
	cp -R tools/validate/* build/validate/

build/validate/uBlock:
	tools/make-validate.sh

build/validate/results/filters.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/filters.txt \
		out=build/validate/results

build/validate/results/filters-2020.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/filters-2020.txt \
		out=build/validate/results

build/validate/results/filters-2021.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/filters-2021.txt \
		out=build/validate/results

build/validate/results/filters-2022.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/filters-2022.txt \
		out=build/validate/results

build/validate/results/privacy.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/privacy.txt \
		out=build/validate/results

build/validate/results/annoyances.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/annoyances.txt \
		out=build/validate/results

build/validate/results/badware.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/badware.txt \
		out=build/validate/results

build/validate/results/ubol-filters.results.txt: build/validate/uBlock build/validate/validate.js
	node build/validate/validate.js \
		in=filters/ubol-filters.txt \
		out=build/validate/results

validate-filters: build/validate/results/filters.results.txt

validate-filters-2020: build/validate/results/filters-2020.results.txt

validate-filters-2021: build/validate/results/filters-2021.results.txt

validate-filters-2022: build/validate/results/filters-2022.results.txt

validate-privacy: build/validate/results/privacy.results.txt

validate-annoyances: build/validate/results/annoyances.results.txt

validate-badware: build/validate/results/badware.results.txt

validate-ubol-filters: build/validate/results/ubol-filters.results.txt

clean:
	rm -rf build
