#!/usr/bin/python2.7

'''
Usage:
fab get_new_db_dump:app=my_app -i ~/.ssh/my-private-key -H user@host

To enable password-less SSH:
ssh-copy-id -i ~/.ssh/my-public-key.pub user@host
'''

from fabric.api import *

def get_new_db_dump(app='my_app'):
    date_suffix = run('date +%F-%H-%M')
    dmp_filename = '%s-%s.sql.gz' % (app, date_suffix)
    dmp_filepath = '/tmp/%s' % (dmp_filename)
    local_filepath = '/path/to/dumps/dir/%s' % (dmp_filename)

    app_folders = {
        'my_app': '/var/www/my_app',
        'another_app': '/var/www/sites/another_app'
    }
    app_folder = app_folders[app]

    run('/usr/bin/drush -r %s sql-dump --structure-tables-list=cache*,search_index,search_dataset,sessions | /bin/gzip > %s' % (app_folder, dmp_filepath))
    get(remote_path=dmp_filepath, local_path=local_filepath)
    run('rm %s' % (dmp_filepath))
