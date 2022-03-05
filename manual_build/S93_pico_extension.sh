#!/bin/sh

# PICO-8 rom extension renaming
if mount|grep -q /media/sdcard; then
  dir=/media/sdcard/roms/PICO8
  if [ ! -d "${dir}/EXT" ]; then
    mkdir -p "${dir}/EXT"
  fi
  # on start inactive rename file created
  # on stop active rename file triggers rename
  case "$1" in
    start)
      # ensures only inactive rename file "p8_png" exists in /EXT
      if [ ! -e "${dir}/EXT/p8_png" ]; then echo "" > "${dir}/EXT/p8_png"; fi
      for anyF in ${dir}/EXT/*
      do
        if [ "${anyF}" != "${dir}/EXT/p8_png" ]; then rm "${anyF}"; fi
      done
    ;;
    stop)
      # avoid possible infinite loop
      if [ -e "${dir}/EXT/png" ] && [ -e "${dir}/EXT/p8" ]; then
        rm "${dir}/EXT/png" && rm "${dir}/EXT/p8"
      # run if a active rename file exists
      elif [ -e "${dir}/EXT/png" ] || [ -e "${dir}/EXT/p8" ]; then
        for rom in ${dir}/*.*
        do
          # rename to .png as long as long as this would not overwrite
          if [ -e "${dir}/EXT/png" ]; then
            case ${rom} in
              *.p8.png) if [ ! -e "${rom%.p8.png}.png" ]; then mv "$rom" "${rom%.p8.png}.png"; fi ;;
              *.p8)     if [ ! -e "${rom%.p8}.png" ]; then mv "$rom" "${rom%.p8}.png"; fi ;;
            esac
          # rename to .p8 as long as long as this would not overwrite
          elif [ -e "${dir}/EXT/p8" ]; then
            case ${rom} in
              *.p8.png) if [ ! -e "${rom%.p8.png}.p8" ]; then mv "$rom" "${rom%.p8.png}.p8"; fi ;;
              *.png)    if [ ! -e "${rom%.png}.p8" ]; then mv "$rom" "${rom%.png}.p8"; fi ;;
            esac
          fi
        done
      fi
    ;;
  esac
fi
