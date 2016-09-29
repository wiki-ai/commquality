"""
Aggregates annotations into a single majority rules label

"""
import json
import sys
from itertools import groupby
from statistics import mean


def main(argv=None):
    rows = (json.loads(line) for line in sys.stdin)

    for rev_id, row_set in groupby(rows, lambda r: r['rev_id']):
        row_set = list(row_set)
        doc = {
            'rev_id': rev_id,
            'other': mean(row['other'] for row in row_set) >= 0.5,
            'third_party': mean(row['third_party'] for row in row_set) >= 0.5,
            'recipient': mean(row['recipient'] for row in row_set) >= 0.5,
            'quoting': mean(row['quoting'] for row in row_set) >= 0.5,
            'attack': mean(row['attack'] for row in row_set) >= 0.5,
            'aggression': mean(row['aggression'] for row in row_set) >= 0.5
        }
        print(json.dumps(doc))


if __name__ == "__main__":
    main()
