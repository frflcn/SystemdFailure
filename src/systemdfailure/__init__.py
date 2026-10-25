import sys
import os
import subprocess
from pathlib import Path
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, QmlSingleton, QmlElement
from PySide6.QtCore import Qt, Slot, Property, QObject, Signal

QML_IMPORT_NAME = "com.trevorsapps.backend"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
@QmlSingleton
class Backend(QObject):
    message_changed = Signal()
    instance = None  # Stores the single instance

    def __new__(cls, *args, **kwargs):
        if cls.instance is None:
            cls.instance = super().__new__(cls, *args, **kwargs)
        return cls.instance


    def __init__(self, parent=None):
        if getattr(self, "initialized", False):   # __init__ runs on every Backend() call
            return
        super().__init__(parent)
        self.initialized = True
        self._message = "Hello from backend"


    def get_message(self):
         return self._message
    def set_message(self, value):
        self._message = value
        self.message_changed.emit()

    message = Property(str, get_message, set_message, notify=message_changed)
        

    

def main() -> None:
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    backend = Backend()

    invocation_id = os.getenv("MONITOR_INVOCATION_ID")
    unit_name = os.getenv("MONITOR_UNIT")
    result = subprocess.run(["journalctl", "--user", f"--invocation={invocation_id}", f"--unit={unit_name}"], capture_output=True, text=True)
    print(f"Invocation ID: {invocation_id}\n Unit Name: {unit_name}")

    src_dir = Path(__file__).resolve().parent
    app.setWindowIcon(QIcon(str(src_dir / "assets/Systemd-logo.svg")))
    engine.addImportPath(src_dir)

    engine.loadFromModule("Qml", "Main")
    backend.set_message(result.stdout)

    if not engine.rootObjects():
        sys.exit(-1)
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)
