#!/bin/bash

# Função para verificar se um comando está instalado
verificar_comando() {
    command -v "$1" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "$1 não encontrado. Instalando..."
        return 1
    else
        echo "$1 já está instalado!"
        return 0
    fi
}

# Função para instalar pacotes necessários
instalar_dependencias() {
    echo "Instalando dependências..."
    pkg update -y
    pkg upgrade -y
    pkg install -y python3 python3-pip git wget curl ffmpeg
}

# Função para instalar o yt-dlp (se necessário)
instalar_yt_dlp() {
    if ! verificar_comando yt-dlp; then
        echo "Instalando yt-dlp..."
        pip3 install yt-dlp
    fi
}

# Função para garantir que o ffmpeg esteja instalado
instalar_ffmpeg() {
    if ! verificar_comando ffmpeg; then
        echo "Instalando ffmpeg..."
        pkg install -y ffmpeg
    fi
}

# Função para verificar e instalar dependências necessárias
verificar_dependencias() {
    verificar_comando "yt-dlp" || instalar_yt_dlp
    verificar_comando "ffmpeg" || instalar_ffmpeg
}

# Função para baixar mídia com lista de formatos
baixar_midia() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "                    ESCOLHA A PLATAFORMA                      "
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1) YouTube"
    echo "2) TikTok"
    echo "3) Voltar"
    read -p "Escolha uma opção: " plataforma

    case $plataforma in
        1)
            echo "Baixando do YouTube..."
            ;;
        2)
            echo "Baixando do TikTok..."
            ;;
        3)
            menu_principal
            return
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            baixar_midia
            return
            ;;
    esac

    echo "Por favor, forneça o link:"
    read url

    # Listar formatos disponíveis
    echo "Listando formatos disponíveis..."
    yt-dlp --list-formats "$url"

    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Escolha o formato de download (exemplo: 137 para vídeo em MP4 ou 140 para MP3):"
    read -p "Formato: " formato_escolhido

    # Diretório de destino para o download
    caminho_destino="/storage/emulated/0/Download/"

    # Baixar com o formato escolhido
    echo "Baixando o conteúdo..."
    yt-dlp -f "$formato_escolhido" -o "${caminho_destino}%(title)s.%(ext)s" "$url"
    
    echo "Processo concluído!"
}

# Menu principal com layout personalizado
menu_principal() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "              BEM-VINDO AO SCRIPT DE DOWNLOAD DE MÍDIA        "
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Escolha uma das opções abaixo:"
    echo "1) Baixar mídia"
    echo "2) Instalar dependências"
    echo "3) Sair"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1)
            baixar_midia
            ;;
        2)
            instalar_dependencias
            echo "Dependências instaladas com sucesso!"
            sleep 2
            menu_principal
            ;;
        3)
            echo "Saindo do script. Até logo!"
            exit 0
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            menu_principal
            ;;
    esac
}

# Início do script
clear
echo "Iniciando o processo de verificação de dependências..."
verificar_dependencias

# Exibir o menu principal
menu_principal
