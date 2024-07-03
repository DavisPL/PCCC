# Define a function to format each example using the provided template
class PromptGenerator:
    def __init__(self) -> None:
        pass
    
    def format_example(example, template):
        return template.format(
            task_description=example["task_description"],
            method_signature=example["method_signature"],
            preconditions=example["preconditions"],
            postconditions=example["postconditions"],
            code=example["code"]
        )
        

        
    def create_few_shot_code_prompts(self, examples_task_ids, examples_db, prompt_template):
        # Fetch similar tasks based on specifications
        examples = self.get_similar_tasks_based_on_specs(examples_task_ids, examples_db)
        

        
        # Format each example using the prompt template
        formatted_examples = [self.format_example(ex, prompt_template) for ex in examples]
        
        # Define the prefix and suffix
        prefix = ("SYSTEM:\nYou are an expert AI assistant that writes Dafny programs. You are very good at writing "
                "verifiable correct code in terms of preconditions and postconditions of methods, and at finding the "
                "appropriate loop invariants for the pre/postconditions to hold.\n\n")
        
        example_separator = "\n------------------------------------------------------\n"
        
        suffix = "TASK:\n{{task}}\n\nAI ASSISTANT:\n\n"

        # Combine prefix, formatted examples, and suffix to create the final prompt
        combined_examples = example_separator.join(formatted_examples)
        final_prompt_template = prefix + combined_examples + suffix

        return final_prompt_template


    def get_similar_tasks_based_on_specs(ids, examples_db):
        similar_examples = []
        for id in ids:
            new_obj = {}
            obj = examples_db[id]
            new_obj['code'] = obj['code']
            new_obj['task_description'] = obj['task_description']
            new_obj['method_signature'] = obj['specification']['method_signature']
            new_obj['preconditions'] = obj['specification']['preconditions']
            new_obj['postconditions'] = obj['specification']['postconditions']
            similar_examples.append(new_obj)
        return similar_examples

    # Define a function to format each example using the provided template
    def format_spec_example(self, example, template):
        return template.format(
            task_description=example["task_description"],
            method_signature=example["method_signature"],
            postconditions=example["postconditions"]
        )

    def create_few_shot_specification_prompts(self, examples_task_ids, examples_db, prompt_template):
        # Fetch similar tasks based on task descriptions
        examples = self.get_similar_tasks_based_on_task_description(examples_task_ids, examples_db)
        
        # Format each example using the prompt template
        formatted_examples = [self.format_spec_example(ex, prompt_template) for ex in examples]
        
        # Define the suffix
        # suffix = "Task:\n{{task}}\n"

        example_separator = "\n------------------------------------------------------\n"

        # Combine formatted examples and suffix to create the final prompt
        combined_examples = example_separator.join(formatted_examples)
        print(f"combined_examples: {combined_examples}")
        
        # Append suffix only once at the end
        final_prompt_template = combined_examples + example_separator

        return final_prompt_template


    def get_similar_tasks_based_on_task_description(self, ids, examples_db):
        # examples_db it's a list
        similar_examples = []
        for id in ids:
            new_obj = {}
            obj = examples_db[id]
            new_obj['task_description'] = obj['task_description']
            new_obj['method_signature'] = obj['specification']['method_signature']
            new_obj['postconditions'] = obj['specification']['postconditions']
            similar_examples.append(new_obj)
        return similar_examples


    def parse_specification_output(self, response_text):
        response_schemas = [
            {"name": "method_signature", "description": "Method Signature"},
            {"name": "postconditions", "description": "Postconditions"}
        ]
        parsed_output = {}
        
        for schema in response_schemas:
            field_name = schema["name"]
            field_description = schema["description"]
            
            # Simple heuristic-based parsing
            start_marker = f"{field_description}:"
            start_index = response_text.find(start_marker)
            
            if start_index != -1:
                start_index += len(start_marker)
                end_index = response_text.find("\n", start_index)
                if end_index == -1:
                    end_index = len(response_text)
                parsed_output[field_name] = response_text[start_index:end_index].strip()
            else:
                parsed_output[field_name] = None
        
        return parsed_output

