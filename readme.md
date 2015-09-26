# HEADS UP, this is a one off build. Code isn't clean and may not be even improved!

# Installations

Run `bundle`


# Usages

- `chmod +x download.rb`
- ./download http://www.music.com.bd/download/browse/P/Polli%20Geeti/ /Music

It will download Polli Geeti album into Music directory. It'll create a directory namd 'Polli Geeti'.


# Caution
It uses a new thread for downloading each link. There is no thread pool. So be careful to use with page where it has too many files to download
