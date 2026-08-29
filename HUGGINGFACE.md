# Hugging Face — Extended Guide

This guide expands on how to use Hugging Face models, Datasets, and Spaces when building chatbots, AI agents, MCP services, and embeddings.

## Quick setup

1. Create a token at https://huggingface.co/settings/tokens and keep it secret.
2. Add `HUGGINGFACE_HUB_TOKEN` to your environment or `.env` (see `.env.example`).
3. Install packages:

```bash
pip install transformers datasets huggingface_hub sentence-transformers chromadb gradio
```

## Inference: local vs hosted

- Local: use `transformers` / `sentence-transformers` to load models locally (requires disk and sometimes a GPU).
- Hosted: use the Hugging Face Inference API or a model's hosted endpoint for lower-maintenance inference. Use `huggingface_hub` or simple HTTP requests to the Inference API.

Example: simple Inference API call (Python requests):

```python
import os
import requests

API_URL = 'https://api-inference.huggingface.co/models/gpt2'
headers = {'Authorization': f"Bearer {os.environ['HUGGINGFACE_HUB_TOKEN']}"}

def query(payload):
    resp = requests.post(API_URL, headers=headers, json=payload)
    return resp.json()

print(query({'inputs': 'Hello! Tell me a friendly greeting.'}))
```

## Embeddings, vector store, and RAG flow

1. Create embeddings with `sentence-transformers`.
2. Persist vectors to a vector DB (Chroma example below).
3. At query time, retrieve the top-k documents and include them in a prompt to the LLM.

Embeddings + Chroma example:

```python
from sentence_transformers import SentenceTransformer
import chromadb

model = SentenceTransformer('all-MiniLM-L6-v2')
texts = ['Doc one text', 'Doc two text']
embs = model.encode(texts)

client = chromadb.Client()
col = client.create_collection('my_docs')
col.add(ids=['d1','d2'], documents=texts, embeddings=embs.tolist())

# Retrieval
results = col.query(query_embeddings=model.encode(['query']), n_results=2)
print(results)
```

## LangChain-style snippet (retriever -> LLM)

This pattern is useful when wiring a chatbot or agent: create a retriever that returns relevant docs and then call an LLM with the retrieved context.

```python
# Pseudocode / conceptual
from langchain import OpenAI, RetrievalQA, VectorDBRetriever

# Use your Hugging Face model as the LLM provider or call the Inference API
# retriever = VectorDBRetriever(chroma_collection)
# qa_chain = RetrievalQA(llm=hf_llm, retriever=retriever)
# answer = qa_chain.run('What is X?')
```

## Agents and MCP

- Agents: keep the LLM role focused on planning and language while the agent runtime executes tools/actions (APIs, system calls, DB queries).
- MCP: when using Model Context Protocol, include retrieved documents, tool descriptions, and memory in the `context` payload passed to the model call. MCP orchestrates calling the LLM and external tools; configure the MCP LLM integration to call a Hub model endpoint or your hosted inference service.

Example MCP-style payload (conceptual):

```json
{
  "model": "hf://gpt-neo-2.7B",
  "input": "Answer the user using the following context:",
  "context": {
    "documents": ["doc text A...", "doc text B..."],
    "tools": [{ "name": "search", "description": "Search company docs" }]
  },
  "instructions": "Be concise and cite sources."
}
```

## Spaces (Gradio) quick demo

Create a simple Gradio app and push to a Space for sharing:

```python
import gradio as gr
from transformers import pipeline

gen = pipeline('text-generation', model='gpt2')

def chat(inp):
    out = gen(inp, max_length=120)[0]['generated_text']
    return out

demo = gr.Interface(chat, gr.Textbox(lines=2, label='User'), gr.Textbox(label='Model'))
demo.launch()
```

Push to a Space using `huggingface-cli` (login then `huggingface-cli repo create --type space my-space` and `git push`). See Hugging Face docs.

## Datasets

Use `datasets` to load and preprocess datasets for fine-tuning or evaluation. Example: `load_dataset('squad')`.

## Production tips

- For latency-critical apps, use hosted inference endpoints or smaller distilled models.
- Monitor model outputs for safety and hallucinations; add semantic checks and human-in-loop review where needed.
- Add rate limits, caching, and batching for efficiency.

## Resources

- Hugging Face docs: https://huggingface.co/docs
- Sentence-Transformers: https://www.sbert.net/

If you'd like, I can also add a runnable Jupyter notebook (`notebooks/rag_example.ipynb`) that demonstrates creating embeddings, storing them in Chroma, and running a simple retrieval + generation flow. Reply 'notebook' and I'll create it.
