import sys
import os

def attach(socket_path):
    if "debugpy" not in sys.modules:
        import debugpy
        for i in range(10):
            target_port = 5678 + i
            try:
                debugpy.listen(target_port)
            except Exception:
                continue
            break
        command = """python -c "import pynvim;pynvim.attach(\\"socket\\", path=\\"%s\\").command(\\"lua require('dap').run({host = '127.0.0.1', port = %s, type = 'python', request = 'attach', name = 'test'})\\")" """ % (socket_path, target_port)
        os.system(command)
        debugpy.wait_for_client()
        os.system('jcnotify "debugger started"')
