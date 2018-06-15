from collections import defaultdict
from hypothesis import given
from hypothesis.stateful import Bundle, RuleBasedStateMachine, rule
import hypothesis.strategies as st
import unittest

from slime.py.ram import Ram


class MemoryComparison(RuleBasedStateMachine):
    def __init__(self):
        super(MemoryComparison, self).__init__()
        self.model = defaultdict(int)
        self.uut = Ram()
        self.uut.reset()
        self.uut.clock(1)
        self.uut.eval()
        self.uut.clock(0)
        self.uut.eval()

    keys = Bundle('keys')
    values = Bundle('values')

    @rule(target=keys, k=st.integers(0, 2**14-1))
    def k(self, k):
        return k

    @rule(target=values, v=st.integers(0, 2**64-1))
    def v(self, v):
        return v

    @rule(k=keys, v=values)
    def write(self, k, v):
        # Do model
        self.model[k] = v

        # Do write
        self.uut.set_write(k, v)
        self.uut.clock(1)
        self.uut.eval()
        self.uut.clock(0)
        self.uut.eval()

    @rule(k=keys)
    def read_agrees(self, k):
        # Do read
        self.uut.set_read(k)
        self.uut.clock(1)
        self.uut.eval()
        self.uut.clock(0)
        self.uut.eval()

        assert self.model[k] == self.uut.get_read()

    def teardown(self):
        self.uut.final()

TestMemoryComparison = MemoryComparison.TestCase

if __name__ == '__main__':
  unittest.main()
