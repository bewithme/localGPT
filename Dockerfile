FROM registry.cn-hangzhou.aliyuncs.com/bewithmeallmylife/11.4.0-cudnn8-runtime-ubuntu18.04-conda-python3.8-qt5:1.0.0

USER root
ENV PATH /root/anaconda3/bin:$PATH
RUN  conda create -n local_gpt python=3.10 -y
SHELL ["conda", "run", "-n", "local_gpt", "/bin/bash", "-c"]
ENV LANGUAGE zh_CN:zh


RUN pip install langchain==0.0.267 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install chromadb==0.4.6 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install pdfminer.six==20221105 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install InstructorEmbedding -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install sentence-transformers -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install faiss-cpu -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install huggingface_hub -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install protobuf==3.20.2  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install protobuf==3.20.2  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install protobuf==3.20.3  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install auto-gptq==0.2.2 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install docx2txt -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install unstructured -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install unstructured[pdf] -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install urllib3==1.26.6 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install accelerate==0.24.1 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install bitsandbytes  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install click -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install flask -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install requests -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com

RUN pip install streamlit -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install Streamlit-extras -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install openpyxl -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install llama-cpp-python==0.1.83 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
#删除sentence-transformers依赖的torch
RUN pip uninstall torch -y
#删除sentence-transformers依赖的torch
RUN pip uninstall torchvision -y
#安装torch==2.0.1以支持cuda11.4
RUN pip install torch==2.0.1  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
#修复ImportError: Using `load_in_8bit=True` requires Accelerate:
RUN pip install transformers==4.31.0  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install torchvision==0.15.2  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com

WORKDIR /app/localGPT
ADD localGPTUI localGPTUI
ADD SOURCE_DOCUMENTS SOURCE_DOCUMENTS
ADD constants.py constants.py
ADD crawl.py crawl.py
ADD ingest.py ingest.py
ADD load_models.py load_models.py
ADD localGPT_UI.py localGPT_UI.py
ADD prompt_template_utils.py prompt_template_utils.py
ADD run_localGPT.py run_localGPT.py
ADD run_localGPT_API.py run_localGPT_API.py
ADD utils.py utils.py
#To fix IndexError: list index out of range when you run  python ingest.py
RUN apt-get install ffmpeg libsm6 libxext6  -y


# HF_ENDPOINT=https://hf-mirror.com python ingest.py --device_type cuda
# HF_ENDPOINT=https://hf-mirror.com python run_localGPT.py --show_sources --device_type cuda
# curl -X POST -d "user_prompt=你是谁？"  http://127.0.0.1:5110/api/prompt_route   can test HF_ENDPOINT=https://hf-mirror.com python run_localGPT_API.py --show_sources --device_type cuda
#sudo docker build -t='registry.cn-hangzhou.aliyuncs.com/bewithmeallmylife/local-gpt-app-cuda-11.4.0:1.0.0' .

#sudo docker run --net=host  --gpus '"device=0,1"' --privileged -v /data-bakup/LLM/nltk_data:/root/nltk_data  -v /data-bakup/LLM/localGPT:/app/localGPT -v /data-bakup/LLM/cache:/root/.cache -it -d registry.cn-hangzhou.aliyuncs.com/bewithmeallmylife/local-gpt-app-cuda-11.4.0:1.0.0
