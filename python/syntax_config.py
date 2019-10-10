"""
File Name:

Authors: Kyle Seidenthal

Date: 09-10-2019

Description: Functions that allow configuration of C syntax checking

"""
import json
import os
import vim

CONFIG_FILE_NAME = ".KyleVimCSyntaxConfig"


def set_command_for_file(filename, command):
    """
    Set the compilation command for the given filename

    :param filename: The name of the file
    :param command: The command used to compile it
    :returns: None
    """

    if not _config_exists():
        _create_config()

    with open(CONFIG_FILE_NAME, 'r') as json_file:
        try:
            data = json.load(json_file)
        except Exception as e:
            data = {}

    data[filename] = command

    with open(CONFIG_FILE_NAME, 'w') as json_file:
        json.dump(data, json_file)


def get_command_for_file(filename):
    """
    Get the command for the given file

    :param filename: The name of the file
    :returns: The command to run for compilation
    """

    if not _config_exists():
        return
    else:
        with open(CONFIG_FILE_NAME) as json_file:
            data = json.load(json_file)

            if filename not in data.keys():

                try:
                    vim.bindeval("g:CurSyntaxCommand")
                    command_str = "unlet g:CurSyntaxCommand"
                except Exception as e:
                    command_str = ""
            else:
                command_str = "let g:CurSyntaxCommand = \""\
                        + data[filename] + "\""

            vim.command(command_str)


def _config_exists():
    """
    Check to see if the config file exists

    :returns: True if the file exists, false otherwise
    """
    return os.path.isfile(CONFIG_FILE_NAME)


def _create_config():
    """
    Create the config file

    :returns: None
    """
    with open(CONFIG_FILE_NAME, 'w') as json_file:
        json.dump({}, json_file)
