import subprocess
import json
import time
import sys
import pdb
import tarfile
import yaml
import paramiko
import socket
import os
from boto import ec2


def main():
  """ Spins up the server specified by the user provided configuration file. """
  if len(sys.argv) != 2:
    print 'Usage: %s [config_file]' % sys.argv[0]
    print 'Spins up a server based on the configuration given in [config_file].'
    return

  with open(sys.argv[1]) as handle:
    config = yaml.load(handle.read())

  print 'Spawning instance...'
  connection = ec2.connect_to_region(config['region'], aws_access_key_id=os.environ['AWS_ACCESS_KEY'],
    aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'])
  reservation = connection.run_instances(config['image'], key_name=config['key_name'],
    instance_type=config['instance_type'], security_groups=config['security_groups'])

  instance = reservation.instances[0]
  print 'Got instance ID:', instance.id

  sys.stdout.write('Waiting for instance to run...')
  sys.stdout.flush()

  while not instance.state == 'running':
    instance.update()
    time.sleep(3)

    sys.stdout.write('.')
    sys.stdout.flush()

  sys.stdout.write('\n')
  print 'Instance %s is running!' % instance.id
  print 'Got IP address', instance.ip_address

  ssh = paramiko.SSHClient()
  ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

  sys.stdout.write('Waiting to be able to ssh...')
  sys.stdout.flush()

  while True:
    try:
      ssh.connect(instance.ip_address, username='ubuntu', key_filename=config['key_path'])
    except socket.error:
      sys.stdout.write('.')
      sys.stdout.flush()
      time.sleep(3)
    else:
      break

  sys.stdout.write('\n')
  print 'Bundling all files and scripts in an archive...'
  # put all scripts/files in an archive
  archive_file = 'archive.tar'
  with tarfile.open(archive_file, 'w') as tar:
    tar.add('./files')
    tar.add('./scripts')

  pdb.set_trace()
  # print 'Uploading to server...'
  # archive_file_remote = '~/%s' % archive_file
  # client.put_file(archive_file, archive_file)

  # print 'Unarchiving...'
  # client.run('tar xvf %s' % archive_file_remote)


if __name__ == '__main__':
  main()
