#!/bin/bash

# Função para verificar se um comando está instalado
verificar_comando() {
    command -v "$1" &> /dev/null
    if [ $? -ne 0 ]; then
        echo -e "\033[31m$1 não encontrado. Instalando...\033[0m"
        return 1
    else
        echo -e "\033[32m$1 já está instalado!\033[0m"
        return 0
    fi
}

# Função para instalar pacotes necessários
instalar_dependencias() {
    echo -e "\033[34mInstalando dependências...\033[0m"
    pkg update -y
    pkg upgrade -y
    pkg install -y python3 python3-pip git wget curl ffmpeg
}

# Função para instalar o yt-dlp (se necessário)
instalar_yt_dlp() {
    if ! verificar_comando yt-dlp; then
        echo -e "\033[34mInstalando yt-dlp...\033[0m"
        pip3 install yt-dlp
    fi
}

# Função para garantir que o ffmpeg esteja instalado
instalar_ffmpeg() {
    if ! verificar_comando ffmpeg; then
        echo -e "\033[34mInstalando ffmpeg...\033[0m"
        pkg install -y ffmpeg
    fi
}

# Função para verificar e instalar dependências necessárias
verificar_dependencias() {
    verificar_comando "yt-dlp" || instalar_yt_dlp
    verificar_comando "ffmpeg" || instalar_ffmpeg
}

# Função para baixar música
baixar_musica() {
    echo -e "\033[1;33mPor favor, forneça o link do vídeo ou playlist do YouTube:\033[0m"
    read url
    echo -e "\033[1;33mEscolha a qualidade do áudio:\n1) Melhor qualidade\n2) MP3\n3) Opções avançadas\033[0m"
    read opcao

    # Diretório de destino para o download
    caminho_destino="/storage/emulated/0/Download/"

    case $opcao in
        1)
            echo -e "\033[32mBaixando o áudio na melhor qualidade...\033[0m"
            yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "${caminho_destino}%(title)s.%(ext)s" "$url"
            ;;
        2)
            echo -e "\033[32mBaixando o áudio em MP3...\033[0m"
            yt-dlp -x --audio-format mp3 -o "${caminho_destino}%(title)s.%(ext)s" "$url"
            ;;
        3)
            echo -e "\033[32mBaixando o áudio com opções avançadas...\033[0m"
            yt-dlp -x --audio-format mp3 --audio-quality 0 --prefer-ffmpeg -o "${caminho_destino}%(title)s.%(ext)s" "$url"
            ;;
        *)
            echo -e "\033[31mOpção inválida. Saindo...\033[0m"
            exit 1
            ;;
    esac
}

# Função para listar músicas baixadas
listar_musicas_baixadas() {
    echo -e "\033[1;36mMúsicas baixadas:\033[0m"
    ls /storage/emulated/0/Download/ | grep ".mp3"
}

# Função para excluir música
excluir_musica() {
    echo -e "\033[1;33mDigite o nome da música para excluir (sem a extensão .mp3):\033[0m"
    read musica
    rm "/storage/emulated/0/Download/$musica.mp3"
    echo -e "\033[32mMúsica $musica excluída!\033[0m"
}

# Função para baixar vídeo em MP4
baixar_video_mp4() {
    echo -e "\033[1;33mDigite o link do vídeo para baixar em MP4:\033[0m"
    read url
    yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 -o "/storage/emulated/0/Download/%(title)s.%(ext)s" "$url"
    echo -e "\033[32mVídeo baixado com sucesso!\033[0m"
}

# Função para verificar a versão do yt-dlp
verificar_yt_dlp() {
    yt-dlp --version
}

# Função para atualizar yt-dlp
atualizar_yt_dlp() {
    echo -e "\033[34mVerificando se há atualizações para yt-dlp...\033[0m"
    pip3 install --upgrade yt-dlp
    echo -e "\033[32myt-dlp foi atualizado!\033[0m"
}

# Função para converter música para outro formato
converter_audio() {
    echo -e "\033[1;33mDigite o formato desejado (wav, ogg):\033[0m"
    read formato
    echo -e "\033[34mConvertendo para $formato...\033[0m"
    ffmpeg -i "/storage/emulated/0/Download/%(title)s.mp3" "/storage/emulated/0/Download/%(title)s.$formato"
    echo -e "\033[32mConversão concluída!\033[0m"
}

# Função para verificar espaço em disco
verificar_espaco() {
    df -h /storage/emulated/0/
}

# Função de ajuda
exibir_ajuda() {
    echo -e "\033[1;36mComandos disponíveis:\033[0m"
    echo -e "1) Baixar música"
    echo -e "2) Baixar vídeo em MP4"
    echo -e "3) Listar músicas baixadas"
    echo -e "4) Excluir música"
    echo -e "5) Verificar versão do yt-dlp"
    echo -e "6) Atualizar yt-dlp"
    echo -e "7) Converter música para outro formato"
    echo -e "8) Verificar espaço em disco"
    echo -e "9) Sair"
}

# Função para pesquisar no YouTube
pesquisar_no_youtube() {
    echo -e "\033[1;33mDigite o nome da música para pesquisar:\033[0m"
    read nome_musica
    yt-dlp "ytsearch:$nome_musica"
}

# Função para baixar playlist do YouTube
baixar_playlist() {
    echo -e "\033[1;33mDigite o link da playlist do YouTube:\033[0m"
    read url
    yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "/storage/emulated/0/Download/%(playlist_index)s - %(title)s.%(ext)s" "$url"
    echo -e "\033[32mPlaylist baixada com sucesso!\033[0m"
}

# Função para voltar ao menu de seleção
voltar_ao_menu() {
    echo -e "\033[34mDeseja realizar outra operação? (s/n)\033[0m"
    read resposta
    if [ "$resposta" == "s" ]; then
        exibir_ajuda
        ler_opcao
    else
        echo -e "\033[31mSaindo...\033[0m"
        exit 0
    fi
}

# Função para ler a opção escolhida pelo usuário
ler_opcao() {
    echo -e "\033[1;33mEscolha uma opção:\033[0m"
    echo -e "1) Baixar música"
    echo -e "2) Baixar vídeo em MP4"
    echo -e "3) Listar músicas baixadas"
    echo -e "4) Excluir música"
    echo -e "5) Verificar versão do yt-dlp"
    echo -e "6) Atualizar yt-dlp"
    echo -e "7) Converter música"
    echo -e "8) Verificar espaço em disco"
    echo -e "9) Pesquisar música no YouTube"
    echo -e "10) Baixar playlist"
    echo -e "11) Sair"
    read opcao

    case $opcao in
        1) baixar_musica ;;
        2) baixar_video_mp4 ;;
        3) listar_musicas_baixadas ;;
        4) excluir_musica ;;
        5) verificar_yt_dlp ;;
        6) atualizar_yt_dlp ;;
        7) converter_audio ;;
        8) verificar_espaco ;;
        9) pesquisar_no_youtube ;;
        10) baixar_playlist ;;
        11) echo -e "\033[31mSaindo...\033[0m"; exit 0 ;;
        *) echo -e "\033[31mOpção inválida. Tente novamente.\033[0m"; voltar_ao_menu ;;
    esac
}
# Função principal
main() {
    echo -e "\033[1;36mBem-vindo ao script de download de áudio e vídeo!\033[0m"
    verificar_dependencias
    exibir_ajuda
    ler_opcao
}

# Chamando a função principal
main
