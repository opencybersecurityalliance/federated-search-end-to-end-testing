import argparse
import json
import logging
import os
import requests
import sys
import tarfile
import traceback as tb

logging.basicConfig(stream=sys.stdout, level=logging.INFO,
                    format='%(asctime)s %(levelname)s [%(filename)s:'
                    '%(lineno)d]: %(message)s')

parser = argparse.ArgumentParser()
parser.add_argument(
    "index",
    help="elastic index to upload from archive with same name"
)
parser.add_argument(
    "-d",
    "--directory",
    type=str,
    required=False,
    help="directory where files are extracted from index archives"
)
parser.add_argument(
    "-o",
    "--organization",
    type=str,
    required=False,
    help="organization from where index archives are retrieved"
)
parser.add_argument(
    "-r",
    "--repository",
    type=str,
    required=False,
    help="repository from where index archives are retrieved"
)

args = parser.parse_args()

target_dir = args.directory if args.directory else os.path.join(os.sep, 'tmp')
gh_organization = args.organization if args.organization else 'opencybersecurityalliance'
gh_repository = args.repository if args.repository else 'data-bucket-kestrel'

logging.info(f'Running with the following args: '
             f'target_dir = {target_dir}, '
             f'gh_organization = {gh_organization}, '
             f'gh_repository = {gh_repository}')
file_compression_extension = 'gz'
url = '/'.join([
    'https://api.github.com',
    'repos',
    gh_organization,
    gh_repository,
    'contents',
    'elasticsearch',
    f'{args.index}.tar.{file_compression_extension}'
    ])

response = requests.get(url, stream=True)
if response.status_code != 200:
    logging.warn(f'{response.status_code} - no metadata for'
                 f'{args.index}.tar.gz file: {response.text}')
    logging.info(f'Trying to retrieve xz file instead')
    file_compression_extension = 'xz'
    url_xz = url.replace('tar.gz', 'tar.xz')
    response = requests.get(url_xz, stream=True)
    if response.status_code != 200:
        logging.error(f'{response.status_code} - no metadata for'
                 f'{args.index}.tar.xz file: {response.text}')
        sys.exit(-1)
file_info = response.json()
download_url = file_info.get('download_url')
if download_url is None:
    logging.error(f'Could not find download_url in '
                  f'{json.dumps(file_info, indent=2)}')
    sys.exit(-1)

target_path = os.path.join(
    target_dir, f'{args.index}.tar.{file_compression_extension}')
response = requests.get(download_url, stream=True)
if response.status_code != 200:
    logging.error(f'{response.status_code} - failed to retrieve '
                  f'{args.index}.tar.gz file: {response.text}')
    sys.exit(-1)
logging.info(f'Got archive for index {args.index}')
index_archive = tarfile.open(
    fileobj=response.raw, 
    mode=f"r|{file_compression_extension}"
)
index_archive.extractall(path=target_dir)
index_archive.close()
