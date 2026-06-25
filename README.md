# mani-cli



mani-cli es una herramienta de interfaz de línea de comandos (CLI) extremadamente ligera para buscar
y reproducir anime directamente desde tu terminal.

En lugar de navegar por webs llenas de anuncios, este script extrae la información en tiempo real
y te ofrece un menú interactivo y limpio. Una vez eliges tu episodio, lo lanza directamente en una
ventana de tu navegador lista para disfrutar.


✨ Características

    Búsqueda en vivo: Busca cualquier anime directamente desde la terminal.  

    Interfaz interactiva: Menús limpios y rápidos usando fzf.  

    Modo Maratón: El script se mantiene abierto en segundo plano. Cuando termines un capítulo,
    solo presiona una tecla para elegir el siguiente.  

    Filtro inteligente: Extrae automáticamente los enlaces de servidores de video subtitulados
    y los limpia para su reproducción directa.  


⚙️ Requisitos previos

Para que el script funcione correctamente, necesitas tener instaladas las siguientes
herramientas en tu sistema Linux/macOS:

    fzf (El motor de la interfaz interactiva)

    curl (Para las peticiones web)

    grep, sed, awk (Herramientas estándar de manipulación de texto preinstaladas en
    casi cualquier distro)

    Brave Browser (Ver la sección de Navegadores alternativos si no usas Brave)

Para instalar fzf en distribuciones basadas en Debian/Ubuntu:

sudo apt install fzf curl


🚀 Instalación

Puedes instalar mani-cli globalmente en tu sistema con estos dos comandos:

Descarga el script y dale permisos de ejecución:

    Bash

    chmod +x mani-cli.sh

Muévelo a tu carpeta de binarios para ejecutarlo desde cualquier lugar:

    Bash

    sudo cp mani-cli.sh /usr/local/bin/mani-cli



🎮 Cómo usarlo

Abre tu terminal y simplemente escribe:
    -mani-cli

    -Escribe el nombre del anime que quieres ver y presiona Enter.  

    -Selecciona el resultado correcto de la lista.  

    -Elige el número de episodio (ordenados del más reciente al más antiguo).  

    -Selecciona el servidor de video que prefieras.  

    -¡Disfruta! El video se abrirá en una ventana emergente.  

    -En cualquier momento, puedes presionar ESC para volver al paso anterior o salir del programa.  



🌐 Navegadores Alternativos (Personalización)

Por defecto, el script está configurado para abrir el video usando Brave en modo "app" e incógnito
(brave --app="URL" --incognito). Esto ofrece la mejor experiencia, ya que abre el reproductor en
una ventana limpia, sin barra de direcciones y utilizando el bloqueador de anuncios nativo de Brave.  

Si no usas Brave, puedes modificar el script fácilmente. Abre el archivo mani-cli.sh con tu editor
de texto favorito, ve a la línea 66 y cambia el comando de ejecución.  

Ejemplo:

    firefox --private-window "$FINAL_URL" & disown
