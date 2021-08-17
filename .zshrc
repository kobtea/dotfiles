source $HOME/dotfiles/.zprofile
# {{{ Completion
# ------------------------------------------------------------------------------
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit
compinit #-C
setopt COMPLETE_ALIASES # エイリアスに対しても補完を効かせる
setopt LIST_PACKED # 補完リストを詰めて表示
# }}}
# {{{ Style
# ------------------------------------------------------------------------------
# 補完候補をカラーリング
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# 補完時大文字小文字を区別しない(大文字打ったときは小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# }}}
# {{{ History
# ------------------------------------------------------------------------------
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS # 既にhistoryに登録されていたら追記しない
setopt HIST_IGNORE_ALL_DUPS # 既にhistoryに登録されていたら古い方を削除する
setopt HIST_REDUCE_BLANKS # 余計な余白を削除する
# }}}
# {{{ Search
# ------------------------------------------------------------------------------
# e.g.) `ls -`の状態で<C-p>する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '\e^P' history-beginning-search-backward-end
bindkey '\e^N' history-beginning-search-forward-end
# }}}
# {{{ Change Directory
# ------------------------------------------------------------------------------
setopt AUTO_CD # `cd`なしのディレクトリ名だけで移動
setopt AUTO_PUSHD # `cd -[TAB]`で移動したことのあるディレクトリのリストを表示
# }}}
# {{{ Prompt
# ------------------------------------------------------------------------------
# case ${UID} in
#     0)
#         PROMPT="%B%{[31m%}%/#%{[m%}%b"
# 	    #PROMPT2="%B%{[31m%}%_#%{[m%}%b"
# 	    #SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{m%}%b"
# 	    #[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#         #    PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
# 	    ;;
#     *)
# 	    PROMPT="%B%{[31m%}%m:%n%%%{[m%} "
# 	    RPROMPT="%B[%{[35m%}%~%{[m%}]"
# 	    PROMPT2="%B%{[31m%}%_%%%{[m%} "
# 	    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
# 	    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
#             PROMPT="%{[37m%}${HOST%%.*} ${PROMPT} "
# 	    ;;
# esac
# case ${UID} in
#     0)
#     PROMPT="%B%{[31m%}%/#%{[m%}%b"
#     PROMPT2="%B%{[31m%}%_#%{[m%}%b"
#     ;;
#     *)
#     PROMPT="%B%{[31m%}macbook $%{[m%} "
#     RPROMPT="%B[%{[35m%}%~%{[m%}]"
#     ;;
# esac
autoload -Uz promptinit
promptinit
PURE_PROMPT_SYMBOL='$'
# }}}
# {{{ Terminal
# ------------------------------------------------------------------------------
case "${TERM}" in
    kterm*|xterm)
        precmd() {
            #echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
            echo -ne "\033]0;${PWD}\007"
        }
        ;;
esac
# }}}
# {{{ Alias
# ------------------------------------------------------------------------------
case ${OSTYPE} in
    darwin*)
        alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@" -u NONE --noplugin'
        alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        alias view='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@" -R'
        alias grep='ggrep'
        alias egrep='gegrep'
        alias sed='gsed'
        alias ls='ls --color=auto'
        alias ll='ls -la --color=auto'
        alias time='gtime'
        alias tac='gtac'
        alias cat='ccat'
        ;;
    linux*)
        alias ls='ls --color'
        alias ll='ls -la --color'
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
        ;;
esac
alias g='git'
alias gs='git status'
alias gb='git branch'
alias gl='git log'
alias gd='git diff'
alias ga='git add'
alias v='vagrant'
alias be='bundle exec'
alias ce='chef exec'
alias diff='colordiff -uprN'
alias tmux='TERM=screen-256color-bce tmux'
alias emacs='emacs -nw'
alias k='kubectl'
alias kx='kubectx'
alias url-encode='nkf -WwMQ | tr = % | tr -d "\n"'
alias url-decode='nkf -w --url-input'
# }}}
# {{{ Hook Function
# ------------------------------------------------------------------------------
function chpwd() {ls} # 移動時にls
# }}}
# {{{ Plugin
# ------------------------------------------------------------------------------
source $HOME/.zplug/init.zsh
zplug "zsh-users/zsh-completions", use:src
zplug "mafredri/zsh-async", from:github, defer:0
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-autosuggestions"
zplug load
# }}}
repo() {
  local dir
  dir=$(ghq list -p > /dev/null | fzf-tmux --reverse +m) && cd $dir
}
source $HOME/dotfiles/.zlogin
