CURRUID := $(shell id -u)
OS := $(shell uname -s)

DOTFILES := $(shell find home -maxdepth 1 -mindepth 1) # eg: home/xinitrc
CONFIGFILES := $(shell find config -maxdepth 1 -mindepth 1) # eg: config/i3

ifeq ($(CURRUID), 0)
  $(error Do not run as root)
endif
ifneq ($(OS), Linux)
  $(error Only runs on Linux)
endif

# https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
# TLDR: targets that don't expect the creation of a file, so make won't complain if the file exists
.PHONY: link unlink fixrepo $(DOTFILES) $(CONFIGFILES)

main: link

# https://www.gnu.org/software/make/manual/make.html#Prerequisite-Types
link: | $(DOTFILES) $(CONFIGFILES)
	@#$(PWD)/config/i3/i3status-rust/link.sh

# Target for each dotfile, eg: "home/xinitrc" is a target
# "notdir" is just like basename
# we add the '.' here to all the files
$(DOTFILES):
	@echo -e "\nLinking dotfiles"
	@# If target exists, and is not a link, let me know
	@(test -e "$(HOME)/.$(notdir $@)" && ! test -L "$(HOME)/.$(notdir $@)") && { echo "Target exists, delete or move it: $(HOME)/.$(notdir $@)"; exit 1; } || true
	@ln -snfv "$(PWD)/home/$(notdir $@)" "$(HOME)/.$(notdir $@)"

$(CONFIGFILES):
	@echo -e "\nLinking configfiles"
	@(test -e "$(HOME)/.config/$(notdir $@)" && ! test -L "$(HOME)/.config/$(notdir $@)") && { echo "Target exists, delete or move it: $(HOME)/.config/$(notdir $@)"; exit 1; } || true
	@ln -snfv "$(PWD)/config/$(notdir $@)" "$(HOME)/.config/$(notdir $@)"

unlink:
	@echo -e "\nUnlinking dotfiles"
	@# notdir doesnt work here
	@for f in $(DOTFILES); do t="$(HOME)/.$$(basename $$f)"; [[ -L "$$t" ]] && rm -v "$$t" || true; test -e "$$t" && echo "Not removing $$t" || true; done
	@echo -e "\nUnlinking configfiles"
	@for f in $(CONFIGFILES); do t="$(HOME)/.config/$$(basename $$f)"; test -L "$$t" && rm -v "$$t" || true; test -e "$$t" && echo "Not removing $$t" || true; done

fixrepo:
	sed -i "s,url = https://github.com/aorith/$$(basename $$PWD),url = git@github.com:aorith/$$(basename $$PWD).git,g" ".git/config"
