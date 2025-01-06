SUPPORTED_PLATFORMS = linux windows web android
PLATFORM ?= linux

ifneq ($(filter $(PLATFORM),$(SUPPORTED_PLATFORMS)),)
	include $(PLATFORM).mk
else
%:
	$(error Invalid PLATFORM '$(PLATFORM)', expected one of: $(SUPPORTED_PLATFORMS))
endif
