from subprocess import call
import os
from urllib.parse import quote, unquote

NGINX_FILE = "/etc/nginx/nginx.conf"

# Replace base url placeholders with actual base url -> should 
decoded_base_url = unquote("/" + os.getenv("MAIN_USER", ""))
call("sed -i 's@{WORKSPACE_BASE_URL_DECODED}@" + decoded_base_url + "@g' " + NGINX_FILE, shell=True)

# Set url escaped url
encoded_base_url = quote(decoded_base_url, safe="/%")
call("sed -i 's@{WORKSPACE_BASE_URL_ENCODED}@" + encoded_base_url + "@g' " + NGINX_FILE, shell=True)

jupyter_server_port = os.getenv("JUPYTER_SERVER_PORT")
call("sed -i 's@{JUPYTER_SERVER_PORT}@" + jupyter_server_port + "@g' " + NGINX_FILE, shell=True)

code_server_port = os.getenv("CODE_SERVER_PORT")
call("sed -i 's@{CODE_SERVER_PORT}@" + code_server_port + "@g' " + NGINX_FILE, shell=True)

# confusingly, it is the env variable "NO_VNC_PORT" that defines the port that
# KASMvnc serves its VNC through. This is set by the underlying KASM base image
vnc_port = os.getenv("NO_VNC_PORT")
call("sed -i 's@{VNC_PORT}@" + vnc_port + "@g' " + NGINX_FILE, shell=True)