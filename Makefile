ca_root_cert_dir = ca_certs
ca_key_file = $(ca_root_cert_dir)/myCA_private.key
ca_cert_file = $(ca_root_cert_dir)/myCA_root_cert.pem
ca_config_file = ca.conf
data_dir = data
ca_db_file = $(data_dir)/db
ca_serial_file = $(data_dir)/serial
cert_dir = new_certs

.PHONY: ca_root_cert install_ca uninstall_ca clean
ca_root_cert: $(ca_root_cert_dir) $(ca_key_file) $(ca_cert_file)

install_ca:
	sudo trust anchor -v --store $(ca_cert_file)

uninstall_ca:
	sudo trust anchor -v --remove $(ca_cert_file)

clean: | uninstall_ca
	rm -rf $(ca_root_cert_dir)
	rm -rf $(data_dir)
	rm -rf $(cert_dir)

$(ca_root_cert_dir) $(data_dir) $(cert_dir):
	mkdir -p $@

$(ca_db_file): | $(data_dir)
	touch $@

$(ca_serial_file): | $(data_dir)
	echo 00 > $@

$(ca_key_file):
	@echo Generating private key ...
	openssl genrsa -des3 -out $@ 4096

$(ca_cert_file): $(ca_key_file)
	@echo Generating root certificate ...
	openssl req -x509 -new -key $< -sha256 -days 3650 -out $@

%.crt: %.csr $(ca_config_file) $(ca_db_file) $(ca_serial_file) $(cert_dir)
	@echo Signing CSR $@ ...
	$(eval serial_old := $(shell cat $(data_dir)/serial))
	openssl ca -config $(ca_config_file) -in $< -verbose
	cp $(cert_dir)/$(serial_old).pem $@