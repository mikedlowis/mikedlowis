
PATH := $(PWD)/tools:$(PATH)
PAGES = $(addprefix site/,$(addsuffix .html,$(basename $(notdir $(wildcard pages/*.md)))))

.PHONY: serve
all: $(PAGES)

serve:
	cd site && serve

site/%.html : pages/%.md
	genpage $< > $@

clean:
	rm site/*.html
