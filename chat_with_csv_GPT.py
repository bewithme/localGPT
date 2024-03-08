from langchain import HuggingFacePipeline

from transformers import AutoTokenizer

from langchain.embeddings import HuggingFaceEmbeddings

from langchain.document_loaders.csv_loader import CSVLoader

from langchain.vectorstores import Chroma

from langchain.chains import RetrievalQA

import transformers

import torch

import textwrap
from chromadb.config import Settings
import os

# model = "meta-llama/Llama-2-7b-chat-hf"
model = "models/models--hfl--chinese-alpaca-2-13b/snapshots/4b896a8bb507af3107517d2a36eb611675db3ed6"


tokenizer = AutoTokenizer.from_pretrained(model)

pipeline = transformers.pipeline(

    "text-generation",  # task

    model=model,

    tokenizer=tokenizer,

    torch_dtype=torch.bfloat16,

    trust_remote_code=True,

    device_map="auto",

    max_length=1000,

    do_sample=True,

    top_k=10,

    num_return_sequences=1,

    eos_token_id=tokenizer.eos_token_id

)

llm = HuggingFacePipeline(pipeline=pipeline, model_kwargs={'temperature': 0})
embeddings = HuggingFaceEmbeddings(model_name='shibing624/text2vec-base-chinese', model_kwargs={'device': 'cuda'})
loader = CSVLoader('data/employees.csv', encoding="utf-8", csv_args={'delimiter': ','})

data = loader.load()
CHROMA_SETTINGS = Settings(
    anonymized_telemetry=False,
    is_persistent=True,
)

ROOT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))

PERSIST_DIRECTORY = f"{ROOT_DIRECTORY}/DB1"


db = Chroma.from_documents(
    data,
    embeddings,
    persist_directory=PERSIST_DIRECTORY,
    client_settings=CHROMA_SETTINGS,
)
retriever = db.as_retriever()
chain = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", return_source_documents=True,
                                    retriever=retriever)

query = "What is the Donald's  employee id?"

result = chain(query)

wrapped_text = textwrap.fill(result['result'], width=500)

print(wrapped_text)
