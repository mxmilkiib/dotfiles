
#!/usr/bin/python

import os
import time
import re
import sys
from datetime import datetime, timedelta

def list_unused_packages(days):
    '''
    list packages not acessed in arch for n days
    it checks if any of files in package were acessed before n days,
    if not add it to list of unused_packages.
    '''
    lt_time = datetime.now() - timedelta(days=days)
    epoch_lt_time = time.mktime(lt_time.timetuple())

    # get list of installed packages
    installed_packages = os.popen('pacman -Q').read().split('\n')[:-1]


    unused_packages = []
    for package in installed_packages:
        # get files of package
        files = os.popen('pacman -Ql ' + re.match('^.* ', package).group())
        files = files.read().split('\n')[:-1]
        acessed = False
        for path in files:
            valid_file = re.search(' (.*\w)$', path) # exclude directories
            if valid_file:
                try:
                    atime = os.path.getatime(valid_file.group(1))
                    if atime > epoch_lt_time:
                        acessed = True
                        break
                except OSError:
                    # broken symlink?
                    pass
        if not acessed:
            unused_packages.append(package)

    return unused_packages


if __name__ == '__main__':
    try:
        unused_packages = list_unused_packages(int(sys.argv[1]))
        print ('\n'.join(unused_packages))
        if unused_packages:
            print ('packages not used for at least {0} days'.format(sys.argv[1]))
        else:
            print ('all packages were acessed.')
    except IndexError:
        print ('usage: unused_packages days')
