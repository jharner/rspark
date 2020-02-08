#! /bin/sh
echo "\n"

PS3='Docker Image Manager: '
options=("Stop Containers" "Delete Containers" "Delete Orphan Images" "Delete All Images" "Delete Hanging Volumes" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Stop Containers")
            docker stop $(docker ps -a -q)
            break
            ;;
        "Delete Containers")
            docker rm $(docker ps -a -q)
            break
            ;;
        "Delete Orphan Images")
            docker images | grep "<none>" | awk '{print $3}' | xargs docker rmi
            break
            ;;
        "Delete All Images")
            docker rmi -f $(docker images -q)
            break
            ;;
        "Delete Hanging Volumes")
            docker volume rm $(docker volume ls -f dangling=true -q)
            break
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done