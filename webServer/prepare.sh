is_enable_web_server(){
    while true
    do
        _read "Enable Webserver Camouflage [y/n]:"
        local yn="${inputInfo}"
        [ -z "${yn}" ] && yn="N"
        case "${yn:0:1}" in
            y|Y)
                isEnableWeb=enable
                ;;
            n|N)
                isEnableWeb=disable
                ;;
            *)
                _echo -e "Incorrect input, please try again.."
                continue
                ;;
        esac
        _echo -r "  web = ${isEnableWeb}"
        break
    done
}

web_server_menu(){
    local WEB_SERVER_STYLE=(caddy nginx)

    generate_menu_logic "${WEB_SERVER_STYLE[*]}" "a Webserver" "1"
    web_flag="${inputInfo}"
}

choose_nginx_version_menu(){
    local NGINX_PACKAGES_V=(Stable Mainline)

    generate_menu_logic "${NGINX_PACKAGES_V[*]}" "Nginx package version" "1"
    pkg_flag="${inputInfo}"
}

choose_caddy_version_menu(){
    local CADDY_PACKAGES_V=(Caddy Caddy2)

    generate_menu_logic "${CADDY_PACKAGES_V[*]}" "Caddy package version" "1"
    caddyVerFlag="${inputInfo}"
}
