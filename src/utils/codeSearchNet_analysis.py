# decompress this gzip file
!gzip -d python/final/jsonl/test/python_test_0.jsonl.gz

with open('python/final/jsonl/test/python_test_0.jsonl', 'r') as f:
    sample_file = f.readlines()
sample_file[0]