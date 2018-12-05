OCF_AGENT = systemd-timer
define template
	awk '! /^##include/ { print $$0 } \
	  /^##include/ { while ((getline line < $$2) > 0) { print "    " line } }' $(1) > $(2)
endef

.PHONY: clean

$(OCF_AGENT): $(OCF_AGENT).sh metadata.xml
	$(call template,$<,$@)

clean:
	rm -f $(OCF_AGENT)
