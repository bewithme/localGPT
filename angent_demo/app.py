
from langchain.chains.conversation.memory import ConversationBufferWindowMemory
from custom_tool import PythagorasTool

from langchain import HuggingFacePipeline

from transformers import AutoTokenizer
from huggingface_hub.hf_api import HfFolder
import transformers
import torch

HfFolder.save_token('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')

model = "google/gemma-7b"


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

# initialize conversational memory
conversational_memory = ConversationBufferWindowMemory(
    memory_key='chat_history',
    k=5,
    return_messages=True
)
from langchain.agents import initialize_agent

# 可以配置多个工具，这样的话会跟据你的提示词来决定使用什么工具
tools = [PythagorasTool()]

# initialize agent with tools
agent = initialize_agent(
    agent='chat-conversational-react-description',
    tools=tools,
    llm=llm,
    verbose=True,
    max_iterations=3,
    early_stopping_method='generate',
    memory=conversational_memory
)
sys_msg = """Assistant is a large language model trained by OpenAI.

Assistant is designed to be able to assist with a wide range of tasks, from answering simple questions to providing in-depth explanations and discussions on a wide range of topics. As a language model, Assistant is able to generate human-like text based on the input it receives, allowing it to engage in natural-sounding conversations and provide responses that are coherent and relevant to the topic at hand.

Assistant is constantly learning and improving, and its capabilities are constantly evolving. It is able to process and understand large amounts of text, and can use this knowledge to provide accurate and informative responses to a wide range of questions. Additionally, Assistant is able to generate its own text based on the input it receives, allowing it to engage in discussions and provide explanations and descriptions on a wide range of topics.

Unfortunately, Assistant is terrible at maths. When provided with math questions, no matter how simple, assistant always refers to it's trusty tools and absolutely does NOT try to answer math questions by itself

Overall, Assistant is a powerful system that can help with a wide range of tasks and provide valuable insights and information on a wide range of topics. Whether you need help with a specific question or just want to have a conversation about a particular topic, Assistant is here to assist.
"""

new_prompt = agent.agent.create_prompt(
    system_message=sys_msg,
    tools=tools
)

agent.agent.llm_chain.prompt = new_prompt

print(agent("can you calculate the hypotenuse of the triangle wiht adjacent_side of 3 mm and opposite_side of 4 mm "))
