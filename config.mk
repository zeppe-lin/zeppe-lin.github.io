# project metadata
NAME    = zeppe-lin.github.io
VERSION = 1.0

# paths
WWWDIR  = /var/www/$(NAME)

# pandoc and its flags
PANDOC  = pandoc
PFLAGS  = -s -f markdown-ascii_identifiers -t html \
          --syntax-highlighting=zenburn -c style.css \
          --template=template.html.in --toc -N

