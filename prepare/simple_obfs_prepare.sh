# Simple-obfs Obfuscation wrapper
OBFUSCATION_WRAPPER=(
http
tls
)


get_input_obfs_mode(){
    generate_menu_logic "${OBFUSCATION_WRAPPER[*]}" "Obfuscated Mode Encryption" "1"
    shadowsocklibev_obfs="${optionValue}"
}

get_input_obfs_domain(){
    while true
        do
        _read "Please enter a domain name for obfuscation for simple-obfs (default: cloudfront.com):"
        domain="${inputInfo}"
        [ -z "$domain" ] && domain="cloudfront.com"
        if ! judge_is_domain "${domain}"; then
            _echo -e "Please enter a well-formed domain name."
            continue
        fi
        if ! judge_is_valid_domain "${domain}"; then
            _echo -e "Unable to resolve to IP, please enter a valid domain name."
            continue
        fi
        _echo -r "  obfs-host = ${domain}"
        break
    done
}

install_prepare_libev_obfs(){
    get_input_obfs_mode
    get_input_obfs_domain
    firewallNeedOpenPort="${shadowsocksport}"
}

