do_you_have_domain(){
    while true
    do
        _read "Do you have your own domain name? [y/n]:"
        local yn="${inputInfo}"
        [ -z "${yn}" ] && yn="N"
        case "${yn:0:1}" in
            y|Y)
                doYouHaveDomian=Yes
                ;;
            n|N)
                doYouHaveDomian=No
                ;;
            *)
                _echo -e "Incorrect input, please try again."
                continue
                ;;
        esac
        _echo -r "  selected = ${doYouHaveDomian}"
        break
    done
}

_get_input_domain(){
    local domainTypeTip=$1

    while true
    do
        _read "Please enter a domain name(${domainTypeTip})："
        domain="${inputInfo}"
        if ! judge_is_domain "${domain}"; then
            _echo -e "Please enter a properly formatted domain name."
            continue
        fi
        if ! judge_is_valid_domain "${domain}"; then
            _echo -e "Could not resolve to IP，Please enter a valid and valid domain name."
            continue
        fi
        break
   done
}

get_specified_type_domain(){
    # typeTip value：CDN，DNS-Only，Other
    local typeTip=$1

    while true
        do
        _get_input_domain "${typeTip}"
        domainType=$(judge_domain_type "${domain_ip}")
        if [ "${domainType}" = "${typeTip}" ]; then
            _echo -r "  domain = ${domain} (${domainType})"
            break
        else
            _echo -e "please enter a ${typeTip} type of domain name."
            continue
        fi
    done
}

get_cdn_or_dnsonly_type_domain(){
    local typeTip="CDN 或 DNS-Only"

    while true
        do
        _get_input_domain "${typeTip}"
        domainType=$(judge_domain_type "${domain_ip}")
        if [ "${domainType}" = "Other" ]; then
            _echo -e "please enter a ${typeTip} type of domain name."
            continue
        fi
        _echo -r "  domain = ${domain} (${domainType})"
        break
    done
}

get_all_type_domain(){
    while true
    do
        _read "Please enter any domain name (Default: cloudfront.com):"
        domain="${inputInfo}"
        [ -z "${domain}" ] && domain="cloudfront.com"
        if ! judge_is_domain "${domain}"; then
            _echo -e "Please enter a properly formatted domain name."
            continue
        fi
        if ! judge_is_valid_domain "${domain}"; then
            _echo -e "Unable to resolve to IP, please enter a valid domain name."
            continue
        fi
        unset domainType
        _echo -r "  domain = ${domain}"
        break
   done
}

get_input_ws_path(){
    gen_random_str
    while true
    do
        _read "Please enter your WebSocket offload path ( Default：/${ran_str5}):"
        path="${inputInfo}"
        [ -z "${path}" ] && path="/${ran_str5}"
        if ! judge_is_path "${path}"; then
            _echo -e "Please enter a path starting with /"
            continue
        fi
        _echo -r "  path = ${path}"
        break
    done
}

_get_input_mux_max_stream() {
    while true
    do
        _read "Please enter the maximum number of multiplexed streams in an actual TCP connection (default: 8)"
        mux="${inputInfo}"
        [ -z "${mux}" ] && mux=8
        expr "${mux}" + 1 &>/dev/null
        if ! judge_is_num "${mux}"; then
            _echo -e "Please enter a valid number."
            continue
        fi
        if judge_is_zero_begin_num "${mux}"; then
            _echo -e " Please enter a number that does not start with 0."
            continue
        fi
        if ! judge_num_in_range "${mux}" "1024"; then
            _echo -e "Please enter a number between 1-65535."
            continue
        fi
        echo
        echo -e "${Red}  mux = ${mux}${suffix}"
        echo
        break
    done
}

_is_disable_mux(){
    while true
    do
        _read "Do you want to disable Mux? [y/n]:"
        local yn="${inputInfo}"
        [ -z "${yn}" ] && yn="N"
        case "${yn:0:1}" in
            y|Y)
                isDisableMux=disable
                ;;
            n|N)
                isDisableMux=enable
                ;;
            *)
                _echo -e "Incorrect input, please try again!"
                continue
                ;;
        esac
        _echo -r "  mux = ${isDisableMux}"
        break
    done
}

is_disable_mux_logic(){
    _is_disable_mux
    if [ "${isDisableMux}" = "enable" ]; then
        _get_input_mux_max_stream
        clientMux=";mux=${mux}"
    fi
}

get_input_mirror_site(){
    while true
    do
        _echo -u "${Tip} This site is recommended to meet the conditions (located overseas, supports HTTPS protocol, will be used to transmit large traffic... ), the default value is not recommended."
        _read -d "Please enter the site you want to mirror to (Default：https://www.bing.com)："
        mirror_site="${inputInfo}"
        [ -z "${mirror_site}" ] && mirror_site="https://www.bing.com"
        if ! judge_is_https_begin_site "${mirror_site}"; then
            _echo -e "Please enter ${Red} https:// ${suffix} starts with ${Red} domain name ${suffix}ending URL."
            continue
        fi
        if ! judge_is_valid_domain "${mirror_site}"; then
            _echo -e "Could not resolve to IP，Please enter a valid and valid domain name."
            continue
        fi
        _echo -r "  mirror_site = ${mirror_site}"
        break
    done
}
