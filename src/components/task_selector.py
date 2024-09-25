from langchain_core.example_selectors import MaxMarginalRelevanceExampleSelector
from langchain_core.example_selectors import SemanticSimilarityExampleSelector
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings


def get_semantic_similarity_example_selector(api_key, example_db_tasks, number_of_similar_tasks):
    return SemanticSimilarityExampleSelector.from_examples(
        # This is the list of examples available to select from.
        example_db_tasks,
        # This is the embedding class used to produce embeddings which are used to measure semantic similarity.
        OpenAIEmbeddings(openai_api_key=api_key),
        # This is the VectorStore class that is used to store the embeddings and do a similarity search over.
        FAISS,
        # This is the number of examples to produce.
        k=number_of_similar_tasks
    )


def get_max_marginal_relevance_based_example_selector(api_key, example_db_tasks, number_of_similar_tasks):
    return MaxMarginalRelevanceExampleSelector.from_examples(
        # This is the list of examples available to select from.
        example_db_tasks,
        # This is the embedding class used to produce embeddings which are used to measure semantic similarity.
        OpenAIEmbeddings(openai_api_key=api_key),
        # This is the VectorStore class that is used to store the embeddings and do a similarity search over.
        FAISS,
        # This is the number of examples to produce.
        k=number_of_similar_tasks,
    )

# from sentence_transformers import SentenceTransformer, util
# import faiss
# import openai
# from openai import OpenAI
# import numpy as np
# from sklearn.metrics.pairwise import cosine_similarity
# import random

# def get_embeddings(api_key, tasks):
#     client = OpenAI(api_key = api_key)
#     embeddings = []
#     for task in tasks:
#         response = client.embeddings.create(input=task['task_description'], model="text-embedding-ada-002")  # Choose the appropriate model
#         embeddings.append(response.data[0].embedding)
#     return np.array(embeddings)

# def build_faiss_index(embeddings):
#     dimension = embeddings.shape[1]
#     index = faiss.IndexFlatL2(dimension)  # Using L2 distance for similarity
#     index.add(embeddings)
#     return index

# def find_similar_tasks(index, query_embedding, tasks, k):
#     D, I = index.search(np.array([query_embedding]), k)  # D is the distances, I are the indices of the nearest neighbors
#     return [tasks[i] for i in I[0]]

# def find_similar_tasks_cosine(embeddings, query_embedding, tasks, k):
#     # Compute cosine similarity between query embedding and all task embeddings
#     cosine_sim = cosine_similarity([query_embedding], embeddings)[0]
#     top_indices = np.argsort(cosine_sim)[-k:][::-1]
#     return [tasks[idx] for idx in top_indices]

# def find_all_semantic_similar_tasks(api_key, example_db_tasks, number_of_similar_tasks):
#     task_embeddings = get_embeddings(api_key, example_db_tasks)
#     # print(f"Task embeddings: {task_embeddings}")
#     index = build_faiss_index(task_embeddings)
#     all_similar_tasks = {}
#     for i, task in enumerate(example_db_tasks):
#         query_embedding = task_embeddings[i]
#         similar_tasks = find_similar_tasks(index, query_embedding, example_db_tasks, number_of_similar_tasks + 1)  # +1 to exclude the task itself
#         # print(f"Similar tasks for {task}: {similar_tasks}")
#         similar_tasks = [t for t in similar_tasks if t['task_id'] != task['task_id']][:number_of_similar_tasks]
#         # print(f"Similar tasks for {task}: {similar_tasks}")
#         all_similar_tasks = dict(all_similar_tasks, **{task['task_id']: similar_tasks})
#     return all_similar_tasks

# def find_semantic_similar_tasks(api_key, example_db_tasks, number_of_similar_tasks, target_task):
#     client = OpenAI(api_key = api_key)
#     # Get embeddings for all tasks
#     task_embeddings = get_embeddings(api_key, example_db_tasks)
#     index = build_faiss_index(task_embeddings)

#     # Get embedding for the target task description
#     target_embedding_response = client.embeddings.create(model="text-embedding-ada-002", input=target_task['task_description'])
#     target_embedding = target_embedding_response.data[0].embedding

#     if random.choice([True, False]):
#         # Find similar tasks with cosine similarity
#         similar_tasks = find_similar_tasks_cosine(task_embeddings, target_embedding, example_db_tasks, number_of_similar_tasks)
#     else:    
#         # Find similar tasks with querying the Index
#         similar_tasks = find_similar_tasks(index, target_embedding, example_db_tasks, number_of_similar_tasks)

#     return {target_task['task_id']: similar_tasks}