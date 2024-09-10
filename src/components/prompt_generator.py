from langchain.output_parsers import ResponseSchema, StructuredOutputParser
from langchain.prompts.few_shot import FewShotPromptTemplate
from langchain.prompts.prompt import PromptTemplate


class PromptGenerator:
    def __init__(self) -> None:
        pass
    def create_few_shot_code_prompts(self, examples_task_ids, examples_db, prompt_template, api_reference):
        examples = self.get_similar_tasks_based_on_specs(examples_task_ids, examples_db) 
        # print(f"examples: {examples}")
        example_prompt_template = PromptTemplate(
            input_variables=["task_description", "method_signature", "api_with_preconditions" , "code"],
            template_format='jinja2',
            template=prompt_template
        )
        print(f"example_prompt_template: \n {example_prompt_template}")
       
        prompt = FewShotPromptTemplate(
            prefix= f"SYSTEM:\nYou are an expert code assistant tasked with implementing Dafny code for filesystem operations. Your implementation should adhere to the following guidelines:\n- Must utilize given Safe APIs for file operations.\n- Generate Dafny code with appropriate preconditions to satisfy safe API preconditions.\n- Ensure that the code satisfies given safety properties for filesystem operations.\n- You are only limited to the provided method signatures and preconditions.\n\nAPI Reference:\n" + api_reference + "\n\n",
            examples=examples,
            example_prompt=example_prompt_template,
            suffix="""Task Description: {{task}}\n Method Signature:\n {{method_signature}}\n\nAI ASSISTANT:\n\n""",
            input_variables=["task", "method_signature",],
            example_separator="\n------------------------------------------------------\n",
            template_format='jinja2'
        )
        # print("Generated prompt successfully")
        # print(f"Suffix: {prompt.suffix}")
        return prompt


    def get_similar_tasks_based_on_specs(self, ids, examples_db):
        print("inside get_similar_tasks_based_on_specs")
        similar_examples = []
        for id in ids:
            new_obj = {}
            obj = examples_db[id]
            new_obj['code'] = obj['code']
            new_obj['task_description'] = obj['task_description']
            new_obj['method_signature'] = obj['method_signature']
            new_obj['api_with_preconditions'] = obj['api_with_preconditions']
            # new_obj['all_api_with_preconditions'] = obj['all_api_with_preconditions']
            # new_obj['safety_properties'] = obj['safety_properties']
            # new_obj['verification_conditions'] = obj['spec']['verification_conditions']
            # new_obj['verification_methods_signature'] = obj['spec']['verification_methods_signature']
            # new_obj['fileIO_methods_signature'] = obj['fileIO_methods_signature']
    
            similar_examples.append(new_obj)
            # print(f"simmilar_examples: {similar_examples}")
        return similar_examples


    # def create_few_shot_specification_prompts(self, examples_task_ids, examples_db, prompt_template):
    #     print(f"\n \n inside few shot spe: {examples_task_ids} \n \n")
    #     # vc_example_selector=vc_example_selector,
    #     examples = self.get_similar_tasks_based_on_sp_description(examples_task_ids, examples_db)
    #     print(f"\n \n =========================== \n\n examples: \n\n {examples} \n\n")
    #     example_prompt_template = PromptTemplate(
    #         # input_variables=["task_description", "method_signature", "safety_properties"],
    #         # input_variables=["safety_properties", "'verification_method_signature", "verification_method_description", "verification_conditions"],
    #         input_variables=["safety_properties", "'verification_method_signature", "verification_conditions","fileIO_methods_signature"],   
    #         template_format='jinja2',
    #         template=prompt_template,

    #     )
    #     print(f"\n\n example_prompt_template: \n\n {example_prompt_template} \n\n")
    #     prompt = FewShotPromptTemplate(
    #         # prefix="SYSTEM:\n Your task is to implement verification conditions (preconditions/posconditions) in Dafny.Your task is to map each given safety propertt to its equivalent in the provided list. Then find the verification method signatures in the given list. Finally generate verification conditions using these signatures.\n\n",
    #         prefix="SYSTEM:\n The list of safety properties and their corresponding verification methods and verification methods descriptions are provided.",
    #         examples=examples,
    #         example_prompt=example_prompt_template,
    #         suffix='''Task:\n{{task}}\n''',
    #         input_variables=["task"],
    #         example_separator="\n------------------------------------------------------\n",
    #         template_format='jinja2'
    #     )
    #     print(f"\n\n SPEC prompt: \n\n {prompt} \n\n")
    #     return prompt


    # def get_similar_tasks_based_on_sp_description(self, ids, examples_db):
    #     # examples_db it's a list
    #     similar_examples = []
    #     for id in ids:
    #         new_obj = {}
    #         obj = examples_db[id]
    #         # new_obj['code'] = obj['code']
    #         # new_obj['task_description'] = obj['task_description']
    #         # new_obj['method_signature'] = obj['method_signature']
    #         new_obj['verification_conditions'] = obj['spec']['verification_conditions']
    #         new_obj['verification_methods_signature'] = obj['spec']['verification_methods_signature']
    #         new_obj['safety_properties'] = obj['safety_properties']
    #         new_obj['fileIO_methods_signature'] = obj['fileIO_methods_signature']
    #         # new_obj['verification_method_description'] = obj['spec']['verification_method_description']
    #         similar_examples.append(new_obj)
      
    #     return similar_examples


    # def get_specification_output_parser(self):
    #     response_schemas = [
    #         ResponseSchema(name="verification_methods_signature", description="Verification Method Signature"),
    #         ResponseSchema(name="task_description", description="task_description"),
    #         ResponseSchema(name="safety_properties", description="Safety Properties"),
    #     ]
    #     specifications_parser = StructuredOutputParser.from_response_schemas(response_schemas)
    #     return specifications_parser

    # def format_safety_properties_and_methods(self, data):
    #     formatted = ""
    #     for key, value in data.items():
    #         formatted += f"Property {value['sp_id']}: {value['safety_property']}\n"
    #         formatted += f"Verification Method: {value['verification_methods_signature']}\n"
    #     return formatted.strip()
    # def format_safety_properties_and_verifications(self, data):
    #     formatted = ""
    #     for key, value in data.items():
    #         formatted += f"    {value['sp_id']}. Safety Property: {value['safety_property']}\n"
    #         formatted += f"       Verification: {value['verification_methods_signature']}\n"
    #     return formatted.strip()

    # def create_safety_property_explanations(self, data):
    #     return "\n".join([f"    {value['sp_id']}. {{explanation_{value['sp_id']}}}" for value in data.values()])

    # def get_sp_vc_for_code_prompt(self, sp_json_data):
    #     safety_properties_and_methods = self.format_safety_properties_and_methods(sp_json_data)
    #     safety_properties_and_verifications = self.format_safety_properties_and_verifications(sp_json_data)
    #     safety_property_explanations = self.create_safety_property_explanations(sp_json_data)
        
    #     return  safety_properties_and_methods, safety_properties_and_verifications,safety_property_explanations
    

# # Define a function to format each example using the provided template
# class PromptGenerator:
#     def __init__(self) -> None:
#         pass
    
#     def format_example(example, template):
#         return template.format(
#             task_description=example["task_description"],
#             method_signature=example["method_signature"],
#             preconditions=example["preconditions"],
#             postconditions=example["postconditions"],
#             code=example["code"]
#         )
        

        
#     def create_few_shot_code_prompts(self, examples_task_ids, examples_db, prompt_template):
#         # Fetch similar tasks based on specifications
        # examples = self.get_similar_tasks_based_on_specs(examples_task_ids, examples_db)
        

        
#         # Format each example using the prompt template
#         formatted_examples = [self.format_example(ex, prompt_template) for ex in examples]
        
#         # Define the prefix and suffix
#         prefix = ("SYSTEM:\nYou are an expert AI assistant that writes Dafny programs. You are very good at writing "
#                 "verifiable correct code in terms of preconditions and postconditions of methods, and at finding the "
#                 "appropriate loop invariants for the pre/postconditions to hold.\n\n")
        
#         example_separator = "\n------------------------------------------------------\n"
        
#         suffix = "TASK:\n{{task}}\n\nAI ASSISTANT:\n\n"

#         # Combine prefix, formatted examples, and suffix to create the final prompt
#         combined_examples = example_separator.join(formatted_examples)
#         final_prompt_template = prefix + combined_examples + suffix

#         return final_prompt_template


#     def get_similar_tasks_based_on_specs(ids, examples_db):
#         similar_examples = []
#         for id in ids:
#             new_obj = {}
#             obj = examples_db[id]
#             new_obj['code'] = obj['code']
#             new_obj['task_description'] = obj['task_description']
#             new_obj['method_signature'] = obj['specification']['method_signature']
#             new_obj['preconditions'] = obj['specification']['preconditions']
#             new_obj['postconditions'] = obj['specification']['postconditions']
#             similar_examples.append(new_obj)
#         return similar_examples

#     # Define a function to format each example using the provided template
#     def format_spec_example(self, example, template):
#         return template.format(
#             task_description=example["task_description"],
#             method_signature=example["method_signature"],
#             postconditions=example["postconditions"]
#         )

#     def create_few_shot_specification_prompts(self, examples_task_ids, examples_db, prompt_template):
#         # Fetch similar tasks based on task descriptions
#         examples = self.get_similar_tasks_based_on_task_description(examples_task_ids, examples_db)
        
#         # Format each example using the prompt template
#         formatted_examples = [self.format_spec_example(ex, prompt_template) for ex in examples]
        
#         # Define the suffix
#         # suffix = "Task:\n{{task}}\n"

#         example_separator = "\n------------------------------------------------------\n"

#         # Combine formatted examples and suffix to create the final prompt
#         combined_examples = example_separator.join(formatted_examples)
#         print(f"combined_examples: {combined_examples}")
        
#         # Append suffix only once at the end
#         final_prompt_template = combined_examples + example_separator

#         return final_prompt_template


#     def get_similar_tasks_based_on_task_description(self, ids, examples_db):
#         # examples_db it's a list
#         similar_examples = []
#         for id in ids:
#             new_obj = {}
#             obj = examples_db[id]
#             new_obj['task_description'] = obj['task_description']
#             new_obj['method_signature'] = obj['specification']['method_signature']
#             new_obj['postconditions'] = obj['specification']['postconditions']
#             similar_examples.append(new_obj)
#         return similar_examples


#     def parse_specification_output(self, response_text):
#         response_schemas = [
#             {"name": "method_signature", "description": "Method Signature"},
#             {"name": "postconditions", "description": "Postconditions"}
#         ]
#         parsed_output = {}
        
#         for schema in response_schemas:
#             field_name = schema["name"]
#             field_description = schema["description"]
            
#             # Simple heuristic-based parsing
#             start_marker = f"{field_description}:"
#             start_index = response_text.find(start_marker)
            
#             if start_index != -1:
#                 start_index += len(start_marker)
#                 end_index = response_text.find("\n", start_index)
#                 if end_index == -1:
#                     end_index = len(response_text)
#                 parsed_output[field_name] = response_text[start_index:end_index].strip()
#             else:
#                 parsed_output[field_name] = None
        
#         return parsed_output
