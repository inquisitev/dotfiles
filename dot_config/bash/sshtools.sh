new_key(){
   local alias="$1"
   local host="$2"
   local user="$2"
   ssh-keygen -f ~/.ssh/id_$alias -P "" 
   cat ~/.ssh/id_hostname.pub | ssh $user@$host 'cat >> ~/.ssh/authorized_keys'

   echo "Host $alias
       HostName $host
       User $user
       IdentityFile ~/.ssh/id_$alias
       StrictHostKeyChecking no
       UserKnownHostsFile /dev/null" >> ~/.ssh/config
}

