all: server.key server.csr

%.key:
	@echo Generating private key ...
	openssl genrsa -out $@ 2048

%.csr: %.key %.csr.conf
	@echo Generating Certificate Signing Request\(CSR\) ...
	openssl req -new -key $< -out $@ -config $(word 2,$^)

.PHONY: clean

clean:
	rm -rf *.key *.crt *.csr