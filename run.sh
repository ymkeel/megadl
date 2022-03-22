#!/bin/bash
limit=300000
dir="./all"
echo "Entre el prefijo para las carpetas: "
read folder

crear() {
    total_size_string=$(du "$dir" --total | awk '/total/ {print $1}')
    total_size_number=$(expr $total_size_string)
    cant_folders_temp=$(expr $total_size_number / $limit)
    cant_folders_number=$(expr $cant_folders_temp + 1)

    for ((i = 0; i < $cant_folders_number; i++)); do
        folder_num=$(cat ini.txt | awk '{print $1}')
        next_number=$(($folder_num + 1))
        next_folder=$folder$next_number
        $(mkdir "$next_folder")
        echo "Se creo la carpeta "$next_folder""
        $(sed -i "s/$folder_num/$next_number/" ini.txt)
        echo 'Se actualizo la cant de carpetas'
    done
}

comprimir() {
    if [ "$(ls -A $1)" ]; then
        $(zip -rvmq "$1" "$1")
    else
        echo "Carpeta vacia"
    fi
}

mover() {
    for fold in $folder*; do
        for file in ./all/*; do
            total=$(du "$file" "$fold" --total | awk '/total/ {print $1}')
            temp_size=$(($total))

            if [ $temp_size -lt $limit ]; then
                $(mv "$file" "$fold")
            fi
        done
        echo "Comprimiendo $fold ..."
        comprimir $fold
    done
}

crear
mover
