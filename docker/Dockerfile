FROM python:3.6
RUN pip install pandas==0.23.3
RUN mkdir /usr/src/julia
WORKDIR /usr/src/julia
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.0-linux-x86_64.tar.gz
RUN tar -xvf julia-1.7.0-linux-x86_64.tar.gz
RUN mkdir /usr/src/nab
WORKDIR /usr/src/nab
ENV PYTHONUNBUFFERED 1
COPY . .
RUN pip install -r requirements.txt
RUN pip install -r nab/detectors/ARTime/requirements.txt 
