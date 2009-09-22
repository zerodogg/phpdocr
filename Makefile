# phpdocr makefile

VERSION=$(shell ./phpdocr --version|perl -pi -e 's/^\D+//; chomp')

ifndef prefix
# This little trick ensures that make install will succeed both for a local
# user and for root. It will also succeed for distro installs as long as
# prefix is set by the builder.
prefix=$(shell perl -e 'if($$< == 0 or $$> == 0) { print "/usr" } else { print "$$ENV{HOME}/.local"}')

# Some additional magic here, what it does is set BINDIR to ~/bin IF we're not root
# AND ~/bin exists, if either of these checks fail, then it falls back to the standard
# $(prefix)/bin. This is also inside ifndef prefix, so if a prefix is supplied
# (ie. meaning this is a packaging), we won't run this at all
BINDIR ?= $(shell perl -e 'if(($$< > 0 && $$> > 0) and -e "$$ENV{HOME}/bin") { print "$$ENV{HOME}/bin";exit; } else { print "$(prefix)/bin"}')
endif

BINDIR ?= $(prefix)/bin
DATADIR ?= $(prefix)/share

DISTFILES=NEWS COPYING Makefile README phpdocr phpdocr.1

# Install phpdocr
install:
	mkdir -p "$(BINDIR)"
	cp phpdocr "$(BINDIR)"
	chmod 755 "$(BINDIR)/phpdocr"
	mkdir -p "$(DATADIR)/man/man1" && cp phpdocr.1 "$(DATADIR)/man/man1" || true
localinstall:
	mkdir -p "$(BINDIR)"
	ln -sf $(shell pwd)/phpdocr $(BINDIR)/
	mkdir -p "$(DATADIR)/man/man1" && ln -sf $(shell pwd)/phpdocr.1 "$(DATADIR)/man/man1" || true
# Uninstall an installed phpdocr
uninstall:
	rm -f "$(BINDIR)/phpdocr"
	rm -f "$(DATADIR)/man/man1/phpdocr.1"
# Clean up the tree
clean:
	rm -f `find|egrep '~$$'`
	rm -f phpdocr-*.tar.bz2 phpdocr-*.gem
	rm -rf phpdocr-$(VERSION)
# Verify syntax
test:
	@ruby -c phpdocr
# Generate the manpage from the POD
man:
	pod2man --name "phpdocr - wine wrapper" --center "" --release "phpdocr $(VERSION)" ./phpdocr.pod ./phpdocr.1
	perl -ni -e 'if(not $$seen) { if(not /Title/) { next } $$seen = 1 }; s/\.Sp//; print' ./phpdocr.1
# Generate files for distribution
distrib: clean test gem tarball
# Create the tarball
tarball: clean test
	mkdir -p phpdocr-$(VERSION)
	cp -r $(DISTFILES) ./phpdocr-$(VERSION)
	rm -rf `find phpdocr-$(VERSION) -name \\.git`
	tar -jcvf phpdocr-$(VERSION).tar.bz2 ./phpdocr-$(VERSION)
	rm -rf phpdocr-$(VERSION)
# Build the gem
TESTGEM?=testgem
gem: clean test $(TESTGEM)
	gem build phpdocr.gemspec
testgem:
	if ! grep '"$(VERSION)"' phpdocr.gemspec 2>&1 >/dev/null; then echo;echo "Update s.version in phpdocr.gemspec";exit 1;fi
