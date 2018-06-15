from slime.rtl.bindings import verilator

class Ram:
    def __init__(self):
        self._m = verilator.VRam_1RW_1C()

    def reset(self):
        self._m.en = 0
        self._m.wr_en = 0
        self._m.addr = 0
        self._m.data_in = 0

    def clock(self, c):
        self._m.clock = c

    def eval(self):
        self._m.eval()

    def final(self):
        self._m.final()

    def set_read(self, addr):
        self._m.en = 1
        self._m.wr_en = 0
        self._m.addr = addr
        self._m.data_in = 0

    def set_write(self, addr, data):
        self._m.en = 1
        self._m.wr_en = 1
        self._m.addr = addr
        self._m.data_in = data

    def get_read(self):
        return self._m.data_out
