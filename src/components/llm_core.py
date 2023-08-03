import openai

openai.api_key = open("src/api_key.txt", "r").read().strip('\n')

def get_user_input():
    defined_role = input("Role >> ")
    user_input = input("Input >> ")
    chats = chat(content=user_input, role=defined_role)
    return chats


def chat(content, role = "user"):
    message_history = []
    message_history.append({
    "role": role, 
    "content": content
    }),
    completion = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages= message_history,
        # max_tokens=8000  # Adjust the number of tokens to control the response length.
    )
    reply_content = completion.choices[0].message.content
    message_history.append({role: 'assistant', 'content': reply_content})
    return reply_content



def llm_core():
    print("Type start to begin the chat and exit to termintate it.")
    user_instruction = input("Instruction >> ")
    while (user_instruction != "exit"):
        print(f"{get_user_input()}")