from langchain import HuggingFacePipeline

from transformers import AutoTokenizer

import transformers

import torch

from pandasai import Agent

from pandasai.llm import LangchainLLM

model = "meta-llama/Llama-2-7b-chat-hf"

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

langchain_llm = HuggingFacePipeline(pipeline=pipeline, model_kwargs={'temperature': 0})

llm = LangchainLLM(langchain_llm=langchain_llm)
df = Agent(
    ["examples/data/Loan payments data.csv"],
    config={"llm": llm, "enable_cache": False, "max_retries": 1},
)
response = df.chat("How many loans are from men and have been paid off?")
print(response)
