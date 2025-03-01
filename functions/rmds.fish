function rmds --description '✌️ remove .DS_Store files recursively from working directory'
    find . -type f -name ".DS_Store" -delete
end
