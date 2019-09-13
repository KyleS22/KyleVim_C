"""
File Name: auto_function_headers.py

Authors: Kyle Seidenthal

Date: 10-09-2019

Description: A module that provides functionality to add function headers to C
and C++ files

"""

import vim


def insert_header_comment(line_num):
    """
    Insert the correct auto-generated header comment for line_num

    :param line_num: The line number to generate a header for
    :returns: None
    :raises IOException: If the given line_num os not able to be cast to an
    integer
    """

    try:
        line_num = int(line_num)
    except Exception as e:
        raise IOException("You must give a line number")

    header_type = _check_header_type(line_num)

    if header_type is None:
        return False

    elif header_type == "FUNC_DEC":
        _insert_function_dec_header(line_num)

    elif header_type == "FUNC_BOD":
        _insert_function_body_header(line_num)

    elif header_type == "CLASS":
        _insert_class_header(line_num)

    elif header_type == "STRUCT":
        _insert_struct_header(line_num)


def _check_header_type(line_num):
    """
    Check to see what type of header should be inserted.

    If this is a function declaration, a full header is the correct type
    If this is a function body, a simple comment is required
    If this is a class, a comment with an example space should be used
    If this is a struct, a simple comment should be used

    :param line_num: The line number with the function on it
    :returns: A string representing the type of header required
    """

    current_buffer = vim.current.buffer
    line = current_buffer[line_num-1]

    if "(" in line and line.endswith(";"):
        return "FUNC_DEC"

    elif "(" in line and (line.endswith("{") or line.endswith(")")):
        return "FUNC_BOD"

    elif "class" in line:
        return "CLASS"

    elif "struct" in line:
        return "STRUCT"

    else:
        return None


def _insert_function_dec_header(line_num):
    """
    Insert a function header for a function declaration

    :param line_num: The line number that the function is on
    :returns: None
    """

    current_buffer = vim.current.buffer
    line = current_buffer[line_num-1]

    # Check for multi-line definitions
    temp_line_num = line_num + 1

    while line.endswith(","):
        line += " " + current_buffer[temp_line_num-1].lstrip()
        temp_line_num += 1

    # Parse function name and params
    parts = line.split("(")

    params = parts[1]
    params = params.split(")")[0]
    params = params.split(",")

    # Indent the docstring to the function indentation level
    spaces = _check_indentation(line_num)

    # Build the comment block
    comment = ["// {% What it do %}"]

    if len(params) > 0 and params[0] != "":
        comment.append("//")

    for p in params:
        if p == "":
            continue
        comment.append("// param " + p.strip() + ": {% A parameter %}")

    comment.append("//")
    comment.append("// returns: {% A thing %}")

    for i in range(len(comment)):
        comment[i] = spaces + comment[i]

    # Insert the comment block
    current_buffer.append(comment, temp_line_num-2)


def _insert_function_body_header(line_num):
    """
    Insert a function header for a function body

    :param line_num: The line number that the function is on
    :returns: None
    """
    current_buffer = vim.current.buffer
    line = current_buffer[line_num-1]

    # Check for multi-line definitions
    temp_line_num = line_num + 1

    while line.endswith(","):
        line += " " + current_buffer[temp_line_num-1].lstrip()
        temp_line_num += 1

    # Parse function name and params
    parts = line.split("(")

    params = parts[1]
    params = params.split(")")[0]
    params = params.split(",")

    # Indent the docstring to the function indentation level
    spaces = _check_indentation(line_num)

    # Build the comment block
    comment = "// {% How it do %}"

    comment = spaces + comment

    # Insert the comment block
    current_buffer.append(comment, temp_line_num-2)


def _insert_class_header(line_num):
    """
    Insert a class comment

    :param line_num: The line number that the class declaration appears on
    :returns: None
    """

    pass


def _insert_struct_header(line_num):
    """
    Insert a struct comment

    :param line_num: The line number that the struct is on
    :returns: None
    """

    pass


def _check_indentation(line_num):
    """
    Returns a string with the correct indentation for the comment block

    :param line_num: The line number that the function is on
    :returns: A string with tabs in it to append to your comment lines
    """

    indent = int(vim.eval("indent(" + str(line_num) + ")"))

    spaces = ""

    for i in range(indent):
        spaces += " "

    return spaces
