
GEM_NAME = mbdb

include Makefile.common

.PHONY: dev
dev:
	$(BUNDLER) exec ./bin/dev

.PHONY: test
test:
	RUBYOPT=-w $(BUNDLER) exec ./test/suite_all.rb

.PHONY: cov
cov:
	RUBYOPT=-w COVERAGE=1 $(BUNDLER) exec ./test/suite_all.rb -v

.PHONY: cov_local
cov_local:
	RUBYOPT=-w SIMPLECOV_PHPUNIT_LOAD_PATH=../simplecov-phpunit COVERAGE=1 $(BUNDLER) exec ./test/suite_all.rb -v
