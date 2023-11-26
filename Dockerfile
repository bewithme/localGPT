# syntax=docker/dockerfile:1
# Build as `docker build . -t localgpt`, requires BuildKit.
# Run as `docker run -it --mount src="$HOME/.cache",target=/root/.cache,type=bind --gpus=all localgpt`, requires Nvidia container toolkit.

FROM registry.cn-hangzhou.aliyuncs.com/bewithmeallmylife/cuda:11.7.1-runtime-ubuntu22.04
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 'A4B469963BF863CC'

ENV  TIME_ZONE Asia/Shanghai
ENV  DEBIAN_FRONTEND=noninteractive
ENV  LIBGL_ALWAYS_INDIRECT=1

RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get install -y g++-11 make python3 python-is-python3 pip


RUN pip install langchain==0.0.267 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install chromadb==0.4.6 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install pdfminer.six==20221105 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install InstructorEmbedding -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install sentence-transformers -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install faiss-cpu -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install huggingface_hub -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install transformers -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install protobuf==3.20.2  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install protobuf==3.20.2  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install protobuf==3.20.3  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install auto-gptq==0.2.2 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install docx2txt -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install unstructured -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install unstructured[pdf] -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install urllib3==1.26.6 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install accelerate -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install bitsandbytes  -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install bitsandbytes-windows -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install click -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install flask -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install requests -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com

RUN pip install streamlit -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install Streamlit-extras -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install openpyxl -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install llama-cpp-python==0.1.83 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com

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

# HF_ENDPOINT=https://hf-mirror.com python ingest.py
#sudo docker build -t='registry.cn-hangzhou.aliyuncs.com/bewithmeallmylife/local-gpt-app-cuda-11.7.1:1.0.0' .

#sudo docker run --net=host  --gpus '"device=0,1"' --privileged -it -d registry.cn-hangzhou.aliyuncs.com/bewithmeallmylife/local-gpt-app-cuda-11.7.1:1.0.0
