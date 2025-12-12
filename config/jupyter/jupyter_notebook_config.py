import os

c = get_config()

jupyter_server_port = int(os.getenv("JUPYTER_SERVER_PORT"))

# http connection config
c.ServerApp.ip = "0.0.0.0"
c.ServerApp.port = jupyter_server_port
c.ServerApp.allow_root = True
c.ServerApp.port_retries = 0
c.ServerApp.quit_button = False
c.ServerApp.allow_remote_access = True
c.ServerApp.disable_check_xsrf = True
c.ServerApp.allow_origin = "*"
c.ServerApp.trust_xheaders = True

# ensure that Jupyter doesn't open a browser window on image startup
c.NotebookApp.open_browser = False
c.LabApp.open_browser = False
c.ServerApp.open_browser = False
c.ExtensionApp.open_browser = False

# set base url if available
base_url = "/" + os.getenv("MAIN_USER", "")
if base_url is not None and base_url != "/":
    c.ServerApp.base_url = base_url

# delete files fully when deleted
c.FileContentsManager.delete_to_trash = False

# deactivate token -> no authentication
c.IdentityProvider.token = ""