FROM python:3.10

# タイムゾーンを日本に設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# インフラを整備
RUN apt-get update && \
    apt-get install -y zsh time pypy3 tzdata tree git curl npm

# デフォルトシェルをZ shellにする
RUN chsh -s /bin/zsh

# 一般的なコマンドで使えるように設定
# e.g. python3.8 main.py => python main.py
RUN echo 'alias python="python3"' >> ~/.zshrc
RUN echo 'alias pip="pip3"' >> ~/.zshrc
RUN echo 'PS1="[%~]$ "' >> ~/.zshrc

WORKDIR /workspace

COPY . .
ENV PATH $PATH:/root/.local/bin
# poetry インストール
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN echo '/root/.local/bin:$PATH' >> ~/.bashrc
RUN echo '/root/.local/bin:$PATH' >> ~/.zshrc
RUN mkdir ~/.zfunc
RUN poetry completions zsh > ~/.zfunc/_poetry

RUN echo '\n\
    fpath+=~/.zfunc\n\
    autoload -Uz compinit && compinit' >> ~/.zshrc

RUN pip install -U pip
RUN poetry install