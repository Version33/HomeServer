{

  flake.modules.nixos.home-assistant =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.home-assistant = {
        enable = true;
        openFirewall = true;

        # lg_thinq pins thinqconnect==1.0.13, which still builds its MQTT client
        # certificate with OpenSSL.crypto.X509Req. pyOpenSSL deprecated that in
        # 24.2.0 and *removed* it in 25.3.0; nixpkgs now ships 26.3.0, so CSR
        # generation dies with
        #   AttributeError: module 'OpenSSL.crypto' has no attribute 'X509Req'
        # lg_thinq catches AttributeError and re-raises ConfigEntryNotReady, and
        # because it forwards all 11 platforms *before* connecting MQTT, HA's
        # retry (which never unloads them) then floods the log with
        #   ValueError: Config entry ... has already been setup!
        #
        # Move only the CSR to `cryptography` (what pyOpenSSL now delegates to).
        # Key generation deliberately still goes through crypto.PKey, which is
        # merely deprecated, so bytes_private_key keeps the exact PKCS#8 PEM
        # encoding awscrt already accepts.
        package = pkgs.home-assistant.override {
          packageOverrides = final: prev: {
            thinqconnect = prev.thinqconnect.overridePythonAttrs (old: {
              dependencies = (old.dependencies or [ ]) ++ [ final.cryptography ];

              # Matches omit leading indentation so substituteInPlace preserves it.
              postPatch = (old.postPatch or "") + ''
                substituteInPlace thinqconnect/mqtt_client.py \
                  --replace-fail 'from OpenSSL import crypto' 'from OpenSSL import crypto; from cryptography import x509; from cryptography.hazmat.primitives import hashes, serialization; from cryptography.x509.oid import NameOID' \
                  --replace-fail 'csr = crypto.X509Req()' '_csr_key = key.to_cryptography_key()' \
                  --replace-fail 'csr.get_subject().CN = "lg_thinq"' '_csr_subject = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "lg_thinq")])' \
                  --replace-fail 'csr.set_pubkey(key)' '_csr_builder = x509.CertificateSigningRequestBuilder().subject_name(_csr_subject)' \
                  --replace-fail 'csr.sign(key, "sha512")' '_csr = _csr_builder.sign(_csr_key, hashes.SHA512())' \
                  --replace-fail 'csr_pem = crypto.dump_certificate_request(crypto.FILETYPE_PEM, csr).decode(encoding="utf-8")' 'csr_pem = _csr.public_bytes(serialization.Encoding.PEM).decode(encoding="utf-8")'
              '';
            });
          };
        };
        extraComponents = [
          "met"
          "esphome"
          "zwave_js"
          "isal"
          "radio_browser"
          "mqtt"
          "sun"
          "mobile_app"
          "bluetooth"
          "lg_thinq"
        ];
        config = {
          default_config = { };
          http = {
            server_host = "0.0.0.0";
            server_port = 8123;
            trusted_proxies = [ "127.0.0.1" ];
            use_x_forwarded_for = true;
          };
          advanced = {
            channel = 11;
            pan_id = 6754;
            ext_pan_id = "00124b0030dd86a9";
            network_key = [
              1
              3
              5
              7
              9
              11
              13
              15
              0
              2
              4
              6
              8
              10
              12
              13
            ];
          };
        };
      };

      users.users.hass = lib.mkIf config.services.home-assistant.enable {
        extraGroups = [ "dialout" ];
      };

      services.caddy.virtualHosts = {
        "hass.versionthirtythr.ee" = {
          extraConfig = ''
            reverse_proxy http://localhost:8123
          '';
        };
      };
    };

}
