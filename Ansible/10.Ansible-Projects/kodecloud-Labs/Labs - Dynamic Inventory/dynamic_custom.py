#!/usr/bin/env python3

'''
Example custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse
import json

class ExampleInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.example_inventory()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self.inventory = self.empty_inventory()

        # Use Python 3 compatible print function
        print(json.dumps(self.inventory))

    # Example inventory for testing.
    def example_inventory(self):
        return {
            'group': {
                'hosts': ['172.20.1.101', '172.20.1.102', '172.20.1.103'],
                'vars': {
                    'ansible_ssh_user': 'root',
                    'ansible_ssh_pass': 'Passw0rd'
                }
            },
            '_meta': {
                'hostvars': {
                    '172.20.1.101': {
                        'host_specific_var': 'custom1'
                    },
                    '172.20.1.102': {
                        'host_specific_var': 'custom2'
                    },
                    '172.20.1.103': {
                        'host_specific_var': 'custom3'
                    }
                }
            }
        }

    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action='store_true')
        parser.add_argument('--host', action='store')
        self.args = parser.parse_args()

# Get the inventory.
ExampleInventory()
