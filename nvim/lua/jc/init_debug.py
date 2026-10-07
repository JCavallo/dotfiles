import sys
import os

def attach(socket_path):
    if "debugpy" not in sys.modules:
        import debugpy
        debugpy.listen(5678)
        command = """python -c "import pynvim;pynvim.attach(\\"socket\\", path=\\"%s\\").command(\\"lua require('dap').run({host = '127.0.0.1', port = 5678, type = 'python', request = 'attach', name = 'test'})\\")" """ % socket_path
        os.system(command)
        debugpy.wait_for_client()
        os.system('jcnotify "debugger started"')
