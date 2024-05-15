# PCCC
Proof Carrying Code Completions

# Tutorials
## How does it work?
```
python3 main.py path_to_prompt path_to_save_generated_code number_of_attempts 
```

For instance, this is a command to run fibonacci prompt to generate fibonacci method in Dafny and save it in a fibonacci.dfy file and repeating the validation process 5 times:
```
python3 main.py ./examples/prompts/Dafny/fibonacci.txt ./examples/generated_codes/fibonacci.dfy 5
```
