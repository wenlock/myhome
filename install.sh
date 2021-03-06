#!/bin/bash
#
export BASE_DIR="$(cd "$(dirname $0)" && pwd)"
git config --global pager.branch false
git config --global push.default current

[ ! -d "${HOME}/git" ] && mkdir -p "${HOME}/git"

# skip login check for sshd 
touch "${HOME}/.gitenv.nologin"

# vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qall

[ ! -s "${HOME}/opt" ] && ln -s "${BASE_DIR}/opt" "${HOME}/opt"
for file in $(find "${BASE_DIR}/opt/profiles" -type f); do
    echo "Creating symlink to $file in home directory."
    [ ! -s "${HOME}/$(basename "${file}")" ] && ln -s "${file}" "${HOME}/$(basename "${file}")"
done

# force a few
for file in ".profile" ".zshrc" ".bash_logout" ".bashrc"; do
  [ -f "${HOME}/${file}" ] && rm -f "${HOME}/${file}"
  ln -s "${BASE_DIR}/opt/profiles/${file}" "${HOME}/${file}"
done 

if [ -x "$(which apt-get)" ]; then
  sudo apt-get install -y \
    corkscrew \
    htop \
    iputils-ping \
    jq \
    lsof \
    net-tools \
    psmisc \
    zsh
fi

[ ! -f "${HOME}/.ruby.env" ] && source "${HOME}/opt/bin/setup_ruby-docker.sh"
[ ! -f "${HOME}/.gitenv" ] && source "${HOME}/opt/bin/setup_git_alias.sh"
[ ! -f "${HOME}/.dindcenv" ] && source "${HOME}/opt/bin/setup_dindc_alias.sh"

if [ -f "${HOME}/.gitrepos" ] ; then
  cd "${HOME}"
  "${HOME}/.gitrepos"
fi
