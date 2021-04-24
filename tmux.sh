creating a tmux session without attaching to it

session=mam.services
path=/var/mam
#folder=$path/$dir

tmux kill-session -t $session


tmux new-session -d -s $session

tmux split-window -h -t ${session}:0.0

tmux split-window -h -t ${session}:0.0

tmux split-window -h -t ${session}:0.0

tmux split-window -h -t ${session}:0.0

#tmux split-window -h -t ${session}:0.0

#tmux split-window -h -t ${session}:0.0

#tmux split-window -h -t ${session}:0.0

#tmux split-window -h -t ${session}:0.0

#tmux split-window -h -t ${session}:0.0

tmux select-layout tiled

tmux send-keys -t ${session}:0.0 "cd $path/mam.log/" C-m "./logwriter"  C-m

tmux send-keys -t ${session}:0.1 "cd $path/mamserver/" C-m "./mamserver"  C-m

tmux send-keys -t ${session}:0.2 "cd $path/mamgui/" C-m "./mamgui"  C-m

#tmux send-keys -t ${session}:0.2 "cd $path/mamserver/" C-m "./mamserver"  C-m

#sleep 5

#tmux send-keys -t test:0.3 "cd $path/maminspector/" C-m "./maminspector -d -r"  C-m

