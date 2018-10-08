#!/usr/bin/python

import sys
import json


def word_count(string):
    words = string.lower().split()
    result = {}
    for word in words:
        if word not in result:
            result[word] = 0
        result[word] += 1

    return result


if __name__ == "__main__":
    if len(sys.argv) > 1:
        print json.dumps(word_count(sys.argv[1]))
        sys.exit(0)
    else:
        sys.exit(1)
