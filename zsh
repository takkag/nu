#!/usr/bin/env zsh

# ZSH
# Fuso horário
export TZ="Europe/Madrid"
# Histórico
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000
HIST_STAMPS="dd/mm/yyyy"
# Paginador
export PAGER='less'
# Editor
HOSTNAME=$(hostname)
TERM='xterm-256color'
# Usuário
export PATH="/usr/local/bin:$PATH"
# Editor local e remoto
if [[ -n $SSH_CONNECTION ]]; then
  EDITOR='nano'
else
  EDITOR='subl -w'
fi
export EDITOR
# Sinalizador
export ARCHFLAGS="-arch x86_64"
# Correção
setopt correctall
unsetopt correct_all
# Bipe
setopt BEEP

# Zsh Extras
# Inicialização do Zsh
autoload -U compinit
compinit
# Verifica e corrige os diretórios inseguros
autoload -Uz add-zsh-hook
verificar_diretorios_inseguros() {
  local diretorios_inseguros
  diretorios_inseguros=$(compaudit 2>/dev/null)
  if [[ -n "$diretorios_inseguros" ]]; then
    echo "Diretórios inseguros encontrados. Corrigindo permissões..."
    sudo chmod g-w $diretorios_inseguros
  fi
}
add-zsh-hook precmd verificar_diretorios_inseguros
# Aliases
alias sitezsh="open /usr/local/share/zsh/site-functions/"
alias src="source $HOME/.zshrc"
alias srcp="source $HOME/.zprofile"
alias zcfg="cat ~/.zshrc"
# Autocompletar
source "${HOMEBREW_PREFIX}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
# Sugestões automáticas
source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Navegação e interação de comandos
source "$HOMEBREW_PREFIX/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh"
# Pesquisa de histórico
source "${HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
# Destacar sintaxes
source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# Realçar sintaxes
# source "${HOMEBREW_PREFIX}/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# iTerm2
# Impede a exibição do prompt irritante ao sair do iTerm2
# echo "Não exiba o prompt irritante ao sair do iTerm"
# defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Configuração
if [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi
# Abre o iTerm2
alias abreiterm='open -a "iTerm"'
# Fecha e reabre o iTerm
alias refresca='atualiza_prompt'
# Executa o fechamento e reabertura do iTerm
atualiza_prompt() {
    osascript -e 'tell application "iTerm" to tell current session of current window to write text "exit"' \
    -e 'tell application "System Events" to keystroke "t" using command down'
    sleep 1
    osascript -e 'tell application "iTerm" to tell current session of current window to write text "ls"'
}

# Starship
# Configuração
eval "$(starship init zsh)"
# Título da janela ($USER, $HOSTNAME, $PWD)
function set_win_title() {
    echo -ne "\033]0;$(basename "$USER")\007"
}
precmd_functions+=(set_win_title)
# Prompt
prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    fi
}

# Homebrew
# Diretório
HOMEBREW_PREFIX="/usr/local"
# Configurações
eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_EDITOR="code -w"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
export PATH="${HOMEBREW_PREFIX}/bin:${PATH}"
export MANPATH="${HOMEBREW_PREFIX}/share/man:${MANPATH}"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--fontdir=${HOME}/FontBase/Homebrew"
# Serviços
SERVICES=("dnsmasq" "mailhog" "mariadb" "nginx" "php" "redis")
for service in ${SERVICES[@]}; do
    alias b${service:0:1}="ln -sfv ${HOMEBREW_PREFIX}/opt/${service}*/homebrew.mxcl.${service}.plist ~/Library/LaunchAgents && brew services"
done
# Aliases
alias bap="brew update --force; brew upgrade --force"
alias bla="brew cleanup 2>/dev/null; brew cleanup --prune=all 2>/dev/null; brew services cleanup 2>/dev/null; brew cleanup -s 2>/dev/null; rm -rf \"$(brew --cache)\" 2>/dev/null; brew doctor --quiet 2>/dev/null; brew outdated 2>/dev/null; brew update --force 2>/dev/null; brew upgrade 2>/dev/null; brew autoremove 2>/dev/null; brew info; brew services list"
alias bco="brew config"
alias bdp="brew uninstall"
alias bds="brew doctor"
alias bia="brew install --cask"
alias bira="brew reinstall --cask"
alias bir="brew reinstall"
alias bip="brew install"
alias bipi="brew info"
alias bpf="brew search font- | grep"
alias bpd="brew outdated"
alias bps="brew search"
alias bra="brew autoremove"
alias bsr="brew services restart"
alias bsp="sudo -u \"$(id -un)\" -i brew services stop"
alias blc="brew cleanup; brew cleanup --prune=all; brew services cleanup; brew cleanup -s; rm -rf \"$(brew --cache)\"; brew doctor"
alias blista="brew list | tr '\n' ';' | sed 's/;$//' | sed 's/;/; /g' | tr ' ' '\n' | sort | tr '\n' ' ' && echo"
alias blp="brew list"
alias bls="brew services list"
alias brmu="sudo chown -R $USER:admin $(brew --prefix); brew cleanup --prune=all"
alias mbs="sudo -u \"$(id -un)\" -i brew services start --all"
alias mbsr="sudo -u david -i brew services restart"
alias mbsp="sudo -u david -i brew services stop"
alias mbsu="sudo -u david -i brew services start"
# Lista de fontes
fonts=("font-fira-code-nerd-font" "font-fira-mono-nerd-font" "font-hack-nerd-font" "font-hackgen-nerd" "font-jetbrains-mono-nerd-font" "font-im-writing-nerd-font" "font-meslo-lg-nerd-font" "font-monoid-nerd-font" "font-noto-nerd-font" "font-roboto-mono-nerd-font" "font-symbols-only-nerd-font" "font-ubuntu-mono-nerd-font" "font-ubuntu-nerd-font" "font-fontawesome" "font-droid-sans-mono-for-powerline" "font-fira-mono-for-powerline" "font-inconsolata-dz-for-powerline" "font-inconsolata-for-powerline" "font-inconsolata-for-powerline-bold" "font-inconsolata-g-for-powerline" "font-menlo-for-powerline" "font-meslo-for-powerline" "font-noto-mono-for-powerline" "font-powerline-symbols" "font-roboto-mono-for-powerline" "font-sf-mono" "font-sf-mono-for-powerline" "font-source-code-pro-for-powerline" "font-ubuntu-mono-derivative-powerline" "font-ibm-plex" "font-ibm-plex-mono" "font-ibm-plex-sans" "font-ibm-plex-serif" "font-iosevka" "font-iosevka-aile" "font-iosevka-comfy" "font-iosevka-curly" "font-iosevka-curly-slab" "font-iosevka-etoile" "font-iosevka-nerd-font" "font-iosevka-term-nerd-font" "font-fantasque-sans-mono" "font-fantasque-sans-mono-nerd-font" "font-fantasque-sans-mono-noloopk" "font-anonymous-pro" "font-victor-mono" "font-victor-mono-nerd-font" "font-ia-writer-duospace" "font-space-grotesk" "font-space-mono" "font-space-mono-nerd-font" "font-trispace" "font-hasklig" "font-noto-color-emoji" "font-noto-emoji" "font-twitter-color-emoji" "font-source-sans-3" "font-source-sans-pro")
# Instalar fontes
alias bif="for font in \"\${fonts[@]}\"; do bip \"\$font\"; done"

# Curl
# Instale-o:
# curl -sL https://raw.github.com/gist/2279031/hack.sh | sh
alias cabcurl="curl --head"
alias climator="curl wttr.in/Tortosa"
alias curlverb="curl -v"
alias luafase="curl wttr.in/moon"
alias meuip="curl ident.me"
alias meuip2="curl ipecho.net/plain"
alias vercurl="curl --version"

# Sublime Text
# Chamar função Atualizar
alias atualizarsublime="atualizar_config_sublime"
# Função Atualizar as configurações
atualizar_config_sublime() {
    # Destino das configurações
    destino="$HOME/Library/Application Support/Sublime Text/Packages/User"
    # Arquivo de configurações
    arquivo_config="$HOME/Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings"
    if [ -d "$destino" ]; then
        if [ -f "$arquivo_config" ]; then
            cp -r "$arquivo_config" "$destino" 2> /dev/null
            echo "Configurações do Sublime Text atualizadas."
        else
            echo "Erro: Arquivo de configurações não encontrado."
        fi
    else
        echo "Erro: Diretório do Sublime Text não encontrado."
    fi
}

# Python
# Configuração do Pyenv
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &>/dev/null; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
# Configuração do Brew com Pyenv
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# Chown
alias don="chown david:admin"
alias dho="set +o nomatch && chown -R root:root .[^.]*"
alias dhor="chown root:root -R \$(ls -d .* | egrep -v \"^\.\.?\$\")"
alias dpr="chown --preserve-root"
alias seum="sudo chown -R $USER:admin; ls"
alias seumt="find / -type f -exec chown -R $USER:admin {} \; 2>/dev/null && find / -type d -exec chown -R $USER:admin {} \; 2>/dev/null && echo 'Todos os arquivos e diretórios foram modificados com sucesso.'"
alias meu="sudo chown -R $(id -u):admin .; ls"
alias meumyt="set +o nomatch && sudo -u david chown -R $(id -u):admin .[^.]*; ls"
alias meut="set +o nomatch && sudo chown -R $(id -u):admin .[^.]*; ls"
alias sum="sudo chown -R $(id -u $USER)"
alias sumt="set +o nomatch && sudo chown -R $(id -u $USER) .[^.]* && ls"

# Chmod
alias cdfpeust="cd \"$HOME/Takk/\" && find . -exec chmod u=rwx,g=rwx,o=rwx {} \; && ls"
alias fpeust="find \"$HOME/Takk/\" -exec chmod u=rwx,g=rwx,o=rwx {} + && ls"
alias peus="chmod u=rwx,g=rwx,o=rwx && ls"
alias peust="set +o nomatch && chmod u=rwx,g=rwx,o=rwx .[^.]* && chmod u=rwx,g=rwx,o=rwx [^.]* && ls"
# Mostrar o progresso
mostrar_progresso() {
    local total=$1
    local atual=$2
    local porcentagem=$((atual * 100 / total))
    local barra=$(seq -s "=" $(($porcentagem / 2)) | sed 's/[0-9]//g')
    printf "\r[%-50s] %d%%" "$barra" "$porcentagem"
}
# Dar acesso "admin" aos arquivos e diretórios
peustodos() {
    local count=0
    local total=$(find / -type f 2>/dev/null | wc -l)
    while IFS= read -r file; do
        chmod u=rwx,g=rwx,o=rwx "$file" 2>/dev/null
        count=$((count + 1))
        mostrar_progresso "$total" "$count"
    done < <(find / -type f 2>/dev/null)
    printf "\n"
}
# Aliases
alias diratual="pwd"
alias infopath="echo \$PATH"
alias infoshell="echo \$SHELL"
alias mudape="chmod -R $(id -u $USER)"
alias mudadm="sudo chmod david:admin"
alias mudatodos="set +o nomatch && chmod -R $(id -u $USER) .[^.]* && ls"
alias mudoculto="sudo chmod -R root:root $(ls -d .* | egrep -v '^\.\.?$')"
alias mudpra="sudo chmod --preserve-root"
alias mudroot="set +o nomatch && sudo chmod -R root:root .[^.]*"
alias smudape="sudo chmod -R $(id -u $USER)"
alias smudatodos="set +o nomatch && sudo chmod -R $(id -u $USER) .[^.]* && ls"
alias paraeutodos="peustodos"

# Prompt
# Aliases para Informações
alias diratual="pwd"
alias infopath="echo \$PATH"
alias infoshell="echo \$SHELL"
# Função para "ls" após "cd"
# function cd {
#     builtin cd "$@" && ls
#     vared -p "Próximo comando: " -c command
#     eval "$command"
# }
# Função para "ls" com exa após "cd"
function cd {
    builtin cd "$@" && exa --color=auto -l -la -lag -lah --icons
}
# Função para executar o próximo comando após "cd" com exa
function cd_proximo {
    builtin cd "$@" && exa --color=auto -l -la -lag -lah --icons
    vared -p "Próximo comando: " -c comando
    eval "$comando"
}
# Função para execução imediata
function nu {
    vared -p "Próximo comando: " -c command
    eval "$command"
}
# Aliases para Prompt
alias ..="cd - && ls"
alias apagards="find / -type f \( -name '.DS_Store' -o -name '._.DS_Store' \) -delete -print 2>/dev/null | grep -vE '^(find: |rm: )'"
alias apagarf="rm -f"
alias apagardir="rm -rf"
alias l="clear"
alias lll="limparme && nu"
alias casa="cd $HOME"
alias cpu="system_profiler SPHardwareDataType | grep 'Nome do Processador'"
alias desligar="sudo shutdown -h now"
alias editar="subl -w"
alias eu="whoami"
alias histclear="fc -R"
alias historico="fc -l"
alias infohd="df -h"
alias infomem="system_profiler SPMemoryDataType"
alias infosis="system_profiler SPSoftwareDataType"
alias memsu="sudo htop"
alias minhamem="htop"
alias novodir="mkdir -p"
alias raiz="cd /"
alias renomear="mv"
alias reiniciar="sudo shutdown -r now"
alias ss="source $HOME/.config/starship.toml"
alias su="sudo"
alias t="touch"
alias ucomp="compinit"
alias w="type -a"
alias wfphp="file \$(which php)"
alias x="exit"
# Aliases de Sistema
alias limpar="sudo purge; sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; killall NotificationCenter; killall Dock; killall Finder"
alias encontrar="find . -type f"
alias pingmeu="ping -c 1"
alias mostrartudo="defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder"
alias ocultartudo="defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder"
alias ocultartudosu="sudo defaults write com.apple.finder AppleShowAllFiles -bool false; sudo killall Finder"
# Função para exibir o progresso em porcentagem
function exibir_progresso {
    local progresso=$1
    local total=$2
    local porcentagem=$((progresso * 100 / total))
    echo -ne "Progresso: $porcentagem% \r"
}
# Excluir alguns arquivos com exceção de algumas pastas
excluir_arquivos() {
  local total_excluir=$(find / -type f \( -name '.DS_Store' -o -name '*.log' \) -not \( -path '*/FontBase/*' -o -path '*/zsh-autocomplete/*' \) -print0 2>/dev/null | grep -c '')
  echo "Total de arquivos para excluir: $total_excluir"
  if [[ $total_excluir -gt 0 ]]; then
    local progresso=0
    while IFS= read -r -d '' arquivo; do
        rm "$arquivo" 2>/dev/null
        ((progresso++))
        exibir_progresso $progresso $total_excluir
    done < <(find / -type f \( -name '.DS_Store' -o -name '*.log' \) -not \( -path '*/FontBase/*' -o -path '*/zsh-autocomplete/*' \) -delete -print0 2>/dev/null)
    echo -e "\nRemoção concluída! Total de arquivos excluídos: $progresso"
  else
    echo "Nenhum arquivo para excluir encontrado."
  fi
}
# Iniciar a exclusão de arquivos
alias limparme="limpar; excluir_arquivos"

# Função para exibir o progresso em porcentagem
function exibir_progresso {
    local progresso=$1
    local total=$2
    local porcentagem=$((progresso * 100 / total))
    echo -ne "Progresso: $porcentagem% \r"
}
# Função para exibir o status do progresso
function exibir_status_progresso {
    local codigo=$1
    local mensagem=$2
    if [ $codigo -eq 0 ]; then
        echo "$mensagem concluído com sucesso"
    else
        echo "Erro ao realizar $mensagem"
    fi
}
# Função para exibir o status de uma etapa
function exibir_status_etapa {
    local codigo=$1
    local mensagem=$2
    if [ $codigo -eq 0 ]; then
        echo "[$mensagem] Concluído"
    else
        echo "[$mensagem] Erro"
    fi
}
# Funções para Limpar o MacOS
function limpar_caches {
    echo "Deletando caches de aplicações..."
    rm -rf ~/Library/Caches/* && exibir_status_etapa $? "Deleção dos caches de aplicações"
}
function limpar_logs {
    local total_arquivos=$(find ~/Library/Logs -type f -name '*.log' 2>/dev/null | wc -l | awk '{ print $1 }')
    local progresso=0
    echo "Deletando todos os arquivos .log..."
    while IFS= read -r -d '' arquivo; do
        rm "$arquivo" 2>/dev/null
        ((progresso++))
        exibir_progresso $progresso $total_arquivos
    done < <(find ~/Library/Logs -type f -name '*.log' -print0 2>/dev/null)
    echo -e "\nDeleção dos arquivos .log concluída!"
}
function limpar_dns {
    echo "Limpando o cache DNS..."
    dscacheutil -flushcache && killall -HUP mDNSResponder && exibir_status_etapa $? "Limpeza do cache DNS"
}
function limpar_brew {
    if command -v brew &> /dev/null; then
        echo "Limpando o cache do homebrew..."
        brew cleanup 2>/dev/null && exibir_status_etapa $? "Limpeza do cache do homebrew"
    else
        echo "Homebrew não encontrado"
    fi
}
function limpar_composer {
    if command -v composer &> /dev/null; then
        echo "Limpando o cache do composer..."
        composer clear-cache && exibir_status_etapa $? "Limpeza do cache do composer"
    else
        echo "Composer não encontrado"
    fi
}
function limpar_node {
    if command -v npm &> /dev/null; then
        echo "Limpando o cache do node..."
        npm cache clean --force 2>/dev/null && exibir_status_etapa $? "Limpeza do cache do node"
    else
        echo "Node não encontrado"
    fi
}
function liberar_memoria {
    echo "Liberando memória RAM..."
    sudo purge >/dev/null 2>&1 && exibir_status_etapa $? "Liberação de memória RAM"
}
function limpar_ds_store {
    local total_arquivos=$(find / -type f \( -name '.DS_Store' -o -name '._.DS_Store' \) 2>/dev/null | wc -l | awk '{ print $1 }')
    local progresso=0
    echo "Deletando todos os arquivos .DS_Store..."
    while IFS= read -r -d '' arquivo; do
        sudo rm "$arquivo" 2>/dev/null
        ((progresso++))
        exibir_progresso $progresso $total_arquivos
    done < <(find / -type f \( -name '.DS_Store' -o -name '._.DS_Store' \) -print0 2>/dev/null)
    echo -e "\nDeleção dos arquivos .DS_Store concluída!"
}
function executar_manutencao {
    echo "Executando scripts de manutenção..."
    sudo periodic daily weekly monthly >/dev/null 2>&1 && exibir_status_etapa $? "Execução de scripts de manutenção"
}
function reparar_disco {
    echo "Reparando o disco rígido..."
    sudo diskutil repairDisk / >/dev/null 2>&1 && exibir_status_etapa $? "Reparo do disco rígido"
}
function redefinir_permissoes {
    echo "Restaurando todas as permissões de usuário..."
    sudo diskutil resetUserPermissions / "$(id -u)" >/dev/null 2>&1 && exibir_status_etapa $? "Restauração das permissões de usuário"
}
function limpar_time_machine {
    echo "Deletando os snapshots do Time Machine..."
    sudo tmutil listlocalsnapshots / | grep "com.apple.TimeMachine" | while read snapshot; do
        sudo tmutil deletelocalsnapshots ${snapshot##*.} >/dev/null 2>&1
    done
    exibir_status_etapa $? "Deleção dos snapshots do Time Machine"
}
# Limpar o MacOS
alias limparmeumac='limpar_caches; limpar_logs; limpar_dns; limpar_brew; limpar_composer; limpar_node; liberar_memoria; limpar_ds_store; executar_manutencao; reparar_disco; redefinir_permissoes; limpar_time_machine'

# Exa
# Configurações
export EXA_COLORS="uu=36:gu=37:sn=32:sb=32:da=34:ur=34:uw=35:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36:"
# Aliases
alias ll='exa -lbF --git --icons'
alias ls="exa --color=auto -l -la -lag -lah --icons"
alias ls-="ls -lad .*"
alias lsarv='exa --tree --level=2'
alias lsgrupo='exa --color=auto --icons'
alias lsmodificado='exa -lbGd --git --sort=modified'
alias lssimples='exa --color=auto -l --icons'
alias lertudo='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale -a'
alias listararv='exa --color=auto -l -lag --tree --level=2 --icons'
alias listartudo='exa -lbF --git -lah --icons'
alias listarum='exa -1'
alias xl='exa -la --icons --color=always'

# PHP
# Verificar e criar link simbólico
# if [ -f "/opt/homebrew/include/pcre2.h" ]; then
#   if [ -d "/opt/homebrew/Cellar/valet-php@7.3/7.3.27_2/include/php/ext/pcre" ]; then
#     ln -s "/opt/homebrew/include/pcre2.h" "/opt/homebrew/Cellar/valet-php@7.3/7.3.27_2/include/php/ext/pcre/pcre2.h"
#     echo "Link criado."
#   else
#     echo "Diretório não encontrado."
#   fi
# else
#   echo "Arquivo não encontrado."
# fi
# Verificar versão do PHP
alias verphp="php --version"
# Exibir informações de configuração
alias infophp="php --info"
# Exibir informações de configuração do PHP
alias iniphp="php --ini"
# Configuração das flags para diferentes versões do PHP
export LDFLAGS74="-L/usr/local/opt/php@7.4/lib"
export CPPFLAGS74="-I/usr/local/opt/php@7.4/include"
export LDFLAGS80="-L/usr/local/opt/php@8.0/lib"
export CPPFLAGS80="-I/usr/local/opt/php@8.0/include"
export LDFLAGS81="-L/usr/local/opt/php@8.1/lib"
export CPPFLAGS81="-I/usr/local/opt/php@8.1/include"
export LDFLAGS82="-L/usr/local/opt/php@8.2/lib"
export CPPFLAGS82="-I/usr/local/opt/php@8.2/include"
export LDFLAGS83="-L/usr/local/opt/php@8.3/lib"
export CPPFLAGS83="-I/usr/local/opt/php@8.3/include"
# Desativar todas as versões do PHP
alias desativarphp="brew unlink php@7.4 php@8.0 php@8.1 php@8.2 php@8.3; brew unlink shivammathur/php/php@7.4 php@8.0 php@8.1 php@8.2 php@8.3; clear"
# Ativar versões específicas do PHP
alias php74="brew link --overwrite --force php@7.4 shivammathur/php/php@7.4; clear"
alias php80="brew link --overwrite --force php@8.0 shivammathur/php/php@8.0; clear"
alias php81="brew link --overwrite --force php@8.1 shivammathur/php/php@8.1; clear"
alias php82="brew link --overwrite --force php@8.2 shivammathur/php/php@8.2; clear"
alias php83="brew link --overwrite --force php@8.3 shivammathur/php/php@8.3; clear"

# WordPress
# Configurações WP-CLI
autoload -U bashcompinit
bashcompinit
source $HOME/Takk/fjallstoppur/wp-completion.bash
# Aliases
alias wplimpar="limpar_cache_e_arquivos"
alias wplimpat="wp cache flush && wp core verify-checksums && wp core update && wp core update-db && wp core update-db --network && wp plugin verify-checksums woocommerce && wp plugin verify-checksums --all && sudo wp cli update && sudo wp cli update --nightly && wp cache flush && wp core version"
alias wplstema="wp theme list"
alias wplsplugin="wp plugin list"
alias wpbkpdb="fazer_backup_banco_dados"
# Limpeza de cache e arquivos indesejados
limpar_cache_e_arquivos() {
    local wp_command='wp'
    printf "Essa ação limpará o cache, arquivos indesejados e removerá transientes do WordPress.\n"
    printf "Deseja continuar? (S/N): "
    read choice
    case "$choice" in
        [sS])
            printf "Limpando cache e arquivos indesejados...\n"
            find . -name '.DS_Store' -type f -delete
            $wp_command cli cache clear
            $wp_command cli cache prune
            $wp_command transient delete --all
            $wp_command cache flush
            ;;
        *)
            printf "Operação cancelada.\n"
            ;;
    esac
}
# Função para fazer backup do banco de dados
fazer_backup_banco_dados() {
    read -p "Deseja fazer backup do banco de dados? (S/N): " fazer_backup
    if [[ $fazer_backup == [Ss] ]]; then
        read -p "Digite o nome do arquivo de backup: " nome_backup
        wp db export "$HOME/Downloads/$nome_backup.sql" --add-drop-table
        echo "Backup do banco de dados realizado com sucesso!"
    fi
}
# Substituir palavras em todo o banco de dados
substituir_palavra() {
    read -p "Qual palavra você deseja substituir em todas as tabelas do banco de dados? " palavra_antiga
    read -p "Ótimo. Qual é a nova palavra? " palavra_nova
    wp search-replace "$palavra_antiga" "$palavra_nova" --all-tables --precise
    echo "A palavra '$palavra_antiga' foi substituída por '$palavra_nova' em todas as tabelas do banco de dados!"
}
# Verificar, reparar e otimizar todo o banco de dados
verificar_reparar_otimizar() {
    wp db check && wp db repair && wp db optimize
    echo "Verificação, reparo e otimização das tabelas do banco de dados concluídos!"
}
# Função principal
processo_principal() {
    fazer_backup_banco_dados
    while true; do
        substituir_palavra
        read -p "Deseja substituir mais alguma palavra? (S/N): " continuar
        if [[ $continuar != [Ss] ]]; then
            break
        fi
    done
    verificar_reparar_otimizar
}
# Chamar função principal
alias wpmudarpdb="processo_principal"

# Composer
# Adicionar diretório do Composer ao PATH
export PATH="$PATH:$HOME/.composer/vendor/bin"
# Definir o limite de memória
composer_alias() {
    COMPOSER_MEMORY_LIMIT=-1 composer "$@"
}
# Aliases
alias cabrir="open ${HOME}/.composer/"
alias cboot="catu; cupg; catud; climpa; cval"
alias cdeletar="composer_alias remove -v"
alias cdes="composer_alias outdated --strict --direct"
alias cdiag="composer_alias diagnose -v"
alias catu="composer_alias update -v"
alias catuig="composer_alias update --ignore-platform-reqs -v"
alias catuigcd="composer_alias update --ignore-platform-reqs --with-dependencies -v"
alias catud="composer_alias dumpautoload -o -v"
alias catupac="composer_alias self-update; composer_alias dumpautoload -o -v"
alias cval="composer_alias validate -v"
alias clic="composer_alias licenses -v"
alias climpa="composer_alias cc -v"
alias creq="composer_alias require -v"
alias creqig="composer_alias require --ignore-platform-reqs -v"
alias cupg="composer_alias upgrade -v"
alias cupgigcd="composer_alias upgrade --ignore-platform-reqs --with-dependencies -v"

# Node
# Adiciona o diretório node_modules/.bin ao PATH
export PATH="$PATH:$HOME/node_modules/.bin"
# Aliases
alias anod="open ${HOME}/node_modules/"
alias nodes="npm outdated"
alias nodatu="npm update -g; npm update --force"
alias nodcor="npm audit fix --force"
alias nodlista="npm list; npm list -g --depth 0; npm view"

# NVN
# Configuração do NVM
export NVM_DIR="$HOME/.nvm"
# Carrega o NVM
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
# Carrega o bash_completion do NVM
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
# Aliases
alias nvajuda="nvm --help"
alias nvativa="nvm use"
alias nvatual="node --version"
alias nvatualiza="nvm install node --reinstall-packages-from=default"
alias nvinfo="node --v8-options | grep -A 1 'in progress'"
alias nvinstala="nvm install"
alias nvinstag="npm install -g"
alias nvlimpa="nvm cache clear"
alias nvlista="nvm ls"
alias nvlistadisp="nvm ls-remote"
alias nvpadrao="nvm alias default"
alias nvremove="nvm uninstall"
alias nvlts="nvm install --lts && nvm use --lts"

# Valet+
alias av="open ${HOME}/.valet/"
alias v="valet"
alias vcriaindex="echo \"<?php echo 'Takk à sua disposição';\" > index.php"
alias vcami="valet paths"
alias vdbdel="valet db drop"
alias vdbls="valet db ls"
alias vdbnov="valet db create"
alias vdbres="valet db reset"
alias vlinks="valet links"
alias vlink="valet link"
alias vls="valet list"
alias vmarca="valet park"
alias vmeubrew="mybrestart dnsmasq && \ mybrestart mailhog && \ mybrestart mariadb && \ mybrestart nginx && \ mybrestart php && \ mybrestart redis"
alias vasites="cd ${HOME}/.valet/Sites/ && ls"

# MariaDB
export MYSQL_DIR="$HOME/.valet/mysql"
export MYSQL_UNIX_PORT="/tmp/mysql.sock"
export PATH="$PATH:$HOME/.valet/valet.sock"
# Configuração do socket
default_socket() {
    if [[ -z "${MYSQL_UNIX_PORT}" ]]; then
        export MYSQL_UNIX_PORT="/tmp/mysql.sock"
    fi
}
# Aliases
alias mdbapagar="mysql_config_editor remove --login-path=local"
alias mdbchave="mysql_config_editor set --login-path=local --host=localhost --user=root --password"
alias mdbcriar="mysqladmin -u root -p create"
alias mdbdelete="mysql -u root -p nome_database -e 'DELETE FROM nome_tabela WHERE condição;'"
alias mdbdesc="mysql -u root -p nome_database -e 'DESCRIBE nome_tabela;'"
alias mdbdrop="mysqladmin -u root -p drop"
alias mdbexport="mysqldump -u root -p nome_database > nome_arquivo.sql"
alias mdbimp="mysql -u root -p <"
alias mdbimport="mysql -u root -p nome_database < nome_arquivo.sql"
alias mdbl="mysql -u root -p -e 'SHOW DATABASES;'"
alias mdblista="mysql_config_editor print --all"
alias mdblogin="mysql -u root -p"
alias mdba="mysqladmin -u root password"
alias mdbnova="mysql -u root -p -e 'CREATE DATABASE nome_database;'"
alias mdbrestart="brew services restart mariadb"
alias mdbshowdbs="mysql -u root -p -e 'SHOW DATABASES;'"
alias mdbshowtables="mysql -u root -p nome_database -e 'SHOW TABLES;'"
alias mdbstart="brew services start mariadb"
alias mdbstatus="brew services list | grep mariadb"
alias mdbstop="brew services stop mariadb"
alias mdbupdate="mysql -u root -p nome_database -e 'UPDATE nome_tabela SET coluna1 = valor1, coluna2 = valor2 WHERE condição;'"
alias mddbcu="mysqldump -u root"
alias mddbcr="mysqldump -u root -p"
alias mdbusar="mysql -u root -p -D"
alias mdbinfo="mysql --version"
alias mdbselect="mysql -u root -p nome_database -e 'SELECT * FROM nome_tabela;'"

# Nginx
# server {
#     # Bloqueia o acesso a arquivos .ht
#     location ~ /\.ht {
#         deny all;
#     }
#     # Permite acesso a arquivos .well-known
#     location ~ /\.well-known {
#         allow all;
#     }
#     # Resto da configuração do servidor...
# }

# Git
alias gatributos="echo \"*.psd filter=lfs diff=lfs merge=lfs -text; *.ai filter=lfs diff=lfs merge=lfs -text; *.pdf filter=lfs diff=lfs merge=lfs -text; *.log filter=lfs diff=lfs merge=lfs -text; *.png filter=lfs diff=lfs merge=lfs -text; *.jpg filter=lfs diff=lfs merge=lfs -text; *.webp filter=lfs diff=lfs merge=lfs -text; *.webm filter=lfs diff=lfs merge=lfs -text; *.mp4 filter=lfs diff=lfs merge=lfs -text; *.zip filter=lfs diff=lfs merge=lfs -text\" > ~/.gitattributes"
alias gbr='git branch'
alias gch='git checkout'
alias gad='git add'
alias gco='git commit'
alias glfssis="sudo git lfs install --system"
alias glfsins="git lfs install --force"
alias glog='git log'
alias gstatus='git status'

# Takk
# Função que será chamada toda vez que entrar em uma pasta ou subpasta dentro de "$HOME/Takk/"
takkauto() {
    if [[ "$PWD" == "$HOME/Takk/"* ]]; then
        for item in "$HOME/Takk/"*; do
            if [[ -d "$item" ]]; then
                alias "${item##*/}"="cd '$item' && takkauto"
            fi
        done
    fi
}
# Chama a função "takkauto"
chpwd_functions+=(takkauto)
# Aliases
alias takkauto='set +o nomatch && chmod u=rwx,g=rwx,o=rwx .[^.]* && chmod u=rwx,g=rwx,o=rwx [^.]* && ls'
alias starfheima="cd ${HOME}/Takk/starf/heima/ && ls"
alias starfisabelastoop="cd ${HOME}/Takk/starf/isabelastoop/ && ls"
alias starftakk="cd ${HOME}/Takk/starf/takk/ && ls"
alias starfwavecontrol="cd ${HOME}/Takk/starf/wavecontrol/ && ls"
alias starfwavecontrolacademy="cd ${HOME}/Takk/starf/wavecontrolacademy/ && ls"
alias codeheima="cdheima && open https://heima.nu/wp/wp-admin/ && open ${HOME}/Takk/starf/heima.code-workspace"
alias codeisabelastoop="cdisabelastoop && open https://isabelastoop.nu/wp/wp-admin/ && open ${HOME}/Takk/starf/isabelastoop.code-workspace"
alias codetakk="cdtakk && open https://takk.nu/wp/wp-admin/ && open ${HOME}/Takk/starf/takk.code-workspace"
alias codewavecontrol="cdwavecontrol && open https://wavecontrol.nu/wp/wp-admin/ && open ${HOME}/Takk/starf/wavecontrol.code-workspace"
alias codewavecontrolacademy="cdwavecontrolacademy && open https://wavecontrolacademy.nu/wp/wp-admin/ && open ${HOME}/Takk/starf/wavecontrolacademy.code-workspace"
alias fjallstoppur="cd ${HOME}/Takk/fjallstoppur/ && ls"
alias heima="cd ${HOME}/Takk/heima/ && ls"
alias inni="cd ${HOME}/Takk/inni/ && ls"
alias starf="cd ${HOME}/Takk/starf/ && ls"
alias takk="cd ${HOME}/Takk/ && ls"
alias aheima="open ${HOME}/Takk/starf/heima/"
alias aisabelastoop="open ${HOME}/Takk/starf/isabelastoop/"
alias atakk="open ${HOME}/Takk/starf/takk/"
alias awavecontrol="open ${HOME}/Takk/starf/wavecontrol/"
alias awavecontrolacademy="open ${HOME}/Takk/starf/wavecontrolacademy/"

# Gerar projeto
function gerarstarf() {
  composer_alias create-project roots/bedrock
  cd bedrock

  set +o nomatch
  chmod u=rwx,g=rwx,o=rwx .[^.]*
  chmod u=rwx,g=rwx,o=rwx [^.]*

  composer_alias config -g github-oauth.github.com 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

  composer_alias install -v

  echo -n 'Qual será o nome deste projeto? '
  read newname

  cd ..
  mv bedrock "$newname"
  cd "$newname"

  composer_alias validate
  sed -i '' '/"repositories": \[/{n;N;N;N;d;}' composer.json
  sed -i '' '/"repositories": \[/a\
    {\
      "type": "composer",\
      "url": "https://wpackagist.org",\
      "only": ["wpackagist-plugin/*", "wpackagist-theme/*"]\
    },\
    {\
      "type": "vcs",\
      "url": "git@github.com:takkag\/heima.git"\
    },\
    {\
      "type": "vcs",\
      "url": "git@github.com:takkag\/heima-child.git"\
    },\
    {\
      "type": "vcs",\
      "url": "git@github.com:takkag\/js_composer.git"\
    },\
    {\
      "type": "vcs",\
      "url": "git@github.com:takkag\/otgs-installer-plugin.git"\
    ' composer.json

  composer_alias remove -v wpackagist-theme/twentytwentythree
  composer_alias require -v takk/heima
  composer_alias require -v takk/heima-child
  composer_alias require -v takk/js_composer
  composer_alias require -v takk/otgs-installer-plugin
  composer_alias require -v wpackagist-plugin/akismet
  composer_alias require -v wpackagist-plugin/classic-editor
  composer_alias require -v wpackagist-plugin/contact-form-7
  composer_alias require -v wpackagist-plugin/disable-comments
  composer_alias require -v wpackagist-plugin/duplicate-post
  composer_alias require -v wpackagist-plugin/google-site-kit
  composer_alias require -v wpackagist-plugin/litespeed-cache
  composer_alias require -v wpackagist-plugin/svg-support
  composer_alias require -v wpackagist-plugin/woocommerce
  composer_alias require -v wpackagist-plugin/wordpress-importer
  composer_alias require -v wpackagist-plugin/wordpress-seo

  echo "Esse é um projeto Takk e você configurou nosso tema 'Heima' que evoca a beleza e a paz encontradas no refúgio do lar. Navegue para a pasta $newname para começar."
}
# Alias para gerar projeto
alias gerarstarf="gerarstarf"

# Abrir programas
alias ableton="/Applications/Ableton\ Live\ Lite.app/Contents/MacOS/Ableton\ Live\ Lite"
alias boom3d="open -a 'Boom 3D'"
alias calculadora="open -a Calculator"
alias chrome="open -a Google\ Chrome"
alias cleanmymac="/Applications/CleanMyMac\ X.app/Contents/MacOS/CleanMyMac\ X"
alias code="open -a 'Visual Studio Code'"
alias deepl="/Applications/DeepL.app/Contents/MacOS/DeepL"
alias fontbase="/Applications/FontBase.app/Contents/MacOS/FontBase"
alias github="/Applications/GitHub\ Desktop.app/Contents/MacOS/GitHub\ Desktop"
alias illustrator="/Applications/Adobe\ Illustrator\ 2023/Adobe\ Illustrator\ 2023.app/Contents/MacOS/Illustrator"
alias notas="open -a Notes"
alias photoshop="/Applications/Adobe\ Photoshop\ 2023/Adobe\ Photoshop\ 2023.app/Contents/MacOS/Adobe\ Photoshop\ 2023"
alias safari="open -a Safari"
alias sequelpro="/Applications/Sequel\ Pro.app/Contents/MacOS/Sequel\ Pro"
alias spotify="open -a Spotify"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias termius="/Applications/Termius.app/Contents/MacOS/Termius"
alias whatsapp="open -a WhatsApp"

# Prompt
# Alias para perguntar qual URL abrir e abrir no navegador
alias abrirurl='read -p "Digite a URL que deseja abrir: " url && open "$url"'

# Função para encerrar processos e limpar a tela
function mortal() {
  # Lista de processos a serem encerrados
  processes=("WindowServer" "Dock" "Finder" "SystemUIServer" "NotificationCenter" "Safari" "Photos" "System Preferences" "Calendar" "Contacts" "Preview" "Pages" "Keynote" "Numbers" "Xcode" "Siri" "iTunes" "Time Machine" "QuickTime Player" "iMovie" "fontd" "coreaudiod" "configd" "cfprefsd" "loginwindow" "opendirectoryd" "nsurlsessiond" "diskarbitrationd" "distnoted" "accountsd" "sharingd" "coreservicesd")
  # Adiciona a configuração para permitir que o usuário execute o pkill sem digitar a senha
  sudo sh -c 'echo "david ALL=(ALL) NOPASSWD: /usr/bin/pkill" >> /etc/sudoers'
  # Itera sobre a lista de processos e encerra cada um deles usando o pkill com privilégios de superusuário
  for process in "${processes[@]}"; do
    sudo pkill -x "$process"
  done
  # Limpa a tela após encerrar os processos
  clear
}
# Alias para executar a função mortal
alias mortal="mortal"

# Função para otimizar o Safari
function mortalsafari() {
    # Limpar cache e dados do site
    defaults delete com.apple.Safari WebKitMediaPlaybackAllowsInline
    rm -rf ~/Library/Caches/com.apple.Safari
    rm -rf ~/Library/Safari
    echo "Cache e dados do site limpos."
    # Desativar extensões desnecessárias
    # defaults write com.apple.Safari ExtensionsEnabled -bool false
    # echo "Extensões desnecessárias desativadas."
    # Fechar todas as guias abertas
    # osascript -e 'tell application "Safari" to close every tab of every window'
    # echo "Todas as guias foram fechadas."
    # Desativar plug-ins
    # defaults write com.apple.Safari WebKitPluginsEnabled -bool false
    # echo "Plug-ins desativados."
    # Gerenciar preferências de privacidade
    defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
    defaults write com.apple.Safari WebKitContentBlockersEnabled -bool true
    echo "Preferências de privacidade gerenciadas."
    # Desativar reprodução automática de vídeos
    defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
    echo "Reprodução automática de vídeos desativada."
    # Desativar detecção automática de números de telefone
    defaults write com.apple.Safari AutomaticallyDetectPhoneNumber -bool false
    echo "Detecção automática de números de telefone desativada."
    # Limpar histórico de navegação
    osascript -e 'tell application "Safari" to delete every history item'
    echo "Histórico de navegação limpo."
    # Desativar preenchimento automático
    defaults write com.apple.Safari AutoFillPasswords -bool false
    defaults write com.apple.Safari AutoFillCreditCardData -bool false
    echo "Preenchimento automático desativado."
    # Reiniciar o Safari
    osascript -e 'tell application "Safari" to quit'
    open -a Safari
    echo "Safari reiniciado."
}
# Alias para executar mortalsafari
alias mortalsafari="mortalsafari"

# Função para otimizar o Google Chrome
function mortalgoogle() {
    # Limpar cache e dados do site
    rm -rf ~/Library/Caches/Google/Chrome
    rm -rf ~/Library/Application\ Support/Google/Chrome/Default/Cache
    echo "Cache e dados do site limpos."
    # Desativar extensões desnecessárias
    # defaults write com.google.Chrome ExtensionsEnabled -bool false
    # echo "Extensões desnecessárias desativadas."
    # Fechar todas as guias abertas
    # osascript -e 'tell application "Google Chrome" to close every tab of every window'
    # echo "Todas as guias foram fechadas."
    # Gerenciar preferências de privacidade
    defaults write com.google.Chrome IncognitoModeAvailability -integer 2
    echo "Preferências de privacidade gerenciadas."
    # Desativar reprodução automática de vídeos
    defaults write com.google.Chrome AutoplayAllowed -bool false
    echo "Reprodução automática de vídeos desativada."
    # Desativar preenchimento automático
    defaults write com.google.Chrome AutoFillEnabled -bool false
    echo "Preenchimento automático desativado."
    # Reiniciar o Google Chrome
    osascript -e 'tell application "Google Chrome" to quit'
    open -a "Google Chrome"
    echo "Google Chrome reiniciado."
}
# Alias para executar mortalgoogle
alias mortalgoogle="mortalgoogle"

# Função para otimizar o Firefox
function mortalfirefox() {
    # Limpar cache e dados do site
    rm -rf ~/Library/Caches/Firefox/Profiles/*.default-release/cache2
    rm -rf ~/Library/Caches/Firefox/Profiles/*.default-release/minidumps
    rm -rf ~/Library/Caches/Firefox/Profiles/*.default-release/offlineCache
    echo "Cache e dados do site limpos."
    # Desativar extensões desnecessárias
    # defaults write org.mozilla.firefox Extensions.enabled -bool false
    # echo "Extensões desnecessárias desativadas."
    # Fechar todas as guias abertas
    # osascript -e 'tell application "Firefox" to close every tab of every window'
    # echo "Todas as guias foram fechadas."
    # Gerenciar preferências de privacidade
    defaults write org.mozilla.firefox browser.privatebrowsing.autostart -bool true
    echo "Preferências de privacidade gerenciadas."
    # Desativar reprodução automática de vídeos
    defaults write org.mozilla.firefox media.autoplay.default -1
    echo "Reprodução automática de vídeos desativada."
    # Desativar preenchimento automático
    defaults write org.mozilla.firefox signon.autofillForms -bool false
    echo "Preenchimento automático desativado."
    # Reiniciar o Firefox
    osascript -e 'tell application "Firefox" to quit'
    open -a Firefox
    echo "Firefox reiniciado."
}
# Alias para executar mortalfirefox
alias mortalfirefox="mortalfirefox"

# Função para otimizar o desempenho do Ableton Live
function mortalableton() {
  # Ajustar as configurações de áudio
  defaults write com.ableton.live buffer_size 512
  defaults write com.ableton.live sample_rate 44100
  # Desativar plugins desnecessários
  # ableton_path="/Applications/Ableton Live.app/Contents/App-Resources/MIDI Remote Scripts"
  # disabled_plugins=("Plugin1" "Plugin2" "Plugin3")
  # for plugin in "${disabled_plugins[@]}"; do
  #   mv "$ableton_path/$plugin" "$ableton_path/$plugin.disabled"
  # done
  # Habilitar uso de múltiplos núcleos de processamento
  defaults write com.ableton.live MaxUseMultipleCores -bool true
  # Informar ao usuário as ações realizadas
  echo "Otimização do Ableton Live concluída. Reinicie o aplicativo para que as alterações entrem em vigor."
}
# Alias para chamar mortalableton
alias mortalableton="mortalableton"

# Função para otimizar o desempenho do Spotify
function mortalify() {
  # Desativar animações
  defaults write com.spotify.client ui.allowanimations -bool false
  # Desativar transparência
  defaults write com.spotify.client NSWindowSupportsAutomaticInlineTitlebar -bool false
  # Desativar aceleração de hardware
  defaults write com.spotify.client force-gpu-acceleration -bool false
  # Informar ao usuário as ações realizadas
  echo "Otimização do Spotify concluída. Reinicie o aplicativo para que as alterações entrem em vigor."
}
# Alias para chamar a mortalify
alias mortalify="mortalify"

# Função para configurar o Macs Fan Control
function mortalcpu() {
  if [ -f "/Applications/Macs Fan Control.app/Contents/MacOS/Macs Fan Control" ]; then
    fan_speed_min=6000
    fan_speed_max=12000
    max_temp=30
    if pgrep -f "Macs Fan Control" > /dev/null; then
      echo "O Macs Fan Control já está em execução. Configurando as opções..."
    else
      open -g -a "Macs Fan Control" >/dev/null 2>&1 & disown
      sleep 2
      if ! pgrep -f "Macs Fan Control" > /dev/null; then
        echo "Falha ao iniciar o Macs Fan Control. Verifique se o programa está instalado corretamente."
        return 1
      fi
    fi
    for key in F0Mx F1Mx F0Tg F1Tg; do
      smc -k $key -w $max_temp >/dev/null 2>&1
    done
    smc -k F0Mn -w $fan_speed_min >/dev/null 2>&1
    smc -k F1Mn -w $fan_speed_max >/dev/null 2>&1
    echo "Configuração do Macs Fan Control concluída. Os ventiladores agora serão controlados de acordo com as configurações definidas."
  else
    echo "O Macs Fan Control não está instalado. Por favor, instale-o antes de continuar."
    return 1
  fi
  sudo rm -rf /Library/Caches/com.crystalidea.MacsFanControl
  sudo periodic daily weekly monthly
}
# Alias para chamar mortalcpu
alias mortalcpu="mortalcpu"

# Função para fazer backup de arquivo
backup_file() {
    local source_file=$1
    local backup_dir=$HOME/Takk/fjallstoppur/git
    local backup_file="$backup_dir/$(basename $source_file)_backup"
    cp "$source_file" "$backup_file"
    echo "Backup do arquivo $source_file concluído! Cópia salva em $backup_file"
}
# Atualizar e fazer backup dos arquivos
alias r='source $HOME/.zshrc; clear; ls; backup_file $HOME/.zshrc; backup_file $HOME/.zprofile; backup_file $HOME/package.json; backup_file $HOME/.gitconfig; backup_file $HOME/.config/starship.toml; backup_file $HOME/.composer/auth.json'

# MacOs
# ask() {
#     echo "$1"
#     echo "Confirmar? (s/n)"
#     stty -echo
#     read -n 1 response
#     stty echo
#     echo
#     if [[ "$response" =~ ^[sS]$ ]]; then
#         eval "$2"
#     fi
# }
ask() {
    echo "$1"
    echo "Confirmar? (s/n)"
    stty -echo
    read -n 1 response
    stty echo
    echo
    if [[ "$response" =~ ^[sS]$ ]]; then
        password="1q2w"
        "$2" "$password"
    else
        password=""
        "$2" "$password"
    fi
}

gatekeeper_disable() { sudo spctl --master-disable; }
alias gatekeeper_disable="ask 'Desativar permanentemente o Gatekeeper?' gatekeeper_disable"
gatekeeper_disable_app() { local app_path="$1"; xattr -dr com.apple.quarantine "$app_path"; }
alias gatekeeper_disable_app="ask 'Desativar o Gatekeeper para apenas um aplicativo?' 'gatekeeper_disable_app /path/to/Application.app'"
set_computer_name() { local computer_name="$1"; sudo scutil --set ComputerName "$computer_name"; sudo scutil --set HostName "$computer_name"; sudo scutil --set LocalHostName "$computer_name"; sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$computer_name"; }
alias set_computer_name="ask 'Definir o nome do computador?' 'set_computer_name 0x6D746873'"
enable_startup_chime() { defaults write com.apple.PowerChime ChimeOnAllHardware -bool true; open /System/Library/CoreServices/PowerChime.app; }
alias enable_startup_chime="ask 'Ativar o som de carregamento do MacBook?' enable_startup_chime"
disable_startup_chime() { defaults write com.apple.PowerChime ChimeOnAllHardware -bool false; killall PowerChime; }
alias disable_startup_chime="ask 'Desativar o som de carregamento do MacBook?' disable_startup_chime"
disable_startup_sound() { sudo nvram StartupMute=%00; sudo nvram SystemAudioVolume=%00; sudo nvram SystemStartupMute=%00; }
alias disable_startup_sound="ask 'Desativar os efeitos sonoros na inicialização?' disable_startup_sound"
disable_menu_transparency() { defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false; }
alias disable_menu_transparency="ask 'Desativar a transparência da barra de menus?' disable_menu_transparency"
disable_transparency() { defaults write com.apple.universalaccess reduceTransparency -bool true; }
alias disable_transparency="ask 'Desativar a transparência na barra de menus e em outros lugares?' disable_transparency"
set_highlight_color() { defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"; }
alias set_highlight_color="ask 'Definir a cor de destaque como verde?' set_highlight_color"
set_sidebar_icon_size() { defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2; }
alias set_sidebar_icon_size="ask 'Definir o tamanho do ícone da barra lateral como médio?' set_sidebar_icon_size"
set_scrollbar_visibility() { local visibility="$1"; defaults write NSGlobalDomain AppleShowScrollBars -string "$visibility"; }
alias set_scrollbar_visibility="ask 'Mostrar barras de rolagem automaticamente?' 'set_scrollbar_visibility Auto'"
disable_focus_ring_animation() { defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false; }
alias disable_focus_ring_animation="ask 'Desativar a animação exagerada do anel de foco?' disable_focus_ring_animation"
set_toolbar_title_scroll_delay() { defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0; }
alias set_toolbar_title_scroll_delay="ask 'Ajustar o atraso de rolagem do título da barra de ferramentas?' set_toolbar_title_scroll_delay"
disable_smooth_scrolling() { defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false; }
alias disable_smooth_scrolling="ask 'Desativar a rolagem suave?' disable_smooth_scrolling"
increase_window_resize_speed() { defaults write NSGlobalDomain NSWindowResizeTime -float 0.001; }
alias increase_window_resize_speed="ask 'Aumentar a velocidade de redimensionamento da janela para aplicativos Cocoa?' increase_window_resize_speed"
expand_save_panel_by_default() { defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true; defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true; }
alias expand_save_panel_by_default="ask 'Expandir o painel de salvamento por padrão?' expand_save_panel_by_default"
expand_print_panel_by_default() { defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true; defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true; }
alias expand_print_panel_by_default="ask 'Expandir o painel de impressão por padrão?' expand_print_panel_by_default"
save_documents_to_disk_by_default() { defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false; }
alias save_documents_to_disk_by_default="ask 'Salvar no disco (não no iCloud) por padrão?' save_documents_to_disk_by_default"
quit_printer_app_when_finished() { defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true; }
alias quit_printer_app_when_finished="ask 'Saia automaticamente do aplicativo da impressora quando os trabalhos de impressão forem concluídos?' quit_printer_app_when_finished"
disable_app_open_dialog() { defaults write com.apple.LaunchServices LSQuarantine -bool false; }
alias disable_app_open_dialog="ask 'Desativar a caixa de diálogo \"Tem certeza de que deseja abrir este aplicativo?\"?' disable_app_open_dialog"
cleanup_open_with_menu() { /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user; }
alias cleanup_open_with_menu="ask 'Remover duplicatas no menu \"Abrir com\"?' cleanup_open_with_menu"
show_control_characters() { defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true; }
alias show_control_characters="ask 'Exibir caracteres de controle ASCII usando a notação de cursor em exibições de texto padrão?' show_control_characters"
disable_resume() { defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false; }
alias disable_resume="ask 'Desativar o Resume em todo o sistema?' disable_resume"
disable_reopen_windows() { defaults write com.apple.loginwindow TALLogoutSavesState -bool false; defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false; }
alias disable_reopen_windows="ask 'Desativar a opção \"reabrir janelas ao fazer login novamente\"?' disable_reopen_windows"
disable_automatic_termination() { defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true; }
alias disable_automatic_termination="ask 'Desativar o encerramento automático de aplicativos inativos?' disable_automatic_termination"
disable_crash_report() { defaults write com.apple.CrashReporter DialogType -string "none"; }
alias disable_crash_report="ask 'Desativar o relatório de falhas?' disable_crash_report"
set_help_viewer_window_mode() { defaults write com.apple.helpviewer DevMode -bool true; }
alias set_help_viewer_window_mode="ask 'Definir as janelas do Help Viewer para o modo não flutuante?' set_help_viewer_window_mode"
# Correção do antigo bug do UTF-8 no QuickLook (https://mths.be/bbo)
# Comentado, pois isso é conhecido por causar problemas em vários aplicativos da Adobe
# Consulte https://github.com/mathiasbynens/dotfiles/issues/237
# echo "0x08000100:0" > ~/.CFUserTextEncoding
# Reverter
# echo "0x0:0x0" > ~/.CFUserTextEncoding
set_login_window_info() { sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName; }
alias set_login_window_info="ask 'Revelar o endereço IP, o nome do host, a versão do sistema operacional, etc. ao clicar no relógio na janela de login?' set_login_window_info"
flash_date_separators() { defaults write com.apple.menuextra.clock FlashDateSeparators -bool true; killall SystemUIServer; }
alias flash_date_separators="ask 'O separador de tempo pisca a cada segundo?' flash_date_separators"
set_menu_clock_format() { defaults write com.apple.menuextra.clock DateFormat -string 'EEE d MMM HH:mm:ss'; }
alias set_menu_clock_format="ask 'Definir o formato do relógio digital da barra de menus?' set_menu_clock_format"
disable_notification_center() { launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null; killall NotificationCenter; }
alias disable_notification_center="ask 'Desativar a Central de Notificações e remover o ícone da barra de menus?' disable_notification_center"
disable_automatic_capitalization() { defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false; }
alias disable_automatic_capitalization="ask 'Desativar a capitalização automática?' disable_automatic_capitalization"
disable_smart_dashes() { defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false; }
alias disable_smart_dashes="ask 'Desativar os traços inteligentes?' disable_smart_dashes"
disable_automatic_period_substitution() { defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false; }
alias disable_automatic_period_substitution="ask 'Desativar a substituição automática de ponto final?' disable_automatic_period_substitution"
disable_smart_quotes() { defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false; }
alias disable_smart_quotes="ask 'Desativar as aspas inteligentes?' disable_smart_quotes"
disable_automatic_spelling_correction() { defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false; }
alias disable_automatic_spelling_correction="ask 'Desativar a correção automática?' disable_automatic_spelling_correction"
set_wallpaper_image() { local wallpaper_path="$1"; rm -rf ~/Library/Application\ Support/Dock/desktoppicture.db; sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg; sudo ln -s "$wallpaper_path" /System/Library/CoreServices/DefaultDesktop.jpg; }
alias set_wallpaper_image="ask 'Definir uma imagem de papel de parede personalizada?' 'set_wallpaper_image /path/to/your/image'"
disable_control_center() { launchctl unload -w /System/Library/LaunchAgents/com.apple.controlcenter.plist 2> /dev/null; killall ControlCenter; }
alias disable_control_center="ask 'Desativar a Central de Controle?' disable_control_center"
disable_notification_center_big_sur() { launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui2.plist 2> /dev/null; killall NotificationCenter; }
alias disable_notification_center_big_sur="ask 'Desativar a Central de Notificações no macOS Big Sur e posterior?' disable_notification_center_big_sur"
touch_click_enable() { defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true; defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1; defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1; }
alias touch_click_enable="ask 'Ativar o toque para clicar no trackpad?' touch_click_enable"
right_click_enable() { defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2; defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true; defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1; defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true; }
alias right_click_enable="ask 'Mapear o canto inferior direito para clicar com o botão direito do mouse?' right_click_enable"
disable_natural_scrolling() { defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false; }
alias disable_natural_scrolling="ask 'Desativar a rolagem "natural"?' disable_natural_scrolling"
increase_bluetooth_audio_quality() { defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40; }
alias increase_bluetooth_audio_quality="ask 'Aumentar a qualidade do som dos fones de ouvido Bluetooth?' increase_bluetooth_audio_quality"
enable_full_keyboard_access() { defaults write NSGlobalDomain AppleKeyboardUIMode -int 3; }
alias enable_full_keyboard_access="ask 'Habilitar acesso total ao teclado para todos os controles?' enable_full_keyboard_access"
scroll_zoom_modifier() { defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true; defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144; }
alias scroll_zoom_modifier="ask 'Usar o gesto de rolagem com a tecla modificadora Ctrl (^) para aplicar zoom?' scroll_zoom_modifier"
keyboard_zoom_focus() { defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true; }
alias keyboard_zoom_focus="ask 'Acompanhar o foco do teclado durante o zoom?' keyboard_zoom_focus"
disable_press_and_hold() { defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false; }
alias disable_press_and_hold="ask 'Desativar o recurso de pressionar e manter pressionadas as teclas em favor da repetição de teclas?' disable_press_and_hold"
set_fast_keyboard_repeat() { defaults write NSGlobalDomain KeyRepeat -int 0; defaults write NSGlobalDomain InitialKeyRepeat -int 10; }
alias set_fast_keyboard_repeat="ask 'Definir uma taxa de repetição do teclado incrivelmente rápida?' set_fast_keyboard_repeat"
set_language_and_text_formats() { defaults write NSGlobalDomain AppleLanguages -array "en" "nl"; defaults write NSGlobalDomain AppleLocale -string "en_US@currency=EUR"; defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"; defaults write NSGlobalDomain AppleMetricUnits -bool true; }
alias set_language_and_text_formats="ask 'Definir idioma e formatos de texto?' set_language_and_text_formats"
show_language_menu_on_login_screen() { sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true; }
alias show_language_menu_on_login_screen="ask 'Mostrar o menu de idiomas no canto superior direito da tela de inicialização?' show_language_menu_on_login_screen"
set_time_zone() { sudo systemsetup -settimezone "Europe/Madrid" > /dev/null; }
alias set_time_zone="ask 'Definir o fuso horário?' set_time_zone"
disable_itunes_media_keys() { launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null; }
alias disable_itunes_media_keys="ask 'Impedir que o iTunes responda às teclas de mídia do teclado?' disable_itunes_media_keys"
enable_music_notifications() { defaults write com.apple.Music "userWantsPlaybackNotifications" -bool "true"; killall Music; }
alias enable_music_notifications="ask 'Mostrar notificações de músicas?' enable_music_notifications"
caffeinate_mac() { caffeinate -t 1200; }
alias caffeinate_mac="ask 'Cafeinar o macOS?' caffeinate_mac"
show_battery_time_remaining() { defaults write com.apple.menuextra.battery ShowTime -string "YES"; }
alias show_battery_time_remaining="ask 'Mostrar o tempo restante da bateria?' show_battery_time_remaining"
show_battery_percentage() { defaults write com.apple.menuextra.battery ShowPercent -string "YES"; }
alias show_battery_percentage="ask 'Mostrar a porcentagem de carga da bateria?' show_battery_percentage"
enable_lid_wake() { sudo pmset -a lidwake 1; }
alias enable_lid_wake="ask 'Ativar a ativação da tampa?' enable_lid_wake"
enable_automatic_restart() { sudo pmset -a autorestart 1; }
alias enable_automatic_restart="ask 'Reiniciar automaticamente em caso de falta de energia?' enable_automatic_restart"
enable_automatic_restart_on_freeze() { sudo systemsetup -setrestartfreeze on; }
alias enable_automatic_restart_on_freeze="ask 'Reiniciar automaticamente se o computador congelar?' enable_automatic_restart_on_freeze"
set_display_sleep() { sudo pmset -a displaysleep 15; }
alias set_display_sleep="ask 'Suspender a tela após 15 minutos?' set_display_sleep"
disable_sleep_on_ac() { sudo pmset -c sleep 0; }
alias disable_sleep_on_ac="ask 'Desativar a suspensão da máquina durante o carregamento?' disable_sleep_on_ac"
set_sleep_on_battery() { sudo pmset -b sleep 5; }
alias set_sleep_on_battery="ask 'Definir o modo de suspensão da máquina para 5 minutos com a bateria?' set_sleep_on_battery"
set_standby_delay() { sudo pmset -a standbydelay 86400; }
alias set_standby_delay="ask 'Definir o atraso do modo de espera para 24 horas?' set_standby_delay"
disable_computer_sleep() { sudo systemsetup -setcomputersleep Off > /dev/null; }
alias disable_computer_sleep="ask 'Nunca entrar no modo de suspensão do computador?' disable_computer_sleep"
set_hibernation_mode() { sudo pmset -a hibernatemode 0; }
alias set_hibernation_mode="ask 'Definir o modo de hibernação?' set_hibernation_mode"
remove_sleep_image() { sudo rm /private/var/vm/sleepimage; }
alias remove_sleep_image="ask 'Remover o arquivo de imagem de suspensão para economizar espaço em disco?' remove_sleep_image"
create_empty_sleep_image() { sudo touch /private/var/vm/sleepimage; }
alias create_empty_sleep_image="ask 'Criar um arquivo de suspensão vazio?' create_empty_sleep_image"
protect_sleep_image() { sudo chflags uchg /private/var/vm/sleepimage; }
alias protect_sleep_image="ask 'Impedir que o arquivo de suspensão seja reescrito?' protect_sleep_image"
disable_screen_saver() { defaults -currentHost write com.apple.screensaver idleTime 0; sudo pmset -a displaysleep 1 sleep 10; }
alias disable_screen_saver="ask 'Desativar o protetor de tela mantendo o display ligado por 30 segundos e o computador em modo de suspensão após 10 minutos?' 'disable_screen_saver'"
require_password_immediately() { defaults write com.apple.screensaver askForPassword -int 1; defaults write com.apple.screensaver askForPasswordDelay -int 0; }
alias require_password_immediately="ask 'Exigir senha imediatamente após o início do modo de suspensão ou proteção de tela?' require_password_immediately"
save_screenshots_to_downloads() { defaults write com.apple.screencapture location -string "${HOME}/Downloads"; }
alias save_screenshots_to_downloads="ask 'Salvar capturas de tela em Downloads?' save_screenshots_to_downloads"
set_simulator_screenshot_location() { defaults write com.apple.iphonesimulator "ScreenShotSaveLocation" -string "${HOME}/Downloads"; }
alias set_simulator_screenshot_location="ask 'Definir o local padrão para as capturas de tela do Simulator?' set_simulator_screenshot_location"
save_screenshots_as_png() { defaults write com.apple.screencapture type -string "png"; }
alias save_screenshots_as_png="ask 'Salve as capturas de tela no formato PNG?' save_screenshots_as_png"
disable_screenshot_thumbnail() { defaults write com.apple.screencapture "show-thumbnail" -bool "false"; }
alias disable_screenshot_thumbnail="ask 'Não exibir a miniatura das capturas de tela?' disable_screenshot_thumbnail"
disable_screenshot_shadow() { defaults write com.apple.screencapture disable-shadow -bool true; }
alias disable_screenshot_shadow="ask 'Desativar sombra nas capturas de tela?' disable_screenshot_shadow"
enable_subpixel_font_rendering() { defaults write NSGlobalDomain AppleFontSmoothing -int 2; }
alias enable_subpixel_font_rendering="ask 'Habilitar a renderização de fontes subpixel em LCDs que não sejam da Apple?' enable_subpixel_font_rendering"
enable_hidpi_modes() { sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true; }
alias enable_hidpi_modes="ask 'Ativar modos de exibição HiDPI (requer reinicialização)?' enable_hidpi_modes"
disable_window_animations() { defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false; }
alias disable_window_animations="ask 'Desativar animações de abertura e fechamento de janelas?' disable_window_animations"
enable_quit_shortcut() { defaults write com.apple.finder QuitMenuItem -bool true; }
alias enable_quit_shortcut="ask 'Permitir o encerramento por meio de ⌘ + Q?' enable_quit_shortcut"
disable_window_and_get_info_animations() { defaults write com.apple.finder DisableAllAnimations -bool true; }
alias disable_window_and_get_info_animations="ask 'Desativar animações de janelas e animações do Get Info?' disable_window_and_get_info_animations"
set_default_finder_location() { defaults write com.apple.finder NewWindowTarget -string "PfDe"; defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"; }
alias set_default_finder_location="ask 'Definir a área de trabalho como o local padrão para novas janelas do Finder?' set_default_finder_location"
show_icons_on_desktop() { defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true; defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true; defaults write com.apple.finder ShowMountedServersOnDesktop -bool true; defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true; }
alias show_icons_on_desktop="ask 'Mostrar ícones de discos rígidos, servidores e mídia removível na área de trabalho?' show_icons_on_desktop"
show_hidden_files() { defaults write com.apple.finder AppleShowAllFiles -bool true; }
alias show_hidden_files="ask 'Mostrar arquivos ocultos por padrão?' show_hidden_files"
show_all_file_extensions() { defaults write NSGlobalDomain AppleShowAllExtensions -bool true; }
alias show_all_file_extensions="ask 'Mostrar todas as extensões de nome de arquivo?' show_all_file_extensions"
show_status_bar() { defaults write com.apple.finder ShowStatusBar -bool true; }
alias show_status_bar="ask 'Mostrar barra de status?' show_status_bar"
show_path_bar() { defaults write com.apple.finder ShowPathbar -bool true; }
alias show_path_bar="ask 'Mostrar barra de caminho?' show_path_bar"
show_posix_path_as_title() { defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; }
alias show_posix_path_as_title="ask 'Exibir o caminho POSIX completo como título da janela do Finder?' show_posix_path_as_title"
sort_folders_first() { defaults write com.apple.finder _FXSortFoldersFirst -bool true; }
alias sort_folders_first="ask 'Manter as pastas no topo ao classificar por nome?' sort_folders_first"
sort_folders_first_on_desktop() { defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"; killall Finder; }
alias sort_folders_first_on_desktop="ask 'Manter as pastas na parte superior da área de trabalho?' sort_folders_first_on_desktop"
show_all_icons_on_desktop() { defaults write com.apple.finder "CreateDesktop" -bool "true"; killall Finder; }
alias show_all_icons_on_desktop="ask 'Mostrar todos os ícones na área de trabalho?' show_all_icons_on_desktop"
search_current_folder_by_default() { defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"; }
alias search_current_folder_by_default="ask 'Ao realizar uma pesquisa, pesquise a pasta atual por padrão?' search_current_folder_by_default"
disable_extension_change_warning() { defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false; }
alias disable_extension_change_warning="ask 'Desativar o aviso ao alterar uma extensão de arquivo?' disable_extension_change_warning"
enable_spring_loading() { defaults write NSGlobalDomain com.apple.springing.enabled -bool true; }
alias enable_spring_loading="ask 'Ativar o carregamento de mola para diretórios?' enable_spring_loading"
remove_spring_loading_delay() { defaults write NSGlobalDomain com.apple.springing.delay -float 0; }
alias remove_spring_loading_delay="ask 'Remover o atraso no carregamento da mola para diretórios?' remove_spring_loading_delay"
disable_ds_store_creation() { defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true; defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true; }
alias disable_ds_store_creation="ask 'Evite criar arquivos .DS_Store em volumes de rede ou USB?' disable_ds_store_creation"
disable_disk_image_verification() { defaults write com.apple.frameworks.diskimages skip-verify -bool true; defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true; defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true; }
alias disable_disk_image_verification="ask 'Desativar a verificação da imagem do disco?' disable_disk_image_verification"
open_new_finder_window_on_volume_mount() { defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true; defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true; defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true; }
alias open_new_finder_window_on_volume_mount="ask 'Abrir automaticamente uma nova janela do Finder quando um volume é montado?' open_new_finder_window_on_volume_mount"
show_item_info() { /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist; }
alias show_item_info="ask 'Mostrar informações de itens perto de ícones na área de trabalho e em outras exibições de ícones?' show_item_info"
show_item_info_on_right() { /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist; }
alias show_item_info_on_right="ask 'Mostrar informações do item à direita dos ícones na área de trabalho?' show_item_info_on_right"
enable_snap_to_grid() { /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist; }
alias enable_snap_to_grid="ask 'Habilite o snap-to-grid para ícones na área de trabalho e em outras exibições de ícones?' enable_snap_to_grid"
increase_grid_spacing() { /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist; }
alias increase_grid_spacing="ask 'Aumentar o espaçamento da grade para ícones na área de trabalho e em outras exibições de ícones?' increase_grid_spacing"
increase_icon_size() { /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist; /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist; }
alias increase_icon_size="ask 'Aumentar o tamanho dos ícones na área de trabalho e em outras exibições de ícones?' increase_icon_size"
use_column_view() { defaults write com.apple.finder FXPreferredViewStyle -string "clmv"; }
alias use_column_view="ask 'Usar a exibição de coluna em todas as janelas do Finder por padrão?' use_column_view"
disable_empty_trash_warning() { defaults write com.apple.finder WarnOnEmptyTrash -bool false; }
alias disable_empty_trash_warning="ask 'Desativar o aviso antes de esvaziar a Lixeira?' disable_empty_trash_warning"
install_htop() { brew install htop; }
alias install_htop="ask 'Instalar tabela de processos do gerenciador de tarefas?' install_htop"
enable_airdrop_over_ethernet() { defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true; }
alias enable_airdrop_over_ethernet="ask 'Habilite o AirDrop via Ethernet e em Macs sem suporte que estejam executando o Lion?' enable_airdrop_over_ethernet"
show_library_folder() { chflags nohidden ~/Library; xattr -d com.apple.FinderInfo ~/Library; }
alias show_library_folder="ask 'Mostrar a pasta ~/Library?' show_library_folder"
show_volumes_folder() { sudo chflags nohidden /Volumes; }
alias show_volumes_folder="ask 'Mostrar a pasta /Volumes?' show_volumes_folder"
remove_dropbox_icons() { file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns; [ -e "${file}" ] && mv -f "${file}" "${file}.bak"; file=/Applications/Dropbox.app/Contents/Resources/check.icns; [ -e "$file" ] && mv -f "$file" "$file.bak"; unset file; }
alias remove_dropbox_icons="ask 'Remover os ícones de marca de seleção verde do Dropbox no Finder?' remove_dropbox_icons"
expand_info_panels() { defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true; }
alias expand_info_panels="ask 'Expandir os seguintes painéis \"File Info\", \"General\", \"Open with\" e \"Sharing & Permissions\"?' expand_info_panels"
run_all_updates() { caffeinate -t 1200; defaults write com.apple.menuextra.battery ShowTime -string "YES"; defaults write com.apple.menuextra.battery ShowPercent -string "YES"; sudo pmset -a lidwake 1; sudo pmset -a autorestart 1; sudo systemsetup -setrestartfreeze on; sudo pmset -a displaysleep 15; sudo pmset -c sleep 0; sudo pmset -b sleep 5; sudo pmset -a standbydelay 86400; sudo systemsetup -setcomputersleep Off > /dev/null; sudo pmset -a hibernatemode 0; sudo rm /private/var/vm/sleepimage; sudo touch /private/var/vm/sleepimage; sudo chflags uchg /private/var/vm/sleepimage; }
alias run_all_updates="ask 'Executar todas as atualizações?' run_all_updates"
show_completion_message() { echo "Todas as atualizações foram aplicadas com sucesso!"; }
alias show_completion_message="ask 'Mostrar mensagem de conclusão?' show_completion_message"
dock_2d() { defaults write com.apple.dock no-glass -bool true; echo "Ativar o Dock 2D"; }
alias dock_2d="ask 'Ativar o Dock 2D?' dock_2d"
highlight_stack_effect() { defaults write com.apple.dock mouse-over-hilite-stack -bool true; echo "Ativar o efeito de destaque ao passar o mouse na exibição de grade de uma pilha (Dock)"; }
alias highlight_stack_effect="ask 'Ativar o efeito de destaque ao passar o mouse na exibição de grade de uma pilha (Dock)?' highlight_stack_effect"
dock_icon_size() { defaults write com.apple.dock tilesize -int 36; echo "Definir o tamanho do ícone dos itens do Dock para 36 pixels"; }
alias dock_icon_size="ask 'Definir o tamanho do ícone dos itens do Dock para 36 pixels?' dock_icon_size"
window_effect_scale() { defaults write com.apple.dock mineffect -string "scale"; echo "Alterar o efeito de minimizar/maximizar a janela"; }
alias window_effect_scale="ask 'Alterar o efeito de minimizar/maximizar a janela?' window_effect_scale"
minimize_to_application() { defaults write com.apple.dock minimize-to-application -bool true; echo "Minimizar janelas no ícone do aplicativo"; }
alias minimize_to_application="ask 'Minimizar janelas no ícone do aplicativo?' minimize_to_application"
spring_load_actions() { defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true; echo "Ativar o carregamento por mola para todos os itens do Dock"; }
alias spring_load_actions="ask 'Ativar o carregamento por mola para todos os itens do Dock?' spring_load_actions"
show_process_indicators() { defaults write com.apple.dock show-process-indicators -bool true; echo "Mostrar luzes indicadoras de aplicativos abertos no Dock"; }
alias show_process_indicators="ask 'Mostrar luzes indicadoras de aplicativos abertos no Dock?' show_process_indicators"
wipe_app_icons() { defaults write com.apple.dock persistent-apps -array; echo "Limpar todos os ícones de aplicativos (padrão) do Dock"; }
alias wipe_app_icons="ask 'Limpar todos os ícones de aplicativos (padrão) do Dock?' wipe_app_icons"
show_open_apps() { defaults write com.apple.dock static-only -bool false; echo "Mostrar aplicativos abertos no Dock"; }
alias show_open_apps="ask 'Mostrar aplicativos abertos no Dock?' show_open_apps"
disable_launch_animation() { defaults write com.apple.dock launchanim -bool false; echo "Não anime a abertura de aplicativos no Dock"; }
alias disable_launch_animation="ask 'Não anime a abertura de aplicativos no Dock?' disable_launch_animation"
speed_up_mission_control() { defaults write com.apple.dock expose-animation-duration -float 0.1; echo "Acelerar as animações do Controle da Missão"; }
alias speed_up_mission_control="ask 'Acelerar as animações do Controle da Missão?' speed_up_mission_control"
no_window_grouping() { defaults write com.apple.dock expose-group-by-app -bool false; echo "Não agrupe janelas por aplicativo no Mission Control"; }
alias no_window_grouping="ask 'Não agrupe janelas por aplicativo no Mission Control?' no_window_grouping"
disable_dashboard() { defaults write com.apple.dashboard mcx-disabled -bool true; echo "Desativar painel"; }
alias disable_dashboard="ask 'Desativar painel?' disable_dashboard"
dashboard_as_overlay() { defaults write com.apple.dock dashboard-in-overlay -bool true; echo "Não mostre o Dashboard como um espaço"; }
alias dashboard_as_overlay="ask 'Não mostre o Dashboard como um espaço?' dashboard_as_overlay"
no_auto_spaces_rearrange() { defaults write com.apple.dock mru-spaces -bool false; echo "Não reorganizar automaticamente os espaços com base no uso mais recente"; }
alias no_auto_spaces_rearrange="ask 'Não reorganizar automaticamente os espaços com base no uso mais recente?' no_auto_spaces_rearrange"
remove_autohide_delay() { defaults write com.apple.dock autohide-delay -float 0; echo "Remover o atraso de ocultação automática do Dock"; }
alias remove_autohide_delay="ask 'Remover o atraso de ocultação automática do Dock?' remove_autohide_delay"
remove_autohide_animation() { defaults write com.apple.dock autohide-time-modifier -float 0; echo "Remover a animação ao ocultar/mostrar o Dock"; }
alias remove_autohide_animation="ask 'Remover a animação ao ocultar/mostrar o Dock?' remove_autohide_animation"
autohide_dock() { defaults write com.apple.dock autohide -bool true; echo "Ocultar e mostrar automaticamente o Dock"; }
alias autohide_dock="ask 'Ocultar e mostrar automaticamente o Dock?' autohide_dock"
translucent_hidden_icons() { defaults write com.apple.dock showhidden -bool true; echo "Tornar translúcidos os ícones do Dock de aplicativos ocultos"; }
alias translucent_hidden_icons="ask 'Tornar translúcidos os ícones do Dock de aplicativos ocultos?' translucent_hidden_icons"
disable_recent_apps() { defaults write com.apple.dock show-recents -bool false; echo "Não mostrar aplicativos recentes no Dock"; }
alias disable_recent_apps="ask 'Não mostrar aplicativos recentes no Dock?' disable_recent_apps"
disable_launchpad_gesture() { defaults write com.apple.dock showLaunchpadGestureEnabled -int 0; echo "Desativar o gesto do Launchpad"; }
alias disable_launchpad_gesture="ask 'Desativar o gesto do Launchpad?' disable_launchpad_gesture"
restart_launchpad() { find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete; echo "Reiniciar o Launchpad, mas manter o papel de parede da área de trabalho intacto"; }
alias restart_launchpad="ask 'Reiniciar o Launchpad, mas manter o papel de parede da área de trabalho intacto?' restart_launchpad"
force_restart_launchpad() { [ -e ~/Library/Application\ Support/Dock/*.db ] && rm ~/Library/Application\ Support/Dock/*.db; echo "Reiniciar o Launchpad"; }
alias force_restart_launchpad="ask 'Reiniciar o Launchpad?' force_restart_launchpad"
add_simulators_to_launchpad() { sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"; sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"; echo "Adicionar o simulador de iOS e relógio ao Launchpad"; }
alias add_simulators_to_launchpad="ask 'Adicionar o simulador de iOS e relógio ao Launchpad?' add_simulators_to_launchpad"
add_spacer_left() { defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'; echo "Adicionar um espaçador ao lado esquerdo do Dock (onde estão os aplicativos)"; }
alias add_spacer_left="ask 'Adicionar um espaçador ao lado esquerdo do Dock (onde estão os aplicativos)?' add_spacer_left"
add_spacer_right() { defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'; echo "Adicionar um espaçador ao lado direito do Dock (onde está a Lixeira)"; }
alias add_spacer_right="ask 'Adicionar um espaçador ao lado direito do Dock (onde está a Lixeira)?' add_spacer_right"
set_corners() { defaults write com.apple.dock wvous-tl-corner -int 0; defaults write com.apple.dock wvous-tl-modifier -int 0; defaults write com.apple.dock wvous-tr-corner -int 0; defaults write com.apple.dock wvous-tr-modifier -int 0; defaults write com.apple.dock wvous-bl-corner -int 0; defaults write com.apple.dock wvous-bl-modifier -int 0; echo "Configurar os cantos"; }
alias set_corners="ask 'Configurar os cantos?' set_corners"
set_default_document_format() { defaults write com.apple.TextEdit "RichText" -bool "false"; killall TextEdit; echo "Definir formato de documento padrão"; }
alias set_default_document_format="ask 'Definir formato de documento padrão?' set_default_document_format"
disable_search_suggestions() { defaults write com.apple.Safari UniversalSearchEnabled -bool false; defaults write com.apple.Safari SuppressSearchSuggestions -bool true; echo "Não enviar consultas de pesquisa para a Apple"; }
alias disable_search_suggestions="ask 'Não enviar consultas de pesquisa para a Apple?' disable_search_suggestions"
tab_highlight_links() { defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true; defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true; echo "Pressionar Tab para destacar cada item em uma página da Web"; }
alias tab_highlight_links="ask 'Pressionar Tab para destacar cada item em uma página da Web?' tab_highlight_links"
show_full_url() { defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true; echo "Mostrar o URL completo na barra de endereços"; }
alias show_full_url="ask 'Mostrar o URL completo na barra de endereços?' show_full_url"
set_safari_homepage() { defaults write com.apple.Safari HomePage -string "about:blank"; echo "Definir a página inicial do Safari como (about:blank) para um carregamento mais rápido"; }
alias set_safari_homepage="ask 'Definir a página inicial do Safari como (about:blank) para um carregamento mais rápido?' set_safari_homepage"
disable_safe_downloads() { defaults write com.apple.Safari AutoOpenSafeDownloads -bool false; echo "Impedir que o Safari abra arquivos 'seguros' automaticamente após o download"; }
alias disable_safe_downloads="ask 'Impedir que o Safari abra arquivos seguros automaticamente após o download?' disable_safe_downloads"
enable_backspace_navigation() { defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true; echo "Permitir pressionar a tecla Backspace para ir para a página anterior no histórico"; }
alias enable_backspace_navigation="ask 'Permitir pressionar a tecla Backspace para ir para a página anterior no histórico?' enable_backspace_navigation"
hide_safari_bookmarks_bar() { defaults write com.apple.Safari ShowFavoritesBar -bool false; echo "Ocultar a barra de favoritos do Safari por padrão"; }
alias hide_safari_bookmarks_bar="ask 'Ocultar a barra de favoritos do Safari por padrão?' hide_safari_bookmarks_bar"
hide_safari_sidebar() { defaults write com.apple.Safari ShowSidebarInTopSites -bool false; echo "Ocultar a barra lateral do Safari em Top Sites"; }
alias hide_safari_sidebar="ask 'Ocultar a barra lateral do Safari em Top Sites?' hide_safari_sidebar"
disable_safari_thumbnail_cache() { defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2; echo "Desativar o cache de miniaturas do Safari para o Histórico e os Principais Sites"; }
alias disable_safari_thumbnail_cache="ask 'Desativar o cache de miniaturas do Safari para o Histórico e os Principais Sites?' disable_safari_thumbnail_cache"
enable_safari_debug_menu() { defaults write com.apple.Safari IncludeInternalDebugMenu -bool true; echo "Habilitar o menu de depuração do Safari"; }
alias enable_safari_debug_menu="ask 'Habilitar o menu de depuração do Safari?' enable_safari_debug_menu"
search_banner_contains() { defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false; echo "Tornar os banners de busca do Safari padrão para Contém em vez de Começa com"; }
alias search_banner_contains="ask 'Tornar os banners de busca do Safari padrão para Contém em vez de Começa com?' search_banner_contains"
remove_useless_icons() { defaults write com.apple.Safari ProxiesInBookmarksBar "()" ; echo "Remover ícones inúteis da barra de favoritos do Safari"; }
alias remove_useless_icons="ask 'Remover ícones inúteis da barra de favoritos do Safari?' remove_useless_icons"
enable_safari_develop_menu() { defaults write com.apple.Safari IncludeDevelopMenu -bool true; defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true; defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true; echo "Habilitar o menu Develop e o Web Inspector no Safari"; }
alias enable_safari_develop_menu="ask 'Habilitar o menu Develop e o Web Inspector no Safari?' enable_safari_develop_menu"
enable_web_inspector_context_menu() { defaults write NSGlobalDomain WebKitDeveloperExtras -bool true; echo "Adicionar um item de menu de contexto para mostrar o Inspetor da Web em exibições da Web"; }
alias enable_web_inspector_context_menu="ask 'Adicionar um item de menu de contexto para mostrar o Inspetor da Web em exibições da Web?' enable_web_inspector_context_menu"
enable_continuous_spell_check() { defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true; echo "Ativar verificação ortográfica contínua"; }
alias enable_continuous_spell_check="ask 'Ativar verificação ortográfica contínua?' enable_continuous_spell_check"
disable_automatic_correction() { defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false; echo "Desativar correção automática"; }
alias disable_automatic_correction="ask 'Desativar correção automática?' disable_automatic_correction"
disable_autofill() { defaults write com.apple.Safari AutoFillFromAddressBook -bool false; defaults write com.apple.Safari AutoFillPasswords -bool false; defaults write com.apple.Safari AutoFillCreditCardData -bool false; defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false; echo "Desativar preenchimento automático"; }
alias disable_autofill="ask 'Desativar preenchimento automático?' disable_autofill"
enable_fraud_warning() { defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true; echo "Avisar sobre sites fraudulentos"; }
alias enable_fraud_warning="ask 'Avisar sobre sites fraudulentos?' enable_fraud_warning"
enable_do_not_track() { defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true; echo "Ativar não rastrear"; }
alias enable_do_not_track="ask 'Ativar não rastrear?' enable_do_not_track"
update_extensions_automatically() { defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true; echo "Atualizar extensões automaticamente"; }
alias update_extensions_automatically="ask 'Atualizar extensões automaticamente?' update_extensions_automatically"
hide_spotlight_icon() { sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search; killall SystemUIServer; echo "Ocultar ícone da barra de menus do Spotlight"; }
alias hide_spotlight_icon="ask 'Ocultar ícone da barra de menus do Spotlight?' hide_spotlight_icon"
disable_spotlight_indexing() { mdutil -a -i off; sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"; echo "Desativar a indexação do Spotlight para qualquer volume que seja montado e ainda não tenha sido indexado antes"; }
alias disable_spotlight_indexing="ask 'Desativar a indexação do Spotlight para qualquer volume que seja montado e ainda não tenha sido indexado antes?' disable_spotlight_indexing"
change_indexing_order() { defaults write com.apple.spotlight orderedItems -array '{"enabled" = 1;"name" = "APPLICATIONS";}' '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' '{"enabled" = 1;"name" = "DIRECTORIES";}' '{"enabled" = 1;"name" = "PDF";}' '{"enabled" = 1;"name" = "FONTS";}' '{"enabled" = 0;"name" = "DOCUMENTS";}' '{"enabled" = 0;"name" = "MESSAGES";}' '{"enabled" = 0;"name" = "CONTACT";}' '{"enabled" = 0;"name" = "EVENT_TODO";}' '{"enabled" = 0;"name" = "IMAGES";}' '{"enabled" = 0;"name" = "BOOKMARKS";}' '{"enabled" = 0;"name" = "MUSIC";}' '{"enabled" = 0;"name" = "MOVIES";}' '{"enabled" = 0;"name" = "PRESENTATIONS";}' '{"enabled" = 0;"name" = "SPREADSHEETS";}' '{"enabled" = 0;"name" = "SOURCE";}' '{"enabled" = 0;"name" = "MENU_DEFINITION";}' '{"enabled" = 0;"name" = "MENU_OTHER";}' '{"enabled" = 0;"name" = "MENU_CONVERSION";}' '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' ; echo "Alterar a ordem de indexação e desativar alguns resultados de pesquisa"; }
alias change_indexing_order="ask 'Alterar a ordem de indexação e desativar alguns resultados de pesquisa?' change_indexing_order"
reload_spotlight_settings() { killall mds > /dev/null 2>&1 ; echo "Carregar novas configurações antes de reconstruir o índice"; }
alias reload_spotlight_settings="ask 'Carregar novas configurações antes de reconstruir o índice?' reload_spotlight_settings"
enable_spotlight_indexing() { sudo mdutil -i on / > /dev/null ; echo "Certificar-se de que a indexação esteja ativada para o volume principal"; }
alias enable_spotlight_indexing="ask 'Certificar-se de que a indexação esteja ativada para o volume principal?' enable_spotlight_indexing"
rebuild_spotlight_index() { sudo mdutil -E / > /dev/null ; echo "Reconstruir o índice do zero"; }
alias rebuild_spotlight_index="ask 'Reconstruir o índice do zero?' rebuild_spotlight_index"
use_utf8_terminal() { defaults write com.apple.terminal StringEncodings -array 4 ; echo "Use somente UTF-8 em Terminal.app"; }
alias use_utf8_terminal="ask 'Use somente UTF-8 em Terminal.app?' use_utf8_terminal"
enable_secure_keyboard_entry() { defaults write com.apple.terminal SecureKeyboardEntry -bool true ; echo "Habilite a entrada segura do teclado no Terminal.app"; }
alias enable_secure_keyboard_entry="ask 'Habilite a entrada segura do teclado no Terminal.app?' enable_secure_keyboard_entry"
disable_line_marks() { defaults write com.apple.Terminal ShowLineMarks -int 0 ; echo "Desative as incômodas marcas de linha"; }
alias disable_line_marks="ask 'Desative as incômodas marcas de linha?' disable_line_marks"
disable_new_disk_prompt() { defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true ; echo "Impedir que o Time Machine solicite o uso de novos discos rígidos como volume de backup"; }
alias disable_new_disk_prompt="ask 'Impedir que o Time Machine solicite o uso de novos discos rígidos como volume de backup?' disable_new_disk_prompt"
disable_local_backups() { hash tmutil &> /dev/null; sudo tmutil disablelocal ; echo "Desativar backups locais do Time Machine"; }
alias disable_local_backups="ask 'Desativar backups locais do Time Machine?' disable_local_backups"
show_activity_monitor_main_window() { defaults write com.apple.ActivityMonitor OpenMainWindow -bool true ; echo "Mostrar a janela principal ao iniciar o Activity Monitor"; }
alias show_activity_monitor_main_window="ask 'Mostrar a janela principal ao iniciar o Activity Monitor?' show_activity_monitor_main_window"
show_cpu_usage_on_dock_icon() { defaults write com.apple.ActivityMonitor IconType -int 5 ; echo "Visualize o uso da CPU no ícone do Dock do Activity Monitor"; }
alias show_cpu_usage_on_dock_icon="ask 'Visualize o uso da CPU no ícone do Dock do Activity Monitor?' show_cpu_usage_on_dock_icon"
show_all_processes() { defaults write com.apple.ActivityMonitor ShowCategory -int 0 ; echo "Mostrar todos os processos no Activity Monitor"; }
alias show_all_processes="ask 'Mostrar todos os processos no Activity Monitor?' show_all_processes"
sort_activity_monitor_by_cpu() { defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" ; defaults write com.apple.ActivityMonitor SortDirection -int 0 ; echo "Classifique os resultados do Activity Monitor por uso da CPU"; }
alias sort_activity_monitor_by_cpu="ask 'Classifique os resultados do Activity Monitor por uso da CPU?' sort_activity_monitor_by_cpu"
disable_automatic_photos_open() { defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true ; echo "Impedir que o Photos seja aberto automaticamente quando os dispositivos estiverem conectados"; }
alias disable_automatic_photos_open="ask 'Impedir que o Photos seja aberto automaticamente quando os dispositivos estiverem conectados?' disable_automatic_photos_open"
reset_affected_apps() { for app in "Activity Monitor" "Address Book" "Calendar" "cfprefsd" "Contacts" "Dock" "Finder" "Google Chrome Canary" "Google Chrome" "Mail" "Messages" "Opera" "Photos" "Safari" "SizeUp" "Spectacle" "SystemUIServer" "Terminal" "iCal"; do killall "${app}" &> /dev/null ; done ; echo "Feito. Observe que algumas dessas alterações exigem um logout/reinício para entrar em vigor."; }
alias reset_affected_apps="ask 'Resetar os aplicativos afetados?' reset_affected_apps"
disable_chrome_swipe_navigation() { defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false ; defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false ; echo "Desabilite o deslizar para trás muito sensível nos trackpads"; }
alias disable_chrome_swipe_navigation="ask 'Desabilite o deslizar para trás muito sensível nos trackpads?' disable_chrome_swipe_navigation"
disable_chrome_mouse_swipe_navigation() { defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false ; defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false ; echo "Desative o deslizar para trás muito sensível no Magic Mouse"; }
alias disable_chrome_mouse_swipe_navigation="ask 'Desative o deslizar para trás muito sensível no Magic Mouse?' disable_chrome_mouse_swipe_navigation"
use_native_print_dialog() { defaults write com.google.Chrome DisablePrintPreview -bool true ; defaults write com.google.Chrome.canary DisablePrintPreview -bool true ; echo "Use a caixa de diálogo de visualização de impressão nativa do sistema"; }
alias use_native_print_dialog="ask 'Use a caixa de diálogo de visualização de impressão nativa do sistema?' use_native_print_dialog"
expand_print_dialog() { defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true ; defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true ; echo "Expandir a caixa de diálogo de impressão por padrão"; }
alias expand_print_dialog="ask 'Expandir a caixa de diálogo de impressão por padrão?' expand_print_dialog"
