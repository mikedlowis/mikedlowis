
PATH := $(PWD)/tools:$(PATH)
PAGES = $(addprefix site/,$(addsuffix .html,$(basename $(notdir $(wildcard pages/*.md)))))

.PHONY: serve
all: $(PAGES) site/index.html

serve:
	tools/serve

site/index.html: index.html
	cp $^ $@

site/%.html : pages/%.md
	genpage $< > $@

clean:
	rm site/*.html
