CURRUID := $(shell id -u)
OS := $(shell uname -s)

HOMEFILES := $(shell find home -maxdepth 1 -mindepth 1 -type f) # home/xinitrc
# make won't run the target if the file exists, so we append a non existing path here:
DOTFILES := $(addprefix target/,$(HOMEFILES)) # eg: target/home/xinitrc

# The same logic is applied here
CONFIGFILES := $(addprefix target/,$(shell find config -maxdepth 1 -mindepth 1)) # eg: target/config/i3

ifeq ($(CURRUID), 0)
  $(error Do not run as root)
endif
ifneq ($(OS), Linux)
  $(error Only runs on Linux)
endif

# https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
# TLDR: targets that don't create a file
.PHONEY: link

main: link

# https://www.gnu.org/software/make/manual/make.html#Prerequisite-Types
link: | $(DOTFILES) $(CONFIGFILES)

# Target for each dotfile, eg: "target/home/xinitrc" is a target
# "notdir" is just like basename
# we add the '.' here to all the files
$(DOTFILES):
	@echo -e "\nLinking dotfiles"
	@# If target exists, and is not a link, tell me about it
	@(test -e "$(HOME)/.$(notdir $@)" && ! test -L "$(HOME)/.$(notdir $@)") && { echo "Target exists, delete or move it: $(HOME)/.$(notdir $@)"; exit 1; } || true
	@ln -snfv "$(PWD)/home/$(notdir $@)" "$(HOME)/.$(notdir $@)"

$(CONFIGFILES):
	@echo -e "\nLinking configfiles"
	@# If target exists, and is not a link, tell me about it
	@(test -e "$(HOME)/.config/$(notdir $@)" && ! test -L "$(HOME)/.config/$(notdir $@)") && { echo "Target exists, delete or move it: $(HOME)/.config/$(notdir $@)"; exit 1; } || true
	@ln -snfv "$(PWD)/config/$(notdir $@)" "$(HOME)/.config/$(notdir $@)"

unlink:
	@echo -e "\nUnlinking dotfiles"
	@# notdir doesnt work here
	@for f in $(DOTFILES); do t="$(HOME)/.$$(basename $$f)"; [[ -L "$$t" ]] && rm -v "$$t" || true; test -e "$$t" && echo "Not removing $$t" || true; done
	@echo -e "\nUnlinking configfiles"
	@for f in $(CONFIGFILES); do t="$(HOME)/.config/$$(basename $$f)"; test -L "$$t" && rm -v "$$t" || true; test -e "$$t" && echo "Not removing $$t" || true; done
