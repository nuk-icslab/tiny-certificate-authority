ca_root_cert_dir = ca_certs
ca_root_cert_config = ca_root.crt.conf
ca_key = $(ca_root_cert_dir)/myCA_private.key
ca_cert = $(ca_root_cert_dir)/myCA_root_cert.pem
ca_config = ca.conf
data_dir = data
ca_db = $(data_dir)/db
ca_serial = $(data_dir)/serial
cert_dir = new_certs

.PHONY: ca_root_cert install_ca uninstall_ca clean
ca_root_cert: $(ca_key) $(ca_cert)

install_ca:
	sudo trust anchor -v --store $(ca_cert)

uninstall_ca:
	sudo trust anchor -v --remove $(ca_cert)

clean: | uninstall_ca
	rm -rf $(ca_root_cert_dir)
	rm -rf $(data_dir)
	rm -rf $(cert_dir)

$(ca_root_cert_dir) $(data_dir):
	mkdir -p $@

$(ca_db): | $(data_dir)
	touch $@

$(ca_serial): | $(data_dir)
	echo 00 > $@

$(ca_key): | $(ca_root_cert_dir)
	@echo Generating private key ...
	openssl genrsa -des3 -out $@ 4096

$(ca_cert): $(ca_key) $(ca_root_cert_config)
	@echo Generating root certificate ...
	openssl req -verbose -x509 -new -key $< -config $(ca_root_cert_config) -days 3650 -out $@
	openssl x509 -in $@ -text -noout

%.crt: %.csr $(ca_config) $(ca_db) $(ca_serial)
	@echo Signing CSR $@ ...
	mkdir -p $(cert_dir)
	$(eval serial_old := $(shell cat $(data_dir)/serial))
	openssl ca -verbose -config $(ca_config) -in $< -verbose
	cp $(cert_dir)/$(serial_old).pem $@