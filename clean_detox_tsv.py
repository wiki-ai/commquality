"""
Cleans up the original Detox TSV files

"""
import csv
import json
import sys
import traceback


def main(argv=None):

    rows = csv.DictReader(sys.stdin, delimiter='\t', quotechar="\"")
    
    for row in rows:
        try:
            del row['diff']
            del row['clean_diff']
            doc = {
                'rev_id': int(row['rev_id']),
                'ns_name': row['ns'],
                'src': row['src'],
                'sample': row['sample'],
                'worker_id': int(row['_worker_id']),
                'user_id': int(float(row['user_id'] or "0")),
                'other': bool(float(row['other'])),
                'third_party': bool(float(row['third_party'])),
                'recipient': bool(float(row['recipient'])),
                'quoting': bool(float(row['quoting'])),
                'attack': bool(float(row['attack'])),
                'aggression': bool(float(row['aggression']))
            }

            print(json.dumps(doc))
        except Exception:
            sys.stderr.write("Error while processing row: {0}".format(row))
            sys.stderr.write(traceback.format_exc())


if __name__ == "__main__": main()
