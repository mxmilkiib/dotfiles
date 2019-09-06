#! /bin/sh

# find duplicated files in directory tree
# comparing by file NAME, SIZE or MD5 checksum
# --------------------------------------------
# LICENSE(s): BSD / CDDL
# --------------------------------------------
# vermaden [AT] interia [DOT] pl
# http://strony.toya.net.pl/~vermaden/links.htm

__usage() {
  echo "usage: $( basename ${0} ) OPTION DIRECTORY"
  echo "  OPTIONS: -n   check by name (fast)"
  echo "           -s   check by size (medium)"
  echo "           -m   check by md5  (slow)"
  echo "           -N   same as '-n' but with delete instructions printed"
  echo "           -S   same as '-s' but with delete instructions printed"
  echo "           -M   same as '-m' but with delete instructions printed"
  echo "  EXAMPLE: $( basename ${0} ) -s /mnt"
  exit 1
  }

__prefix() {
  case $( id -u ) in
    (0) PREFIX="rm -rf" ;;
    (*) case $( uname ) in
          (SunOS) PREFIX="pfexec rm -rf" ;;
          (*)     PREFIX="sudo rm -rf"   ;;
        esac
        ;;
  esac
  }

__crossplatform() {
  case $( uname ) in
    (FreeBSD)
      MD5="md5 -r"
      STAT="stat -f %z"
      ;;
    (Linux)
      MD5="md5sum"
      STAT="stat -c %s"
      ;;
    (SunOS)
      echo "INFO: supported systems: FreeBSD Linux"
      echo
      echo "Porting to Solaris/OpenSolaris"
      echo "  -- provide values for MD5/STAT in '$( basename ${0} ):__crossplatform()'"
      echo "  -- use digest(1) instead for md5 sum calculation"
      echo "       $ digest -a md5 file"
      echo "  -- pfexec(1) is already used in '$( basename ${0} ):__prefix()'"
      echo
      exit 1
    (*)
      echo "INFO: supported systems: FreeBSD Linux"
      exit 1
      ;;
  esac
  }

__md5() {
  __crossplatform
  :> ${DUPLICATES_FILE}
  DATA=$( find "${1}" -type f -exec ${MD5} {} ';' | sort -n )
  echo "${DATA}" \
    | awk '{print $1}' \
    | uniq -c \
    | while read LINE
      do
        COUNT=$( echo ${LINE} | awk '{print $1}' )
        [ ${COUNT} -eq 1 ] && continue
        SUM=$( echo ${LINE} | awk '{print $2}' )
        echo "${DATA}" | grep ${SUM} >> ${DUPLICATES_FILE}
      done

  echo "${DATA}" \
    | awk '{print $1}' \
    | sort -n \
    | uniq -c \
    | while read LINE
      do
        COUNT=$( echo ${LINE} | awk '{print $1}' )
        [ ${COUNT} -eq 1 ] && continue
        SUM=$( echo ${LINE} | awk '{print $2}' )
        echo "count: ${COUNT} | md5: ${SUM}"
        grep ${SUM} ${DUPLICATES_FILE} \
          | cut -d ' ' -f 2-10000 2> /dev/null \
          | while read LINE
            do
              if [ -n "${PREFIX}" ]
              then
                echo "  ${PREFIX} \"${LINE}\""
              else
                echo "  ${LINE}"
              fi
            done
        echo
      done
  rm -rf ${DUPLICATES_FILE}
  }

__size() {
  __crossplatform
  find "${1}" -type f -exec ${STAT} {} ';' \
    | sort -n \
    | uniq -c \
    | while read LINE
      do
        COUNT=$( echo ${LINE} | awk '{print $1}' )
        [ ${COUNT} -eq 1 ] && continue
        SIZE=$( echo ${LINE} | awk '{print $2}' )
        SIZE_KB=$( echo ${SIZE} / 1024 | bc )
        echo "count: ${COUNT} | size: ${SIZE_KB}KB (${SIZE} bytes)"
        if [ -n "${PREFIX}" ]
        then
          find ${1} -type f -size ${SIZE}c -exec echo "  ${PREFIX} \"{}\"" ';'
        else
          # find ${1} -type f -size ${SIZE}c -exec echo "  {}  " ';'  -exec du -h "  {}" ';'
          find ${1} -type f -size ${SIZE}c -exec echo "  {}  " ';'
        fi
        echo
      done
  }

__file() {
  __crossplatform
  find "${1}" -type f \
    | xargs -n 1 basename 2> /dev/null \
    | tr '[A-Z]' '[a-z]' \
    | sort -n \
    | uniq -c \
    | sort -n -r \
    | while read LINE
      do
        COUNT=$( echo ${LINE} | awk '{print $1}' )
        [ ${COUNT} -eq 1 ] && break
        FILE=$( echo ${LINE} | cut -d ' ' -f 2-10000 2> /dev/null )
        echo "count: ${COUNT} | file: ${FILE}"
        FILE=$( echo ${FILE} | sed -e s/'\['/'\\\['/g -e s/'\]'/'\\\]'/g )
        if [ -n "${PREFIX}" ]
        then
          find ${1} -iname "${FILE}" -exec echo "  ${PREFIX} \"{}\"" ';'
        else
          find ${1} -iname "${FILE}" -exec echo "  {}" ';'
        fi
        echo
      done 
  }

# main()

[ ${#} -ne 2  ] && __usage
[ ! -d "${2}" ] && __usage

DUPLICATES_FILE="/tmp/$( basename ${0} )_DUPLICATES_FILE.tmp"

case ${1} in
  (-n)           __file "${2}" ;;
  (-m)           __md5  "${2}" ;;
  (-s)           __size "${2}" ;;
  (-N) __prefix; __file "${2}" ;;
  (-M) __prefix; __md5  "${2}" ;;
  (-S) __prefix; __size "${2}" ;;
  (*)  __usage ;;
esac
