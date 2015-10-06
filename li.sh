#!/bin/bash

li() {

  export LI_PATH=${HOME}/.aliases/
  export LI_CONFIG=${LI_PATH}.config
  export LI_MAIN=${HOME}/.bashrc

  if [[ -f ${HOME}/.bash_aliases ]];
  then
    export LI_MAIN=${HOME}/.bash_aliases
  fi;

  if [[ ! -f ${LI_CONFIG} ]];
  then
    echo -n "# name=url" > ${LI_CONFIG}
  fi

  if [[ ! -f ${LI_PATH} ]];
  then
    mkdir -p ${LI_PATH}
  fi

  __is_exist() {
    cat ${LI_CONFIG} | grep "^$1=" | wc -l
  }

  __get_url() {
    look $1 ${LI_CONFIG} | cut -d '=' -f 2-
  }

  _install() {
    if [[ $(__is_exist $1) -ne 0 ]];
    then
      echo "Alias '$1' already instaled."
    else
      URL=$2
      TMP_FILE=${LI_PATH}/$1.tmp
      HTTP_CODE=$(curl -s -w %{http_code} --output "${TMP_FILE}" "${URL}")
      if [[ ${HTTP_CODE} -ne 200 ]];
      then
        rm ${TMP_FILE}
        echo "Url '${URL}' is not avalable. Respons code: ${HTTP_CODE}"
      else
        mv ${TMP_FILE} ${LI_PATH}/$1.sh
        echo "[[ -s \"${HOME}/.aliases/$1.sh\" ]] && source \"${HOME}/.aliases/$1.sh\" # Alias $1" >> ${LI_MAIN}
        echo -e "\n$1=$2" >> ${LI_CONFIG}
        . ${LI_MAIN}
        echo "Alias '$1' installed."
      fi
    fi
  }

  _add() {
    echo "TODO: Add new aliases by name."
  }

  _update() {
    if [[ $(__is_exist $1) -eq 0 ]];
    then
      echo "Alias '$1' not instaled."
      echo "Use command to install: li -a $1"
    else
      URL=$(__get_url $1)
      TMP_FILE=${LI_PATH}/$1.tmp
      HTTP_CODE=$(curl -s -w %{http_code} --output "${TMP_FILE}" "${URL}")
      if [[ ${HTTP_CODE} -ne 200 ]];
      then
        rm ${TMP_FILE}
        echo "Url '${URL}' is not avalable."
      else
        mv ${TMP_FILE} ${LI_PATH}/$1.sh
        . ${LI_MAIN}
        echo "Alias '$1' updated."
      fi
    fi
  }

  _remove(){
    if [[ $(__is_exist $1) -eq 0 ]];
    then
      echo "Alias '$1' not instaled."
      echo "Use command to install: li -a $1"
    else
      # Comment in configuration
      sed -i -e "s/^$1=/#$1=/g" ${LI_CONFIG}
      # Remove file
      if [[ ! -f ${LI_PATH}$1.sh ]];
      then
        echo "File '${LI_PATH}$1.sh' does not exist."
      else
        rm ${LI_PATH}$1.sh
        echo "File '${LI_PATH}$1.sh' removed."
      fi
      # echo "[[ -s \"${HOME}/.aliases/$1.sh\" ]] && source \"${HOME}/.aliases/$1.sh\" # Alias $1"
      # sed -i -e "s/# Alias $1//g" ${LI_MAIN}
      sed -i -e "/$1.sh\" # Alias $1/,+1 d" ${LI_MAIN}
      . ${LI_MAIN}
      echo "'$1' removed."
      echo "Node: to full removing aliases please reload terminal."
    fi
  }

  _list() {
    echo "TODO: Display list of aliases."
  }

  _upgrade() {
    echo "TODO: Upgrade list."
  }

  _help() {
    echo "usage: li <command> [<name> [<url>]]
Command line tool for manager own set of aliases.

COMMAND
    -a, add		Add aliases by name
    -i, install		Add aliases
    -u, update		Update aliases
    -r, remove		Remove aliases
    -d, details		Dispaly details of aliases
    -l, list		List aliases
    -h, help		Display help
    -g, upgrade		Upgrade newews configuration of aliases. Download file with exusting aliases.

NAME
    Name is unicue name of set aliases.

URL
    Url to bash src with aliases. This params neede onli on adding/install new aliases.

Configuration:
    File '.config' at '${LI_CONFIG}' contains configuration of li command.

Aliases:
    In current time exist $(wc -l ${LI_CONFIG}) aliases.
    For upgrate list of avalable configuration run:
	li	upgrade
	li	-g

Examples:
    li	add	 maven-color	Add aliases maven-color.
    li	update namen-color	Update maven-color aliases.
    li	remove namen-color	Remove maven-color aliases.
    li	list	 		Display list of avalable aliases.

Add own/new aliases:
    li	--install	app	http://raw.github.com/		Add aliases from  url.

Report li bugs to 'banadiga.user@github.com' or to 'http://github.com/banadiga/li-aliases'
For complete documentation, wisit: 'http://github.com/banadiga/li-aliases'"
  }

case "$1" in
  -i|install)
    [ "$#" == "3" ] && _install $2 $3 || echo "Install expect two extra params."
  ;;

  -a|add)
    [ "$#" == "2" ] && _add $2 || echo "Add expect one extra params."
  ;;

  -r|remove)
    [ "$#" == "2" ] && _remove $2 || echo "Remove expect one extra params."
  ;;

  -u|update)
    [ "$#" == "2" ] && _update $2 || echo "Update expect one extra params."
  ;;

  -l|list)
    [ "$#" == "1" ] && _list || echo "List expect no extra params."
  ;;

  -g|upgrade)
    [ "$#" == "1" ] && _upgrade || echo "Upgrade configuration no extra params."
  ;;

  -h|--help|*)
    _help
  ;;

  *)
    _help
    exit 1
  ;;

esac
}

complete -W "install add remove update list upgrade help -i -a -r -l -u -g -h" li

alias li=li
