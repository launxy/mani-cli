#!/bin/bash

show_header() {
    clear
    echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo -e "\e[1;36m  MANI-CLI - VER ANIME EN ESPAÑOL\e[0m"
    echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
}

while true; do
    show_header
    
    # 1. Búsqueda
    QUERY=$(echo "" | fzf --prompt="🔍 Buscar Anime (ESC para salir): " --print-query --height=40% --reverse --border | head -n 1)
    [ -z "$QUERY" ] && break
    SEARCH_QUERY=$(echo "$QUERY" | tr ' ' '+')

    show_header
    echo "🔎 Buscando '$QUERY'..."
    SEARCH_RESULTS=$(curl -sL -A "Mozilla/5.0" "https://www4.animeflv.net/browse?q=$SEARCH_QUERY" | \
        grep -oP '<a href="/anime/.*?">|<h3 class="Title">.*?</h3>' | \
        sed 's/<h3 class="Title">//g;s/<\/h3>//g;s/<a href="//g;s/">//g' | \
        paste - - | fzf --prompt="📺 Selecciona Anime: " --height=40% --reverse --border)

    [ -z "$SEARCH_RESULTS" ] && continue
    ANIME_URL=$(echo "$SEARCH_RESULTS" | awk '{print $1}')
    ANIME_NAME=$(echo "$SEARCH_RESULTS" | cut -d' ' -f2-)

    # 2. Episodios
    show_header
    echo "⏳ Cargando episodios de: $ANIME_NAME"
    HTML_ANIME=$(curl -sL -A "Mozilla/5.0" "https://www4.animeflv.net$ANIME_URL")
    SLUG=$(echo "$ANIME_URL" | cut -d'/' -f3)

    NUMS_EP=$(echo "$HTML_ANIME" | grep -oP 'var episodes = \[\K.*?(?=\];)' | \
        grep -oP '\[\K\d+' | fzf --prompt="🔢 Episodio: " --height=40% --reverse --border)

    [ -z "$NUMS_EP" ] && continue


# 3. Servidores
    show_header
    EP_URL="https://www4.animeflv.net/ver/${SLUG}-${NUMS_EP}"
    
    echo "🌐 Cargando servidores para el episodio $NUMS_EP..."
    
    HTML_EP=$(curl -sL -A "Mozilla/5.0" "$EP_URL")

    SERVER_CHOICE=$(echo "$HTML_EP" | grep -oP 'var videos = \{"SUB":\[\K.*?\](?=,"LAT")|var videos = \{"SUB":\[\K.*?\](?=\})' | \
        sed 's/},{"/\n/g' | \
        grep -oP '"title":"\K[^"]+|"code":"\K[^"]+' | \
        paste - - | \
        sed 's/\\//g' | \
        fzf --prompt="🚀 Servidor : " --height=40% --reverse --border)

    [ -z "$SERVER_CHOICE" ] && continue

    FINAL_URL=$(echo "$SERVER_CHOICE" | awk '{print $NF}')
    [[ "$FINAL_URL" == //* ]] && FINAL_URL="https:$FINAL_URL"

    if [[ "$FINAL_URL" == //* ]]; then
        FINAL_URL="https:$FINAL_URL"

    elif [[ "$FINAL_URL" == *"mega.nz"* && "$FINAL_URL" != *"embed"* ]]; then

        : 
    fi

    # 4. Brave
    show_header
    echo -e "\e[1;32m✓ REPRODUCIENDO:\e[0m $ANIME_NAME"
    echo -e "\e[1;32m✓ EPISODIO:     \e[0m $NUMS_EP"
    echo -e "\e[1;32m✓ SERVIDOR:     \e[0m $(echo "$SERVER_CHOICE" | awk '{print $1}')"
    echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo ""
    
    brave --app="$FINAL_URL" --incognito & disown
    
    echo -e "\e[1;33mℹ Presiona cualquier tecla para volver al buscador...\e[0m"
    read -n 1 -s -r
done

clear
echo "👋 ¡Cerrando Mani-Cli!"
