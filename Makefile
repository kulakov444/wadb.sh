# SPDX-FileCopyrightText: NONE
#
# SPDX-License-Identifier: Unlicense

PREFIX=/data/data/com.termux/files/usr
VERSION=1.0.0-beta

install:
	mkdir -p $(PREFIX)/bin
	mkdir -p ~/.termux/boot
	cp -f wadb.sh $(PREFIX)/libexec
	cp -f wadb_cancel.sh $(PREFIX)/libexec
	cp -f wadb_job.sh ~/.termux/boot
	~/.termux/boot/wadb_job.sh

define SETUP_PERMISSIONS
settings put global adb_allowed_connection_time 0;                            \
pm grant name.kulakov444.wadbswitch android.permission.WRITE_SECURE_SETTINGS; \
for p in com.termux com.termux.api; do                                        \
	pm grant $$p android.permission.POST_NOTIFICATIONS;                   \
	cmd deviceidle whitelist +$$p;                                        \
done;                                                                         \
cmd notification allow_listener                                               \
	com.termux.api/.apis.NotificationListAPI\$$NotificationService;       \
pm grant com.termux.api android.permission.ACCESS_FINE_LOCATION;              \
pm grant com.termux.api android.permission.ACCESS_COARSE_LOCATION;            \
pm grant com.termux.api android.permission.ACCESS_BACKGROUND_LOCATION;        \

endef

connect:
	-echo | adb shell && return
	for p in $$(nmap localhost -p 30000-50000 | grep '^[0-9]' | awk '{print $$1}' | cut -d '/' -f1); do \
		adb connect localhost:$$p | grep failed && adb disconnect localhost:$$p; \
	done; \

setup-permissions:
	echo '$(SETUP_PERMISSIONS)' | adb shell

dist: clean
	FILES="$$(ls)"; \
	mkdir wadb.sh-$(VERSION); \
	cp -R $$FILES wadb.sh-$(VERSION)
	tar cf wadb.sh-$(VERSION).tar wadb.sh-$(VERSION)
	xz wadb.sh-$(VERSION).tar
	rm -rf wadb.sh-$(VERSION)

clean:
	rm -f wadb.sh-*.tar.xz

uninstall:
	$(PREFIX)/libexec/wadb_cancel.sh
	rm -f $(PREFIX)/libexec/wadb.sh
		$(PREFIX)/libexec/wadb_cancel.sh
		~/.termux/boot/wadb_job.sh

.PHONY: install setup-permissions dist clean uninstall
