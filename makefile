all: Analysis Data_prep

data-preparation:
	make -C src/Data_prep

analysis: data-preparation
	make -C src/Analysis

clean:
	-rm -r data
	-rm -r gen