#!/bin/bash

# logファイルを保存する先のディレクトリ
_log_dir="/home/kukun/GoogleDrive/Dev/log/"

# 親プロセスが script ではない場合に 0 を返す。
# 例えば、bash や su や sshd などの場合。
is_parent_proc_check(){
_ret_value=1
while read _pid _p_proc
do
    if [ "x${_pid}" = "x${PPID}" ]; then 
        case "x${_p_proc}" in 
            "x""sshd"   )   _ret_value=0;;
            "x""bash"   )   _ret_value=0;;
            "x""su"     )   _ret_value=0;;
            "x""code"   )   _ret_value=0;;
            "x""gnome-terminal-"    )   _ret_value=0;;
            "x""sshd: ""${USER}""@notty"    ) return _ret_value=0;;
        esac
    fi
done <<__EOC__
    `ps aucx | grep "${PPID}" | awk '{ print $2 " " $11 }' `
__EOC__
return "${_ret_value}"

}

is_parent_proc_check
if [ $? -eq 0 ]; then
# script -af /home/ku/GoogleDrive/Dev/`date +%Y%m%d%H%M%S`_`hostname`.log
    script -af ${_log_dir}`date +%Y%m%d%H%M%S`_`hostname`.log
    exit
fi

unset _log_dir
